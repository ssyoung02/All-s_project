package bit.naver.service;

import bit.naver.entity.CommentsEntity;
import bit.naver.entity.LikeReferencesEntity;
import bit.naver.entity.StudyReferencesEntity;
import bit.naver.mapper.StudyNoteMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@Service
public class StudyNoteService {

    @Autowired
    private StudyNoteMapper studyNoteMapper;

    public List<StudyReferencesEntity> getStudyNoteList(String userIdx,String searchKeyword,String searchOption,String limits) {
        return studyNoteMapper.getAllStudyNote(userIdx,searchKeyword,searchOption,limits);
    }

    public StudyReferencesEntity getStudyNoteById(Long referenceIdx, String userIdx) {
        studyNoteMapper.updateViewsCount(referenceIdx);
        return studyNoteMapper.getStudyNoteById(referenceIdx,userIdx);
    }

    public List<CommentsEntity> getCommentsByReferenceIdx(Long referenceIdx) {
        return studyNoteMapper.getCommentsByReferenceIdx(referenceIdx);
    }

    public String deleteComment(String commentIdx) {
        int result = studyNoteMapper.deleteComment(commentIdx);
        if (result == 1) {
            return "삭제에 성공하였습니다.";
        }else{
            return "삭제에 실패하였습니다.";
        }
    }

    public String insertComment(CommentsEntity content) {
        int result = studyNoteMapper.insertComment(content);  // insertComment로 수정합니다.
        if (result == 1) {
            return "댓글 작성 완료";
        } else {
            return "댓글 작성에 실패하였습니다.";
        }
    }

    public int insertLike(LikeReferencesEntity entity) {
        int result = studyNoteMapper.insertLike(entity);
        if (result > 0) {
            studyNoteMapper.plusLike(entity);
        }
        return result;
    }

    public int deleteLike(LikeReferencesEntity entity) {
        int result = studyNoteMapper.deleteLike(entity);
        if (result > 0) {
            studyNoteMapper.minusLike(entity);
        }
        return result;
    }

    public int updateReport(StudyReferencesEntity entity){
        return  studyNoteMapper.updateReport(entity);
    }

    public Long writePost(StudyReferencesEntity entity) {
        int result = studyNoteMapper.writePost(entity);
        return entity.getReferenceIdx(); // 성공적으로 업데이트되면 참조 인덱스를 반환
    }


    @Transactional //3가지 모두 에러가 나지 않고 실행 되었을때만, 데이터베이스 변경이 반영이 되는것
    public int deletePost(int referenceIdx){
        studyNoteMapper.deleteLikeRef(referenceIdx);
        studyNoteMapper.deleteCommentRef(referenceIdx);
        return studyNoteMapper.deletePost(referenceIdx);
    }

    public Long updatePost(StudyReferencesEntity entity) {
        int result = studyNoteMapper.updatePost(entity);
        return entity.getReferenceIdx(); // 성공적으로 업데이트되면 참조 인덱스를 반환ㅍ
    }

}
