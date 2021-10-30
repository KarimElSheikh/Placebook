<!DOCTYPE html>
<?php
include "header.php";
$email=$_SESSION['email'];
?>
<div class="row well well-lg">
	<div class="col-sm-2 subHeaderLabel">Explore</div>
	<div class="col-sm-2 subHeaderB"><a href="restaurant.php" data-toggle="tooltip" data-placement="top" title="Restaurants"><span class="glyphicon glyphicon-cutlery"></span></a></div>
	<div class="col-sm-2 subHeaderFa"><a href="hotel.php" data-toggle="tooltip" data-placement="top" title="Hotels"><span class="fa fa-building"></span></a></div>
	<div class="col-sm-2 subHeaderFa"><a href="museum.php" data-toggle="tooltip" data-placement="top" title="Museums"><span class="fa fa-institution"></span></a></div>
	<div class="col-sm-2 subHeaderB"><a href="monument.php" data-toggle="tooltip" data-placement="top" title="Monuments"><span class="glyphicon glyphicon-tower"></span></a></div>
	<div class="col-sm-2 subHeaderB"><a href="city.php" data-toggle="tooltip" data-placement="top" title="Cities"><span class="glyphicon glyphicon-flag"></span></a></div>
</div>
<br>
<div class="row well well-lg">
	<div class="col-md-12 subHeaderLabel">Recommended Places</div>
	<?php
	$sql = "call get_recommended_places(?)";
	$stmt = $mysqli->prepare($sql);
	if($stmt)
	{
		$stmt->bind_param('s', $email);
		$stmt->execute();
		$stmt->store_result();
		$stmt->bind_result($pid,$name,$overall_rating);
		
		while ($stmt->fetch()) {
		?>
			<div class="row well-sm">
				<a href="place.php?id=<?php echo $pid;?>" class="HIco" style="margin-left: 36px"><?php echo "$name";?></a>
			</div>
		<?php
		}
	}
	?>
</div>
<br>
<div class="row well well-lg">
	<div class="col-sm-12 subHeaderLabel">Similar Users</div>
	<?php
	$stmt->close();
	$sql = "call get_top_10_common(?)";
	$stmt = $mysqli->prepare($sql);
	
	if($stmt)
	{
		$stmt->bind_param('s', $email);
		$stmt->execute();
		$stmt->store_result();
		$stmt->bind_result($member_email,$firstname,$lastname,$likes);
		
		while ($stmt->fetch()) {
		?>
			<div class="row well-sm">
				<a href="user.php?email=<?php echo $member_email;?>" class="HIco" style="margin-left: 36px"><?php echo "$firstname $lastname";?></a>
			</div>
		<?php
		}
	}
	?>
</div>
<?php
include "footer.php";
?>