package com.example.banking;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("bankName", "SmartPay Bank");
        model.addAttribute("accountHolder", "Sai Kumar");
        model.addAttribute("balance", "₹1,50,000.75");
        return "home";
    }
}
