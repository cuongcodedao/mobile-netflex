package com.project.backend.repository;

import com.project.backend.entity.History;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HistoryRepository extends JpaRepository<History, Long> {
    List<History> findAllByProfileId(Long profileId);
    void deleteAllByProfileId(Long profileId);
}
