package bit.naver.mapper;

import bit.naver.entity.CommentsEntity;
import bit.naver.entity.LikeReferencesEntity;
import bit.naver.entity.StudyReferencesEntity;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface StudyNoteMapper {

    List<StudyReferencesEntity> getAllStudyNote(@Param("userIdx") String userIdx, @Param("searchKeyword") String searchKeyword,@Param("searchOption") String searchOption,@Param("limits")String limits);

    // Mapper에서 매개변수가 두개이상일 경우 Mapper.xml에서 어디에 어떤값이 들어갈지 모르니까 @Param으로 지정해야함 !
    StudyReferencesEntity getStudyNoteById(@Param("referenceIdx") Long referenceIdx, @Param("userIdx") String userIdx);

    List<CommentsEntity> getCommentsByReferenceIdx(Long referenceIdx);

    int deleteComment(String commentIdx);

    int insertComment(CommentsEntity comment);

    int updateViewsCount(Long referenceIdx);

    int insertLike(LikeReferencesEntity entity);

    int plusLike(LikeReferencesEntity entity);

    int deleteLike(LikeReferencesEntity entity);

    int minusLike(LikeReferencesEntity entity);

    int updateReport(StudyReferencesEntity entity);

    int writePost(StudyReferencesEntity entity);

    int deletePost(int referenceIdx);
    int deleteLikeRef(int referenceIdx);
    int deleteCommentRef(int referenceIdx);

    int updatePost(StudyReferencesEntity entity);
}
