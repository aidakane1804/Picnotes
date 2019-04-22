function messageForm(){
  var shiftDown = false;
  var chatForm = $("#new_message");
  var messageBox = chatForm.children("textarea");
  $(document).keypress(function (e) {
      if(e.keyCode == 13) {
          if(messageBox.is(":focus") && !shiftDown) {
          	e.preventDefault(); // prevent another \n from being entered
						chatForm.submit();
              $(".scroll").scrollTop($(".scroll")[0].scrollHeight);
						$(chatForm).trigger('reset');

          }
      }
  });

  $(document).keydown(function (e) {
      if(e.keyCode == 16) shiftDown = true;
      $(".scroll").scrollTop($(".scroll")[0].scrollHeight);
  });

  $(document).keyup(function (e) {
      if(e.keyCode == 16) shiftDown = false;
      $(".scroll").scrollTop($(".scroll")[0].scrollHeight);
  });
}
