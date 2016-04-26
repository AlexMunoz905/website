function heapSort() {
    STOP = false;
    var states = [];
    var pairs = []; // The pairs that are swapped
    // Construct a min-heap
    var heap = new BinaryHeap(function(x){return x;});
    for (index = 0; index < arr.length; index++) {
        heap.push(arr[index]);
    }
    // Extract elements from the heap
    var extracted = [];
    while (heap.size() > 0) {
        extracted[extracted.length] = heap.pop();
        states[states.length] = extracted.concat(heap.content);
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
