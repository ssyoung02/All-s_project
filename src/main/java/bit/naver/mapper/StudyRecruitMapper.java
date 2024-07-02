package bit.naver.mapper;

import bit.naver.entity.LikeStudyEntity;
import bit.naver.entity.StudyGroup;
import bit.naver.entity.StudyMembers;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper
public interface StudyRecruitMapper {

    // 스터디 모집 리스트
//    List<StudyGroup> getAllStudies(@Param("userIdx") long userIdx);
    List<StudyGroup> getAllStudies(@Param("userIdx") long userIdx, @Param("searchKeyword") String searchKeyword,@Param("searchOption") String searchOption, @Param("limits") int limits);

    // 9개 리밋
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

    // 모집인원
    @Select("SELECT currentParticipants FROM Studies WHERE study_idx = #{studyIdx}")
    int getCurrentParticipants(Long studyIdx);

    //모집인원 마감되면
    @Update("UPDATE Studies SET status = 'CLOSED' WHERE study_idx = #{studyIdx} AND currentParticipants >= capacity")
    void closeStudyIfFull(Long studyIdx);

    // 스터디 모집 리스트 페이징 및 필터링 처리
    List<StudyGroup> getStudiesPaged(@Param("userIdx") long userIdx,
                                     @Param("status") String status,
                                     @Param("offset") int offset,
                                     @Param("limit") int limit);

    // 전체 스터디 수
    int countAllStudies(@Param("userIdx") long userIdx, @Param("status") String status);

    List<StudyGroup> getUserLikedStudies(@Param("userIdx") long userId);
}