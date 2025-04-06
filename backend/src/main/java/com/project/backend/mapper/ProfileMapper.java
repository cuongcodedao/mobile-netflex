package com.project.backend.mapper;

import com.project.backend.dto.request.ProfileCreationRequest;
import com.project.backend.dto.request.ProfileUpdateRequest;
import com.project.backend.dto.response.ProfileResponse;
import com.project.backend.entity.Profile;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface ProfileMapper {
     Profile toProfile(ProfileCreationRequest request);
     void updateProfile(@MappingTarget Profile profile, ProfileUpdateRequest request);

     @Mapping(target = "accountId", source = "account.id")
     ProfileResponse toProfileResponse(Profile profile);
}
