package bit.naver.mapper;

import bit.naver.entity.StudyGroup;
import bit.naver.entity.StudyList;
import bit.naver.entity.StudyMembers;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface StudyGroupMapper {

    // 스터디 모집 테이블 데이터 삽입
    void insertStudy(StudyGroup studyGroup);

    // Memebers 테이블에 데이터 삽입
    void insertStudyMember(StudyMembers studyMember);

    // studyIdx 최근에 생성된 것 찾기
    Long findStudyIdx(Long userIdx);


    // 내 스터디 리스트
    List<StudyList> getMyStudies(Long userIdx);

    // 스터디 메인 타이틀
    StudyGroup getStudyById(Long studyIdx);

    //  스터디 메인 페이지 유저
    List<StudyMembers> getStudyMembers(Long studyIdx);

    void deleteStudy(Long studyIdx);

    void removeMember(@Param("studyIdx") Long studyIdx, @Param("userIdx") Long userIdx);

    void approveMember(@Param("studyIdx") Long studyIdx, @Param("userIdx") Long userIdx);

    StudyMembers getStudyMember(@Param("studyIdx") Long studyIdx, @Param("userIdx") Long userIdx);

    void updateMemberStatus(@Param("studyIdx") Long studyIdx, @Param("userIdx") Long userIdx, @Param("status") String status);

    // 추가된 메서드: 승인된 스터디 목록 가져오기
    List<StudyList> getApprovedStudies(Long userIdx);

    List<StudyList> getAllMyStudies(@Param("userIdx")Long userIdx, @Param("searchKeyword") String searchKeyword,@Param("searchOption") String searchOption);

    void deleteTeamCalendarsByStudyIdx(Long studyIdx);

    void deleteStudyMembersByStudyIdx(Long studyIdx);
//    void approveMember(Long studyIdx, Long userIdx);

    @Select("SELECT study_idx as studyIdx, study_title AS studyTitle, category, latitude, longitude FROM Studies") // 필요한 정보만 조회
    List<StudyGroup> findAllStudies();

    Long getStudyLeaderIdx(Long studyIdx);
}
