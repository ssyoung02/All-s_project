//RootAppContext의 핵심 기능
//DB 연결 설정:
//          HikariCP를 사용하여 데이터베이스 연결 풀을 생성하고 설정합니다.
//MyBatis 설정:
//          SqlSessionFactoryBean을 통해 SqlSessionFactory를 생성하고,
//          데이터 소스와 XML Mapper 파일 경로를 설정합니다.
//          SqlSessionTemplate을 생성하여 MyBatis 작업을 편리하게 수행할 수 있도록 합니다.
//컴포넌트 스캔:
//          bit.naver 패키지 내의 컴포넌트를 스캔하여 Spring 컨테이너에 등록합니다.
//Mapper 스캔:
//          bit.naver.mapper 패키지 내의 MyBatis Mapper 인터페이스를 스캔하여 자동으로 빈으로 등록합니다.
package bit.naver.config;

import com.zaxxer.hikari.HikariConfig;    // HikariCP 설정 클래스
import com.zaxxer.hikari.HikariDataSource;  // HikariCP 데이터 소스 클래스
import org.apache.ibatis.session.SqlSessionFactory;  // MyBatis SqlSessionFactory 인터페이스
import org.mybatis.spring.SqlSessionFactoryBean; // MyBatis-Spring 연동 설정 클래스
import org.mybatis.spring.SqlSessionTemplate;   // MyBatis-Spring SqlSessionTemplate 클래스
import org.mybatis.spring.annotation.MapperScan;  // Mapper 스캔 어노테이션
import org.springframework.beans.factory.annotation.Autowired; // 자동 의존성 주입 어노테이션
import org.springframework.context.annotation.Bean;  // Bean 등록 어노테이션
import org.springframework.context.annotation.ComponentScan; // 컴포넌트 스캔 어노테이션
import org.springframework.context.annotation.Configuration; // Spring 설정 클래스 어노테이션
import org.springframework.context.annotation.PropertySource; // 프로퍼티 파일 로드 어노테이션
import org.springframework.core.env.Environment;  // 환경 변수 접근 인터페이스
import org.springframework.core.io.support.PathMatchingResourcePatternResolver; // 리소스 패턴 매칭 클래스

import javax.sql.DataSource; // DataSource 인터페이스

@Configuration
// 이 클래스가 Spring 설정 클래스임을 나타냅니다.
@MapperScan("bit.naver.mapper")
// bit.naver.mapper 패키지 내의 MyBatis Mapper 인터페이스를 스캔하여 자동으로 빈으로 등록합니다.
@ComponentScan(basePackages = {"bit.naver.mapper", "bit.naver.security", "bit.naver.service","bit.naver.listener"})
// bit.naver 패키지 내의 컴포넌트(Controller, Service, Listener 등)를 스캔하여 Spring 컨테이너에 빈으로 등록합니다.
@PropertySource({"classpath:db.properties"})
// classpath 경로에 있는 db.properties 파일을 로드하여 프로퍼티 값을 사용할 수 있도록 설정합니다.
public class RootAppContext {

    @Autowired
    private Environment env;
    // Environment 빈을 주입받아 프로퍼티 파일에서 값을 읽어올 수 있도록 합니다.

    @Bean
    public DataSource myDataSource() {
        // HikariCP를 사용하여 데이터베이스 연결 풀을 생성하고 설정하는 메서드입니다.
        // @Bean 어노테이션을 통해 Spring 컨테이너에 DataSource 빈으로 등록합니다.
        HikariConfig hikari = new HikariConfig();
        // HikariCP 설정 객체 생성
        hikari.setDriverClassName(env.getProperty("jdbc.driver"));
        hikari.setJdbcUrl(env.getProperty("jdbc.url"));
        hikari.setUsername(env.getProperty("jdbc.user"));
        hikari.setPassword(env.getProperty("jdbc.password"));
        // db.properties 파일에서 데이터베이스 연결 정보(드라이버 클래스 이름, URL, 사용자 이름, 비밀번호)를 읽어와 HikariCP 설정에 적용합니다.
        HikariDataSource myDataSource = new HikariDataSource(hikari);
        return myDataSource;
        // HikariCP 데이터 소스 객체를 생성하여 반환합니다.
    }

    @Bean
    public SqlSessionFactory sessionFactory() throws Exception {
        // MyBatis의 SqlSessionFactory를 생성하고 설정하는 메서드입니다.
        // @Bean 어노테이션을 통해 Spring 컨테이너에 SqlSessionFactory 빈으로 등록합니다
        SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
        // SqlSessionFactoryBean 객체를 생성합니다.
        sessionFactory.setDataSource(myDataSource());
        // 앞서 생성한 HikariCP 데이터 소스를 MyBatis 설정에 주입합니다.
        sessionFactory.setMapperLocations(
                new PathMatchingResourcePatternResolver().getResources("classpath:mapper/*.xml")
        );
        // classpath 경로에서 모든 XML Mapper 파일을 찾아서 설정합니다.
        // 여기서는 모든 XML Mapper 파일을 로드하도록 설정되어 있습니다.
        // mapper/xml 폴더에 있는 모든 XML Mapper 파일을 로드합니다.
        sessionFactory.setConfigLocation(new PathMatchingResourcePatternResolver().getResource("classpath:mybatis-config.xml"));

        return sessionFactory.getObject();
        // SqlSessionFactoryBean 객체를 통해 SqlSessionFactory를 생성하고 반환합니다.
    }

    @Bean
    public SqlSessionTemplate sqlSessionTemplate() throws Exception {
        // MyBatis의 SqlSessionTemplate을 생성하는 메서드입니다.
        // @Bean 어노테이션을 통해 Spring 컨테이너에 SqlSessionTemplate 빈으로 등록합니다.
        return new SqlSessionTemplate(sessionFactory());
        // 앞서 생성한 SqlSessionFactory를 사용하여 SqlSessionTemplate을 생성하고 반환합니다.
    }
}