<?php

	//reference to master db connection data
	require_once('DBinfo.php');
	
	$conn = mysql_connect($path, $username, $password) or die(mysql_error());
	$db = mysql_select_db($db_name, $conn) or die(mysql_error());
	//incoming code from iphone, deserialize and test for duplicate in database
	$json = file_get_contents('php://input');
	$obj = json_decode($json, true);
	
	//variables
	$usercode = "";
	$text = "";
	$timestamp = "";
	 
	//get variables from iphone data
	foreach ($obj as $Field) {
		$usercode = $Field["usercode"];
		$text = $Field["text"];
		$timestamp = $Field["timestamp"];
	}
	
	echo "here";
	
	$sql = "INSERT INTO events (usercode, text, done, active, timestamp) VALUES ('$usercode', '$text', '0', '1', '$timestamp')";
	$result = mysql_query($sql) or die(mysql_error());
	
	mysql_close($conn);
	
?>