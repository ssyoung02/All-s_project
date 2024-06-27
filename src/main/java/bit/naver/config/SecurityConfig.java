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

import bit.naver.security.CustomLogoutSuccessHandler;
import bit.naver.security.UsersUserDetailsService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean; // Bean 등록 어노테이션
import org.springframework.context.annotation.Configuration; // Spring 설정 클래스 어노테이션
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder; // 인증 관리 설정
import org.springframework.security.config.annotation.web.builders.HttpSecurity; // HTTP 요청 보안 설정
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity; // Spring Security 활성화
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter; // Spring Security 설정 어댑터
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder; // BCrypt 비밀번호 암호화
import org.springframework.security.crypto.password.PasswordEncoder; // 비밀번호 암호화 인터페이스
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.csrf.CsrfFilter;
import org.springframework.security.web.context.SecurityContextPersistenceFilter;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;
import org.springframework.security.web.csrf.CsrfFilter;
import org.springframework.security.web.session.HttpSessionEventPublisher;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.web.filter.CharacterEncodingFilter;


@Configuration
// 이 클래스를 Spring 설정 클래스로 지정하여 Bean 등록 및 설정을 처리합니다.
@EnableWebSecurity
// Spring Security를 활성화하고 웹 보안 설정을 구성합니다.
@RequiredArgsConstructor // Lombok 어노테이션: final 필드에 대한 생성자 자동 생성
public class SecurityConfig extends WebSecurityConfigurerAdapter  {


    private final CustomLogoutSuccessHandler customLogoutSuccessHandler;

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
    public void configure(WebSecurity web) throws Exception {  //리소스 파일들을 시큐리티와 관계없이 통과시키기위한 메소드
        web.ignoring().antMatchers("/webapp/resources/**","/resources/**","/webapp/resources/images/**","/webapp/resources/css/**",
                "/studies/listOnAnonymousMap","/detail/{studyIdx}",
                "/Users/checkDuplicate","/Users/UsersImageUpdate");
    }


    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
                .authorizeRequests()
                .antMatchers("/admin/**").hasRole("ADMIN") // 관리자 페이지 접근 제한
                .antMatchers("/resources/**","/webapp/resources/css/**",
                        "/webapp/resources/js/**", "/", "/main", "/about").permitAll()
                .antMatchers("/Users/checkDuplicate", "/Users/UsersRegister",
                        "/Users/Join", "/Users/Login", "/Users/UsersLoginForm"
                        , "/access-denied").permitAll()
                    .antMatchers("/kakao/login/alls", "/login/kakao", "/Users/Join").permitAll()
                    .antMatchers("/login/naver", "/login/oauth2/code/naver", "/include/**").permitAll()
                // 그 외 모든 요청은 인증된 사용자만 접근 허용
                    .antMatchers("/calendar/**").authenticated()
                    .antMatchers("/login/oauth2/code/google",  "/login/google").permitAll() //"/login/oauth2/authorization/google"
        // 그 외 모든 요청은 인증된 사용자만 접근 허용
                    .antMatchers("/Users/userInfoProcess").authenticated()
                    .antMatchers("/Users/userInfo").authenticated()
                    .antMatchers("/calendar/*").authenticated()
                    .antMatchers("/Users/updateLocation").authenticated()
                    .antMatchers(HttpMethod.POST, "/calendar/addSchedule").authenticated()
                .anyRequest().authenticated()
                .and()
                .formLogin()
                    .loginPage("/Users/UsersLoginForm")
                    .loginProcessingUrl("/Users/Login")
                    .defaultSuccessUrl("/main")
                    .failureUrl("/Users/UsersLoginForm?error=true") // 로그인 실패 시 에러 파라미터와 함께 로그인 페이지로 이동
                    .permitAll()
                .and()
                .logout()
                .logoutUrl("/Users/logout")
                .logoutSuccessUrl("/main")
                .logoutSuccessHandler(customLogoutSuccessHandler)
                .invalidateHttpSession(true)
                .permitAll()
                .and()
                .csrf()
                .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse()) // CSRF 토큰을 쿠키에 저장 (JavaScript에서 접근 가능)
                .ignoringAntMatchers("/Users/checkDuplicate", "/Users/updateLocation", "/calendar/**", "/admin/**", "/include/start", "/include/pause", "/include/updateTime", "/include/updateMemo", "/Users/UsersImageUpdate")
                .and()
                .sessionManagement() // 세션 관리 설정 시작
//                .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED) // 세션 필요 시 생성
                .maximumSessions(1) // 최대 허용 가능한 세션 수 (1로 설정하면 단일 로그인만 허용)
                .maxSessionsPreventsLogin(false) // 최대 세션 수 초과 시 로그인 차단 여부 (false로 설정하면 기존 세션 만료)
                .expiredUrl("/Users/UsersLoginForm?expired") // 세션 만료 시 이동할 URL(만료 메시지 표시)
                // invalidSessionUrl 메서드 호출 위치 변경 및 and() 추가
                .and()
                .invalidSessionUrl("/Users/UsersLoginForm?invalid")
                .and()
                    .addFilterBefore(new CharacterEncodingFilter("UTF-8", true), CsrfFilter.class);//csrf 활성화


        http.sessionManagement()
                .maximumSessions(1)
                .maxSessionsPreventsLogin(false)
                .expiredUrl("/main?expired")
                .and()
                .invalidSessionUrl("/main")
                .sessionFixation().migrateSession(); // 세션 고정 공격 방지
        /*
            추가 설정 시 필요:

            세션 유지 시간 설정: sessionManagement().sessionFixation().migrateSession() 또는 sessionManagement().sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED) 등을 사용하여 세션 유지 시간을 설정할 수 있습니다.
            세션 쿠키 설정: sessionManagement().sessionCookieName("JSESSIONID") 등을 사용하여 세션 쿠키 이름, 경로, 보안 설정 등을 변경할 수 있습니다.
            세션 이벤트 리스너: sessionManagement().sessionEventPublisher(new HttpSessionEventPublisher()) 등을 사용하여 세션 생성, 만료 등 이벤트 발생 시 처리 로직을 추가할 수 있습니다.

        */

        // SecurityContextHolder 설정 (기존 코드 유지)
        SecurityContextHolder.setStrategyName(SecurityContextHolder.MODE_INHERITABLETHREADLOCAL);

    }

    // HTTP 요청에 대한 보안 설정 메서드입니다.
    // URL 패턴에 따라 접근 권한을 설정하고, 로그인/로그아웃 페이지 및 처리 방식을 지정합니다.

    @Bean // HttpSessionEventPublisher 빈 등록
    public HttpSessionEventPublisher httpSessionEventPublisher() {
        return new HttpSessionEventPublisher();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    // BCryptPasswordEncoder를 Bean으로 등록하여 비밀번호 암호화에 사용합니다.
}