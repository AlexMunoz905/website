$(document).ready(function() {
	// Initialize the lights
	var lights = [];
	var changeClass = function(obj) {
		if (obj.attr("class") == "white") {
			obj.removeClass("white").addClass("black");
		} else {
			obj.removeClass("black").addClass("white");
		}
	}
	var isValid = function(obj) {
		return 0 <= obj[0] && obj[0] < 5 && 0 <= obj[1] && obj[1] < 5;
	}
	for (var i = 0; i < 5; ++i) {
		lights.push([]);
		for (var j = 0; j < 5; ++j) {
			lights[i].push($("tr:eq(" + i + ")").find("td:eq(" + j + ")"));
			lights[i][j].addClass("white");
		}
	}
	for (var i = 0; i < 5; ++i) {
		for (var j = 0; j < 5; ++j) {
			lights[i][j].click({row: i, column: j}, function(event) {
				var neighbor = [[event.data.row, event.data.column],
				[event.data.row - 1, event.data.column],
				[event.data.row, event.data.column - 1],
				[event.data.row + 1, event.data.column],
				[event.data.row, event.data.column + 1]
				];
				for (var k = 0; k < 5; ++k) {
					if (isValid(neighbor[k])) {
						changeClass(lights[neighbor[k][0]][neighbor[k][1]]);
					}
				}
			})
		}
	}
	// If the puzzle is solved, alert the user
	var haveAlreadySolve = 0;
	var checkFinish = function() {
		var finished = 1;
		for (var i = 0; i < 5; ++i) {
			for (var j = 0; j < 5; ++j) {
				if (lights[i][j].hasClass("white")) {
					finished = 0;
				}
			}
		}
		if (finished === 1 && haveAlreadySolve == 0) {
			alert("You have solved this puzzle!");
			haveAlreadySolve = 1;
		}
	};
	setInterval(checkFinish, 200);
	// When reset is pressed, we set all colors to be empty
	$("#button").click(function() {
		for (var i = 0; i < 5; ++i) {
			for (var j = 0; j < 5; ++j) {
				var obj = lights[i][j];
				if (obj.hasClass("black")){
					obj.removeClass("black").addClass("white");
				}
			}
		}
	});
})
