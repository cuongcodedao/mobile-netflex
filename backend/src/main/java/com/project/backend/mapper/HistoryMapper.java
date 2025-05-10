package com.project.backend.mapper;


import com.project.backend.dto.request.HistoryCreationRequest;
import com.project.backend.dto.response.HistoryResponse;
import com.project.backend.entity.History;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface HistoryMapper {
    History toHistory(HistoryCreationRequest historyDTO);

    @Mapping(target = "profileId", source = "profile.id")
    HistoryResponse toHistoryDTO(History history);
    void updateHistory(@MappingTarget History history, HistoryCreationRequest historyDTO);
}