var ctx = document.getElementById("myChart");

var c_question_num = $('#c_question_num').val();
var r_question_num = $('#r_question_num').val();
var myPieChart = new Chart(ctx, {
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
