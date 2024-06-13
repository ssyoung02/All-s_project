//ServletAppContext의 핵심 기능:
//Spring MVC 활성화 (@EnableWebMvc):
//          Spring MVC 프레임워크를 활성화하고 웹 애플리케이션 개발에 필요한 다양한 기능들을 자동으로 설정합니다.
//컴포넌트 스캔 (@ComponentScan):
//          bit.naver.controller 패키지 내의 컴포넌트들을 스캔하여 빈으로 등록합니다.
//          일반적으로 @Controller 어노테이션이 붙은 클래스들이 컨트롤러로 등록되어 웹 요청을 처리합니다.
//JSP 뷰 리졸버 설정 (configureViewResolvers):
//          JSP 파일 경로 설정 (/WEB-INF/views/) 및 확장자 (.jsp)를 지정하여
//          컨트롤러에서 반환하는 뷰 이름에 따라 해당 JSP 파일을 찾아 응답을 생성하도록 설정합니다.
//정적 자원 경로 설정 (addResourceHandlers):
//          웹 애플리케이션에서 사용하는 CSS, JavaScript, 이미지 등 정적 자원의 경로를 설정합니다.
//          여기서는 모든 요청 (/**)에 대해 /resources/ 경로에서 자원을 찾도록 설정합니다.
// 이 설정 클래스는 웹 애플리케이션의 뷰, 정적 자원, 컨트롤러 등 Spring MVC 관련 설정을 담당하며,
// SpringConfigClass에 의해 로드되어 웹 애플리케이션 초기화 과정에서 사용

package bit.naver.config;

import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.validation.Validator;
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;
import org.springframework.web.servlet.config.annotation.*;

@Configuration
// 해당 클래스를 Spring 설정 클래스로 지정하여 빈(Bean) 등록 및 설정을 처리합니다.
@EnableWebMvc
// Spring MVC를 활성화하고 기본적인 웹 MVC 설정을 자동으로 구성합니다.
@ComponentScan(basePackages = {"bit.naver.controller"})
// bit.naver.controller 패키지 내의 컴포넌트들을 스캔하여 Spring 컨테이너에 빈으로 등록합니다. 주로 @Controller 어노테이션이 붙은 클래스들이 컨트롤러로 등록됩니다.

public class ServletAppContext implements WebMvcConfigurer {

    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        WebMvcConfigurer.super.configureViewResolvers(registry);
        registry.jsp("/WEB-INF/views/", ".jsp"); // JSP 파일 경로 설정 (prefix, suffix)
    }

    // configureViewResolvers 메서드는 ViewResolver를 설정하는 역할을 합니다.
    // 여기서는 JSP 뷰 리졸버를 설정하여 /WEB-INF/views/ 경로에서 .jsp 확장자를 가진 JSP 파일을 찾아서 뷰로 사용하도록 지정합니다.
    // super.configureViewResolvers(registry) 호출은 부모 클래스의 기본 설정을 상속받는 부분입니다.

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        WebMvcConfigurer.super.addResourceHandlers(registry);
        registry.addResourceHandler("/resources/**").addResourceLocations("/resources/"); // 정적 자원 경로 설정
    }

    // addResourceHandlers 메서드는 웹 애플리케이션에서 사용하는 정적 자원(CSS, JavaScript, 이미지 등)의 경로를 설정하는 역할을 합니다.
    // 여기서는 "/**" 패턴에 해당하는 모든 요청을 /resources/ 경로에서 찾도록 설정합니다.
    // super.addResourceHandlers(registry) 호출은 부모 클래스의 기본 설정을 상속받는 부분입니다.

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/").setViewName("redirect:/main"); // 루트 경로 접근 시 메인 페이지리다이렉트
    }

    @Bean
    public MessageSource messageSource() {
        ResourceBundleMessageSource messageSource = new ResourceBundleMessageSource();
        messageSource.setBasename("messages"); // messages.properties 파일 사용 (필요에 따라 변경)
        messageSource.setDefaultEncoding("UTF-8"); // UTF-8 인코딩 설정
        return messageSource;
    }

    @Bean
    public LocalValidatorFactoryBean validator() {
        LocalValidatorFactoryBean factoryBean = new LocalValidatorFactoryBean();
        factoryBean.setValidationMessageSource(messageSource()); // MessageSource 주입
        return factoryBean;
    }

    @Override
    public Validator getValidator() {
        return validator();
    }

}
