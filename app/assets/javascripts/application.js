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
//= require chosen-jquery
//= require popper
//= require bootstrap-sprockets
//= require rails-ujs
//= require turbolinks
//= require_tree .

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

$(document).ready(function(){ 
   $("#how-it-works").show('slow');
   $("#choose-topic").delay(1000).show('fast');
   $("#upload-pic").delay(2500).show(2000);
   $("#picnotes-img").delay(3000).show(3000);
   $("#share-notes").delay(6000).show('fast');
   $("#coral-triangle").delay(7000).show('fast');
   $("#easy").delay(8000).show('fast');
   $("#terms-conditions").delay(9000).show('fast');

   var text="THE CORAL TRIANGLE";
   var delay=170;
   var elem = $("#triangle");
    var addTextByDelay = function(text,elem,delay){
        if(!elem){
            elem = $("body");
        }
        if(!delay){
            delay = 300;
        }
        if(text.length >0){
            elem.append(text[0]);
            setTimeout(
                function(){
                    addTextByDelay(text.slice(1),elem,delay);            
                 },delay                 
                );
        }
    }

    $("#triangle").delay(1300).show('slow');
    addTextByDelay(text,elem,delay)
 }) 
