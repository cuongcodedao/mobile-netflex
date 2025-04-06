package com.project.backend.controller;

import com.project.backend.dto.request.AccountCreationRequest;
import com.project.backend.dto.request.AccountUpdateRequest;
import com.project.backend.dto.response.AccountResponse;
import com.project.backend.dto.response.TemplateResponse;
import com.project.backend.service.IAccountService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/account")
@RequiredArgsConstructor
public class AccountController {
    private final IAccountService accountService;

    @GetMapping("")
    public TemplateResponse<List<AccountResponse>> getAllAccounts() {
        List<AccountResponse> response = accountService.getAllAccounts();
        return TemplateResponse.<List<AccountResponse>>builder()
                .result(response)
                .build();
    }

    @GetMapping("/{id}")
    public TemplateResponse<AccountResponse> getAccountById(@PathVariable Long id) {
        AccountResponse response = accountService.getAccountById(id);
        return TemplateResponse.<AccountResponse>builder()
                .result(response)
                .build();
    }

    @PostMapping("")
    public TemplateResponse<AccountResponse> createAccount(@RequestBody AccountCreationRequest accountCreationRequest) {
        AccountResponse response = accountService.createAccount(accountCreationRequest);
        return TemplateResponse.<AccountResponse>builder()
                .result(response)
                .build();
    }

//    @PutMapping("/{id}")
//    public TemplateResponse<AccountResponse> updateAccount(@RequestBody AccountUpdateRequest accountUpdateRequest) {
//        AccountResponse response = accountService.updateAccount(accountUpdateRequest);
//        return TemplateResponse.<AccountResponse>builder()
//                .result(response)
//                .build();
//    }

    @DeleteMapping("/{id}")
    public TemplateResponse<Void> deleteAccount(@PathVariable Long id) {
        accountService.deleteAccount(id);
        return TemplateResponse.<Void>builder()
                .build();
    }
}