<?php

	//reference to master db connection data
	require_once('DBinfo.php');
	
	//incoming code from iphone, deserialize and test for duplicate in database
	$json = file_get_contents('php://input');
	$obj = json_decode($json, true);
	
	//variables
	$usercode = ""; 
	$createID = "";
	$driverStartLat = "";
	$driverStartLong = "";
	
	//Set up database connection
	$conn = mysql_connect($path, $username, $password) or die(mysql_error());
	$db = mysql_select_db($db_name, $conn) or die(mysql_error());
	
	//get variables from device data
	foreach ($obj as $Field) {
		$usercode = $Field["usercode"];
		$createID = $Field["createID"];
		$driverStartLat = $Field["driverStartLat"];
		$driverStartLong = $Field["driverStartLong"];
	}
	 
	$usercode = mysql_real_escape_string($usercode);
	$createID = mysql_real_escape_string($createID);
	$driverStartLat = mysql_real_escape_string($driverStartLat);
	$driverStartLong = mysql_real_escape_string($driverStartLong);
	
	$sql = "UPDATE usercodes SET driver_start_lat = '$driverStartLat', driver_start_long = '$driverStartLong' WHERE usercode = '$usercode' AND create_id = '$createID'";
	$result = mysql_query($sql) or die(mysql_error());
	
	//echo $usercode . " " . $createID . " " . $driverStartLat . " " . $driverStartLong;
	
	
	mysql_close($conn);
?>