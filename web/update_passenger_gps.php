<?php

	//reference to master db connection data
	require_once('DBinfo.php');
	
	//incoming code from iphone, deserialize and test for duplicate in database
	$json = file_get_contents('php://input');
	$obj = json_decode($json, true);
	
	//variables
	$usercode = ""; 
	$connectID = "";
	$passengerLat = "";
	$passengerLong = "";
	
	//Set up database connection
	$conn = mysql_connect($path, $username, $password) or die(mysql_error());
	$db = mysql_select_db($db_name, $conn) or die(mysql_error());
	
	//get variables from device data
	foreach ($obj as $Field) {
		$usercode = $Field["usercode"];
		$connectID = $Field["connectID"];
		$passengerLat = $Field["passengerLat"];
		$passengerLong = $Field["passengerLong"];
	}
	 
	$usercode = mysql_real_escape_string($usercode);
	$connectedID = mysql_real_escape_string($connectedID);
	$passengerLat = mysql_real_escape_string($passengerLat);
	$passengerLong = mysql_real_escape_string($passengerLong);
	
	$sql = "UPDATE device_connections SET passenger_lat = '$passengerLat', passenger_long = '$passengerLong' WHERE usercode = '$usercode' AND connected_id = '$connectID'";
	$result = mysql_query($sql) or die(mysql_error());
	
	
	mysql_close($conn);
?>