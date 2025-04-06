package com.project.backend.dto.response;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.util.List;

@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class Movie {
    private Tmdb tmdb;
    private Imdb imdb;

    @JsonProperty("_id")
    private String id;

    private String name;
    private String slug;
    private String origin_name;
    private String content;
    private String type;
    private String status;
    private String poster_url;
    private String thumb_url;

    @JsonProperty("is_copyright")
    private Boolean isCopyright;

    @JsonProperty("sub_docquyen")
    private Boolean subDocquyen;

    private Boolean chieurap;
    private String trailer_url;
    private String time;
    private String episode_current;
    private String episode_total;
    private String quality;
    private String lang;
    private String notify;
    private String showtimes;
    private Integer year;
    private Integer view;
    private List<String> actor;
    private List<String> director;
    private List<Category> category;
    private List<Country> country;

}
