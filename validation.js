var text;
$.ajax({ url: "text.txt", success: function(file_content) {
    text = file_content;
}});
document.getElementById("zone").onkeydown = function (e) {
    if (e.keyCode == 13) {
        document.getElementById("mybutton").click();
    }
};
function validate() {
    var answer = document.getElementById("zone").value;
    if (answer == text) {
        alert("You are a human! Congratulations!");
    } else {
        alert("You are either an idiot of a robot!");
    }
}
