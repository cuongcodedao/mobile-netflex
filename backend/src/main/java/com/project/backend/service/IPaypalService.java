package com.project.backend.service;

import com.project.backend.dto.request.SubscriptionCreationRequest;
import com.project.backend.dto.response.PaypalSubscriptionResponse;

import java.io.IOException;

public interface IPaypalService {
    PaypalSubscriptionResponse createSubscription(SubscriptionCreationRequest subscriptionCreationRequest) throws IOException;
    PaypalSubscriptionResponse getSubscription(String subscriptionId) throws IOException;
    void cancelSubscription(String subscriptionId) throws IOException;
}
