package com.project.backend.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import lombok.Getter;

import java.util.List;

@Data
@Getter
public class Episode {
    private String server_name;

    @JsonProperty("server_data")
    private List<ServerData> serverData;

}
