package com.m_life.userservice.dto;

import lombok.Data;

@Data
public class SignupRequest {

    private String username;
    private String password;
    private String nickname;
    private String email;
}