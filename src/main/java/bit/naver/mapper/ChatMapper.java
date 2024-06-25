package bit.naver.mapper;

import bit.naver.entity.Chat;
import bit.naver.entity.StudyGroup;
import bit.naver.entity.StudyMembers;
import bit.naver.entity.Users;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ChatMapper {

    StudyGroup getStudyDescriptionTitle(@Param("studyIdx") Long studyIdx);

    List<Users> getNames(@Param("studyIdx") Long studyIdx);

    void insertMessage(Chat message);

    List<StudyMembers> getStudiesByUserId(@Param("userIdx") Long userIdx);

    List<Chat> getAllMessages(Long studyIdx);
}
