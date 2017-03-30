package io.pivotal;

import org.springframework.amqp.AmqpConnectException;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.info.BuildProperties;
import org.springframework.boot.info.GitProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.Environment;
import org.springframework.core.env.PropertiesPropertySource;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
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

        public String getDatabaseDetails() {
            StringBuilder sb = new StringBuilder();

            if (this.hasDatabase()) {
                try {
                    Field urlField = ReflectionUtils.findField(dataSource.getClass(), "url");
                    ReflectionUtils.makeAccessible(urlField);
                    sb.append(urlField.get(dataSource));
                } catch (Exception fe) {
                    try {
                        Method urlMethod = ReflectionUtils.findMethod(dataSource.getClass(), "getUrl");
                        ReflectionUtils.makeAccessible(urlMethod);
                        sb.append(urlMethod.invoke(dataSource, (Object[]) null));
                    } catch (Exception me) {
                        sb.append("NOT_CONFIGURED (");
                        sb.append(me.getCause().getMessage());
                        sb.append(")");
                    }
                }
            }

            return sb.toString();
        }

        public String getMessagingDetails() {
            StringBuilder sb = new StringBuilder();

            if (this.hasMessaging()) {
                try {
                    sb.append(rabbitConnectionFactory.getHost());
                    sb.append(":");
                    sb.append(rabbitConnectionFactory.getPort());
                } catch (AmqpConnectException ce) {
                    sb.append("NOT_CONFIGURED (");
                    sb.append(ce.getCause().getMessage());
                    sb.append(")");
                }
            }
            return sb.toString();
        }

        public boolean hasDatabase() {
            return !(null == dataSource);
        }

        public boolean hasMessaging() {
            boolean hasMessaging = false;

            try {
                hasMessaging = rabbitConnectionFactory.createConnection().isOpen();
            }
            catch (AmqpConnectException qe){
                hasMessaging = false;
            }
            return hasMessaging;
        }
    }

    @Configuration
    class CustomInfoEndpoint {

        @Autowired
        Status status;

        @Autowired
        GitProperties gitProperties;

        /**
         * These properties will show up in Spring Boot Actuator's /info endpoint
         **/
        @Autowired
        public void setInfoProperties(ConfigurableEnvironment env) {

            // Add the status to the /info endpoint using Properties
            Properties props = new Properties();


            // Add the basic status of the resources
            props.put("info.hasdatabase", status.hasDatabase());
            props.put("info.hasmessaging", status.hasMessaging());

            if(status.hasDatabase()) {
                props.put("info.database", status.getDatabaseDetails());
            }
            if(status.hasMessaging()) {
                props.put("info.messaging", status.getMessagingDetails());
            }

            // Set the new properties into the environment
            env.getPropertySources().addFirst(new PropertiesPropertySource("extra-info-props", props));
        }
    }
}
