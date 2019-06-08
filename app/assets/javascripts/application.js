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
//= require ./select2/select2.min.js
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
                    borderColor: 'RGBA(255, 204, 102, 1)',
                    borderWidth: 1,
                    backgroundColor: 'RGBA(255, 204, 102, 0)',
                }, {
                    label: 'Guestさん',
                    data: [c_v_1, c_v_2, c_v_3, c_v_4, c_v_5],
                    borderColor: 'RGBA(66, 133, 244, 1)',
                    borderWidth: 2,
                    backgroundColor: 'RGBA(66, 133, 244, 0.3)',
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
				var c_v_6 = $('#c_v_6').val();
        var c_v_7 = $('#c_v_7').val();
        var c_v_8 = $('#c_v_8').val();
        var c_v_9 = $('#c_v_9').val();
        var c_v_10 = $('#c_v_10').val();
        var ctx_ichart = document.getElementById("itemChart");
        var myRadarIChart = new Chart(ctx_ichart, {
            type: 'radar',
            data: {
                labels: [c_1, c_2, c_3, c_4, c_5],
                datasets: [{
                  data: [c_v_6, c_v_7, c_v_8, c_v_9, c_v_10],
                  borderColor: 'RGBA(255, 204, 102, 1)',
                  borderWidth: 1,
                  backgroundColor: 'RGBA(255, 204, 102, 0)',
                },
                {
                  label: 'Average',
                  data: [c_v_1, c_v_2, c_v_3, c_v_4, c_v_5],
                  borderColor: 'RGBA(66, 133, 244, 1)',
                  borderWidth: 2,
                  backgroundColor: 'rgba(66, 133, 244, 0.3)',
                  label: 'Guestさん',
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

    // Question
    if ($("#question_id_array").val() != null){
        const question_id_array = JSON.parse($("#question_id_array").val());
        const question_content_array = JSON.parse($("#question_content_array").val());
        const question_remain_array = JSON.parse($("#question_remain_array").val());
        const option_id_array = JSON.parse($("#option_id_array").val());
        const option_question_id_array = JSON.parse($("#option_question_id_array").val());
        const option_next_question_id_array = JSON.parse($("#option_next_question_id_array").val());
        const option_content_array = JSON.parse($("#option_content_array").val());
        const before_question_id_array = JSON.parse($("#before_question_id_array").val());

        let questionNum = 1;
        let optionArray = [];
        let beforeQuestions = [];
        let startQuestion = Number($("#startQuestion").val());
        let question_index;
        let remain_question_number;

        if (questionNum == 1) {
            $("#questionReturn").hide();

            if (before_question_id_array.length > 0) {
                var index = before_question_id_array.length - 1;
                startQuestion = Number(before_question_id_array[index]);
                beforeQuestions = before_question_id_array;
                questionNum = before_question_id_array.length;
                $("#selectedOptions").hide();
                $('#beforeQuestions').hide();
                $("#category").hide();
                $("#user_id").hide();
                $("#questionSubmit").val("質問を中断して結果を見る");
                $("#questionSubmit").show();
                $("#questionForm").show();
                $("#questionReturn").show();
                beforeQuestions.pop();
            }

            question_index = question_id_array.indexOf(startQuestion);
            remain_question_number = question_remain_array[question_index] + 1;
            var question_parcent = changeQuestionPercent(questionNum - 1, remain_question_number);
            $("#question-parcent").text(question_parcent + "%");
            $("#questionNum").hide();
            $("#questionNum").text(questionNum + "問目");
            $("#questionNum").fadeIn(1000);
            $("#question_content").hide();
            $("#question_content").text(question_content_array[question_index]);
            $("#question_content").fadeIn(1000);

            var option_contents = [];
            var option_ids = [];
            var option_next_question_ids = [];
            var option_question_ids = [];
            for (var i = 0; i < option_question_id_array.length; i++) {
                if (option_question_id_array[i] == startQuestion) {
                    option_contents.push(option_content_array[i]);
                    option_ids.push(option_id_array[i]);
                    option_next_question_ids.push(option_next_question_id_array[i]);
                    option_question_ids.push(option_question_id_array[i]);
                }
            }

            option_ids = option_ids.filter(function (v, i, s) {
                return s.indexOf(v) === i;
            });

            for (var i = 0; i < option_ids.length; i++) {
                var id = "#option" + i;
                $(id).text(option_contents[i]);
                $(id).attr('name', option_ids[i]);
                $(id).attr('data-next', option_next_question_ids[i]);
                $(id).attr('data-before', option_question_ids[i]);
                $(id).fadeIn(1000);
                $(id).css('display', 'inline-block');
            }
        }

        // Question Chart
        if (document.getElementById("qChart") != null) {
            var ctx_qchart = document.getElementById("qChart");
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
                        data: [questionNum-1, remain_question_number]
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

        $(".options").click(function () {

            questionNum += 1;
            var option_id = Number($(this).attr('name'));
            optionArray.push(option_id);
            beforeQuestions.push($(this).attr('data-before'));
            var option_index = option_id_array.indexOf(option_id);
            var next_question_id = option_next_question_id_array[option_index];
            question_index = question_id_array.indexOf(next_question_id);
            remain_question_number = question_remain_array[question_index] + 1;
            var question_parcent = changeQuestionPercent(questionNum-1, remain_question_number);
            changeQChart();
            $("#questionNum").hide();
            $("#questionNum").text(questionNum + "問目");
            $("#questionNum").show();
            $("#question_content").hide();
            $("#question_content").text(question_content_array[question_index]);
            $("#question_content").show();
            $("#question-parcent").text(question_parcent + "%");

            var option_contents = [];
            var option_ids = [];
            var option_next_question_ids = [];
            var option_question_ids = [];



            for (var i = 0; i < 10; i++) {
                var id = "#option" + i;
                $(id).hide();
            }
            for (var i = 0; i < option_question_id_array.length; i++) {
                if (option_question_id_array[i] == next_question_id) {
                    option_contents.push(option_content_array[i]);
                    option_ids.push(option_id_array[i]);
                    option_next_question_ids.push(option_next_question_id_array[i]);
                    option_question_ids.push(option_question_id_array[i]);
                }
            }

            option_ids = option_ids.filter(function (v, i, s) {
                return s.indexOf(v) === i;
            });

            for (var i = 0; i < option_ids.length; i++) {
                var id = "#option" + i;
                $(id).text(option_contents[i]);
                $(id).attr('name', option_ids[i]);
                $(id).attr('data-next', option_next_question_ids[i]);
                $(id).attr('data-before', option_question_ids[i]);
                $(id).fadeIn(1000);
                $(id).css('display', 'inline-block');
            }


            $("#selectedOptions").val(optionArray);
            $("#selectedOptions").hide();
            $('#beforeQuestions').val(beforeQuestions);
            $('#beforeQuestions').hide();
            $("#category").hide();
            $("#user_id").hide();
            $("#questionSubmit").val("質問を中断して結果を見る");
            if (next_question_id == 0) {
                $("#questionSubmit").val("結果を見る");
                $("#question_content").hide();
                $("#questionNum").hide();
            }
            $("#questionSubmit").show();
            $("#questionForm").show();
            $("#questionReturn").show();

        });

        $("#questionReturn").click(function () {
            questionNum -= 1;
            question_index = question_id_array.indexOf(Number(beforeQuestions[beforeQuestions.length - 1]));
            remain_question_number = question_remain_array[question_index] + 1;
            var question_parcent = changeQuestionPercent(questionNum-1, remain_question_number);
            changeQChart();
            $("#questionNum").hide();
            $("#questionNum").text(questionNum + "問目");
            $("#questionNum").show();
            $("#question_content").hide();
            $("#question_content").text(question_content_array[question_index]);
            $("#question_content").show();
            $("#question-parcent").text(question_parcent + "%");
            optionArray.pop();
            var option_contents = [];
            var option_ids = [];
            var option_next_question_ids = [];
            var option_question_ids = [];

            for (var i = 0; i < 10; i++) {
                var id = "#option" + i;
                $(id).hide();
            }

            for (var i = 0; i < option_question_id_array.length; i++) {
                if (option_question_id_array[i] == question_id_array[question_index]) {
                    option_contents.push(option_content_array[i]);
                    option_ids.push(option_id_array[i]);
                    option_next_question_ids.push(option_next_question_id_array[i]);
                    option_question_ids.push(option_question_id_array[i]);
                }
            }

            option_ids = option_ids.filter(function (v, i, s) {
                return s.indexOf(v) === i;
            });

            for (var i = 0; i < option_ids.length; i++) {
                var id = "#option" + i;
                $(id).text(option_contents[i]);
                $(id).attr('name', option_ids[i]);
                $(id).attr('data-next', option_next_question_ids[i]);
                $(id).attr('data-before', option_question_ids[i]);
                $(id).fadeIn(1000);
                $(id).css('display', 'inline-block');
            }

            beforeQuestions.pop();
            $("#selectedOptions").val(optionArray);
            $("#selectedOptions").hide();
            $('#beforeQuestions').val(beforeQuestions);
            $('#beforeQuestions').hide();
            $("#category").hide();
            $("#user_id").hide();

            if (questionNum == 1) {
                $("#questionReturn").hide();
                $("#questionSubmit").hide();
            } else {
                $("#questionSubmit").show();
                $("#questionForm").show();
                $("#questionSubmit").val("質問を中断して結果を見る");
            }
        });

        $("#questionSubmit").click(function () {
            if ($(this).val() == "結果を見る" ) {
                beforeQuestions = [];
            } else {
                beforeQuestions.push(question_id_array[question_index]);
            }
            $('#beforeQuestions').val(beforeQuestions);
            $("#question-parcent").text("終了");
            $(this).hide();
            $("#question_content").hide();
            $(".options").hide();
            $("#questionReturn").hide();
            $("#questionNum").hide();
        });


        function changeQChart() {
            myPieQChart.data.labels.pop();
            myPieQChart.data.labels.pop();

            myPieQChart.data.datasets.forEach((dataset) => {
                dataset.data.pop();
            });
            myPieQChart.data.datasets.forEach((dataset) => {
                dataset.data.pop();
            });

            myPieQChart.data.labels.push("済", "未");

            myPieQChart.data.datasets.forEach((dataset) => {
                dataset.data.push(questionNum-1, remain_question_number);
            });
            myPieQChart.update();
        }

        function changeQuestionPercent(q, r) {
            if (r > 0) {
                return Math.floor(q / (q + r) * 100)
            } else {
                return 100;
            }

        }
    } // Question

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

    if ($("#new_option_id").val() != null) {
        let new_option_id = Number($("#new_option_id").val());

        $(document).on("click", ".question-group-top", function () {
            $(this).next('.question-group-content').slideToggle();
            $('.question-group-content').not($(this).next('.question-group-content')).slideUp();
        });

        $('form').submit(function () {
            return confirm("本当に実行しますか？");
        });

        $(document).on("click", ".delete-match", function () {
            $(this).parent().parent().remove();
        });

        $(document).on("click",".delete-option", function () {
            $(this).parent().parent().parent().parent().remove();
        });

        $(document).on("click", ".add-match", function () {
            option_id = $(this).parent().prev().children(".match_option_id").val();
            $(this).parent().prev().append(
                '<div class="input-group">' +
                '<input name="match_option_id[]" class="match_option_id" type="hidden" value="' +
                option_id +
                '">' +
                '<input name="match_id[]" class="match_id" type="hidden" value="0">' +
                '<div class="input-group-prepend"><div class="input-group-text">Column</div></div>' +
                '<input type="text" name="match_column[]" id="option_column_" value="" class="form-control" />' +
                '<div class="input-group-prepend"><div class="input-group-text">Max</div></div>' +
                '<input type="text" name="match_max[]" id="option_max_" value="" class="form-control" />' +
                '<div class="input-group-prepend"><div class="input-group-text">Min</div></div>' +
                '<input type="text" name="match_min[]" id="option_min_" value="" class="form-control" />' +
                '<div class="input-group-append"><div class="input-group-text btn btn-danger delete-match">ー</div></div>' +
                '</div>'
            );
        });


        $(document).on("click", ".add-option", function () {
            if ($("#new_question").val() == 1) {
                new_option_id += 1;
            }
            $(this).parent().prev().append(
                '<div class="row mt-3">' +
                    '<div class="col-md-6">' +
                        '<div class="input-group">' +
                            '<input name="option_id[]" class="option_id" type="hidden" value="' +
                            new_option_id +
                            '">' +
                            '<div class="input-group-prepend"><div class="input-group-text">' +
                            new_option_id +
                            '</div></div>' +
                            '<input type="text" name="option_content[]" id="option_content_" value="" class="form-control" />' +
                            '<div class="input-group-prepend"><div class="input-group-text">Next</div></div>' +
                            '<input type="text" name="next_question_id[]" id="next_question_id_" value="" class="form-control" />' +
                            '<div class="input-group-append"><div class="input-group-text btn btn-danger delete-option">ー</div></div>' +
                        '</div>' +
                    '</div>' +
                    '<div class="col-md-6">' +
                        '<div class="input-group">' +
                            '<input name="match_option_id[]" class="match_option_id" type="hidden" value="' +
                            new_option_id +
                            '">' +
                            '<input name="match_id[]" class="match_id" type="hidden" value="0">' +
                            '<div class="input-group-prepend"><div class="input-group-text">Column</div></div>' +
                            '<input type="text" name="match_column[]" id="option_column_" value="" class="form-control" />' +
                            '<div class="input-group-prepend"><div class="input-group-text">Max</div></div>' +
                            '<input type="text" name="match_max[]" id="option_max_" value="" class="form-control" />' +
                            '<div class="input-group-prepend"><div class="input-group-text">Min</div></div>' +
                            '<input type="text" name="match_min[]" id="option_min_" value="" class="form-control" />' +
                            '<div class="input-group-append"><div class="input-group-text btn btn-danger delete-match">ー</div></div>' +
                        '</div>' +
                        '<div class="row"><button type="button" class=" mx-auto btn btn-outline-secondary rounded-circle p-0 mt-2 add-match" style="width:2rem;height:2rem;">＋</button></div>' +
                    '</div>' +
                '</div>'
            );
            new_option_id += 1;
            if ($("#new_question").val() == 1) {
                new_option_id -= 1;
            }
        });
    }

    $(document).ready(function () {
        $('.select2').select2();
    });
});
