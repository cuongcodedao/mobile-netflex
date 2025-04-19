package com.project.backend.repository;

import com.project.backend.entity.AccessLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AccessLogRepository extends JpaRepository<AccessLog, Long> {
    @Query("SELECT a FROM AccessLog a WHERE a.account.id = :accountId and a.deviceId = :deviceId")
    List<AccessLog> findByAccountIdAndDeviceId(@Param("accountId") Long accountId, @Param("deviceId") String deviceId);

}
