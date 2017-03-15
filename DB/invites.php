<?php
include "header.php";
if(isset($_GET["action"]) && isset($_GET["id"]) && isset($_GET["email"])) {
	if($_GET["action"] == "accept") {
		$stmt = $mysqli->prepare("call accept_invitation(?, ?)");
        $stmt->bind_param('ss', $_SESSION["email"], $_GET["id"]);
		$stmt->execute();    	
		$stmt->close();
	} else if ($_GET["action"] == "reject") {
		$stmt = $mysqli->prepare("call reject_invitation(?, ?, ?)");
        $stmt->bind_param('sss', $_GET["email"], $_SESSION["email"], $_GET["id"]);
		$stmt->execute();    	
		$stmt->close();
	}
}
?>

<div class = "row">
	<div class="col-sm-12">
		<div class="place-well">
			<div class="well well-lg">
				<div class="subHeaderLabel">Invitations</div>
				
<?php
$stmt = $mysqli->prepare("CALL view_invites(?)");
        $stmt->bind_param('s', $_SESSION["email"]);
		$stmt->execute();    
        $stmt->store_result();
		$stmt->bind_result($admin1,$pid,$name,$fname,$lname);
if (!($stmt->num_rows()) > 0 ) { ?>
<div class="alert alert-danger wrap-msg"><strong>No Invitations :(</strong></div>
<?php }		
while ($stmt->fetch()) {
?>
<div class="row">
<div class="col-sm-8">
	<a href="place.php?id=<?php echo $pid;?>" ><h3><?php echo $fname.' '.$lname.' for '.$name;?></h3></a>
</div>
<div class="col-sm-2">
	<a href="invites.php?action=accept&id=<?php echo $pid;?>&email=<?php echo $admin1;?>" class="btn btn-success" style="width: 80%; margin-top:15px;"><span class="fa fa-check"></span> Accept</a>
</div>
<div class="col-sm-2">
	<a href="invites.php?action=reject&id=<?php echo $pid;?>&email=<?php echo $admin1;?>" class="btn btn-danger" style="width: 80%; margin-top:15px;"><span class="fa fa-close"></span> Reject</a>
</div>
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