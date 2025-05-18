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
    AccessLog findByAccountIdAndDeviceId(@Param("accountId") Long accountId, @Param("deviceId") String deviceId);
    List<AccessLog> findByAccountId(Long accountId);

    @Query("SELECT COUNT(a) FROM AccessLog a WHERE a.account.id = :accountId and a.deviceId != :deviceId")
    int countDevices(@Param("accountId") Long accountId, @Param(("deviceId")) String deviceId);

    @Query("SELECT COUNT(a) FROM AccessLog a WHERE a.account.id = :accountId AND a.active = true and a.deviceId != :deviceId")
    int countActiveDevices(@Param("accountId") Long accountId, @Param(("deviceId")) String deviceId);



}
