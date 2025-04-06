package com.project.backend.service;

import com.project.backend.dto.request.ProfileCreationRequest;
import com.project.backend.dto.request.ProfileUpdateRequest;
import com.project.backend.dto.response.ProfileResponse;

import java.util.List;

public interface IProfileService {
    ProfileResponse createProfile(ProfileCreationRequest creationRequest);
    List<ProfileResponse> getAllProfilesByAccountId(Long accountId);
    ProfileResponse updateProfile(ProfileUpdateRequest profileUpdateRequest);
    void deleteProfile(Long id);
}
