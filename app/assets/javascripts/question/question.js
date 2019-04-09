
$(function () {
    $('#openModal').click(function () {
        $('#modalArea').fadeIn();
    });
    // $('#closeModal , #modalBg').click(function () {
    //     $('#modalArea').fadeOut();
    // });
    $('#closeModal').click(function () {
        $('#modalArea').fadeOut();
        var h2 = $('h2').offset().top -50;
        $('html, body').animate({ scrollTop: h2 }, 1000, 'swing');
    });
});
