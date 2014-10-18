//script to generate a unique code
<?php


require_once('DBinfo.php');

//incoming code from iphone, deserialize and test for duplicate in database
$json = file_get_contents('php://input');
$obj = json_decode($json);
 //use foreach loop

//test
if ((!empty(json_decode($_POST["userCode"])) && (!empty












?>