//Spring Security 활성화 (@EnableWebSecurity):
//          Spring Security를 웹 애플리케이션에 적용합니다.
//
//인증 설정 (configure(AuthenticationManagerBuilder)):
//          사용자 정보를 가져오는 UserDetailsService와 비밀번호 암호화를 위한 PasswordEncoder를 설정합니다.
//
//HTTP 요청 보안 설정 (configure(HttpSecurity)):
//          특정 URL 패턴에 대한 접근 권한을 설정합니다.
//          폼 기반 로그인을 사용하고 로그인 페이지 경로를 지정합니다.
//          로그아웃 기능을 설정합니다.
//비밀번호 암호화 (passwordEncoder):
//          BCryptPasswordEncoder를 사용하여 비밀번호를 안전하게 암호화합니다.
package bit.naver.config;

import bit.naver.security.UsersUserDetailsService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean; // Bean 등록 어노테이션
import org.springframework.context.annotation.Configuration; // Spring 설정 클래스 어노테이션
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder; // 인증 관리 설정
import org.springframework.security.config.annotation.web.builders.HttpSecurity; // HTTP 요청 보안 설정
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity; // Spring Security 활성화
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter; // Spring Security 설정 어댑터
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder; // BCrypt 비밀번호 암호화
import org.springframework.security.crypto.password.PasswordEncoder; // 비밀번호 암호화 인터페이스


@Configuration
// 이 클래스를 Spring 설정 클래스로 지정하여 Bean 등록 및 설정을 처리합니다.
@EnableWebSecurity
// Spring Security를 활성화하고 웹 보안 설정을 구성합니다.
@RequiredArgsConstructor // Lombok 어노테이션: final 필드에 대한 생성자 자동 생성
public class SecurityConfig extends WebSecurityConfigurerAdapter  {

    private final UsersUserDetailsService usersUserDetailsService;

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(usersUserDetailsService).passwordEncoder(passwordEncoder());
    }

    // 인증 관리자 설정 메서드입니다.
    // UserDetailsService를 설정하여 사용자 정보를 가져오고,
    // PasswordEncoder를 설정하여 비밀번호 암호화 방식을 지정합니다.
    // 여기서는 BCryptPasswordEncoder를 사용하여 비밀번호를 암호화합니다.
    /*
    UsersUserDetailsService 대신 UserDetailsService 인터페이스를 사용하여 의존성을 주입받습니다.
    Spring은 UsersUserDetailsService가 UserDetailsService를 구현하고 있으므로,
    자동으로 userDetailsService 변수에 UsersUserDetailsService 객체를 주입합니다.
    이렇게 하면 SecurityConfig와 UsersUserDetailsService 사이의 직접적인 의존 관계가 제거되어 순환 참조 문제가 해결됩니다.
     */


    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
                .authorizeRequests()
                // 모든 사용자 접근 허용 경로
                .antMatchers("/resources/**", "/", "/main", "/about").permitAll()
                .antMatchers("/Users/checkDuplicate", "/Users/UsersRegister", "/Users/Join", "/Users/Login", "/Users/UsersLoginForm", "/Users/access-denied").permitAll()
                // 관리자만 접근 허용 경로
                .antMatchers("/admin/**").hasRole("ADMIN")
                // 그 외 모든 요청은 인증된 사용자만 접근 허용
                .anyRequest().authenticated()
                .and()
                .formLogin()
                .loginPage("/Users/UsersLoginForm")
                .failureUrl("/Users/UsersLoginForm?error=true") // 로그인 실패 시 에러 파라미터와 함께 로그인 페이지로 이동
                .permitAll()
                .and()
                .logout()
                .permitAll()

            /*
                .and()
                .oauth2Login() // OAuth2 로그인 설정 (현재는 주석 처리)
                    .loginPage("/login")  //(폼 로그인과 동일한 페이지 사용 가능)
                    .userInfoEndpoint()
                        .userService(customOAuth2UserService) // OAuth2 사용자 정보 처리 서비스 (구현 필요) (customOAuth2UserService는 직접 구현해야 함)->로그인성공 후 사용자정보 가져오는 서비스
                .and()
                    .successHandler(oAuth2LoginSuccessHandler) // OAuth2 로그인 성공시 핸들러 (구현 필요)
                    .failureHandler(oAuth2LoginFailureHandler); // OAuth2 로그인 실패시 핸들러 (구현 필요)
                */
            /*
            추가적으로 필요한 작업:

            OAuth2 클라이언트 등록: Google, Naver, Kakao 등 소셜 로그인 제공 업체에 애플리케이션을 등록하고 클라이언트 ID, 클라이언트 시크릿 등 정보를 발급받아야 합니다.
            CustomOAuth2UserService 구현: OAuth2 로그인 성공 후 사용자 정보를 가져와서 애플리케이션에 맞게 처리하는 로직을 구현해야 합니다. (예: 사용자 정보를 DB에 저장하거나 세션에 저장)
            OAuth2LoginSuccessHandler, OAuth2LoginFailureHandler 구현: OAuth2 로그인 성공/실패 시 처리할 로직을 구현해야 합니다. (예: 로그인 성공 시 메인 페이지로 이동, 실패 시 에러 페이지로 이동)
            현재 상태:
            주석 처리된 부분을 제외하면 기존의 폼 로그인 방식으로 동작합니다. 추후 OAuth2 소셜 로그인 기능을 추가할 때 주석을 해제하고 필요한 클래스들을 구현하면 됩니다.
             */
//                .and()
//                .sessionManagement() // 세션 관리 설정 시작
//                .maximumSessions(1) // 최대 허용 가능한 세션 수 (1로 설정하면 단일 로그인만 허용)
//                .maxSessionsPreventsLogin(false) // 최대 세션 수 초과 시 로그인 차단 여부 (false로 설정하면 기존 세션 만료)
//                .expiredUrl("/main") // 세션 만료 시 이동할 URL(만료 메시지 표시)
//                // invalidSessionUrl 메서드 호출 위치 변경 및 and() 추가
//                .and()
//                .invalidSessionUrl("/main") // 유효하지 않은 세션 접근 시 이동할 URL(유효하지 않은 세션 메시지 표시)
                .and()
                .csrf() // CSRF 보호 활성화
                .disable();
//                .ignoringAntMatchers("/Users/checkDuplicate","/main") // 중복확인 csrf 예외처리
        ;
        /*
            추가 설정 시 필요:

            세션 유지 시간 설정: sessionManagement().sessionFixation().migrateSession() 또는 sessionManagement().sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED) 등을 사용하여 세션 유지 시간을 설정할 수 있습니다.
            세션 쿠키 설정: sessionManagement().sessionCookieName("JSESSIONID") 등을 사용하여 세션 쿠키 이름, 경로, 보안 설정 등을 변경할 수 있습니다.
            세션 이벤트 리스너: sessionManagement().sessionEventPublisher(new HttpSessionEventPublisher()) 등을 사용하여 세션 생성, 만료 등 이벤트 발생 시 처리 로직을 추가할 수 있습니다.

        */
            /*
            로그인 페이지 이후 페이지 에서 csrf 코드 추가 필요
            <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <form method="POST" action="/member/login">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            </form>
             */

    }

    // HTTP 요청에 대한 보안 설정 메서드입니다.
    // URL 패턴에 따라 접근 권한을 설정하고, 로그인/로그아웃 페이지 및 처리 방식을 지정합니다.

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    // BCryptPasswordEncoder를 Bean으로 등록하여 비밀번호 암호화에 사용합니다.
}
