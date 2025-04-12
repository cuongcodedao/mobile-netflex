package com.project.backend.service.impl;

import com.project.backend.dto.response.Category;
import com.project.backend.repository.ApiClient;
import com.project.backend.service.ICategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CategoryService implements ICategoryService {

    private final ApiClient apiClient;
    @Override
    public List<Category> getAllCategories() throws IOException {
        return apiClient.getAllGenres();
    }

}
