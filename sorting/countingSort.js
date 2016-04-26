function countingSort() {
    STOP = false;
    var states = [];
    var pairs = []; // The pairs that are swapped
    var counts = [];
    for (i = 0; i <= graph.maxValue; i++) {
        counts[counts.length] = 0;
    }
    for (i = 0; i != arr.length; i++) {
        counts[arr[i]]++;
    }
    var currIdx = 0;
    for (i = 0; i <= graph.maxValue; i++) {
        var count = counts[i];
        for (j = 0; j != count; j++) {
            arr[currIdx + j] = i;
        }
        currIdx += count;
        if (count != 0) {
            states[states.length] = arr.slice();
            pairs[pairs.length] = [-1];
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
