function bubbleSort() {
    STOP = false;
    var states = [];
    var pairs = []; // The pairs that are swapped
    var finished = false;
    for (i = 0; i != arr.length; i++) {
        if (!finished) {
            finished = true;
            for (j = 0; j < arr.length - 1; j++) {
                if (arr[j] > arr[j + 1]) {
                    finished = false;
                    var tmp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = tmp;
                    pairs[pairs.length] = [j, j + 1];
                    states[states.length] = arr.slice();
                }
            }
        }
    }
    pairs[pairs.length] = [-1];
    var index = 0;
    pauseTime = 200;
    function visualize() {
        setTimeout(function() {
            if (index == states.length || STOP) {
                clearInterval(visualize);
                return;
            }
            graph.draw(states[index].slice(), pairs[index + 1]);
            index++;
            visualize();
        }, pauseTime);
    };
    visualize();
}
