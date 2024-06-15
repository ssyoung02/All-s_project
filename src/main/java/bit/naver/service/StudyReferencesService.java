package bit.naver.service;

import bit.naver.entity.CommentsEntity;
import bit.naver.entity.LikeReferencesEntity;
import bit.naver.entity.StudyReferencesEntity;
import bit.naver.mapper.StudyReferencesMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StudyReferencesService {

    @Autowired
    private StudyReferencesMapper studyReferencesMapper;

    public List<StudyReferencesEntity> getStudyReferencesList(String userIdx,String searchKeyword,String searchOption,String limits) {
        return studyReferencesMapper.getAllStudyReferences(userIdx,searchKeyword,searchOption,limits);
    }

    public StudyReferencesEntity getStudyReferenceById(Long referenceIdx, String userIdx) {
        studyReferencesMapper.updateViewsCount(referenceIdx);
        return studyReferencesMapper.getStudyReferenceById(referenceIdx,userIdx);
    }

    public List<CommentsEntity> getCommentsByReferenceIdx(Long referenceIdx) {
        return studyReferencesMapper.getCommentsByReferenceIdx(referenceIdx);
    }

    public String deleteComment(String commentIdx) {
        int result = studyReferencesMapper.deleteComment(commentIdx);
        if (result == 1) {
            return "삭제에 성공하였습니다.";
        }else{
            return "삭제에 실패하였습니다.";
        }
    }

    public String insertComment(CommentsEntity content) {
        int result = studyReferencesMapper.insertComment(content);  // insertComment로 수정합니다.
        if (result == 1) {
            return "댓글 작성 완료";
        } else {
            return "댓글 작성에 실패하였습니다.";
        }
    }

    public int insertLike(LikeReferencesEntity entity) {
        return studyReferencesMapper.insertLike(entity);
    }

    public int deleteLike(LikeReferencesEntity entity) {
        return studyReferencesMapper.deleteLike(entity);
    }

    public int updateReport(StudyReferencesEntity entity){
        return  studyReferencesMapper.updateReport(entity);
    }
}
