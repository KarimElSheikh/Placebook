<?php
include_once "header.php";
?>
<div class="well well-lg wrap-msg" style="width: 1300px;">
	<div class ="row">
		<div class = "col-sm-6">
			<div class="subHeaderLabel">Monuments</div>
		</div>
		<div class = "col-sm-1">
		</div>
		<?php 
		if(!isset($_GET["sort"])) {
		?>
		<div class="col-sm-2"><a href ="monument.php" class="btn btn-success" style ="width: 80%; margin-top: 18px;"><span class="fa fa-thumbs-up"></span> Sorted by Likes</a></div>
		<div class="col-sm-3"><a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-expanded="false" style ="width: 80%; margin-top: 18px;"><span class="fa fa-star"></span> Sort by Criteria</a>
		<?php
		} else {
		?>
		<div class="col-sm-2"><a href ="monument.php" class="btn btn-primary" style ="width: 80%; margin-top: 18px;"><span class="fa fa-thumbs-up"></span> Sort by Likes</a></div>
		<div class="col-sm-3"><a class="btn btn-success dropdown-toggle" data-toggle="dropdown" aria-expanded="false" style ="width: 80%; margin-top: 18px;"><span class="fa fa-star"></span> Sorted by <?php echo $_GET["cname"];?></a>
		<?php
		}
		?>
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
			<li><a href="monument.php?sort=2&cname=<?php echo utf8_encode($cname);?>"><?php echo utf8_encode($cname);?></a></li>
			<?php }} $stmt->close(); ?>
		</ul>
		</div>
	</div>
		
<?php 
	if(!isset($_GET["sort"])) {
	$sql = "call get_monuments_sorted_by_likes()";
	$stmt = $mysqli->prepare($sql);
	if($stmt)
	{
		$stmt->execute();
	 	$stmt->store_result();
		$stmt->bind_result($pid, $name, $num_likes);

	while ($stmt->fetch()) {
?>	<div class="row">
		<div class ="col-sm-6"><h3><a href="place.php?id=<?php echo $pid;?>"><?php echo utf8_encode($name);?></a></h3></div>
		<div class ="col-sm-1"></div>
		<div class ="col-sm-5"><h3>Likes: <?php echo round($num_likes, 2);?></h3></div>
	</div>
<?php
}
}
} else if ($_GET["sort"] == 2) { 
$cname = $_GET["cname"];
$sql = "call view_monuments_according_to_rating_criteria(?)";
	$stmt = $mysqli->prepare($sql);
	$stmt->bind_param('s', $cname);
	if($stmt)
	{
		$stmt->execute();
	 	$stmt->store_result();
		$stmt->bind_result($pid, $name, $avg);

	while ($stmt->fetch()) {
?>	<div class="row">
		<div class ="col-sm-6"><h3><a href="place.php?id=<?php echo $pid;?>"><?php echo utf8_encode($name);?></a></h3></div>
		<div class ="col-sm-1"></div>
		<div class ="col-sm-5"><h3><?php echo utf8_encode($cname).": ".round($avg, 2);?></h3></div>
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


	