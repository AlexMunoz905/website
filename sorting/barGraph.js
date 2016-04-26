// http://www.williammalone.com/articles/html5-canvas-javascript-bar-graph/downloads/html5-canvas-bar-graph.html
function BarGraph(ctx) {

  // Private properties and methods
  var that = this;

  // Draw method updates the canvas with the current display
  // The block at p1 and p2 will be colored in red, but will be changed back to white
  // Highlights are the indices to highlight, a list
    this.draw = function (arr, highlights = []) {
							
	  var numOfBars = arr.length;
	  var barWidth;
	  var barHeight;
	  var border = 2;
	  var ratio;
	  var maxBarHeight;
	  var gradient;
	  var largestValue;
	  var graphAreaX = 0;
	  var graphAreaY = 0;
	  var graphAreaWidth = that.width;
	  var graphAreaHeight = that.height;
	  var i;
	  
		// Update the dimensions of the canvas only if they have changed
	  if (ctx.canvas.width !== that.width || ctx.canvas.height !== that.height) {
		ctx.canvas.width = that.width;
		ctx.canvas.height = that.height;
	  }
				
	  // Draw the background color
	  ctx.fillStyle = that.backgroundColor;
	  ctx.fillRect(0, 0, that.width, that.height);
					
	  // Calculate dimensions of the bar
	  barWidth = graphAreaWidth / numOfBars - that.margin * 2;
	  maxBarHeight = graphAreaHeight - 25;
				
	  // Determine the largest value in the bar array
	  var largestValue = 0;
      for (i = 0; i < arr.length; i++) {
		if (arr[i] > largestValue) {
		  largestValue = arr[i];	
		}
	  }
	  
	  // For each bar
	  for (i = 0; i < arr.length; i++) {
		// Set the ratio of current bar compared to the maximum
		if (that.maxValue) {
		  ratio = arr[i] / that.maxValue;
		} else {
		  ratio = arr[i] / largestValue;
		}
		
		barHeight = ratio * maxBarHeight;
	  
		// Draw bar background
		ctx.fillStyle = "#333";			
		ctx.fillRect(that.margin + i * that.width / numOfBars,
		  graphAreaHeight - barHeight,
		  barWidth,
		  barHeight);

        ctx.fillStyle = that.color;
        for (j = 0; j != highlights.length; j++) {
            if (highlights[j] == i) {
                ctx.fillStyle = that.highlightColor;
                break;
            }
        }

        ctx.fillRect(that.margin + i * that.width / numOfBars + border,
          graphAreaHeight - barHeight + border,
          barWidth - border * 2,
          barHeight - border * 2);
		}
	  };

    this.setBackgroundColor = function(background = "black") {
        that.backgroundColor = background;
        this.draw(arr);
    }

    this.setForegroundColor = function(foreground = "white") {
        that.color = foreground;
        this.draw(arr);
    }

    this.setHighlightColor = function(highlight = "red") {
        that.highlightColor = highlight;
    }
  // Public properties and methods
  this.width = window.innerWidth * 0.99;
  this.height = window.innerHeight * 0.6;
  this.maxValue;
  this.margin = 5;
  this.colors = ["purple", "red", "green", "yellow"];
  this.curArr = [];
  this.backgroundColor = "black";
  this.highlightColor = "red";
  this.xAxisLabelArr = [];
  this.yAxisLabelArr = [];
	
}
