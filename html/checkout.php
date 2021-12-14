<?php
session_start();
require_once dirname(__FILE__).'/omise-php/lib/Omise.php';
define('OMISE_API_VERSION', '2015-11-17');
// define('OMISE_PUBLIC_KEY', 'PUBLIC_KEY');
// define('OMISE_SECRET_KEY', 'SECRET_KEY');
define('OMISE_PUBLIC_KEY', 'pkey_test_5oc5o06hka4mu1fb5b4');
define('OMISE_SECRET_KEY', 'skey_test_5oc5o06hk1dqhmetet6');
$referer = $_SERVER['HTTP_REFERER'];

$charge = OmiseCharge::create(array(
  'amount' => $_POST["amount"],
  'currency' => 'thb',
  'card' => $_POST["omiseToken"]
));

if($charge['status']=='successful'){
	$_SESSION['msg1'] = "Success message";
	header('Location: test.html?msg='.$charge['status']);
	//header("Location: $referer");
}else{
	echo($charge['status']);

print('<pre>');
print_r($charge);
print('</pre>');
}

?> 