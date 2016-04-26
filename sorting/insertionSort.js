function insertionSort() {
    STOP = false;
    var states = [];
    var pairs = []; // The pairs that are swapped
    for (i = 1; i < arr.length; i++) {
        var j = i;
        while (j != 0 && arr[j] < arr[j - 1]) {
            pairs[pairs.length] = [j];
            var tmp = arr[j];
            arr[j] = arr[j - 1];
            arr[j - 1] = tmp;
            j -= 1;
            states[states.length] = arr.slice();
        }
        pairs[pairs.length] = [j];
        states[states.length] = arr.slice();
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
