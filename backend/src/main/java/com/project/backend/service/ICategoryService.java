package com.project.backend.service;

import com.project.backend.dto.response.Category;

import java.io.IOException;
import java.util.List;

public interface ICategoryService {
    List<Category> getAllCategories() throws IOException;


}
