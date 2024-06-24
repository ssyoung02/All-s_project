package bit.naver.service;

import bit.naver.entity.NaverUsersInfo;

public interface INaverLoginService {
    NaverUsersInfo getUsersInfoFromNaver(String code, String state) throws Exception;
}
