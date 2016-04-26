function bucketSort() {
    STOP = false;
    var states = [];
    var pairs = []; // The pairs that are swapped
    var bucketSize = 10;
    var bucketNum = Math.floor(graph.maxValue / bucketSize) + 1;
    var buckets = [];
    for (i = 0; i != bucketNum; i++) {
        buckets[buckets.length] = [];
    }
    for (i = 0; i != arr.length; i++) {
        var val = arr[i];
        buckets[Math.floor(val / bucketSize)].push(val);
    }
    // Sort each bucket
    for (i = 0; i != bucketNum; i++) {
        var bucketElements = buckets[i];
        // Apply insertion sort
        for (j = 1; j < bucketElements.length; j++) {
            var k = j;
            while (k != 0 && bucketElements[k] < bucketElements[k - 1]) {
                var tmp = bucketElements[k];
                bucketElements[k] = bucketElements[k - 1];
                bucketElements[k - 1] = tmp;
                k -= 1;
            }
            buckets[i] = bucketElements;
        }
    }
    var currIdx = 0;
    for (i = 0; i != bucketNum; i++) {
        for (j = 0; j != buckets[i].length; j++) {
            arr[currIdx + j] = buckets[i][j];
        }
        currIdx += buckets[i].length;
        states[states.length] = arr.slice();
        pairs[pairs.length] = [-1];
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
