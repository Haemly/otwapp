<?php
	require_once('DBinfo.php');
	
	//Set up database connection
	$conn = mysql_connect($path, $username, $password) or die(mysql_error());
	$db = mysql_select_db($db_name, $conn) or die(mysql_error());
	
	$usercode = $_GET['usercode'];
	$usercode = mysql_real_escape_string($usercode);
	$time = $_GET['time'];
	$time = mysql_real_escape_string($time);
	$timestamp = $_GET['timestamp'];
	$timestamp = mysql_real_escape_string($timestamp);
	
	$sql = "INSERT INTO added_times (usercode, time, timestamp, executed) VALUES ('$usercode', '$time', '$timestamp', '$executed')";
	$result = mysql_query($sql) or die(mysql_error());
	
	mysql_close($conn);
?>