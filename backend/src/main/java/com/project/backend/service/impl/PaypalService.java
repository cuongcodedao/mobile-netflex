package com.project.backend.service.impl;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.project.backend.config.PaypalConfig;
import com.project.backend.dto.request.SubscriptionCreationRequest;
import com.project.backend.dto.response.PaypalSubscriptionResponse;
import com.project.backend.service.IPaypalService;
import lombok.RequiredArgsConstructor;
import okhttp3.*;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.Base64;

@Service
@RequiredArgsConstructor
public class PaypalService implements IPaypalService {
    private final OkHttpClient client = new OkHttpClient();
    private final PaypalConfig config;
    private final ObjectMapper objectMapper;

    private String accessToken;
    private long expiresAt = 0;

    public String getAccessToken() throws IOException {
        if (System.currentTimeMillis() >= expiresAt) {
            refreshToken();
        }
        return accessToken;
    }

    @Scheduled(fixedDelay = 32400000)
    public void scheduledRefreshToken() {
        try {
            refreshToken();
        } catch (IOException e) {
            System.err.println("Failed to refresh PayPal token: " + e.getMessage());
        }
    }

    private void refreshToken() throws IOException {
        System.out.println("Refreshing PayPal access token...");

        String credential = config.clientId + ":" + config.clientSecret;
        String encoded = Base64.getEncoder().encodeToString(credential.getBytes());

        Request request = new Request.Builder()
                .url(config.baseUrl + "/v1/oauth2/token")
                .post(RequestBody.create("grant_type=client_credentials", MediaType.parse("application/x-www-form-urlencoded")))
                .addHeader("Authorization", "Basic " + encoded)
                .addHeader("Content-Type", "application/x-www-form-urlencoded")
                .build();

        try (Response response = client.newCall(request).execute()) {
            if (response.isSuccessful() && response.body() != null) {
                String responseBody = response.body().string();
                JsonNode jsonNode = objectMapper.readTree(responseBody);

                accessToken = jsonNode.get("access_token").asText();
                int expiresIn = jsonNode.get("expires_in").asInt();
                expiresAt = System.currentTimeMillis() + (expiresIn * 1000L) - 600_000L;
                System.out.println("PayPal token refreshed.");
            } else {
                throw new IOException("Failed to retrieve access token. Response: " + response);
            }
        }
    }

    public PaypalSubscriptionResponse createSubscription(SubscriptionCreationRequest requestData) throws IOException {
        String token = getAccessToken();

        String json = "{\n" +
                "  \"plan_id\": \"" + requestData.getPlanId() + "\",\n" +
                "  \"application_context\": {\n" +
                "    \"return_url\": \"myapp://subscription/success\",\n" +
                "    \"cancel_url\": \"myapp://subscription/failed\",\n" +
                "    \"brand_name\": \"Netflex\",\n" +
                "    \"locale\": \"en-US\",\n" +
                "    \"user_action\": \"SUBSCRIBE_NOW\"\n" +
                "  }\n" +
                "}";

        Request request = new Request.Builder()
                .url(config.baseUrl + "/v1/billing/subscriptions")
                .post(RequestBody.create(json, MediaType.parse("application/json")))
                .addHeader("Authorization", "Bearer " + token)
                .addHeader("Content-Type", "application/json")
                .build();

        try (Response response = client.newCall(request).execute()) {
            if (response.isSuccessful() && response.body() != null) {
                return objectMapper.readValue(response.body().string(), PaypalSubscriptionResponse.class);
            } else {
                throw new IOException("Failed to create subscription: " + response.code() + " - " + response.message());
            }
        }
    }

    public PaypalSubscriptionResponse getSubscription(String subscriptionId) throws IOException {
        String token = getAccessToken();

        Request request = new Request.Builder()
                .url(config.baseUrl + "/v1/billing/subscriptions/" + subscriptionId)
                .get()
                .addHeader("Authorization", "Bearer " + token)
                .addHeader("Content-Type", "application/json")
                .build();

        try (Response response = client.newCall(request).execute()) {
            if (response.isSuccessful() && response.body() != null) {
                return objectMapper.readValue(response.body().string(), PaypalSubscriptionResponse.class);
            } else {
                throw new IOException("Failed to retrieve subscription: " + response.code() + " - " + response.message());
            }
        }
    }
    public void cancelSubscription(String subscriptionId) throws IOException {
        String token = getAccessToken();

        Request request = new Request.Builder()
                .url(config.baseUrl + "/v1/billing/subscriptions/" + subscriptionId + "/cancel")
                .post(RequestBody.create("{}", MediaType.parse("application/json")))
                .addHeader("Authorization", "Bearer " + token)
                .addHeader("Content-Type", "application/json")
                .build();

        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                throw new IOException("Failed to cancel subscription: " + response.code() + " - " + response.message());
            }
        }
    }
}
