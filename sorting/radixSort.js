function radixSort() {
    STOP = false;
    var states = [];
    var pairs = []; // The pairs that are swapped
    var base = 10;
    var maxValue = arr[0];
    for (i = 1; i < arr.length; i++) {
        if (maxValue < arr[i]) {
            maxValue = arr[i];
        }
    }
    var maxLength = Math.floor(Math.log(maxValue) / Math.log(base)) + 1;
    var queues = [];
    for (i = 0; i != base; i++) {
        queues[i] = new Queue();
    }
    for (l = 0; l != maxLength; l++) {
        for (i = 0; i != arr.length; i++) {
            var val = arr[i];
            var queueId = Math.floor(val / Math.pow(base, l)) % base;
            queues[queueId].enqueue(val);
        }
        arr = [];
        for (i = 0; i != base; i++) {
            var currQueue = queues[i];
            while (currQueue.size() != 0) {
                arr[arr.length] = currQueue.dequeue();
            }
        }
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
