$(document).ready(function() {
	$("p").load("Introduction");
	var name = "suibian";
	$("button:eq(0)").click(function() {
		if (name === "suibian") {
			name = "";
			$("p").load("preA");
		} else {
			name += "A";
			$("p").load(name);
		}
		$("button:eq(2)").show();
	});
	$("button:eq(1)").click(function() {
		if (name === "suibian") {
			name = "";
			$("p").load("preB");
		} else {
			name += "B";
			$("p").load(name);
		}
		$("button:eq(2)").show();
	});
	$("button:eq(2)").click(function() {
		name = name.slice(0, -1);
		$("p").load(name);
	}).hide();

});