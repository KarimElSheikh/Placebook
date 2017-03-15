<?php
include "header.php";
?>
<div class = "row">
	<div class="col-sm-6">
		<div class="place-box">
			<div class="well well-lg">
				<div class="subHeaderLabel">Friends</div>
				
<?php
$stmt = $mysqli->prepare("CALL view_friends(?)");
        $stmt->bind_param('s', $_SESSION["email"]);
		$stmt->execute();    
        $stmt->store_result();
		$stmt->bind_result($fname,$lname,$email);
if (!($stmt->num_rows()) > 0 ) { ?>
<div class="alert alert-danger wrap-msg"><strong>No Friends :(</strong></div>
<?php }		
while ($stmt->fetch()) {
?>
<div>
	<a href="user.php?email=<?php echo $email;?>"><h3><?php echo $fname.' '.$lname;?></h3></a>
</div>
	
<?php
}
?>
			</div>
		</div>
	</div>
	<div class="col-sm-6">
		<div class="place-box">
			<div class="well well-lg">
				<div class="subHeaderLabel">Requests</div>
<?php
$stmt->close();
$stmt = $mysqli->prepare("CALL view_pending_incoming_requests(?)");
        $stmt->bind_param('s', $_SESSION["email"]);
		$stmt->execute();    
        $stmt->store_result();
		$stmt->bind_result($email,$fname,$lname);

if (!($stmt->num_rows()) > 0 ) { ?>
<div class="alert alert-danger wrap-msg"><strong>No Requests :(</strong></div>
<?php }	

while ($stmt->fetch()) {
?>
<div>
	<a href="user.php?email=<?php echo $email;?>" ><h3><?php echo $fname.' '.$lname;?></h3></a>
</div>
<?php
}
?>
			</div>
		</div>
	</div>
</div>
<?php
include "footer.php";
?>	