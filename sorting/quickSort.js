function quickSort() {
    STOP = false;
    var states = [];
    var pairs = []; // The pairs that are swapped
    function quickSortHelper(l, r) {
        if (l >= r) {
            return [];
        }
        //var rtn = [];
        var pivotIdx = l + Math.floor(Math.random() * (r - l + 1));
        var p = arr[pivotIdx];
        var pivotTarget = l; // Count number of elements < p
        for (i = l; i <= r; i++) {
            if (arr[i] < p) {
                pivotTarget++;
            }
        }
        pairs[pairs.length] = [pivotIdx, pivotTarget];
        states[states.length] = arr.slice();
        var tmp = arr[pivotIdx];
        arr[pivotIdx] = arr[pivotTarget];
        arr[pivotTarget] = tmp;
        var p1 = l;
        var p2 = r;
        while (p1 < pivotTarget && p2 > pivotTarget) {
            while (arr[p1] < p && p1 < pivotTarget) {
                p1++;
            }
            while (arr[p2] >= p && p2 > pivotTarget) {
                p2--;
            }
            if (p1 == pivotTarget || p2 == pivotTarget) {
                break;
            }
            pairs[pairs.length] = [p1, p2];
            states[states.length] = arr.slice();
            var tmp = arr[p1];
            arr[p1] = arr[p2];
            arr[p2] = tmp;
            p1++;
            p2--;
        }
        quickSortHelper(l, pivotTarget - 1);
        quickSortHelper(pivotTarget + 1, r);
    }
    quickSortHelper(0, arr.length - 1);
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
