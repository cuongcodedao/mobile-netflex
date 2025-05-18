package com.project.backend.service.impl;

import com.project.backend.dto.UserDetailsImpl;
import com.project.backend.dto.request.AccountCreationRequest;
import com.project.backend.dto.request.AccountUpdateRequest;
import com.project.backend.dto.request.LogoutRequest;
import com.project.backend.dto.request.SignInRequest;
import com.project.backend.dto.response.AccountResponse;
import com.project.backend.dto.response.AuthResponse;
import com.project.backend.entity.AccessLog;
import com.project.backend.entity.Account;
import com.project.backend.entity.Plan;
import com.project.backend.entity.RefreshToken;
import com.project.backend.enums.DeviceType;
import com.project.backend.exception.AppException;
import com.project.backend.exception.ErrorCode;
import com.project.backend.exception.UserAlreadyExistsException;
import com.project.backend.mapper.AccountMapper;
import com.project.backend.repository.AccessLogRepository;
import com.project.backend.repository.AccountRepository;
import com.project.backend.repository.PlanRepository;
import com.project.backend.service.IAccountService;
import com.project.backend.utils.JWTUtils;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.apache.catalina.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AccountService implements IAccountService {
    private final AccountRepository accountRepository;
    private final AccountMapper accountMapper;
    private final PlanRepository planRepository;
    private final AuthenticationManager authenticationManager;
    private final JWTUtils jwtUtils;
    private final PasswordEncoder passwordEncoder;
    private final AccessLogRepository accessLogRepository;

    @Override
    public List<AccountResponse> getAllAccounts() {
        return accountRepository.findAll().stream()
                .map(accountMapper::toAccountResponse)
                .collect(Collectors.toList());
    }

    @Override
    @PostAuthorize("returnObject.id == authentication.principal.id")
    public AccountResponse getAccountById(Long id) {
        Account account = accountRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Account not found"));
        AccountResponse accountResponse = accountMapper.toAccountResponse(account);
        accountResponse.setCurrentPlan(account.getCurrentPlan());
        return accountResponse;
    }

    @Override
    public AccountResponse createAccount(AccountCreationRequest accountCreationRequest) throws UserAlreadyExistsException {
        if (accountRepository.existsByEmail(accountCreationRequest.getEmail())) {
            throw new UserAlreadyExistsException("Email already exists");
        }
        Account account = accountMapper.toAccount(accountCreationRequest);
        account.setPassword(passwordEncoder.encode(accountCreationRequest.getPassword()));
        Plan plan = planRepository.findById("basic-plan")
                .orElseThrow(() -> new RuntimeException("Plan not found"));
        account.setCreatedAt(LocalDateTime.now());
        account.setCurrentPlan(plan);
        account.setEnabled(true);
        account = accountRepository.save(account);
        return accountMapper.toAccountResponse(account);
    }

    @Override
    @Transactional
    public AuthResponse login(SignInRequest signInRequest) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(signInRequest.getEmail(), signInRequest.getPassword())
        );
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        Account account = accountRepository.findById(userDetails.getId())
                .orElseThrow(() -> new RuntimeException("Account not found"));

        if(!account.isEnabled()) {
            throw new AppException(ErrorCode.ACCOUNT_DISABLED);
        }
        AccessLog accessLog = accessLogRepository.findByAccountIdAndDeviceId(userDetails.getId(), signInRequest.getDeviceId());
        int totalDevices = accessLogRepository.countDevices(userDetails.getId(), signInRequest.getDeviceId());
        int activeDevices = accessLogRepository.countActiveDevices(userDetails.getId(),  signInRequest.getDeviceId());

        int plus = accessLog == null ? 1 : 0;

        if (totalDevices+plus > userDetails.getCurrentPlan().getMaxNumberOfDevice()) {
            throw new AppException(ErrorCode.EXCEEDS_MAX_DEVICE);
        }
        if (activeDevices+plus > userDetails.getCurrentPlan().getMaxNumberOfDeviceActive()) {
            throw new AppException(ErrorCode.EXCEEDS_MAX_DEVICE_ACTIVE);
        }
        if(accessLog!=null){
            accessLog.setLastLogin(LocalDateTime.now());
        }
        else{
             accessLog = AccessLog.builder()
                    .account(account)
                    .deviceId(signInRequest.getDeviceId())
                    .active(true)
                    .lastLogin(LocalDateTime.now())
                    .deviceName(signInRequest.getDeviceName())
                    .deviceType(DeviceType.MOBILE)
                    .build();
        }
        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(userDetails.getUsername());
        RefreshToken refreshToken = jwtUtils.createRefreshToken(userDetails.getUsername());

        accessLogRepository.save(accessLog);
        return AuthResponse.builder()
                .account(accountMapper.toAccountResponse(account))
                .accessToken(jwt)
                .refreshToken(refreshToken.getRefreshToken())
                .tokenType("Bearer")
                .expiresIn(jwtUtils.getJwtExpirationMs())
                .build();
    }

    public AuthResponse refreshToken(String refreshToken) {
        RefreshToken token = jwtUtils.verifyRefreshToken(refreshToken);
        String email = token.getEmail();
        String newAccessToken = jwtUtils.generateJwtToken(email);
        return AuthResponse.builder()
                .accessToken(newAccessToken)
                .refreshToken(token.getRefreshToken())
                .tokenType("Bearer")
                .expiresIn(jwtUtils.getJwtExpirationMs())
                .build();
    }

    @Override
    public boolean isEmailExists(String email) {
        return accountRepository.existsByEmail(email);
    }

    @PreAuthorize("@userDetailsServiceImpl.loadUserByUsername(authentication.name).username == #logoutRequest.email")
    @Override
    public void logout(LogoutRequest logoutRequest) {
        Account account = accountRepository.findByEmail(logoutRequest.getEmail());
        if (account == null) {
            throw new RuntimeException("Account not found");
        }
        AccessLog accessLog = accessLogRepository.findById(logoutRequest.getAccessLogId())
                .orElseThrow(() -> new RuntimeException("Access log not found"));
        accessLog.setActive(false);
        jwtUtils.deleteRefreshToken(logoutRequest.getRefreshToken());
        SecurityContextHolder.clearContext();
        accessLogRepository.save(accessLog);
    }

    @Override
    @PostAuthorize("returnObject.id == authentication.principal.id")
    public AccountResponse updateAccount(Long accountId, AccountUpdateRequest accountUpdateRequest) {
        Account account = accountRepository.findById(accountId)
                .orElseThrow(() -> new RuntimeException("Account not found"));
        account.setUpdatedAt(LocalDateTime.now());
        accountMapper.updateAccount(account, accountUpdateRequest);
        if (accountUpdateRequest.getPassword() != null && !accountUpdateRequest.getPassword().isEmpty()) {
            account.setPassword(passwordEncoder.encode(accountUpdateRequest.getPassword()));
        }
        else{
            account.setPassword(account.getPassword());
        }
        accountRepository.save(account);
        return accountMapper.toAccountResponse(account);
    }

    @Override
    public void deleteAccount(Long id) {
        Account account = accountRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Account not found"));
        account.setEnabled(false);
        accountRepository.save(account);
    }
}