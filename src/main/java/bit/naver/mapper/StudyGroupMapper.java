package bit.naver.mapper;

import bit.naver.entity.StudyGroup;
import bit.naver.entity.StudyList;
import bit.naver.entity.StudyMembers;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface StudyGroupMapper {

    // 스터디 모집 테이블 데이터 삽입
    void insertStudy(StudyGroup studyGroup);

    // Memebers 테이블에 데이터 삽입
    void insertStudyMember(StudyMembers studyMember);

    // studyIdx 최근에 생성된 것 찾기
    Long findStudyIdx(Long userIdx);

    // 모집 게시글
    List<StudyGroup> getAllRecruitedStudies();

    // 내 스터디 리스트
    List<StudyList> getMyStudies(Long userIdx);

}
