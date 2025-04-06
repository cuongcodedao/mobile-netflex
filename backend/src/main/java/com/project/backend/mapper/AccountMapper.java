package com.project.backend.mapper;

import com.project.backend.dto.request.AccountCreationRequest;
import com.project.backend.dto.request.AccountUpdateRequest;
import com.project.backend.dto.response.AccountResponse;
import com.project.backend.entity.Account;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface AccountMapper {
    AccountResponse toAccountResponse(Account account);
    Account toAccount(AccountCreationRequest accountCreationRequest);
    void updateAccount(@MappingTarget Account account, AccountUpdateRequest accountUpdateRequest);
}
