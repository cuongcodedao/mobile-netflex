package com.project.backend.service;


import com.project.backend.dto.request.SubscriptionCreationRequest;
import com.project.backend.dto.response.PaypalSubscriptionResponse;
import com.project.backend.dto.response.SubscriptionResponse;

import java.io.IOException;
import java.util.List;

public interface ISubscriptionService {
    PaypalSubscriptionResponse create(SubscriptionCreationRequest subscriptionDTO) throws IOException;
    PaypalSubscriptionResponse activeSubscription(String subscriptionId) throws IOException;
    void cancelSubscription(String subscriptionId) throws IOException;
    void cancelSubscriptionByAccountId(Long accountId) throws IOException;
    List<SubscriptionResponse> getAllSubscriptions() throws IOException;
}
