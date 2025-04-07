package com.project.backend.dto;


import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class HistoryDTO {
    Long id;
    @JsonProperty("movie_slug")
    String movieSlug;
    @JsonProperty("watch_duration")
    int watchDuration;

    @NotNull
    @JsonProperty("profile_id")
    Long profileId;
    @JsonProperty("last_watch")
    LocalDateTime lastWatch;

    boolean finished;
}
