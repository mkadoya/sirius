
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
var ctx = document.getElementById("resultChart");
var myRadarChart = new Chart(ctx, {
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
