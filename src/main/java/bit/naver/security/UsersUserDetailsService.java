/*
UsersUserDetailsService 클래스의 핵심 기능:
1.UserDetailsService 인터페이스 구현:
            UserDetailsService 인터페이스는 Spring Security에서 사용자 정보를 조회하는 데 사용되는 인터페이스입니다.
            loadUserByUsername(String username) 메소드를 구현하여 사용자 이름으로 사용자 정보를 조회하고, UserDetails 객체를 반환합니다.
2.UsersMapper 의존성 주입:
            생성자를 통해 UsersMapper 객체를 주입받습니다.
            UsersMapper는 MyBatis를 사용하여 데이터베이스에서 사용자 정보를 조회하는 역할을 합니다.
3.사용자 정보 조회 (loadUserByUsername):
            입력받은 사용자 이름으로 UsersMapper를 통해 데이터베이스에서 사용자 정보를 조회합니다.
            조회된 사용자 정보가 없으면 UsernameNotFoundException 예외를 발생시킵니다.
            조회된 사용자 정보를 기반으로 UsersUser 객체를 생성하여 반환합니다.
UsersUserDetailsService의 역할:
            Spring Security는 인증 과정에서 UserDetailsService를 사용하여 사용자 정보를 가져옵니다.
            UsersUserDetailsService는 데이터베이스에서 사용자 정보를 조회하여 Spring Security에게 제공하는 역할을 합니다.
            이렇게 제공된 사용자 정보는 Spring Security에서 인증 및 권한 부여에 사용됩니다.
 */


package bit.naver.security;

import bit.naver.entity.Users; // Users 엔티티 클래스 임포트
import bit.naver.mapper.UsersMapper; // UsersMapper 인터페이스 임포트 (MyBatis)
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails; // UserDetails 인터페이스 임포트
import org.springframework.security.core.userdetails.UserDetailsService; // UserDetailsService 인터페이스 임포트
import org.springframework.security.core.userdetails.UsernameNotFoundException; // UsernameNotFoundException 예외 클래스 임포트
import org.springframework.stereotype.Service; // Spring 서비스 컴포넌트 어노테이션

import java.util.ArrayList;
import java.util.List;


// 이 클래스를 Spring 빈(Bean)으로 등록합니다. @Component의 특수 형태로 서비스 계층 컴포넌트를 나타냅니다.
@Service
@RequiredArgsConstructor
public class UsersUserDetailsService implements UserDetailsService {


    private final UsersMapper usersMapper;


    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Users user = usersMapper.findByUsername(username);
        // usersMapper를 이용하여 주어진 username으로 Users 객체를 조회합니다.
        // findByUsername 메서드는 UsersMapper 인터페이스에 정의되어 있어야 합니다.
        if (user == null) {
            // 사용자를 찾지 못한 경우 UsernameNotFoundException 예외를 발생시킵니다.
            throw new UsernameNotFoundException("사용자ID를 찾을 수 없습니다.");
        }
        List<GrantedAuthority> authorities = new ArrayList<>();
        authorities.add(new SimpleGrantedAuthority("ROLE_USER")); // 예시 권한
        return new UsersUser(user);
        // UsersUser 객체를 생성하여 반환합니다.
        // UsersUser는 UserDetails 인터페이스를 구현한 클래스로,
        // Spring Security에서 사용자 정보를 다루는 데 필요한 정보를 제공합니다.
    }
}
