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
//= require jquery3
// = require chosen-jquery
//= require popper
//= require bootstrap-sprockets
//= require rails-ujs
//= require turbolinks
//= require_tree .
//= require_tree ./channels


$(document).on('turbolinks:load', function () {
    $('.dropdown .dropdown-menu').on('click', 'a.dropdown-item', function () {
        var searchTest = $(this).text();
        $('.dropdown a:first').text(searchTest);
    });
});


$(window).scroll(function() {
    var scroll = $(window).scrollTop();
    if (scroll >= 30) {
        $(".header").addClass("headerfixed");
        $(".midsec").addClass("headerfsixed");
    } else {
        $(".header").removeClass("headerfixed");
        $(".midsec").removeClass("headerfsixed");
    }
});

if ($(".scroll")[0]){
  $(".scroll").scrollTop($(".scroll")[0].scrollHeight);
}  
$("#modal-window").find(".modal-content").html("<%= j (render 'new') %>");
$("#modal-window").modal();

// document.getElementById("defaultOpen").click();

function openTab(evt, tabName) {
    // Declare all variables
    var i, tabcontent, tablinks;

    // Get all elements with class="tabcontent" and hide them
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }

    // Get all elements with class="tablinks" and remove the class "active"
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }

    // Show the current tab, and add an "active" class to the button that opened the tab
    document.getElementById(tabName).style.display = "block";
    evt.currentTarget.className += " active";
}

function ChangeUrl(title, url) {

    if (typeof (history.pushState) != "undefined") {
        var obj = { Title: title, Url: url };
        history.pushState(obj,"", '/notes',);
        history.pushState(obj, obj.Title, obj.Url);
    } else {
        alert("Browser does not support HTML5.");
    }
}

function ChangeUrlForEdFluencers(title, url) {
    if (typeof (history.pushState) != "undefined") {
        var obj = { Title: title, Url: url };
        history.pushState(obj,"", '/ed_fluencers',);
        history.pushState(obj, obj.Title, obj.Url);
    } else {
        alert("Browser does not support HTML5.");
    }
}

function ChangeUrlForUsers(title, url) {
    if (typeof (history.pushState) != "undefined") {
        var obj = {Title: title  , Url: url};
        history.pushState(obj, "", '/users',);
        history.pushState(obj, obj.Title, obj.Url);
    } else {
        alert("Browser does not support HTML5.");
    }
}

function changeMetaContent(title, metaName, newMetaContent) {
    document.title = title;
    $("meta").each(function() {
        if($(this).attr("name") === metaName) {
            $(this).attr("content" , newMetaContent);
        }
    });
}

function ed_tracker_dropdown(Object, id, current_user_id) {
    var value = Object.value;
    var id = id;
    $.ajax({
        url: "/update_status",
        type: "POST",
        dataType: "json",
        crossDomain: true,
        data: {
            status: value,
            edtracker_id: id,
            current_user_id: current_user_id
        },
        success: function (request) {
            location.reload();
        },
        error: function (xhr) {
            alert("Please login first!");
        }
    });
}
