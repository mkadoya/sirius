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
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

$(function () {
    $('#openModal').click(function () {
        $('#modalArea').fadeIn();
    });
    // $('#closeModal , #modalBg').click(function () {
    //     $('#modalArea').fadeOut();
    // });
    $('#closeModal').click(function () {
        $('#modalArea').fadeOut();
    });
});

var doughnutData = [
    {
        value: 30,
        color: "#aaf2fb"
    },
    {
        value: 50,
        color: "#ffb6b9"
    },
    {
        value: 120,
        color: "#ffe361"
    },
    {
        value: 170,
        color: "#fbaa6e"
    },
    {
        value: 70,
        color: "#A8BECB"
    }
];

var myDoughnut = new Chart(document.getElementById("question-status-graph").
    getContext("2d")).Doughnut(doughnutData);
