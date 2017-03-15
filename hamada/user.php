<?php
include "header.php";
?>
<?php 
if(!isset($_GET["email"])){
	$targetEmail = $_SESSION["email"];
} else {
	$targetEmail = $_GET["email"];
}
$accept = 0;
$stmt = $mysqli->prepare("SELECT firstname,lastname,address,nationality
						FROM member 
						WHERE email = ? 
						LIMIT 1");
        $stmt->bind_param('s', $targetEmail);
        $stmt->execute();    
        $stmt->store_result();
		$stmt->bind_result($fname,$lname,$addr,$nat);
        $stmt->fetch();
if (!($stmt->num_rows == 1)) {
		header('Location: ./user.php');
}
$loggedIn = $targetEmail == $_SESSION["email"];
$notFriend = 0;
if(!$loggedIn) {
	$stmt = $mysqli->prepare("SELECT accept, sender_email,  reciever_email
							FROM add_friend 
							WHERE sender_email = ? and reciever_email = ?
							Union
							Select accept, sender_email,  reciever_email
							FROM add_friend 
							WHERE sender_email = ? and reciever_email = ?
							LIMIT 1");
			$stmt->bind_param('ssss', $_SESSION["email"], $targetEmail, $targetEmail, $_SESSION["email"]);  
			$stmt->execute();  
			$stmt->store_result();
			$stmt->bind_result($accept, $sender, $rec);
			$stmt->fetch();
	if (!($stmt->num_rows == 1)) {
		$notFriend = 1;
	}
	else {
		if($accept ==  0) {
			if($sender == $_SESSION["email"]) {
				$outgoing = 1;
			}
			else {
				$outgoing = 0;
			}
		}
	}
}
$phoneNos = array();
$stmt = $mysqli->prepare("SELECT phone_numbers
						FROM phone_number
						WHERE email = ?");
    $stmt->bind_param('s', $targetEmail);
    $stmt->execute();    
    $stmt->store_result();
	$stmt->bind_result($phoneNo);
    while ($stmt->fetch()) {
		array_push($phoneNos, $phoneNo);
	}
$o = $targetEmail;
$b = $_SESSION["email"];
?>
<div class="row well well-lg">
	<div class="row">
		<div class="col-sm-6 subHeaderLabel"><p><?php echo $fname." ".$lname; ?></p></div>
		<div class="col-sm-2"><p></p></div>
		<?php if($loggedIn) { ?>
		<div class="col-sm-2"><p></p></div>
		<div class="col-sm-2"><a class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa fa-gears"></span> Settings</a></div>
		<?php } else if ($notFriend == 1) {?>
		<div class="col-sm-2"><a href="friendAction.php<?php action('add', $b, $o) ?>" class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa fa-plus"></span> Add Friend</a></div>
		<div class="col-sm-2"><a class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa fa-comments-o"></span> Message</a></div>
		<?php } else if ($accept == 0) { 
		if ($outgoing == 1) {
		?>
		<div class="col-sm-2"><a class="btn btn-primary" style ="width: 80%; margin-top: 18px;"><span class="fa fa-spinner"></span> Sent</a></div>
		<div class="col-sm-2"><a class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa fa-comments-o"></span> Message</a></div>
		<?php } else { ?>
		<div class="col-sm-2"><a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-expanded="false" style ="width: 80%; margin-top: 18px;"><span class="fa fa-spinner"></span> Respond</span></a>
		<ul class="dropdown-menu" role="menu">
			<li><a href="friendAction.php<?php action('accept', $b, $o) ?>">Accept</a></li>
			<li><a href="friendAction.php<?php action('reject', $b, $o) ?>">Reject</a></li>
		</ul>
		</div>
		<div class="col-sm-2"><a class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa fa-comments-o"></span> Message</a></div>
		<?php } ?>
		<?php } else { ?>
		<div class="col-sm-2"><a class="btn btn-success dropdown-toggle" data-toggle="dropdown" aria-expanded="false" style ="width: 80%; margin-top: 18px;"><span class="fa fa-check fa-inverted"></span> Friend</span></a>
		<ul class="dropdown-menu" role="menu">
			<li><a href="friendAction.php<?php action('unfriend', $b, $o) ?>">Unfriend</a></li>
		</ul>
		</div>
		<div class="col-sm-2"><a class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa fa-comments-o"></span> Message</a></div>
		<?php } ?>
	</div>
	<br>
<?php if(($notFriend == 0 && $accept == 1) || $loggedIn) { ?>
	<div class="row">
		<div class="col-sm-3"><strong><span class="fa fa-envelope"></span> Email</strong></div>
		<div class="col-sm-3"><strong><span class="fa fa-flag"></span> Nationality</strong></div>
		<div class="col-sm-3"><strong><span class="fa fa-home"></span> Address</strong></div>
		<div class="col-sm-3"><strong><span class="fa fa-phone"></span> Phone number(s)</strong></div>
	</div>
	<br>
	<div class="row">
		<div class="col-sm-3"><?php echo $targetEmail; ?></div>
		<div class="col-sm-3"><?php echo $nat; ?></div>
		<div class="col-sm-3"><?php echo $addr; ?></div>
		<div class="col-sm-3">
			<?php foreach ($phoneNos as $no) { 
				echo $no."<br>";
			} ?>
		</div>
	</div>
<?php } ?>
</div>
<?php if(($notFriend == 0 && $accept == 1) || $loggedIn) { ?>
<div class="row well well-lg">
	<div class="col-sm-12 subHeaderLabel">Likes</div>
</div>
<div class="row well well-lg">
	<div class="col-sm-12 subHeaderLabel">Visited</div>
</div>
<?php } ?>
<?php
include "footer.php";
?>	