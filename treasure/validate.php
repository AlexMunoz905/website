<?php

$validate = array(
	"level-1" => array( /* array key -> level name */
		"answer" => "1211", // answer string
		"url" => "sequence.html" # url of next level
	),
	"level-2" => array(
		"answer" => "3271",
		"url" => "matchstick.html"
	),
	"level-3" => array(
		"answer" => "292",
		"url" => "yuchun.html"
	),
	"level-4" => array(
		"answer" => "2014",
		"url" => "colorful.html"
	),
	"level-5" => array(
		"answer" => "4537",
		"url" => "last.html"
	)
);

if (isset($_POST["level-name"]) && isset($_POST["answer"])) {
	$level = $_POST["level-name"];
	$answer = $_POST["answer"];
	if ($validate[$level]["answer"] == $answer) {
		header("Location: " . $validate[$level]["url"]);
		return;
	}
}

include "wrong-answer.html"; // or you may just write html here

?>
