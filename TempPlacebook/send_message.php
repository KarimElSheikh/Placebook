<?php
include_once 'includes/functions.php';
include_once 'includes/db_connect.php';
sec_session_start();

if(!isset($_GET["message"])) {
	header('Location: ./message.php?email='.$_GET["email"]);
}
$msg = $_GET["message"];
$fromEmail = $_SESSION["email"];
$toEmail = $_GET["email"];

$stmt = $mysqli->prepare("CALL send_message(?, ?, ?)");
        $stmt->bind_param('sss', $msg, $fromEmail, $toEmail);
		$stmt->execute();    
		header('Location: ./message.php?email='.$toEmail);
?>