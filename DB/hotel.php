<?php
include_once"header.php";
?>
<div class="well well-lg wrap-msg">
	<div class ="row">
		<div class = "col-sm-6">
			<div class="subHeaderLabel">Hotels</div>
		</div>
		<div class="col-sm-2"><a href ="hotel.php" class="btn btn-primary" style ="width: 80%; margin-top: 18px;"><span class="fa fa-thumbs-up"></span> Likes</a></div>
		<div class="col-sm-2"><a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-expanded="false" style ="width: 80%; margin-top: 18px;"><span class="fa fa-star"></span> Criteria</a>
		<ul class="dropdown-menu" role="menu">
			<?php
				$sql = "Select Distinct criteria_name
						From rating_criteria";
				$stmt = $mysqli->prepare($sql);
				if($stmt)
				{
					$stmt->execute();
					$stmt->store_result();
					$stmt->bind_result($cname);
					while ($stmt->fetch()) { ?>
			<li><a href="hotel.php?sort=2&cname=<?php echo $cname;?>"><?php echo $cname;?></a></li>
			<?php }} $stmt->close(); ?>
		</ul>
		</div>
		<div class="col-sm-2"><a href ="hotel.php?sort=3" class="btn btn-primary" style ="width: 80%; margin-top: 18px;"><span class="fa fa-dollar"></span> Prices</a></div>
	</div>
		
<?php 
	if(!isset($_GET["sort"])) {
	$sql = "call get_hotel_with_most_likes()";
	$stmt = $mysqli->prepare($sql);
	if($stmt)
	{
		$stmt->execute();
	 	$stmt->store_result();
		$stmt->bind_result($pid,$name);

	while ($stmt->fetch()) {
?>	<div class="row">
		<div class ="col-sm-12"><h3><a href="place.php?id=<?php echo $pid;?>"><?php echo $name;?></a></h3></div>
	</div>
<?php
}
}
} else if ($_GET["sort"] == 2) { 

$sql = "call view_hotels_according_to_rating_criteria(?)";
	$stmt = $mysqli->prepare($sql);
	$stmt->bind_param('s', $_GET["cname"]);
	if($stmt)
	{
		$stmt->execute();
	 	$stmt->store_result();
		$stmt->bind_result($pid,$name,$avg);

	while ($stmt->fetch()) {
?>	<div class="row">
		<div class ="col-sm-12"><h3><a href="place.php?id=<?php echo $pid;?>"><?php echo $name;?></a></h3></div>
	</div>
<?php

}
}
}  else if ($_GET["sort"] == 3) {
	
$sql = "call get_hotels_sort_by_avg_room_price()";
	$stmt = $mysqli->prepare($sql);
	if($stmt)
	{
		$stmt->execute();
	 	$stmt->store_result();
		$stmt->bind_result($pid,$name,$price);

	while ($stmt->fetch()) {
	?>	<div class="row">
		<div class ="col-sm-12"><h3><a href="place.php?id=<?php echo $pid;?>"><?php echo $name;?></a></h3></div>
	</div>
<?php

}
}
}
?>
</div>
<?php
include "footer.php";
?>