package io.pivotal;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.PropertiesPropertySource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import javax.sql.DataSource;
import java.util.Properties;


@SpringBootApplication
public class PcfSpringBootApplication {

    private static final Logger LOG = LoggerFactory.getLogger(PcfSpringBootApplication.class);

    public static void main(String[] args) {
        SpringApplication.run(PcfSpringBootApplication.class, args);
        LOG.info("Starting the PCF SpringBoot Demo with Thymeleaf.");
    }

    @Controller
    class dashboardController {

        @GetMapping("/")
        public String dashboard() {
            return "index";
        }
    }

//    @Component
//    class Status {
//
//        @Autowired
//        Environment env;
//
//        @Autowired(required = false)
//        DataSource dataSource;
//
//        @Autowired(required = false)
//        ConnectionFactory rabbitConnectionFactory;
//
//        public Status() {
//        }
//
//        public String getDatabaseDetails() {
//            StringBuilder sb = new StringBuilder();
//
//            if (this.hasDatabase()) {
//                try {
//                    Field urlField = ReflectionUtils.findField(dataSource.getClass(), "url");
//                    ReflectionUtils.makeAccessible(urlField);
//                    sb.append(urlField.get(dataSource));
//                } catch (Exception fe) {
//                    LOG.warn("Datasource findField 'url' failed: ", fe);
//                    try {
//                        Method urlMethod = ReflectionUtils.findMethod(dataSource.getClass(), "getUrl");
//                        ReflectionUtils.makeAccessible(urlMethod);
//                        sb.append(urlMethod.invoke(dataSource, (Object[]) null));
//                    } catch (Exception me) {
//                        LOG.warn("Datasource findMethod 'getUrl()' failed: ", me);
//                    }
//                }
//            }
//
//            return sb.toString();
//        }
//
//        public String getMessagingDetails() {
//            StringBuilder sb = new StringBuilder();
//
//            if (this.hasMessaging()) {
//                try {
//                    sb.append(rabbitConnectionFactory.getHost());
//                    sb.append(":");
//                    sb.append(rabbitConnectionFactory.getPort());
//                } catch (AmqpConnectException ce) {
//                    LOG.warn("Messaging connectionFactory 'getHost()' or 'getPort()' call failed: ", ce);
//                }
//            }
//            return sb.toString();
//        }
//
//        public boolean hasDatabase() {
//            return !(null == dataSource);
//        }
//
//        public boolean hasMessaging() {
//            boolean hasMessaging = false;
//
//            try {
//                hasMessaging = rabbitConnectionFactory.createConnection().isOpen();
//            }
//            catch (AmqpConnectException qe){
//                hasMessaging = false;
//                LOG.warn("Messaging is not connected: {}", qe.getMessage());
//            }
//            return hasMessaging;
//        }
//    }
//
    
    @Configuration
    class CustomInfoEndpoint {

        @Autowired(required = false)
        DataSource dataSource;


        private boolean hasDatabase() {
            return !(null == dataSource);
        }

        @Autowired
        public void setInfoProperties(ConfigurableEnvironment env) {

            // Add the status to the /info endpoint using Properties
            Properties props = new Properties();

            // Add the basic status of the resources
            if(null != dataSource) {
                props.put("info.hasdatabase", true);
            }

            // Make these properties will show up in Spring Boot Actuator's '/info' endpoint...
            env.getPropertySources().addFirst(new PropertiesPropertySource("extra-info-props", props));
        }
    }
}
