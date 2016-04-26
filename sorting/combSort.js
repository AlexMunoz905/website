function combSort() {
    STOP = false;
    var states = [];
    var pairs = []; // The pairs that are swapped
    var finished = false;
    var gap = arr.length;
    var shrinkingFactor = 1.3;
    while (gap > 1 || !finished) {
        gap = Math.floor(gap / shrinkingFactor);
        if (gap < 1) {
            gap = 1;
        }
        finished = true;
        for (i = 0; i < arr.length - gap; i++) {
            if (arr[i] > arr[i + gap]) {
                finished = false;
                pairs[pairs.length] = [i, i + gap];
                states[states.length] = arr.slice();
                var tmp = arr[i];
                arr[i] = arr[i + gap];
                arr[i + gap] = tmp;
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
