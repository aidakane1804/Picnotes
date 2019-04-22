function createMessageChannel() {
	App.messages = App.cable.subscriptions.create({
		channel: 'MessagesChannel', chat_id: parseInt($("#message_chat_id").val())
	},
	{
		received: function(data) {
			$("#messages").removeClass('hidden');
            $("#circle").addClass('dot');
            // $(".recent_heading").addClass('alert-success');
            $(".scroll").animate({scrollTop: $(".scroll")[0].scrollHeight });
            return $('#messages').append(this.renderMessage(data));

		},

		renderMessage: function(data) {
			return "<p  class=\"scroll\" style=\"text-align: left;\word-wrap: break-word;\">  <span class=\"badge badge-pill badge-info\" ><b>" + data.user + " &nbsp; &nbsp;: </b>" + "</span>" + "&nbsp; &nbsp;&nbsp;" + data.message + "</p>"+"<br>";
        // <p style="max-width:543%;text-align: left;  " > <span class="badge badge-pill badge-info" ><b><%= message.user.username %> &nbsp; &nbsp; &nbsp;: </b></span> &nbsp; &nbsp; &nbsp; &nbsp;<%=message.content%></p>

		}
	});

	return App.messages;
}