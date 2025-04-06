package com.project.backend.controller;

import com.project.backend.dto.request.ProfileCreationRequest;
import com.project.backend.dto.request.ProfileUpdateRequest;
import com.project.backend.dto.response.ProfileResponse;
import com.project.backend.dto.response.TemplateResponse;
import com.project.backend.service.IProfileService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/profile")
@RequiredArgsConstructor
public class ProfileController {
    private final IProfileService profileService;

    @PostMapping("")
    public TemplateResponse<ProfileResponse> createProfile(@RequestBody ProfileCreationRequest profileCreationRequest) {
        ProfileResponse response = profileService.createProfile(profileCreationRequest);
        return TemplateResponse.<ProfileResponse>builder()
                .result(response)
                .build();
    }

    @GetMapping("/account/{id}")
    public TemplateResponse<List<ProfileResponse>> getAllProfilesByAccountId(@PathVariable Long id) {
        List<ProfileResponse> response = profileService.getAllProfilesByAccountId(id);
        return TemplateResponse.<List<ProfileResponse>>builder()
                .result(response)
                .build();
    }

    @PutMapping("/")
    public TemplateResponse<ProfileResponse> updateProfile(@RequestBody ProfileUpdateRequest profileUpdateRequest) {
        ProfileResponse response = profileService.updateProfile(profileUpdateRequest);
        return TemplateResponse.<ProfileResponse>builder()
                .result(response)
                .build();
    }

    @DeleteMapping("/{id}")
    public TemplateResponse<Void> deleteProfile(@PathVariable Long id) {
        profileService.deleteProfile(id);
        return TemplateResponse.<Void>builder()
                .build();
    }

}
