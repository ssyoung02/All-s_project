package bit.naver.service;

import bit.naver.entity.LikeReferencesEntity;
import bit.naver.entity.ResumesEntity;
import bit.naver.entity.StudyReferencesEntity;
import bit.naver.mapper.MyPageMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@Service
public class MyPageService {

    @Autowired
    MyPageMapper myPageMapper;

    public List<StudyReferencesEntity> getStudyReferencesList(StudyReferencesEntity entity){
        return myPageMapper.getStudyReferencesList(entity);
    }

    public List<ResumesEntity> getResumesList(ResumesEntity entity) {
        return myPageMapper.getResumesList(entity);
    }

    public List<StudyReferencesEntity> getLikePostList(String userIdx,String searchKeyword,String searchOption,String limits) {
        return myPageMapper.getLikePostList(userIdx,searchKeyword,searchOption,limits);
    }

    public int insertLike(LikeReferencesEntity entity) {
        int result = myPageMapper.insertLike(entity);
        if (result > 0) {
            myPageMapper.plusLike(entity);
        }
        return result;
    }

    public int deleteLike(LikeReferencesEntity entity) {
        int result = myPageMapper.deleteLike(entity);
        if (result > 0) {
            myPageMapper.minusLike(entity);
        }
        return result;
    }

    public ResumesEntity getMyPageById(Long resumeIdx) {
        ResumesEntity data = myPageMapper.getMyPageById(resumeIdx);
        return data;
    }

    public Long uploadResume(ResumesEntity entity, MultipartFile uploadFile) {

        try {
            // 파일이 있을경우에만
            if (!uploadFile.isEmpty()) {
                String fileName = uploadFile.getOriginalFilename();
                byte[] fileBytes = uploadFile.getBytes();
                entity.setResumePath(fileBytes);
                entity.setFileName(fileName);
            }
        } catch (IllegalStateException | IOException e) {
            e.printStackTrace();
            return -1L;
        }
        int result = myPageMapper.uploadResume(entity);
        return entity.getResumeIdx();
    }

    public String deleteResume(String resumeIdx) {
        int result = myPageMapper.deleteResume(resumeIdx);
        if (result == 1) {
            return "삭제에 성공하였습니다.";
        } else {
            return "삭제에 실패하였습니다.";
        }
    }
}
