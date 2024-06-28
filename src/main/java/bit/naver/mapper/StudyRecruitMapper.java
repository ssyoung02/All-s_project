package bit.naver.mapper;

import bit.naver.entity.LikeStudyEntity;
import bit.naver.entity.StudyGroup;
import bit.naver.entity.StudyMembers;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface StudyRecruitMapper {

    // 스터디 모집 리스트
    List<StudyGroup> getAllStudies(@Param("userIdx") long userIdx);

    // 18개 리밋
//    List<StudyGroup> getAllStudy_9();   ///// ??????????????
    List<StudyGroup> getAllStudy_9(@Param("userIdx") long userIdx);

    // 가입 폼
    StudyGroup getStudyById(@Param("studyIdx") Long studyIdx, @Param("userIdx") long userIdx);

    // 스터디 등록
    void insertStudyMember(StudyMembers studyMember);

    int checkLikeExists(@Param("studyIdx") Long studyIdx, @Param("userIdx") Long userIdx);

    int insertLike(LikeStudyEntity entity);

    int plusLike(LikeStudyEntity entity);

    int deleteLike(LikeStudyEntity entity);

    int minusLike(LikeStudyEntity entity);

    int updateReport(StudyGroup entity);


    // 스터디 멤버 상태 업데이트
    void updateStudyMemberStatus(@Param("studyIdx") Long studyIdx, @Param("userIdx") Long userIdx, @Param("status") String status);

    // 특정 스터디의 멤버 조회
    List<StudyMembers> getStudyMembersByStudyId(Long studyIdx);

    List<StudyMembers> getMembersByStudyIdx(Long studyIdx);

    // 사용자 스터디 멤버 여부 확인
    boolean isMember(@Param("studyIdx") Long studyIdx, @Param("userIdx") Long userIdx);

    // 스터디 업데이트
    void updateStudyGroup(StudyGroup studyGroup);
}
