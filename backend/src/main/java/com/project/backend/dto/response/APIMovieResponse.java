package com.project.backend.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import lombok.Getter;

import java.util.List;

@Data
public class APIMovieResponse {
    private Boolean status;
    private String msg;
    private Movie movie;
    private List<Episode> episodes;
}

@Data
class Tmdb {
    private String type;
    private String id;
    private Integer season;
    private Double vote_average;
    private Integer vote_count;

}

@Data
class Imdb {
    private String id;

}


