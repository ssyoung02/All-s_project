/*
UsersUser 클래스의 핵심 기능:
1.UserDetails 인터페이스 구현:
            Spring Security에서 요구하는 사용자 정보를 제공하기 위해 UserDetails 인터페이스를 구현합니다.
2.Users 엔티티와의 연결:
            Users 엔티티 객체를 멤버 변수로 가지고,
            UserDetails 인터페이스의 메소드에서 필요한 정보를 Users 객체에서 가져옵니다.
3.권한 정보 제공:
            getAuthorities() 메소드를 통해 사용자의 권한 목록을 제공합니다.
            현재는 모든 사용자에게 "ROLE_USER" 권한을 부여합니다.
개선 사항:
권한 관리: 사용자별로 다른 권한을 부여해야 하는 경우,
             Users 엔티티에 권한 정보를 추가하고 getAuthorities() 메소드에서 해당 정보를 기반으로 권한 목록을 생성해야 합니다.
계정 상태 관리:
            계정 만료, 잠금, 비밀번호 만료 등의 정보를 관리해야 하는 경우,
            Users 엔티티에 해당 필드를 추가하고
            isAccountNonExpired(), isAccountNonLocked(), isCredentialsNonExpired() 메소드에서 해당 정보를 반환해야 합니다.
 */

package bit.naver.security;

import bit.naver.entity.Users; // 사용자 엔티티 클래스 임포트
import org.springframework.security.core.GrantedAuthority; // 권한 인터페이스
import org.springframework.security.core.authority.SimpleGrantedAuthority; // 간단 권한 구현 클래스
import org.springframework.security.core.userdetails.UserDetails; // 사용자 정보 인터페이스

import java.util.Collection; // 컬렉션 인터페이스
import java.util.Collections; // 컬렉션 관련 유틸리티 클래스

// Spring Security의 UserDetails 인터페이스를 구현한 클래스입니다.
public class UsersUser implements UserDetails {

    private final Users user;

    // Users 엔티티 객체를 저장하는 멤버 변수입니다.
    // 생성자를 통해 Users 객체를 받아 초기화합니다.
    public UsersUser(Users user) {
        this.user = user;
    }

    public Users getUsers() { // Users 객체를 반환하는 메서드
        return user;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.singleton(new SimpleGrantedAuthority("ROLE_USER"));
    }

    // 사용자의 권한 목록을 반환합니다.
    // 여기서는 모든 사용자에게 "ROLE_USER" 권한을 부여합니다.
    // 만약 사용자별로 다른 권한을 부여해야 한다면, Users 엔티티에 권한 정보를 추가하고
    // 해당 정보를 기반으로 권한 목록을 생성해야 합니다.

    @Override
    public String getPassword() {
        return user.getPassword();
    }

    // 사용자의 비밀번호를 반환합니다.
    // 비밀번호는 Users 엔티티에서 가져옵니다.

    @Override
    public String getUsername() {
        return user.getUsername();
    }

    // 사용자의 아이디를 반환합니다.
    // 아이디는 Users 엔티티에서 가져옵니다.

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    // 계정 만료 여부를 반환합니다.
    // 여기서는 모든 계정이 만료되지 않았다고 가정합니다. (true 반환)

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    // 계정 잠금 여부를 반환합니다.
    // 여기서는 모든 계정이 잠기지 않았다고 가정합니다. (true 반환)

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    // 비밀번호 만료 여부를 반환합니다.
    // 여기서는 모든 비밀번호가 만료되지 않았다고 가정합니다. (true 반환)

    @Override
    public boolean isEnabled() {
        return user.getEnabled();
    }

    // 계정 활성화 여부를 반환합니다.
    // Users 엔티티의 enabled 필드 값을 그대로 반환합니다.
}
