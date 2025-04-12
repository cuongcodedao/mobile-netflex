package com.project.backend.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.project.backend.enums.PaymentStatus;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class SubscriptionResponse {
    String id;
    Long accountId;
    @JsonProperty("plan_id")
    String planId;
    LocalDate startDate;
    PaymentStatus status;
    boolean active;

}