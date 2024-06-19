package bit.naver.dto;

import lombok.Data;

@Data
public class GoogleUsersInfo {
    private String name;
    private String email;

    public GoogleUsersInfo() {
    }

    public GoogleUsersInfo(String name, String email) {
        this.name = name;
        this.email = email;
    }


}
