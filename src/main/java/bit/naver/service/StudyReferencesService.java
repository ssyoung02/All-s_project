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

	public Long writePost(StudyReferencesEntity entity, MultipartFile uploadFile) {

		try {
			// 파일이 있을경우에만
			if (!uploadFile.isEmpty()) {
				//일반적인 저장소 파일업로드방식 주석처리
				
				String fileName = uploadFile.getOriginalFilename();
//				String uploadPath = "c:\\uploadPath"; //파일이 저장될경로, 나중에 config로 전역변수로 빼면될듯 UUID는 따로 처리안하였음.
//				String originFilename = uploadFile.getOriginalFilename();
//				long size = uploadFile.getSize();
//
//				File file = new File(uploadPath, uploadFile.getOriginalFilename());
//				uploadFile.transferTo(file);
//				
//				entity.setFilename(originFilename);
//				entity.setUploadPath(file.getAbsolutePath());
				//이미지 파일만 저장 가능
//				if(fileName.toLowerCase().endsWith(".png") ||
//			            fileName.toLowerCase().endsWith(".jpg") ||
//			            fileName.toLowerCase().endsWith(".jpeg")) {
//					return 11L;
//				}
				
				byte[] fileBytes = uploadFile.getBytes();
				entity.setFileAttachments(fileBytes);
				entity.setFileName(fileName);

			}
		} catch (IllegalStateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		int result = studyReferencesMapper.writePost(entity);

		return entity.getReferenceIdx();
	}

	@Transactional // 3가지 모두 에러가 나지 않고 실행 되었을때만, 데이터베이스 변경이 반영이 되는것
	public int deletePost(int referenceIdx) {
		studyReferencesMapper.deleteLikeRef(referenceIdx);
		studyReferencesMapper.deleteCommentRef(referenceIdx);
		return studyReferencesMapper.deletePost(referenceIdx);
	}

	public int updatePost(StudyReferencesEntity entity) {
		return studyReferencesMapper.updatePost(entity);
	}
}
