package io.pivotal;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;


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

    @Controller
    class stbController {

        @GetMapping("/stb")
        public String stb() {
            LOG.error("Had a crisis...   :(   ", new OutOfMemoryError("Fake OutOfMemoryError!"));
            System.exit(-1);
            return "index";
        }
    }
}
