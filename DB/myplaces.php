<?php
include "header.php";

?>
<div class = "row">
	<div class="col-sm-12">
		<div class="place-well">
			<div class="well well-lg">
				<div class="subHeaderLabel">My Places</div>
<?php 
$stmt = $mysqli->prepare("CALL view_places_managed_by_member(?)");
        $stmt->bind_param('s', $_SESSION["email"]);
		$stmt->execute();    
        $stmt->store_result();
		$stmt->bind_result($pid,$name);
if (!($stmt->num_rows()) > 0 ) { ?>
<div class="alert alert-danger wrap-msg"><strong>No places yet :(</strong></div>
<?php }		
while ($stmt->fetch()) {
?>
<div>
	<a href="place.php?id=<?php echo $pid;?>"><h3><?php echo $name;?></h3></a>
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
