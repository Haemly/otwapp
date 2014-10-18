<!--for generating 20 character alphanumeric codes-->
<?php
echo "test";
//reference to master db connection data
	require_once('DBinfo.php');
	
	//if iphone requests a code then generate and return
	$t=time() % (sqrt(time()));
	$ran= rand(0,10000000) * $t;
	$mdun = md5($ran);
	for($i=0; $i<10; $i++) { $mdun = str_shuffle($mdun); }
	$mdun = substr($mdun,0,20);
	
	$conn = mysql_connect("$db_name","$username","$password");
	msyql_select_db("$db_name", $conn ) or die("E01"); 
	
	//query database for duplicate codes or error
	$sql_query_existing = sprintf("SELECT * FROM usercodes WHERE usercode = '%s'", mysql_real_escape_string($mdun));
	$existing_rows = mysql_query($sql_query_existing) or die ("E02");
	$resulting_rows = mysql_num_rows($existing_rows);
	
	//test for duplicate code
	if ($resulting_rows > 0) {
		echo "E04";

	} else {
	echo $mdun;
	}





?>