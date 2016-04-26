var slider = document.getElementById("slider");
setInterval(function() {
    pauseTime = 1000 - parseInt(slider.value);
}, 100)
