package com.project.backend.controller;

import com.project.backend.dto.response.Country;
import com.project.backend.dto.response.TemplateResponse;
import com.project.backend.service.ICountryService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/countries")
public class CountryController {
    private final ICountryService countryService;

    @GetMapping("")
    public TemplateResponse<List<Country>> getAllCountries() throws Exception {
        List<Country> countries = countryService.getAllCountries();
        return TemplateResponse.<List<Country>>builder()
                .result(countries)
                .build();
    }
}