package bit.naver.mapper;

import bit.naver.entity.StudyGroup;
import bit.naver.entity.StudyList;
import bit.naver.entity.StudyMembers;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

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

    void removeMember(Long studyIdx, Long userIdx);

    void approveMember(Long studyIdx, Long userIdx);

    int countAllStudies();
}
