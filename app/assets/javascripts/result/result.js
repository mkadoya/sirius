$(function () {
    $('#item_btn_0').click(function () {
        var result = $('#item_0').offset().top;
        $('html, body').animate({ scrollTop: result }, 2000, 'swing');
    });
    $('#item_btn_1').click(function () {
        var result = $('#item_1').offset().top;
        $('html, body').animate({ scrollTop: result }, 2000, 'swing');
    });
    $('#item_btn_2').click(function () {
        var result = $('#item_2').offset().top;
        $('html, body').animate({ scrollTop: result }, 1000, 'swing');
    });
    $('#item_btn_3').click(function () {
        var result = $('#item_3').offset().top;
        $('html, body').animate({ scrollTop: result }, 1000, 'swing');
    });
    $('#item_btn_4').click(function () {
        var result = $('#item_4').offset().top;
        $('html, body').animate({ scrollTop: result }, 1000, 'swing');
    });
    $('#item_btn_5').click(function () {
        var result = $('#item_5').offset().top;
        $('html, body').animate({ scrollTop: result }, 1000, 'swing');
    });

});
