<?php
	 //reference to master db connection data
	require_once('DBinfo.php');
	
	//if iphone requests a code then generate and return
	$t=time() % (sqrt(time()));
	$ran= rand(0,10000000) * $t;
	$mdun = md5($ran);
	for($i=0; $i<10; $i++) { $mdun = str_shuffle($mdun); }
	$mdun = substr($mdun,0,20);
	
	//Set up database connection
	$conn = mysql_connect($path, $username, $password) or die(mysql_error());
	$db = mysql_select_db($db_name, $conn) or die(mysql_error());
	
	//query database for duplicate codes or error
	$sql = "SELECT * FROM usercodes WHERE usercode = '$mdun'";
	$result = mysql_query($sql) or die(mysql_error());
	$num = mysql_num_rows($result);
	
	//test for duplicate code
	if ($num > 0) {
		echo "E04";
	} else {
		echo $mdun;
	} 

	mysql_close($conn);

?>