package bit.naver.controller;

import com.nimbusds.oauth2.sdk.util.StringUtils;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.UUID;

@Controller
@AllArgsConstructor
public class SmarteditorController {

    private final ServletContext application;

    @RequestMapping(value="/multiImageUpload")
    public void smarteditorMultiImageUpload(HttpServletRequest request, HttpServletResponse response){

        //파일이 저장되는 경로
        String web_path = "/resources/upload/";
        String path = application.getRealPath(web_path);

//        String rootPath = request.getSession().getServletContext().getRealPath("/");
//        String path = rootPath +"/image/";
        try {
            //파일정보
            String sFileInfo = "";
            //파일명을 받는다 - 일반 원본파일명
            String sFilename = request.getHeader("file-name");
            //파일 확장자
            String sFilenameExt = sFilename.substring(sFilename.lastIndexOf(".")+1);
            //확장자를소문자로 변경
            sFilenameExt = sFilenameExt.toLowerCase();

            //이미지 검증 배열변수
            String[] allowFileArr = {"jpg","png","bmp","gif"};

            //확장자 체크
            int nCnt = 0;
            for(int i=0; i<allowFileArr.length; i++) {
                if(sFilenameExt.equals(allowFileArr[i])){
                    nCnt++;
                }
            }

            //이미지가 아니라면
            if(nCnt == 0) {
                PrintWriter print = response.getWriter();
                print.print("NOTALLOW_"+sFilename);
                print.flush();
                print.close();
            } else {
                //디렉토리 설정 및 업로드

                //파일경로
                String filePath = path;
                File file = new File(filePath);



                if(!file.exists()) {
                    file.mkdirs();
                }

                String sRealFileNm = "";
                SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
                String today= formatter.format(new java.util.Date());
                sRealFileNm = today+UUID.randomUUID().toString() + sFilename.substring(sFilename.lastIndexOf("."));
                String rlFileNm = filePath + sRealFileNm;

                System.out.println("파일의 실제경로");
                System.out.println(file.getAbsolutePath());
                System.out.println(file.getPath());

                ///////////////// 서버에 파일쓰기 /////////////////
                InputStream inputStream = request.getInputStream();
                OutputStream outputStream=new FileOutputStream(rlFileNm);
                int numRead;
                byte bytes[] = new byte[Integer.parseInt(request.getHeader("file-size"))];
                while((numRead = inputStream.read(bytes,0,bytes.length)) != -1){
                    outputStream.write(bytes,0,numRead);
                }
                if(inputStream != null) {
                    inputStream.close();
                }
                outputStream.flush();
                outputStream.close();


                // 이미지 리사이징
                resizeImage(rlFileNm, rlFileNm, 700, 500);

                ///////////////// 이미지 /////////////////
                // 정보 출력
                sFileInfo += "&bNewLine=true";
                // img 태그의 title 속성을 원본파일명으로 적용시켜주기 위함
                sFileInfo += "&sFileName="+ sFilename;
                sFileInfo += "&sFileURL="+web_path+sRealFileNm;
                PrintWriter printWriter = response.getWriter();
                printWriter.print(sFileInfo);
                printWriter.flush();
                printWriter.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private void resizeImage(String inputImagePath, String outputImagePath, int maxWidth, int maxHeight) throws IOException {
        // 원본 이미지 읽기
        File inputFile = new File(inputImagePath);
        BufferedImage originalImage = ImageIO.read(inputFile);

        // 원본 이미지 크기
        int originalWidth = originalImage.getWidth();
        int originalHeight = originalImage.getHeight();

        // 새로운 이미지 크기 계산
        int newWidth = originalWidth;
        int newHeight = originalHeight;

        if (originalWidth > maxWidth) {
            newWidth = maxWidth;
            newHeight = (newWidth * originalHeight) / originalWidth;
        }

        if (newHeight > maxHeight) {
            newHeight = maxHeight;
            newWidth = (newHeight * originalWidth) / originalHeight;
        }

        // 새로운 이미지 만들기
        BufferedImage resizedImage = new BufferedImage(newWidth, newHeight, BufferedImage.TYPE_INT_RGB);
        Graphics2D graphics2D = resizedImage.createGraphics();
        graphics2D.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
        graphics2D.drawImage(originalImage, 0, 0, newWidth, newHeight, null);
        graphics2D.dispose();

        // 새로운 이미지 파일로 저장
        String formatName = outputImagePath.substring(outputImagePath.lastIndexOf(".") + 1);
        ImageIO.write(resizedImage, formatName, new File(outputImagePath));
    }
}
