function selectionSort() {
    STOP = false;
    var states = [];
    var pairs = []; // The pairs that are swapped
    for (i = 0; i < arr.length; i++) {
        var minIdx = i;
        for (j = i + 1; j < arr.length; j++) {
            if (arr[j] < arr[minIdx]) {
                minIdx = j;
            }
        }
        var tmp = arr[i];
        arr[i] = arr[minIdx];
        arr[minIdx] = tmp;
        states[i] = arr.slice();
        pairs[i] = [i, minIdx];
    }
    pairs[i] = [-1, -1];
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
