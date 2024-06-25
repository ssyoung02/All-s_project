package bit.naver.mapper;

import bit.naver.entity.StudyGroup;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface StudiesMapMapper {
    @Select("SELECT * FROM Studies")
    List<StudyGroup> findAllStudies();
}

