<?php
include_once "header.php";
?>
<div class="well well-lg wrap-msg">
	<div class ="row">
		<div class = "col-sm-6">
			<div class="subHeaderLabel">Restaurants</div>
		</div>
		<div class = "col-sm-2">
		</div>
		<div class="col-sm-2"><a href ="restaurant.php" class="btn btn-primary" style ="width: 80%; margin-top: 18px;"><span class="fa fa-thumbs-up"></span> Likes</a></div>
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
			<li><a href="restaurant.php?sort=2&cname=<?php echo $cname;?>"><?php echo $cname;?></a></li>
			<?php }} $stmt->close(); ?>
		</ul>
		</div>
	</div>
		
<?php 
	if(!isset($_GET["sort"])) {
	$sql = "call get_restaurant_with_most_likes()";
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

$sql = "call view_restaurants_according_to_rating_criteria(?)";
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
}
?>
</div>
<?php
include "footer.php";
?>	


	