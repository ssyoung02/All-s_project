package bit.naver.service;

import bit.naver.entity.LikeReferencesEntity;
import bit.naver.entity.StudyReferencesEntity;
import bit.naver.mapper.MyPageMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MyPageService {

    @Autowired
    MyPageMapper myPageMapper;

    public List<StudyReferencesEntity> getStudyReferencesList(StudyReferencesEntity entity){
        return myPageMapper.getStudyReferencesList(entity);
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

}
