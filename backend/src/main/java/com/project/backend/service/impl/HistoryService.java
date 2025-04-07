package com.project.backend.service.impl;

import com.project.backend.dto.HistoryDTO;
import com.project.backend.entity.History;
import com.project.backend.entity.Profile;
import com.project.backend.mapper.HistoryMapper;
import com.project.backend.repository.HistoryRepository;
import com.project.backend.repository.ProfileRepository;
import com.project.backend.service.IHistoryService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class HistoryService implements IHistoryService {
    private final HistoryRepository historyRepository;
    private final ProfileRepository profileRepository;
    private final HistoryMapper historyMapper;

    @Override
    public HistoryDTO create(HistoryDTO historyRequest) {
        Profile profile = profileRepository.findById(historyRequest.getProfileId())
                .orElseThrow(() -> new RuntimeException("Profile not found"));

        History history = historyMapper.toHistory(historyRequest);
        history.setProfile(profile);
        history = historyRepository.save(history);
        return historyMapper.toHistoryDTO(history);
    }

    @Override
    public HistoryDTO update(HistoryDTO historyRequest) {
        History history = historyRepository.findById(historyRequest.getId())
                .orElseThrow(() -> new RuntimeException("History not found"));

        historyMapper.updateHistory(history, historyRequest);
        history = historyRepository.save(history);
        return historyMapper.toHistoryDTO(history);
    }

    @Override
    public void delete(Long id) {
        History history = historyRepository.findById(id).orElseThrow(()-> new RuntimeException("History not found"));
        historyRepository.delete(history);
    }

    @Override
    public List<HistoryDTO> getAllHistoriesByProfileId(Long profileId) {
        return historyRepository.findAllByProfileId(profileId)
                .stream()
                .map(historyMapper::toHistoryDTO)
                .toList();
    }

    @Override
    @Transactional
    public void deleteAllByProfileId(Long profileId) {
        historyRepository.deleteAllByProfileId(profileId);
    }


}