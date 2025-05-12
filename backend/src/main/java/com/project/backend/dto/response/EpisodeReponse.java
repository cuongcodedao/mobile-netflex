package com.project.backend.dto.response;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Builder;
import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@Builder
public class EpisodeReponse {
    private String poster_url;
    private String name;
    private String slug;
    private String filename;
    private String link_embed;
    private String link_m3u8;
}
