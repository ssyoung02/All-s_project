package bit.naver.mapper;

import bit.naver.entity.StudyGroup;
import bit.naver.entity.StudyMembers;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface StudyRecruitMapper {

    // 스터디 모집 리스트
    List<StudyGroup> getAllStudies();

    // 18개 리밋
    List<StudyGroup> getAllStudy_9();

    // 가입 폼
    StudyGroup getStudyById(Long studyIdx);

    // 스터디 등록
    void insertStudyMember(StudyMembers studyMember);
}
