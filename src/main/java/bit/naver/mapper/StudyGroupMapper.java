package bit.naver.mapper;

import bit.naver.entity.StudyGroup;
import bit.naver.entity.StudyList;
import bit.naver.entity.StudyMembers;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface StudyGroupMapper {

    void insertStudy(StudyGroup studyGroup);

    void insertStudyMember(StudyMembers studyMember);

    Long findStudyIdx(Long userIdx);

    List<StudyList> getMyStudies(Long userIdx);

    StudyGroup getStudyById(Long studyIdx);

    List<StudyMembers> getStudyMembers(Long studyIdx);

    void deleteStudy(Long studyIdx);

    void removeMember(@Param("studyIdx") Long studyIdx, @Param("userIdx") Long userIdx);

    void approveMember(@Param("studyIdx") Long studyIdx, @Param("userIdx") Long userIdx);

    StudyMembers getStudyMember(@Param("studyIdx") Long studyIdx, @Param("userIdx") Long userIdx);

    void updateMemberStatus(@Param("studyIdx") Long studyIdx, @Param("userIdx") Long userIdx, @Param("status") String status);

    // 추가된 메서드: 승인된 스터디 목록 가져오기
    List<StudyList> getApprovedStudies(Long userIdx);

    List<StudyList> getAllMyStudies(Long userIdx);

    void deleteTeamCalendarsByStudyIdx(Long studyIdx);

    void deleteStudyMembersByStudyIdx(Long studyIdx);
}
