//SecurityInitializer 클래스는 Spring Security의 필터 체인을 웹 애플리케이션에 자동으로 등록하고 초기화하는 역할을 합니다.
//AbstractSecurityWebApplicationInitializer 클래스를 상속받아 Spring Security 필터 체인을 구성하는 데 필요한 기본적인 설정을 자동으로 처리합니다.
//동작 원리:
//
//1. 서블릿 컨테이너 시작: 웹 애플리케이션이 시작될 때 SecurityInitializer 클래스가 실행됩니다.
//2. AbstractSecurityWebApplicationInitializer 실행: 부모 클래스인 AbstractSecurityWebApplicationInitializer는 Spring Security 필터 체인을 구성하고 등록하는 작업을 수행합니다.
//      Spring Security 필터 (DelegatingFilterProxy)를 생성합니다.
//      DelegatingFilterProxy를 웹 애플리케이션의 필터 체인에 등록합니다.
//      SecurityConfig 클래스에서 정의한 설정을 기반으로 필터 체인을 구성합니다.
//3. Spring Security 필터 실행: 웹 요청이 들어올 때마다 Spring Security 필터 체인이 실행되어 인증, 권한 부여 등의 보안 처리를 수행합니다.

// SecurityInitializer의 특징:
//      자동 설정: Spring Security 필터 체인 구성 및 등록을 자동으로 처리하므로 개발자가 직접 설정할 필요가 없습니다.
//      코드 간결화: 필터 체인 설정 코드를 별도로 작성하지 않아도 되므로 코드가 간결해집니다.
//      유지 보수 용이: Spring Security 버전 업그레이드 시 변경 사항을 최소화할 수 있습니다.
//web.xml 파일:
//      파일을 사용하는 경우 SecurityInitializer를 함께 사용하면 충돌이 발생할 수 있습니다.
//      이 경우에는 web.xml에서 필터 설정을 제거하고 SecurityInitializer를 사용해야 합니다.


package bit.naver.config;

import org.springframework.security.web.context.AbstractSecurityWebApplicationInitializer;

public class SecurityInitializer extends AbstractSecurityWebApplicationInitializer {

}