//SpringConfigClass의 핵심 기능:
//웹 애플리케이션 초기화:
//          AbstractAnnotationConfigDispatcherServletInitializer를 상속받아
//          서블릿 컨테이너(예: Tomcat) 시작 시 웹 애플리케이션의 초기 설정을 자동으로 처리합니다.
//DispatcherServlet 등록 및 매핑:
//          모든 웹 요청을 DispatcherServlet으로 전달하여 Spring MVC 프레임워크를 통해 처리하도록 설정합니다.
//루트 및 서블릿 컨텍스트 설정:
//          각각 RootAppContext와 ServletAppContext 클래스를 통해 애플리케이션 전반 및 웹 관련 설정을 로드합니다.
//문자 인코딩 필터 설정:
//          웹 요청 및 응답 데이터의 문자 인코딩을 UTF-8로 설정하여 한글 처리 문제를 방지합니다.
package bit.naver.config;


import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.filter.CharacterEncodingFilter; // 문자 인코딩 필터 임포트
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer; // Spring MVC 초기화 클래스 임포트


import javax.servlet.Filter; // 서블릿 필터 인터페이스 임포트
import javax.servlet.ServletRegistration;

public class SpringConfigClass extends AbstractAnnotationConfigDispatcherServletInitializer {

    // 웹 애플리케이션 초기화를 담당하는 클래스
    // AbstractAnnotationConfigDispatcherServletInitializer를 상속받아 웹 애플리케이션의 초기 설정을 처리합니다.

    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class[] {RootAppContext.class, SecurityConfig.class};
    }

    // RootAppContext, SecurityConfig 클래스를 반환하여
    // 애플리케이션 전반에 걸친 설정(예: 데이터베이스 연결, Spring Security 설정)을 로드합니다.


    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class[] {ServletAppContext.class};
    }

    // ServletAppContext 클래스를 반환하여 웹 MVC 관련 설정(예: 컨트롤러, 뷰 리졸버 등)을 로드합니다.


    @Override
    protected String[] getServletMappings() {
        return new String[] {"/"};
    }

    // 모든 URL 패턴("/")에 대한 요청을 DispatcherServlet에게 위임하여 처리하도록 설정합니다.
    // 즉, 모든 웹 요청은 Spring MVC 프레임워크를 통해 처리됩니다.


    @Override
    protected Filter[] getServletFilters() {
        CharacterEncodingFilter characterEncodingFilter = new CharacterEncodingFilter();
        characterEncodingFilter.setEncoding("UTF-8");
        characterEncodingFilter.setForceEncoding(true);
        return new Filter[] { characterEncodingFilter };
    }




}
