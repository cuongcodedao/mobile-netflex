package com.project.backend.service.impl;

import com.project.backend.dto.response.APIResponse;
import com.project.backend.dto.response.Category;
import com.project.backend.repository.ApiClient;
import com.project.backend.service.IGenreService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;

@Service
@RequiredArgsConstructor
public class GenreService implements IGenreService {

    private final ApiClient apiClient;
    @Override
    public List<Category> getAllGenres() throws IOException {
        return apiClient.getAllGenres();
    }

}
