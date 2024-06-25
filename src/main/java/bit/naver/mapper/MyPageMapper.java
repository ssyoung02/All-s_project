package bit.naver.mapper;

import bit.naver.entity.LikeReferencesEntity;
import bit.naver.entity.ResumesEntity;
import bit.naver.entity.StudyReferencesEntity;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MyPageMapper {
    List<StudyReferencesEntity> getStudyReferencesList(StudyReferencesEntity entity);

    List<ResumesEntity> getResumesList(ResumesEntity entity);

    List<StudyReferencesEntity> getLikePostList(@Param("userIdx") String userIdx, @Param("searchKeyword") String searchKeyword, @Param("searchOption") String searchOption, @Param("limits")String limits);

    int insertLike(LikeReferencesEntity entity);

    int plusLike(LikeReferencesEntity entity);

    int deleteLike(LikeReferencesEntity entity);

    int minusLike(LikeReferencesEntity entity);

    ResumesEntity getMyPageById(Long resumeIdx);

    int uploadResume(ResumesEntity entity);

    int deleteResume(String resumeIdx);
}
