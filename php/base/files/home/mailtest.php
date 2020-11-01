<?php

ini_set('display_errors', 1);
error_reporting(E_ALL);

$to = "recipient@somewhere.com";
$subject = "PHP sendmail test script";
$message = "This is a test to check the PHP sendmail functionality";

$headers = "";
$headers .= "From: Druid <noreply@druid.fi> \r\n";
$headers .= "X-Mailer: PHP/" . phpversion();
$headers .= 'MIME-Version: 1.0' . "\r\n";
$headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";

mail($to, $subject, $message, $headers);

echo "Test email sent\n\n";
