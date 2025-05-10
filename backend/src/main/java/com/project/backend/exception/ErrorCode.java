package com.project.backend.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;

@Getter
public enum ErrorCode {
    UNCATEGORIZED_EXCEPTION(9999, "Uncategorized error", HttpStatus.INTERNAL_SERVER_ERROR),
    USER_EXISTED(1002, "User existed", HttpStatus.BAD_REQUEST),
    USERNAME_INVALID(1003, "Username must be at least {min} characters", HttpStatus.BAD_REQUEST),
    INVALID_PASSWORD(1004, "Password must be at least {min} characters", HttpStatus.BAD_REQUEST),
    USER_NOT_FOUND(1005, "User not found", HttpStatus.NOT_FOUND),
    HTTP_METHOD_NOT_SUPPORTED(1006, "Http method not supported", HttpStatus.METHOD_NOT_ALLOWED),
    UNAUTHENTICATED(1007, "Unauthenticated", HttpStatus.UNAUTHORIZED),
    BAD_CREDENTIALS(1008, "Bad credentials", HttpStatus.UNAUTHORIZED),
    UNAUTHORIZED(1008, "Unauthorized", HttpStatus.FORBIDDEN),
    INVALID_DOB(1009, "Your age must be at least {min}", HttpStatus.BAD_REQUEST),
    TOKEN_REVOKED(1010, "Token revoked", HttpStatus.UNAUTHORIZED),
    TOKEN_EXPIRED(1011, "Token expired", HttpStatus.UNAUTHORIZED),
    USER_ALREADY_EXISTS(1012, "User already exists", HttpStatus.CONFLICT),
    EXCEEDS_MAX_PROFILE(1013, "Exceeds max profile", HttpStatus.BAD_REQUEST),
    EXCEEDS_MAX_DEVICE(1014, "Exceeds max device", HttpStatus.BAD_REQUEST),
    EXCEEDS_MAX_DEVICE_ACTIVE(1015, "Exceeds max device active", HttpStatus.BAD_REQUEST),
    ;

    ErrorCode(int code, String message, HttpStatusCode httpStatusCode) {
        this.code = code;
        this.message = message;
        this.httpStatusCode = httpStatusCode;
    }

    private int code;
    private String message;
    private HttpStatusCode httpStatusCode;

}
