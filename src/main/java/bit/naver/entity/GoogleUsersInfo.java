package bit.naver.entity;

import lombok.Data;

@Data
public class GoogleUsersInfo {
    private String name;
    private String email;
    private String profileImage;

    public GoogleUsersInfo() {
    }

    public GoogleUsersInfo(String name, String email) {
        this.name = name;
        this.email = email;
        this.profileImage = "https://www.google.com/url?sa=i&url=https%3A%2F%2Ficonscout.com%2Ficons%2Fgoogle&psig=AOvVaw0dbE76jSgtZP20FKYyxeEW&ust=1719040155908000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCJi8yOCR7IYDFQAAAAAdAAAAABAI";
    }


}
