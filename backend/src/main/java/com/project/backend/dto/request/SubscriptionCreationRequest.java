package com.project.backend.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.project.backend.enums.PaymentStatus;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class SubscriptionCreationRequest {
    @NotNull
    @JsonProperty("account_id")
    Long accountId;
    @NotNull
    @JsonProperty("plan_id")
    String planId;

}