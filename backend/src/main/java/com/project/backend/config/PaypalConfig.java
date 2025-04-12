package com.project.backend.config;


import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class PaypalConfig {

    @Value("${paypal.client.id}")
    public String clientId;

    @Value("${paypal.client.secret}")
    public String clientSecret;

    @Value("${paypal.base.url}")
    public String baseUrl;
}
