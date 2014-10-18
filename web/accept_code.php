//script to accept iphone code and place in database table usercodes
<?php

//reference to master db connection data
require_once('DBinfo.php');

//incoming code from iphone, deserialize and test for duplicate in database
$json = file_get_contents('php://input');
$obj = json_decode($json);

//variables
$usercode = "";
$first_name = ""; 
$last_name = ""; 
$phone_number = ""; 
$timestamp = "";
$error_msg = "";
 
 //get variables from iphone data
 foreach ($obj as $Field) {
	$usercode = $Field["usercode"];
	$first_name = $Field["first_name"];
	$last_name = $Field["last_name"];
	$phone_number = $Field["phone_number"];
	$timestamp = $Field["timestamp"];
 }

//test for missing data 
if (!empty($usercode) && !empty($first_name) && !empty($last_name) 
	&& !empty($phone_number) && !empty($timestamp) {
	
	//Set up database connection
	$conn = mysql_connect($path, $username, $password) or die(mysql_error());
	$db = mysql_select_db($db_name, $conn) or die(mysql_error());
	
	//query database for duplicate codes or error
	$sql_query_existing = sprintf("SELECT * FROM usercodes WHERE usercode = '%s'", mysql_real_escape_string($usercode));
	$existing_rows = mysql_query($sql_query_existing) or die ("E02");
	$resulting_rows = mysql_num_rows($existing_rows);
	
	//test for duplicate code
	if ($resulting_rows > 0) {
		//duplicate exists
		echo "E04"
		
		} else {
		//place code in database
		$sql_query_insert = sprintf("INSERT INTO usercodes 
		(usercode, first_name, last_name, phone_number, timestamp) 
		VALUES ('%s','%s','%s','%s','%s',)", 
		mysql_real_escape_string($usercode)
		mysql_real_escape_string($first_name)
		mysql_real_escape_string($last_name)
		mysql_real_escape_string($phone_number)
		mysql_real_escape_string($timestamp));
		$response = mysql_query($sql_query_insert) or die ("E03");
	
	//close db connection
	mysql_close($conn);
	
	} 
	
	} else (
	//say what data is missing
	if ((empty($usercode) { echo "E05"};
	if ((empty($first_name) { echo "E06"};
	if ((empty($last_name) { echo "E07"};
	if ((empty($email) { echo "E08"};
	if ((empty($phone_number) { echo "E09"};
	if ((empty($timestamp) { echo "E10"};
	
	}
	
?>