package com.project.backend.service.impl;

import com.project.backend.dto.response.Country;
import com.project.backend.repository.ApiClient;
import com.project.backend.service.ICountryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CountryService implements ICountryService {
    private final ApiClient apiClient;

    @Override
    public List<Country> getAllCountries() throws Exception {
        return apiClient.getAllCountries();
    }
}
