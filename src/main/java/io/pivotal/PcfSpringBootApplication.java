package io.pivotal;

import org.springframework.amqp.AmqpConnectException;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.Environment;
import org.springframework.core.env.PropertiesPropertySource;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ReflectionUtils;
import org.springframework.web.bind.annotation.GetMapping;

import javax.sql.DataSource;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Properties;

@SpringBootApplication
public class PcfSpringBootApplication {

    public static void main(String[] args) {
        SpringApplication.run(PcfSpringBootApplication.class, args);
    }

    @Controller
    class dashboardController {

        @GetMapping("/")
        public String dashboard() {
            return "index";
        }
    }

    @Component
    class Status {

        @Autowired
        Environment env;

        @Autowired(required = false)
        DataSource dataSource;

        @Autowired(required = false)
        ConnectionFactory rabbitConnectionFactory;

        public Status() {
        }

        public String getSql() {
            StringBuilder sb = new StringBuilder();

            if (dataSource == null) {
                sb.append("NOT_CONFIGURED");
            } else {
                try {
                    Field urlField = ReflectionUtils.findField(dataSource.getClass(), "url");
                    ReflectionUtils.makeAccessible(urlField);
                    sb.append(urlField.get(dataSource));
                    sb.append(":UP");
                } catch (Exception fe) {
                    try {
                        Method urlMethod = ReflectionUtils.findMethod(dataSource.getClass(), "getUrl");
                        ReflectionUtils.makeAccessible(urlMethod);
                        sb.append(urlMethod.invoke(dataSource, (Object[]) null));
                        sb.append(":UP");
                    } catch (Exception me) {
                        sb.append(":DOWN - ");
                        sb.append(me.getCause().getMessage());
                    }
                }
            }
            return sb.toString();
        }

        public String getRabbit() {
            StringBuilder sb = new StringBuilder();

            if (rabbitConnectionFactory == null) {
                sb.append("NOT_CONFIGURED");
            } else {
                try {
                    rabbitConnectionFactory.createConnection().isOpen();
                    sb.append(rabbitConnectionFactory.getHost());
                    sb.append(":");
                    sb.append(rabbitConnectionFactory.getPort());
                    sb.append(":UP");
                } catch (AmqpConnectException ce) {
                    sb.append("NOT_PRESENT (");
                    sb.append(ce.getCause().getMessage());
                    sb.append(")");
                }
            }
            return sb.toString();
        }

        public boolean isSql() {
            return !(null == dataSource);
        }

        public boolean isRabbit() {
            return !(null == rabbitConnectionFactory);
        }

        @Override
        public String toString() {
            StringBuilder sb = new StringBuilder();
            sb.append("DATABASE: [");
            sb.append(getSql());
            sb.append("] MESSAGING: [");
            sb.append(getRabbit());
            sb.append("]");
            return sb.toString();
        }
    }

    @Configuration
    class CustomInfoEndpoint {

        @Value("${INSTANCE_GUID:NOT_SET}")
        String id;

        @Value("${INSTANCE_INDEX:NOT_SET}")
        String instanceIndex;

        @Autowired
        Status status;

        /**
         * These properties will show up in Spring Boot Actuator's /info endpoint
         **/
        @Autowired
        public void setInfoProperties(ConfigurableEnvironment env) {

            // Add the status to the /info endpoint using Properties
            Properties props = new Properties();
            props.put("info.id", id);
            props.put("info.index", instanceIndex);
            props.put("info.database", status.getSql());
            props.put("info.messaging", status.getRabbit());

            // Set the new properties into the environment
            env.getPropertySources().addFirst(new PropertiesPropertySource("extra-info-props", props));
        }
    }
}
