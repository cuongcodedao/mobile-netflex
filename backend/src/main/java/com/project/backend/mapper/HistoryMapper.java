package com.project.backend.mapper;

import com.project.backend.dto.HistoryDTO;
import com.project.backend.entity.History;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface HistoryMapper {
    History toHistory(HistoryDTO historyDTO);

    @Mapping(target = "profileId", source = "profile.id")
    HistoryDTO toHistoryDTO(History history);
    void updateHistory(@MappingTarget History history, HistoryDTO historyDTO);
}