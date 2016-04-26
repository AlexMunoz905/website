function createCanvas(divName) {
    var div = document.getElementById(divName);
    var canvas = document.createElement('canvas');
    div.appendChild(canvas);
    if (typeof G_vmlCanvasManager != 'undefined') {
        canvas = G_vmlCanvasManager.initElement(canvas);
    }	
    var ctx = canvas.getContext("2d");
    return ctx;
}
var ctx = createCanvas("graphDiv1");
var graph = new BarGraph(ctx);
graph.maxValue = 90;
graph.minValue = 10;
graph.margin = 0;
graph.color = "white";
var STOP = false;
var numBars = 100;
var arr = [];
for (i = 0; i < numBars; i++) {
    arr[i] = graph.minValue + Math.floor(Math.random() * (graph.maxValue - graph.minValue));
}
// Plot the data
setTimeout(function() {
    graph.draw(arr.slice());
}, 100);
// Shuffle the data
function shuffle() {
    for (i = 0; i < arr.length; i++) {
        j = Math.floor(Math.random() * (arr.length - i));
        var tmp = arr[i];
        arr[i] = arr[i + j];
        arr[i + j] = tmp;
    }
    setTimeout(function () {
        graph.draw(arr.slice());
    }, 100);
}
var pauseTime = 200;
var slider2 = document.getElementById("arraySize");
setInterval(function() {
    newNum = parseInt(slider2.value);
    if (newNum != numBars) {
        numBars = newNum;
        document.getElementById("value").innerHTML = "Array size: " + newNum;
        arr = [];
        for (i = 0; i < numBars; i++) {
            arr[i] = Math.floor(Math.random() * graph.maxValue);
        }
        graph.draw(arr.slice());
    }
}, 100);
// Plot the data
/*
setTimeout(function() {
    graph.draw(arr.slice());
}, 100);
*/
function changeBackgroundColor(jscolor) {
    graph.setBackgroundColor("#" + jscolor);
}
function changeForegroundColor(jscolor) {
    graph.setForegroundColor("#" + jscolor);
}
function changeHighlightColor(jscolor) {
    graph.setHighlightColor("#" + jscolor);
}
function stop() {
    STOP = true;
}
