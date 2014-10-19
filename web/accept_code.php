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
$createID = "";
$firstName = ""; 
$lastName = ""; 
$phone = ""; 
$timestamp = "";
 
//get variables from iphone data
foreach ($obj as $Field) {
	$usercode = $Field["usercode"];
	$createID = $Field["createID"];
	$firstName = $Field["first_name"];
	$lastName = $Field["last_name"];
	$email = $Field["email"];
	$phone = $Field["phone"];
	$timestamp = $Field["timestamp"];
}

$sql = "INSERT INTO usercodes (usercode, create_id, first_name, last_name, email, phone, timestamp) VALUES ('$usercode', '$createID', '$firstName', '$lastName', '$email', '$phone', '$timestamp')";
$result = mysql_query($sql) or die(mysql_error());

mysql_close($conn);
	
?>