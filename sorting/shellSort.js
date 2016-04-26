function shellSort() {
    STOP = false;
    var states = [];
    var pairs = []; // The pairs that are swapped
    var gaps = [701, 301, 132, 57, 23, 10, 4, 1];
    for (i = 0; i != gaps.length; i++) {
        var gap = gaps[i];
        for (j = gap; j < arr.length; j++) {
            var k = j;
            while (k >= gap && arr[k] < arr[k - gap]) {
                pairs[pairs.length] = [k, k - gap];
                states[states.length] = arr.slice();
                var tmp = arr[k];
                arr[k] = arr[k - gap];
                arr[k - gap] = tmp;
                k -= gap;
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
