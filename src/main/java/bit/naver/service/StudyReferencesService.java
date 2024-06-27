package bit.naver.service;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import bit.naver.entity.CommentsEntity;
import bit.naver.entity.LikeReferencesEntity;
import bit.naver.entity.StudyReferencesEntity;
import bit.naver.mapper.StudyReferencesMapper;

@Service
public class StudyReferencesService {


	@Autowired
	private StudyReferencesMapper studyReferencesMapper;

	public List<StudyReferencesEntity> getStudyReferencesList(String userIdx, String searchKeyword, String searchOption,
															  String limits) {
		return studyReferencesMapper.getAllStudyReferences(userIdx, searchKeyword, searchOption, limits);
	}

	public StudyReferencesEntity getStudyReferenceById(Long referenceIdx, String userIdx) {
		studyReferencesMapper.updateViewsCount(referenceIdx);
		StudyReferencesEntity data = studyReferencesMapper.getStudyReferenceById(referenceIdx, userIdx);
		return data;
	}

	public List<CommentsEntity> getCommentsByReferenceIdx(Long referenceIdx) {
		return studyReferencesMapper.getCommentsByReferenceIdx(referenceIdx);
	}

	public String deleteComment(String commentIdx) {
		int result = studyReferencesMapper.deleteComment(commentIdx);
		if (result == 1) {
			return "삭제에 성공하였습니다.";
		} else {
			return "삭제에 실패하였습니다.";
		}
	}

	public String insertComment(CommentsEntity content) {
		int result = studyReferencesMapper.insertComment(content); // insertComment로 수정합니다.
		if (result == 1) {
			return "댓글 작성 완료";
		} else {
			return "댓글 작성에 실패하였습니다.";
		}
	}

	public int insertLike(LikeReferencesEntity entity) {
		int result = studyReferencesMapper.insertLike(entity);
		if (result > 0) {
			studyReferencesMapper.plusLike(entity);
		}
		return result;
	}

	public int deleteLike(LikeReferencesEntity entity) {
		int result = studyReferencesMapper.deleteLike(entity);
		if (result > 0) {
			studyReferencesMapper.minusLike(entity);
		}
		return result;
	}

	public int updateReport(StudyReferencesEntity entity) {
		return studyReferencesMapper.updateReport(entity);
	}

	public Long writePost(StudyReferencesEntity entity) {
		int result = studyReferencesMapper.writePost(entity);
		return entity.getReferenceIdx(); // 성공적으로 업데이트되면 참조 인덱스를 반환
	}


	@Transactional // 3가지 모두 에러가 나지 않고 실행 되었을때만, 데이터베이스 변경이 반영이 되는것
	public int deletePost(int referenceIdx) {
		studyReferencesMapper.deleteLikeRef(referenceIdx);
		studyReferencesMapper.deleteCommentRef(referenceIdx);
		return studyReferencesMapper.deletePost(referenceIdx);
	}

	public Long updatePost(StudyReferencesEntity entity) {
		int result = studyReferencesMapper.updatePost(entity);
		return entity.getReferenceIdx(); // 성공적으로 업데이트되면 참조 인덱스를 반환ㅍ
	}
}
