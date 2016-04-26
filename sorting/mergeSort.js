function mergeSort() {
    STOP = false;
    var states = [];
    var pairs = []; // The pairs that are swapped
    function mergeSortHelper(l, r) {
        // Helper function to sort from l to r, change in place, but not using constant space
        if (l == r) {
            return;
        }
        var m = Math.floor((l + r) / 2);
        mergeSortHelper(l, m);
        mergeSortHelper(m + 1, r);
        var mergedList = [];
        var p1 = l;
        var p2 = m + 1;
        while (p1 <= m && p2 <= r) {
            if (arr[p1] <= arr[p2]) {
                mergedList[mergedList.length] = arr[p1];
                p1++;
            } else {
                mergedList[mergedList.length] = arr[p2];
                p2++;
            }
        }
        while (p1 <= m) {
            mergedList[mergedList.length] = arr[p1];
            p1++;
        }
        while (p2 <= r) {
            mergedList[mergedList.length] = arr[p2];
            p2++;
        }
        for (i = 0; i != mergedList.length; i++) {
            arr[l + i] = mergedList[i];
        }
        states[states.length] = arr.slice();
        pairs[pairs.length] = [-1];
    }
    mergeSortHelper(0, arr.length - 1);
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
