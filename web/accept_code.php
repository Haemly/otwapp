//script to generate a unique code
<?php


require_once('DBinfo.php');

//incoming code from iphone, deserialize and test for duplicate in database
$json = file_get_contents('php://input');
$obj = json_decode($json);

//variables
$userCode = "";
$first_name = ""; 
$last_name = ""; 
$phone_number = ""; 
$timestamp = "";
$error_msg = "";
 
 //get variables from iphone data
 foreach ($obj as $Field) {
	$userCode = $Field["usercode"];
	$first_name = $Field["first_name"];
	$last_name = $Field["last_name"];
	$phone_number = $Field["phone_number"];
	$timestamp = $Field["timestamp"];
 }

//test
if (!empty($usercode) && !empty($first_name) && !empty($last_name) 
	&& !empty($phone_number) && !empty($timestamp) {
	
	//connect to database
	$conn = mysql_connect("$db_name","$username","$password");
	msyql_select_db("$db_name", $conn ) or die("E01"); 
	
	
	
	
	
	}
 











?>