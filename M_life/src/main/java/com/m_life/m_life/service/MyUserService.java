package com.m_life.m_life.service;

import com.m_life.m_life.domain.UserAccount;
import com.m_life.m_life.dto.request.SignupRequest;
import com.m_life.m_life.repository.UserAccountRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class MyUserService {

    private final UserAccountRepository userRepository;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;


    public ResponseEntity<String> joinProcess(SignupRequest signupRequest) {

        String userid = signupRequest.getUsername();
        String nickname = signupRequest.getNickname();
        String password = signupRequest.getPassword();

        Boolean isExist = userRepository.existsByUserid(userid);

        if (isExist) {
            return ResponseEntity.badRequest().body("이미 존재하는 회원 아이디입니다.");
        }
        boolean isExistNick = userRepository.existsByNickname(nickname);
        if(isExistNick){
            return ResponseEntity.badRequest().body("이미 존재하는 회원 닉네임입니다.");
        }

        UserAccount userAccount = UserAccount.of(
                nickname,
                userid,
                bCryptPasswordEncoder.encode(password),
                "ROLE_USER"
        );
        userRepository.save(userAccount);
        return ResponseEntity.ok().body("회원가입 되었습니다.");
    }

    @Transactional(readOnly = true)

    public ResponseEntity<Integer> getLike(String user_nickname) {
        if(userRepository.existsByNickname(user_nickname)){
            UserAccount userAccount = userRepository.findWithLikedPostsByNickname(user_nickname).orElseThrow(
                    () -> new IllegalArgumentException("User not found with nickname : " + user_nickname)
            );
            return ResponseEntity.ok(userAccount.getLikedPosts().size());
        }
        return ResponseEntity.badRequest().body(-1);
    }
}