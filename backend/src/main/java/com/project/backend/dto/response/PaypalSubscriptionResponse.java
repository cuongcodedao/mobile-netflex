package com.project.backend.dto.response;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class PaypalSubscriptionResponse {
    private String status;
    private String id;
    private String plan_id;
    private String create_time;
    private List<Link> links;

    @Data
    public static class Link {
        private String href;
        private String rel;
        private String method;
    }
}

