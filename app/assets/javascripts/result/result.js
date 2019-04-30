const defaultDispCnt = 6; // 初期表示件数
const addDispCnt = 6;     // 追加表示件数

jQuery(function ($) {
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

    // もっと見るボタンクリックイベント
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

});


// const defaultDispCnt = 6; // 初期表示件数
// const addDispCnt = 6;     // 追加表示件数

// jQuery(function ($) {
//     let maxDispCnt = 0;     // 最大表示件数
//     let currentDispCnt = 0; // 現在の表示件数

//     // 一覧の初期表示
//     $('.card-item').each(function (i, elem) {
//         // 初期表示件数のみ表示
//         if (i < defaultDispCnt) {
//             $(this).show();
//             currentDispCnt++;
//         }
//         maxDispCnt++;

//         // もっと見るボタンを表示
//         let displayed = 0;
//         if (maxDispCnt > currentDispCnt && !displayed) {
//             $('.readMoreBtn').show();
//             displayed = 1;
//         }
//     });

//     // 一覧の初期表示
//     $('.item-details').each(function (i, elem) {
//         // 初期表示件数のみ表示
//         if (i < defaultDispCnt) {
//             $(this).show();
//         }
//     });

//     // もっと見るボタンクリックイベント
//     $('.readMoreBtn').click(function () {
//         let newCount = currentDispCnt + addDispCnt; // 新しく表示する件数

//         // 新しく表示する件数のみ表示
//         $('.card-item').each(function (i, elem) {
//             if (currentDispCnt <= i && i < newCount) {
//                 $(this).show();
//                 currentDispCnt++;
//             }
//         });

//         currentDispCnt = 0;

//         // 新しく表示する件数のみ表示
//         $('.item-details').each(function (i, elem) {
//             if (currentDispCnt <= i && i < newCount) {
//                 $(this).show();
//                 currentDispCnt++;
//             }
//         });

//         // もっと見るボタンを非表示
//         if (maxDispCnt <= newCount) {
//             $(this).hide();
//         }

//         return false;
//     });


//     $('#item_btn_0').click(function () {
//         var result = $('#item_0').offset().top;
//         $('html, body').animate({ scrollTop: result }, 2000, 'swing');
//     });
//     $('#item_btn_1').click(function () {
//         var result = $('#item_1').offset().top;
//         $('html, body').animate({ scrollTop: result }, 2000, 'swing');
//     });
//     $('#item_btn_2').click(function () {
//         var result = $('#item_2').offset().top;
//         $('html, body').animate({ scrollTop: result }, 1000, 'swing');
//     });
//     $('#item_btn_3').click(function () {
//         var result = $('#item_3').offset().top;
//         $('html, body').animate({ scrollTop: result }, 1000, 'swing');
//     });
//     $('#item_btn_4').click(function () {
//         var result = $('#item_4').offset().top;
//         $('html, body').animate({ scrollTop: result }, 1000, 'swing');
//     });
//     $('#item_btn_5').click(function () {
//         var result = $('#item_5').offset().top;
//         $('html, body').animate({ scrollTop: result }, 1000, 'swing');
//     });

// });
