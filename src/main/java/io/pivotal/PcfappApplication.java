package io.pivotal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ExtendedModelMap;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.Collection;
import java.util.Map;

@SpringBootApplication
public class PcfappApplication {

	public static void main(String[] args) {
		SpringApplication.run(PcfappApplication.class, args);
	}

	@Controller
	class dashboardController{

        @Autowired
        Environment env;

		@GetMapping("/dash")
		public String dashboard(Model model){
			model.addAttribute("name", "ben");
			model.addAttribute("port", env.getProperty("local.server.port"));
			return "dash";
		}
	}
}
