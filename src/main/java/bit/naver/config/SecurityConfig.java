//package bit.naver.config;
//
//import kr.bit.security.MemberUserDetailsService;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
//import org.springframework.security.config.annotation.web.builders.HttpSecurity;
//import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
//import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
//import org.springframework.security.core.userdetails.UserDetailsService;
//import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
//import org.springframework.security.crypto.password.PasswordEncoder;
//import org.springframework.security.web.csrf.CsrfFilter;
//import org.springframework.web.filter.CharacterEncodingFilter;
//
//@Configuration
//@EnableWebSecurity
//public class SecurityConfig extends WebSecurityConfigurerAdapter {
//
//    @Bean
//    public UserDetailsService UserDetailsService() {
//        return new MemberUserDetailsService();
//    }
//
//    @Override
//    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
//        auth.userDetailsService(UserDetailsService()).passwordEncoder(passwordEncoder());
//        //loadUserByUsername(String username) 함수가 실행될 조건
//    }
//
//    //비밀번호 암호화 하기 위해
//    @Bean
//    public PasswordEncoder passwordEncoder() {
//        return new BCryptPasswordEncoder();
//    }
//
//    @Override
//    protected void configure(HttpSecurity security) throws Exception {//mvc와 쉬큐리티 결합해서 필요한 환경을 이 클래스에세 설정
//        //요청에 대한 보안 -> 한글깨짐 방지
//        CharacterEncodingFilter filter=new CharacterEncodingFilter();
//        filter.setEncoding("UTF-8");
//        filter.setForceEncoding(true);
//        security.addFilterBefore(filter, CsrfFilter.class);
//
//        //요청에 따른 권한을 확인하여 서비스 하는 부분
//        //인증: ex) 로그인 처리 (시큐리티에서 로그인, 로그아웃 처리 제공해줌)
//        //인가: 인증된 사용자가 해당 기능을 접속할 권한이 있는지 확인(권한체크)
//        security
//                .authorizeRequests ()
//                .antMatchers("/") // 설정한 리소스 접근을 인증절차 없이 허용하겠다
//                .permitAll()
//                .and ()
//                .formLogin()// 스프링에서 제공해주는 폼이 기본으로 나온다(로그인처리 성공실패 처리 사용)
//                .loginPage("/memberLoginForm") //사용자가 만든 로그인페이지를 사용하려할 때 설정
//                .loginProcessingUrl("/memberLogin") //이 url이 왔을때 스프링 시큐리티 로그인으로 넘어가겠다(인증처리필터)
//                .permitAll()
//                .and ()
//                .logout() //스프링에서 설정해놓은 logout거쳐 세션끝나고
//                .invalidateHttpSession(true) //세션제거
//                .logoutSuccessUrl("/") //로그아웃 처리
//                .and() //성공 처리 후 이동
//                .exceptionHandling().accessDeniedPage("/access-denied"); //오류페이지로 이동
//    }
//}