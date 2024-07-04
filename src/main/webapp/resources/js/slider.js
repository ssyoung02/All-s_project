var mySwiper = new Swiper('.swiper-container', {
    spaceBetween: 10, // 슬라이드 사이 여백
    slidesPerView: 1, // 한 슬라이드에 보여줄 갯수
    // 반응형 옵션
    breakpoints: {
        // 768px 이상에서는 3개의 슬라이드를 보여줌
        1000: {
            spaceBetween: 10,
            slidesPerView: 3
        }
    },
    navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
    },
    pagination: {
        el: '.swiper-pagination',
        type: 'bullets',
        clickable: true,
    },
    autoplay: {
        delay: 6000,
    },
    watchOverflow : true,
});

var controlButton = document.querySelector('.control-button');
var controlIcon = controlButton.querySelector('i');

// 슬라이드 정지/재생 버튼 클릭 이벤트
controlButton.addEventListener('click', function() {
    if (mySwiper.autoplay.running) {
        mySwiper.autoplay.stop();
        controlIcon.classList.remove('bi-pause');
        controlIcon.classList.add('bi-play-fill');
    } else {
        mySwiper.autoplay.start();
        controlIcon.classList.remove('bi-play-fill');
        controlIcon.classList.add('bi-pause');
    }
});
