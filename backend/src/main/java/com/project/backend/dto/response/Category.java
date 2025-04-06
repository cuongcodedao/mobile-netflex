package com.project.backend.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class Category {
    private String id;
    private String name;
    private String slug;
}
