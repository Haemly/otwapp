<<!--accept gps data from device to put in database table driver_positions-->
<?php

//reference to master db connection data
require_once('DBinfo.php');

//incoming code from iphone, deserialize and test for duplicate in database
$json = file_get_contents('php://input');
$obj = json_decode($json, true);

//variables
$create_id = "";
$gps_lat = ""; 
$gps_long = ""; 
$gps_error = ""; 
$timestamp = "";
$error_msg = "";

//Set up database connection
	$conn = mysql_connect($path, $username, $password) or die(mysql_error());
	$db = mysql_select_db($db_name, $conn) or die(mysql_error());
 
 //get variables from device data
 foreach ($obj as $Field) {
	$create_id = $Field["create_id"];
	$gps_lat = $Field["gps_lat"];
	$gps_long = $Field["gps_long"];
	$gps_error = $Field["gps_error"];
	$timestamp = $Field["timestamp"];
 }
 
$create_id = mysql_real_escape_string($create_id);
$gps_lat = mysql_real_escape_string($gps_lat);
$gps_long = mysql_real_escape_string($gps_long);
$gps_error = mysql_real_escape_string($gps_error);
$timestamp = mysql_real_escape_string($timestamp);

//test for missing data 
if (!empty($create_id) && !empty($gps_lat) && !empty($gps_long) && !empty($gps_error) && !empty($timestamp) {
	
	//Set up database connection
	$conn = mysql_connect($path, $username, $password) or die(mysql_error());
	$db = mysql_select_db($db_name, $conn) or die(mysql_error());
	
	//put new location in database driver_positions table
	$sql = "INSERT INTO driver_positions (create_id, gps_lat, gps_long, gps_error, timestamp) VALUES ('$create_id', '$gps_lat', '$gps_long', '$gps_error', '$timestamp')";
	$result = mysql_query($sql) or die(echo "E03");
		
	} else {
	//say what data is missing
	if ((empty($create_id) { echo "E11"};
	if ((empty($gps_lat) { echo "E12"};
	if ((empty($gps_long) { echo "E13"};
	if ((empty($gps_error) { echo "E14"};
	if ((empty($timestamp) { echo "E09"};
	
	}


function validConnection() {

	//Check if valid connection
	$sql = "SELECT active FROM connected_devices WHERE usercode = '$usercode'";
	$result = mysql_query($sql) or die(echo "E03");
	
	$active;
	
	while ($row = mysql_fetch_array($result)) {
		$active = $row['active'];
	}
	
	if ($active == 0) {
		return false;
	} else {
		return true;
	}
	
	return false;
}




















>