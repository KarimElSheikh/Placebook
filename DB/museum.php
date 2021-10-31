<?php
include_once"header.php";
?>
<div class="well well-lg wrap-msg" style="width: 1300px;">
	<div class ="row">
		<div class = "col-sm-5">
			<div class="subHeaderLabel">Museums</div>
		</div>
		<?php 
		if(!isset($_GET["sort"])) {
		?>
		<div class="col-sm-2"><a href ="museum.php" class="btn btn-success" style ="width: 80%; margin-top: 18px;"><span class="fa fa-thumbs-up"></span> Sorted by Likes</a></div>
		<div class="col-sm-3"><a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-expanded="false" style ="width: 80%; margin-top: 18px;"><span class="fa fa-star"></span> Sort by Criteria</a>
		<?php
		} else if ($_GET["sort"] == 2) {
		?>
		<div class="col-sm-2"><a href ="museum.php" class="btn btn-primary" style ="width: 80%; margin-top: 18px;"><span class="fa fa-thumbs-up"></span> Sort by Likes</a></div>
		<div class="col-sm-3"><a class="btn btn-success dropdown-toggle" data-toggle="dropdown" aria-expanded="false" style ="width: 80%; margin-top: 18px;"><span class="fa fa-star"></span> Sorted by <?php echo $_GET["cname"];?></a>
		<?php
		} else {
		?>
		<div class="col-sm-2"><a href ="museum.php" class="btn btn-primary" style ="width: 80%; margin-top: 18px;"><span class="fa fa-thumbs-up"></span> Sort by Likes</a></div>
		<div class="col-sm-3"><a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-expanded="false" style ="width: 80%; margin-top: 18px;"><span class="fa fa-star"></span> Sort by Criteria</a>
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
							<li><a href="museum.php?sort=2&cname=<?php echo $cname;?>"><?php echo utf8_encode($cname);?></a></li>
						<?php }
					}
					$stmt->close();
					?>
			</ul>
		</div>
		<?php 
		if(!isset($_GET["sort"])) {
		?>
		<div class="col-sm-2"><a href ="museum.php?sort=3" class="btn btn-primary" style ="width: 80%; margin-top: 18px;"><span class="fa fa-dollar"></span> Sort by Prices</a></div>
		<?php
		} else if ($_GET["sort"] == 2) {
		?>
		<div class="col-sm-2"><a href ="museum.php?sort=3" class="btn btn-primary" style ="width: 80%; margin-top: 18px;"><span class="fa fa-dollar"></span> Sort by Prices</a></div></a>
		<?php
		} else {
		?>
		<div class="col-sm-2"><a href ="museum.php?sort=3" class="btn btn-success" style ="width: 80%; margin-top: 18px;"><span class="fa fa-dollar"></span> Sorted by Prices</a></div>
		<?php
		}
		?>
	</div>
		
<?php 
	if(!isset($_GET["sort"])) {
	$sql = "call get_museums_sorted_by_likes()";
	$stmt = $mysqli->prepare($sql);
	if($stmt)
	{
		$stmt->execute();
	 	$stmt->store_result();
		$stmt->bind_result($pid, $name, $num_likes);

	while ($stmt->fetch()) {
?>	<div class="row">
		<div class ="col-sm-5"><h3><a href="place.php?id=<?php echo $pid;?>"><?php echo utf8_encode($name);?></a></h3></div>
		<div class ="col-sm-7"><h3>Likes: <?php echo round($num_likes, 2);?></h3></div>
	</div>
<?php
}
}
} else if ($_GET["sort"] == 2) { 
	$cname = $_GET["cname"];
	$sql = "call view_museums_according_to_rating_criteria(?)";
	$stmt = $mysqli->prepare($sql);
	$stmt->bind_param('s', $cname);
	if($stmt)
	{
		$stmt->execute();
	 	$stmt->store_result();
		$stmt->bind_result($pid, $name, $avg);

		while ($stmt->fetch()) {
			?>	<div class="row">
				<div class ="col-sm-5"><h3><a href="place.php?id=<?php echo $pid;?>"><?php echo utf8_encode($name);?></a></h3></div>
				<div class ="col-sm-7"><h3><?php echo utf8_encode($cname).": ".round($avg, 2);?></h3></div>
			</div>
		<?php }
	}
} else if ($_GET["sort"] == 3) {
	
	$sql = "call get_museums_sort_by_ticket_price()";
	$stmt = $mysqli->prepare($sql);
	if($stmt)
	{
		$stmt->execute();
	 	$stmt->store_result();
		$stmt->bind_result($pid, $name, $price);

		while ($stmt->fetch()) {
			?>	<div class="row">
				<div class ="col-sm-5"><h3><a href="place.php?id=<?php echo $pid;?>"><?php echo utf8_encode($name);?></a></h3></div>
				<div class ="col-sm-7"><h3>Ticket price: <?php echo "<span class='fa fa-dollar'></span>".round($price, 2);?></h3></div>
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