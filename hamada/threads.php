<?php
include "header.php";

$stmt = $mysqli->prepare("CALL view_threads(?)");
        $stmt->bind_param('s', $_SESSION["email"]);
		$stmt->execute();    
        $stmt->store_result();
		$stmt->bind_result($fname,$lname,$email);
if (!($stmt->num_rows()) > 0 ) { ?>
<div class="alert alert-danger wrap-msg"><strong>No threads yet.</strong></div>
<?php }		
while ($stmt->fetch()) {
?>
<div class="well well-lg wrap-msg">
	<div><a href="message.php?email=<?php echo $email;?>" class="HIco"><?php echo $fname.' '.$lname;?></a></div>
</div>
<?php
}

include "footer.php";
?>	