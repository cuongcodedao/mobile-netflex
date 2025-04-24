package com.project.backend.mapper;

import com.project.backend.dto.response.SubscriptionResponse;
import com.project.backend.entity.Subscription;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface SubscriptionMapper {
    @Mapping(source = "account.id", target = "accountId")
    @Mapping(source = "plan.id", target = "planId")
    SubscriptionResponse toSubscriptionResponse(Subscription subscription);
}