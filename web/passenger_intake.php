<?php

//reference to master db connection data
require_once('DBinfo.php');

//incoming code from iphone, deserialize and test for duplicate in database
$json = file_get_contents('php://input');
echo $json;
$obj = json_decode($json, true);

//variables
$usercode = ""; 
$connected_id = ""; 
$timestamp = "";
$error_msg = "";

//Set up database connection
$conn = mysql_connect($path, $username, $password) or die(mysql_error());
$db = mysql_select_db($db_name, $conn) or die(mysql_error());

//get variables from device data
foreach ($obj as $Field) {
	$usercode = $Field["usercode"];
	$connected_id = $Field["connectID"];
	$timestamp = $Field["timestamp"];
}
 
$usercode = mysql_real_escape_string($usercode);
$connected_id = mysql_real_escape_string($connected_id);
$timestamp = mysql_real_escape_string($timestamp);

//echo $usercode . " " . $connected_id . " " . $timestamp;

//test for missing data
if (!empty($usercode) && !empty($connected_id) && !empty($timestamp)) {
	
	$createID;
	
	$sql = "SELECT create_id FROM usercodes WHERE usercode = '$usercode'";
	$result = mysql_query($sql) or die(mysql_error());
	$row = mysql_fetch_array($result);
	
	$createID = $row["create_id"];
	
	$sql = "INSERT INTO device_connections (usercode, create_id, connected_id, active, timestamp) VALUES ('$usercode', '$createID', '$connected_id', '1', '$timestamp')";
	$result = mysql_query($sql) or die(mysql_error());

} else {
}
	

?>