package bit.naver.service;

import bit.naver.entity.LikeReferencesEntity;
import bit.naver.entity.LikeStudyEntity;
import bit.naver.entity.StudyGroup;
import bit.naver.entity.StudyReferencesEntity;
import bit.naver.mapper.StudyRecruitMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class StudyRecruitService {
    @Autowired
    StudyRecruitMapper studyMapper;

    public int insertLike(LikeStudyEntity entity) {
        int result = studyMapper.insertLike(entity);
        if (result > 0) {
            studyMapper.plusLike(entity);
        }
        return result;
    }

    public int deleteLike(LikeStudyEntity entity) {
        int result = studyMapper.deleteLike(entity);
        if (result > 0) {
            studyMapper.minusLike(entity);
        }
        return result;
    }

    public int updateReport(StudyGroup entity) {
        return studyMapper.updateReport(entity);
    }



}
