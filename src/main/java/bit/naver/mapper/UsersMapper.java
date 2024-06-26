/*UsersMapper 인터페이스의 핵심 기능:
MyBatis Mapper:
            @Mapper 어노테이션을 사용하여 MyBatis Mapper 인터페이스임을 나타냅니다.
            이 인터페이스의 메소드들은 XML 매퍼 파일 또는 어노테이션에 정의된 SQL 문과 연결되어 데이터베이스 작업을 수행합니다.
CRUD 작업:
            사용자 정보에 대한 기본적인 CRUD(Create, Read, Update, Delete) 작업을 위한 메소드를 제공합니다.
어노테이션 활용:
            각 메소드에 @Select, @Insert, @Update, @Delete 어노테이션을 사용하여 SQL 문을 지정합니다. @Options 어노테이션은 추가적인 설정을 제공합니다.
개선 사항:
        SQL 문 관리: SQL 문을 인터페이스에 직접 작성하는 대신 XML 매퍼 파일로 분리하여 관리하는 것이 좋습니다. 이렇게 하면 SQL 문을 더욱 효율적으로 관리하고 재사용할 수 있습니다.
        -> UsersMapper.xml 설명
                    SQL 문을 XML 매퍼 파일로 분리. SQL 문 관리가 용이해지고 코드 가독성이 향상
                    ResultMap 사용: UsersResultMap 정의 ->Users 엔티티 클래스와 데이터베이스 테이블 간의 매핑 정보를 명시 -> 조회 결과를 Users 객체에 자동으로 매핑
        Null 처리: 데이터베이스에서 조회된 값이 null일 경우를 고려하여 NullPointerException 발생을 방지하는 로직을 추가하는 것이 좋습니다.
        파라미터 유효성 검증: 메소드에 전달되는 파라미터의 유효성을 검증하여 예외 상황을 방지하는 것이 좋습니다.
UsersMapper.xml 추가 고려 사항:
            동적 SQL: 조건에 따라 SQL 문을 변경해야 하는 경우 동적 SQL(Dynamic SQL)을 사용하는 것이 좋습니다. MyBatis는 <if>, <choose>, <when>, <otherwise>, <where>, <foreach> 등 다양한 동적 SQL 요소를 제공합니다.
            매개변수 처리: SQL 문에 사용되는 매개변수의 타입과 이름을 명확하게 지정하는 것이 좋습니다. 이는 코드 가독성을 높이고 오류를 줄이는 데 도움이 됩니다.
            페이징 처리: 대량의 데이터를 조회할 때는 페이징 처리를 적용하는 것이 좋습니다. MyBatis는 <select> 태그의 offset과 limit 속성을 사용하여 페이징 처리를 지원합니다.
*/
package bit.naver.mapper;

import bit.naver.entity.Users; // Users 엔티티 클래스 임포트
import org.apache.ibatis.annotations.*; // MyBatis 어노테이션 임포트

import java.util.List; // List 인터페이스 임포트

@Mapper // MyBatis Mapper 인터페이스임을 나타내는 어노테이션
public interface UsersMapper {

    // user_idx를 이용하여 사용자 정보를 조회합니다.
  //  @Select("SELECT * FROM Users WHERE user_idx = #{userIdx}")
    Users findById(Long userIdx);

    // username을 이용하여 사용자 정보를 조회합니다.
//    @Select("SELECT * FROM Users WHERE username = #{username}")
    Users findByUsername(String username);

    // 모든 사용자 정보를 조회합니다.
    //@Select("SELECT * FROM Users")
    List<Users> findAll();

    // 새로운 사용자 정보를 데이터베이스에 추가합니다.
  //  @Insert("INSERT INTO Users (username, password, email, name, birthdate, profile_image, enabled, grade_idx, provider, latitude, longitude, gender, social_login, created_at, updated_at) " +
   //         "VALUES (#{username}, #{password}, #{email}, #{name}, #{birthdate}, #{profileImage}, #{enabled}, #{gradeIdx}, #{provider}, #{latitude}, #{longitude}, #{gender}, #{socialLogin}, #{createdAt}, #{updatedAt})")
   // @Options(useGeneratedKeys = true, keyProperty = "userIdx")
    // 자동 생성된 키(user_idx)를 Users 객체에 설정합니다.
    void insertUser(Users user);

    // 기존 사용자 정보를 업데이트합니다.
   // @Update("UPDATE Users SET username = #{username}, password = #{password}, email = #{email}, name = #{name}, birthdate = #{birthdate}, profile_image = #{profileImage}, enabled = #{enabled}, grade_idx = #{gradeIdx}, provider = #{provider}, latitude = #{latitude}, longitude = #{longitude}, gender = #{gender}, social_login = #{socialLogin}, created_at = #{createdAt}, updated_at = #{updatedAt} " +
    //        "WHERE user_idx = #{userIdx}")
    void updateUser(Users user);


    boolean findByEmail(String email);

    Users findUserByEmail(String email); // 이메일로 사용자 정보 가져오기

    void deleteUserByUsername(String username);

    void deleteUserAuthorities(@Param("username") String username);

    void deleteUserCalendars(@Param("userId") Long userId);

    void deleteUserOAuth2Logins(@Param("userId") Long userId);

    void deleteUserPersonalStatements(@Param("userId") Long userId);

    void deleteUserResumes(@Param("userId") Long userId);

    void deleteUserStudyMembers(@Param("userId") Long userId);

    void deleteUserChats(@Param("userId") Long userId);

    void deleteUserLikeStudies(@Param("userId") Long userId);

    void deleteUserNotifications(@Param("userId") Long userId);

    void deleteUserStudyRecords(@Param("userId") Long userId);

    void deleteUserStudyReferences(@Param("userId") Long userId);

    void deleteUserComments(@Param("userId") Long userId);

    void deleteUserLikeReferences(@Param("userId") Long userId);

    void deleteUserTodos(@Param("userId") Long userId);

    void deleteUser(@Param("userId") Long userId);

    Long findUserIdByUsername(@Param("username") String username);
}
