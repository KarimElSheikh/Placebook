<?php 
include_once 'includes/functions.php';
include_once 'includes/db_connect.php';
sec_session_start();

$action = $_GET["action"];
$actionBy = $_GET["actionBy"];
$actionOn = $_GET["actionOn"];
if(!isset($_GET["actionBy"]) || !isset($_GET["actionOn"]) || !isset($_GET["action"])) {
	header('Location: ./user.php');
}
if($action == "reject") {
	$stmt = $mysqli->prepare("CALL reject_friend_request(?,?)");
        $stmt->bind_param('ss', $actionOn, $actionBy);
        $stmt->execute();    
        header('Location: ./user.php?email='.$actionOn);
}
else if ($action == "add") {
	$stmt = $mysqli->prepare("CALL send_friendship_request(?,?)");
        $stmt->bind_param('ss', $actionBy, $actionOn);
        $stmt->execute();  
		echo $_GET["action"];
        header('Location: ./user.php?email='.$actionOn);
}
else if ($action == "accept") {
	$stmt = $mysqli->prepare("UPDATE add_friend
							SET accept = 1
							WHERE sender_email = ? and reciever_email = ?");
        $stmt->bind_param('ss', $actionOn, $actionBy);
        $stmt->execute();    
        header('Location: ./user.php?email='.$actionOn);
}
else if ($action == "unfriend"){
	$stmt = $mysqli->prepare("DELETE FROM add_friend
							  WHERE (sender_email = ? and reciever_email = ?) or (sender_email = ? and reciever_email = ?)");
        $stmt->bind_param('ssss', $actionOn, $actionBy, $actionBy, $actionOn);
        $stmt->execute();    
        header('Location: ./user.php?email='.$actionOn);
}
else {
	header('Location: ./user.php?email='.$actionOn);
}