<?php

	//reference to master db connection data
	require_once('DBinfo.php');
	
	$conn = mysql_connect($path, $username, $password) or die(mysql_error());
	$db = mysql_select_db($db_name, $conn) or die(mysql_error());
	
	$usercode = $_POST['usercode'];
	$usercode = mysql_real_escape_string($usercode);
	
	$events = array();
	
	$obj = new stdClass;

	//Select News Titles where the mapID matches
	$sql = "SELECT text, timestamp FROM events WHERE usercode = '$usercode' AND active = '1'";
	$result = mysql_query($sql) or die(mysql_error());
	while ($row = mysql_fetch_array($result)) {
	
	    $obj->text = $row["text"];
	    $obj->timestamp = $row["timestamp"];
	    
	    array_push($events, $obj);           
	}
	
	echo json_encode($events);
	
	mysql_close($conn);
	
?>