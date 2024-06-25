package bit.naver.mapper;

import bit.naver.entity.StudyGroup;
import bit.naver.entity.StudyMembers;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

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

    // 스터디 멤버 상태 업데이트
    void updateStudyMemberStatus(@Param("studyIdx") Long studyIdx, @Param("userIdx") Long userIdx, @Param("status") String status);

    // 특정 스터디의 멤버 조회
    List<StudyMembers> getStudyMembersByStudyId(Long studyIdx);
}
