<?php

	//reference to master db connection data
	require_once('DBinfo.php');
	
	$conn = mysql_connect($path, $username, $password) or die(mysql_error());
	$db = mysql_select_db($db_name, $conn) or die(mysql_error());
	
	$usercode = $_POST['usercode'];
	$usercode = mysql_real_escape_string($usercode);
	
	$events = array();

	//Select News Titles where the mapID matches
	$sql = "SELECT text, who, timestamp FROM events WHERE usercode = '$usercode' AND active = '1' ORDER BY timestamp DESC";
	$result = mysql_query($sql) or die(mysql_error());
	while ($row = mysql_fetch_array($result)) {
		$obj = new stdClass;
	
	    $obj->text = $row["text"];
	    $obj->who = $row["who"];
	    $obj->timestamp = $row["timestamp"];
	    
	    array_push($events, $obj);           
	}
	
	echo json_encode($events);
	
	mysql_close($conn);
	
?>