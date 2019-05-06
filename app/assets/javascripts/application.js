// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require activestorage
//= require bootstrap-sprockets
//= require popper
//= require Chart.min
//= require ./slick/slick.min.js
//= require froala_editor.min.js
//= require plugins/align.min.js
//= require plugins/char_counter.min.js
//= require plugins/code_beautifier.min.js
//= require plugins/code_view.min.js
//= require plugins/colors.min.js
//= require plugins/emoticons.min.js
//= require plugins/entities.min.js
//= require plugins/file.min.js
//= require plugins/font_family.min.js
//= require plugins/font_size.min.js
//= require plugins/fullscreen.min.js
//= require plugins/image.min.js
//= require plugins/image_manager.min.js
//= require plugins/inline_style.min.js
//= require plugins/line_breaker.min.js
//= require plugins/link.min.js
//= require plugins/lists.min.js
//= require plugins/paragraph_format.min.js
//= require plugins/paragraph_style.min.js
//= require plugins/quick_insert.min.js
//= require plugins/quote.min.js
//= require plugins/save.min.js
//= require plugins/table.min.js
//= require plugins/url.min.js
//= require plugins/video.min.js
//= require languages/ja.js

jQuery(function ($) {

    // Question Chart
    if (document.getElementById("myChart") != null) {
        var ctx_qchart = document.getElementById("myChart");
        var c_question_num = $('#c_question_num').val();
        var r_question_num = $('#r_question_num').val();
        var myPieQChart = new Chart(ctx_qchart, {
            //グラフの種類
            type: 'doughnut',
            //データの設定
            data: {
                //データ項目のラベル
                labels: ["済", "未"],
                //データセット
                datasets: [{
                    //背景色
                    backgroundColor: [
                        "#ffcc66",
                        "#F2F2F2"
                    ],
                    //背景色(ホバーしたとき)
                    hoverBackgroundColor: [
                        "#ffcc66",
                        "#F2F2F2"
                    ],
                    borderWidth: 0,
                    //グラフのデータ
                    data: [c_question_num, r_question_num]
                }]
            },
            options: {
                legend: {
                    display: false
                },
                animation: {
                    animateRotate: true,
                    duration: 2000,
                    render: false,
                },
            }
        });
    }


    // Result Chart
    if (document.getElementById("resultChart") != null) {
        var c_1 = $('#c_1').val();
        var c_2 = $('#c_2').val();
        var c_3 = $('#c_3').val();
        var c_4 = $('#c_4').val();
        var c_5 = $('#c_5').val();
        var c_v_1 = $('#c_v_1').val();
        var c_v_2 = $('#c_v_2').val();
        var c_v_3 = $('#c_v_3').val();
        var c_v_4 = $('#c_v_4').val();
        var c_v_5 = $('#c_v_5').val();
        var ctx_rchart = document.getElementById("resultChart");
        var myRadarChart = new Chart(ctx_rchart, {
            type: 'radar',
            data: {
                labels: [c_1, c_2, c_3, c_4, c_5],
                datasets: [{
                    label: 'Average',
                    data: [5, 5, 5, 5, 5],
                    borderColor: 'RGBA(66, 133, 244, 1)',
                    borderWidth: 1,
                    backgroundColor: 'RGBA(66, 133, 244, 0)',
                }, {
                    label: 'Guestさん',
                    data: [c_v_1, c_v_2, c_v_3, c_v_4, c_v_5],
                    borderColor: 'RGBA(255, 136, 51, 1)',
                    borderWidth: 3,
                    backgroundColor: 'RGBA(255, 136, 51, 0.4)',
                }]
            },
            options: {
                title: {
                    display: false,
                    fontColor: 'RGBA(33, 150, 243, 1)',
                    text: 'あなたに重要な５つの要素',
                },
                legend: {
                    display: false,
                },
                scale: {
                    ticks: {
                        display: true,
                        max: 10,
                        min: 0,
                        stepSize: 5,
                    }
                },
                responsive: true,
            }
        });
    }

    // Item Chart
    if (document.getElementById("itemChart") != null) {
        var c_1 = $('#c_1').val();
        var c_2 = $('#c_2').val();
        var c_3 = $('#c_3').val();
        var c_4 = $('#c_4').val();
        var c_5 = $('#c_5').val();
        var c_v_1 = $('#c_v_1').val();
        var c_v_2 = $('#c_v_2').val();
        var c_v_3 = $('#c_v_3').val();
        var c_v_4 = $('#c_v_4').val();
        var c_v_5 = $('#c_v_5').val();
        var ctx_ichart = document.getElementById("itemChart");
        var myRadarIChart = new Chart(ctx_ichart, {
            type: 'radar',
            data: {
                labels: [c_1, c_2, c_3, c_4, c_5],
                datasets: [{
                    label: 'Average',
                    data: [5, 5, 5, 5, 5],
                    borderColor: 'RGBA(66, 133, 244, 1)',
                    borderWidth: 1,
                    backgroundColor: 'RGBA(66, 133, 244, 0)',
                }, {
                    label: 'Guestさん',
                    data: [c_v_1, c_v_2, c_v_3, c_v_4, c_v_5],
                    borderColor: 'RGBA(255, 136, 51, 1)',
                    borderWidth: 3,
                    backgroundColor: 'RGBA(255, 136, 51, 0.4)',
                }]
            },
            options: {
                title: {
                    display: false,
                    fontColor: 'RGBA(33, 150, 243, 1)',
                    text: 'あなたに重要な５つの要素',
                },
                legend: {
                    display: false,
                },
                scale: {
                    ticks: {
                        display: true,
                        max: 10,
                        min: 0,
                        stepSize: 5,
                    }
                },
                responsive: true,
            }
        });
    }

    // Question Modal Area
    $('#openModal').click(function () {
        $('#modalArea').fadeIn();
    });

    $('#closeModal').click(function () {
        $('#modalArea').fadeOut();
        var h2 = $('h2').offset().top - 50;
        $('html, body').animate({ scrollTop: h2 }, 1000, 'swing');
    });



    // もっと見るボタンクリックイベント
    const defaultDispCnt = 6; // 初期表示件数
    const addDispCnt = 6;     // 追加表示件数

    // Result Item Area
    let maxDispCnt = 100;     // 最大表示件数
    let currentDispCnt = 0; // 現在の表示件数

    // 一覧の初期表示
    $('.items').each(function (i, elem) {
        // 初期表示件数のみ表示
        if (i < defaultDispCnt) {
            $(this).show();
            currentDispCnt++;
        }
        maxDispCnt++;

        // もっと見るボタンを表示
        let displayed = 0;
        if (maxDispCnt > currentDispCnt && !displayed) {
            $('.readMoreBtn').show();
            displayed = 1;
        }
    });

    $('.readMoreBtn').click(function () {
        let newCount = currentDispCnt + addDispCnt; // 新しく表示する件数

        // 新しく表示する件数のみ表示
        $('.items').each(function (i, elem) {
            if (currentDispCnt <= i && i < newCount) {
                $(this).show();
                currentDispCnt++;
            }
        });
        // もっと見るボタンを非表示
        if (maxDispCnt <= newCount) {
            $(this).hide();
        }
        return false;
    });

    // Slick
    $('.slider').slick({
        dots: true,
        infinite: true,
        speed: 300,
        slidesToShow: 3,
        slidesToScroll: 1,
        prevArrow: '<div class="slick-button-prev">◀</div>',
        nextArrow: '<div class="slick-button-next">▶</div>',
        responsive: [
            {
                breakpoint: 1024,
                settings: {
                    slidesToShow: 3,
                    slidesToScroll: 3,
                    infinite: true,
                    dots: true
                }
            },
            {
                breakpoint: 600,
                settings: {
                    slidesToShow: 2,
                    slidesToScroll: 2
                }
            },
            {
                breakpoint: 480,
                settings: {
                    slidesToShow: 1,
                    slidesToScroll: 1
                }
            }
            // You can unslick at a given breakpoint now by adding:
            // settings: "unslick"
            // instead of a settings object
        ]
    });

    $('.latest-article, .p').each(function () {
        var $target = $(this);

        // オリジナルの文章を取得する
        var html = $target.html();

        // 対象の要素を、高さにautoを指定し非表示で複製する
        var $clone = $target.clone();
        $clone
            .css({
                display: 'none',
                position: 'absolute',
                overflow: 'visible'
            })
            .width($target.width())
            .height('auto');

        // DOMを一旦追加
        $target.after($clone);

        // 指定した高さになるまで、1文字ずつ消去していく
        while ((html.length > 0) && ($clone.height() > $target.height())) {
            html = html.substr(0, html.length - 1);
            $clone.html(html + '...');
        }

        // 文章を入れ替えて、複製した要素を削除する
        $target.html($clone.html());
        $clone.remove();
    });

    $('#article_content').froalaEditor({
        language: 'ja',
        // Set the image upload URL.
        imageUploadURL: '/upload_image',

        imageUploadParams: {
            id: 'my_editor'
        }
    });
});
