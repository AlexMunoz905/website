$(document).ready(function() {
	var changeUrl = function() {
		top.location = $("input[name=textfield]").val() + ".html";
	}
	$("#button").click(changeUrl);
	$("form").submit(function(event) {
		event.preventDefault();
		changeUrl();
	});
});
