package com.project.backend.service;

import com.project.backend.dto.response.Country;

import java.util.List;

public interface ICountryService {
    List<Country> getAllCountries() throws Exception;
}
