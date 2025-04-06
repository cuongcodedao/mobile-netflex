package com.project.backend.service.impl;

import com.project.backend.dto.request.ProfileCreationRequest;
import com.project.backend.dto.request.ProfileUpdateRequest;
import com.project.backend.dto.response.ProfileResponse;
import com.project.backend.entity.Account;
import com.project.backend.entity.Profile;
import com.project.backend.mapper.ProfileMapper;
import com.project.backend.repository.AccountRepository;
import com.project.backend.repository.ProfileRepository;
import com.project.backend.service.IProfileService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProfileService implements IProfileService {
    private final ProfileRepository profileRepository;
    private final AccountRepository accountRepository;
    private final ProfileMapper profileMapper;

    public ProfileResponse createProfile(ProfileCreationRequest creationRequest) {
        Profile profile = profileMapper.toProfile(creationRequest);
        Account account = accountRepository.findById(creationRequest.getAccountId())
                .orElseThrow(() -> new RuntimeException("Account not found"));
        profile.setAccount(account);
        profile = profileRepository.save(profile);
        return profileMapper.toProfileResponse(profile);
    }

    public List<ProfileResponse> getAllProfilesByAccountId(Long accountId) {
        List<Profile> profiles = profileRepository.findAllByAccountId(accountId);
        return profiles.stream()
                .map(profileMapper::toProfileResponse)
                .toList();
    }

    public ProfileResponse updateProfile(ProfileUpdateRequest profileUpdateRequest) {
        Profile profile = profileRepository.findById(profileUpdateRequest.getId())
                .orElseThrow(() -> new RuntimeException("Profile not found"));
        profileMapper.updateProfile(profile, profileUpdateRequest);
        profileRepository.save(profile);
        return profileMapper.toProfileResponse(profile);
    }

    @Override
    public void deleteProfile(Long id) {
        Profile profile = profileRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Profile not found"));
        profileRepository.delete(profile);
    }


}
