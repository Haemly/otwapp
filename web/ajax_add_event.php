<?php

	//reference to master db connection data
	require_once('DBinfo.php');
	
	$conn = mysql_connect($path, $username, $password) or die(mysql_error());
	$db = mysql_select_db($db_name, $conn) or die(mysql_error());
	
	//variables
	$usercode = $_POST['usercode'];
	$text = $_POST['text'];
	$timestamp = $_POST['timestamp'];
	
	$sql = "INSERT INTO events (usercode, text, who, done, active, timestamp) VALUES ('$usercode', '$text', '1', '0', '1', '$timestamp')";
	$result = mysql_query($sql) or die(mysql_error());
	
	echo "Hello Cory";
	
	mysql_close($conn);
	
?>