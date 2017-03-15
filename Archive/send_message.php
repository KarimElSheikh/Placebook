<?php
include_once 'includes/functions.php';
include_once 'includes/db_connect.php';
sec_session_start();

if(!isset($_POST["message"])) {
	header('Location: ./message.php?email='.$_POST["email"]);
}
$msg = $_POST["message"];
$fromEmail = $_SESSION["email"];
$toEmail = $_POST["email"];

$stmt = $mysqli->prepare("CALL send_message(?, ?, ?)");
        $stmt->bind_param('sss', $msg, $fromEmail, $toEmail);
		$stmt->execute();    
		header('Location: ./message.php?email='.$toEmail);
?>