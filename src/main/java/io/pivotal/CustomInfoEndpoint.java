package io.pivotal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.PropertiesPropertySource;

import java.util.Properties;

/**
 * Created by benwilcock on 04/08/2016.
 * This is the method we currently use to add information to the /info endpoint in Actuator.
 */
@Configuration
public class CustomInfoEndpoint {

    @Value("${INSTANCE_GUID:NOT_SET}")
    String id;

    @Value("${INSTANCE_INDEX:NOT_SET}")
    String instanceIndex;

    @Autowired
    Status status;

    /** These properties will show up in Spring Boot Actuator's /info endpoint **/
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