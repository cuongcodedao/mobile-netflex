package com.project.backend.service;

import com.project.backend.dto.HistoryDTO;

import java.util.List;


public interface IHistoryService {
    HistoryDTO create(HistoryDTO historyRequest);
    HistoryDTO update(HistoryDTO historyRequest);
    void delete(Long id);
    List<HistoryDTO> getAllHistoriesByProfileId(Long profileId);
    void deleteAllByProfileId(Long profileId);
}
