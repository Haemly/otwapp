<?php

	//reference to master db connection data
	require_once('DBinfo.php');
	
	$conn = mysql_connect($path, $username, $password) or die(mysql_error());
	$db = mysql_select_db($db_name, $conn) or die(mysql_error());
	
	$usercode = $_POST['usercode'];
	$usercode = mysql_real_escape_string($usercode);
	
	$gps = array();
	
	$obj = new stdClass;

	$sql = "SELECT driver_start_lat, driver_start_long FROM usercodes WHERE usercode = '$usercode'";
	$result = mysql_query($sql) or die(mysql_error());
	while ($row = mysql_fetch_array($result)) {
	    $obj->driverStartLat = $row["driver_start_lat"];
	    $obj->driverStartLong = $row["driver_start_long"];
	}
	
	$sql = "SELECT passenger_lat, passenger_long FROM device_connections WHERE usercode = '$usercode'";
	$result = mysql_query($sql) or die(mysql_error());
	while ($row = mysql_fetch_array($result)) {
	    $obj->passengerLat = $row["passenger_lat"];
	    $obj->passengerLong = $row["passenger_long"];
	}
	
	array_push($gps, $obj);
	
	echo json_encode($gps);
	mysql_close($conn);
	
?>