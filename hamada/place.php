<?php
include "header.php";
if(!isset($_GET["id"])){
	header('Location: ./');
}
$id = $_GET["id"];
$email = $_SESSION["email"];
$admin = 0;
$liked = 0;
$visited = 0;
$stmt = $mysqli->prepare("SELECT * 
						FROM manage_place
						WHERE pid = ? and email= ?");
        $stmt->bind_param('is', $id, $email);
        $stmt->execute();    
        $stmt->store_result();
if ($stmt->num_rows > 0) {
		$admin = 1;
}
$stmt = $mysqli->prepare("SELECT * 
						FROM visited
						WHERE member_email = ? and pid = ?");
        $stmt->bind_param('si', $email, $id);
        $stmt->execute();    
        $stmt->store_result();
        $stmt->fetch();
if ($stmt->num_rows > 0) {
		$visited = 1;
}
$stmt = $mysqli->prepare("SELECT * 
						FROM member_liked
						WHERE member_email = ? and pid = ?");
        $stmt->bind_param('si', $email, $id);
        $stmt->execute();    
        $stmt->store_result();
        $stmt->fetch();
if ($stmt->num_rows > 0) {
		$liked = 1;
}
$information = $mysqli->query("CALL view_information(".$id.")");
foreach ($information as $info) {
	$data = $info;
}
$information->close();
$mysqli->close();
$mysqli = new mysqli(HOST, USER, PASSWORD, DATABASE);
$stmt = $mysqli->prepare("SELECT image_file 
						FROM professional_picture
						Where email = ? and pid = ?
						Order By number Desc
						Limit 1");
        $stmt->bind_param('si', $email, $id);
        $stmt->execute();    
        $stmt->store_result();
		$stmt->bind_result($imagefile);
        $stmt->fetch();
if($data["type"] == "Hotel") { 
	$stmt = $mysqli->prepare("SELECT type, price 
						FROM room
						Where pid = ?");
        $stmt->bind_param('i', $id);
        $stmt->execute();    
        $stmt->store_result();
		$stmt->bind_result($roomtype, $roomprice);
        $stmt->fetch();
}
$stmt = $mysqli->prepare("CALL avg_rating(?)");
        $stmt->bind_param('i', $id);
        $stmt->execute();    
        $stmt->store_result();
		$stmt->bind_result($avgratevalue);
        $stmt->fetch();

?>
<div class="row well well-lg place-well">
		<div class="col-sm-8 subHeaderLabel"><?php echo $data["name"];?></div>
		<?php if($visited == 0) { ?>
		<div class="col-sm-2"><a class="btn btn-default disabled" style ="width: 80%; margin-top: 18px;"><span class="fa fa-thumbs-up"></span> Like</a></div>
		<div class="col-sm-2"><a href="./placeAction.php?action=visit&id=<?php echo $id;?>" class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa fa-question"></span> Visited</a></div>
		<?php } else if ($liked == 0) {?> 
		<div class="col-sm-2"><a href="./placeAction.php?action=like&id=<?php echo $id;?>" class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa fa-thumbs-up"></span> Like</a></div>
		<div class="col-sm-2"><a class="btn btn-success" style ="width: 80%; margin-top: 18px;"><span class="fa fa-check"></span> Visited</a></div>	
		<?php } else { ?>
		<div class="col-sm-2"><a class="btn btn-success" style ="width: 80%; margin-top: 18px;"><span class="fa fa-check"></span> Liked</a></div>
		<div class="col-sm-2"><a class="btn btn-success" style ="width: 80%; margin-top: 18px;"><span class="fa fa-check"></span> Visited</a></div>
		<?php } ?>
</div>'
<?php if($admin == 1) { ?>
<div class="row well well-lg place-well">
		<div class="col-sm-2 subHeaderLabel">Controls</div>
		<div class="col-sm-2"><a class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false" style ="width: 80%; margin-top: 18px;"><span class="fa fa-close"></span> Delete</a>
		<ul class="dropdown-menu" role="menu">
			<li><a href="./adminAction.php?action=Delete&id=<?php echo $id;?>">Sure?</a></li>
		</ul>
		</div>
		<div class="col-sm-2"><a href="./adminAction.php?action=delete&id=<?php echo $id;?>" class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa fa-plus"></span> Invite</a></div>
		<div class="col-sm-2"><a href="./adminAction.php?action=update&id=<?php echo $id;?>" class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa fa-refresh"></span> Update</a></div>
		<div class="col-sm-4"><a href="./adminAction.php?action=upload&id=<?php echo $id;?>" class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa fa-image"></span> Upload Photo</a></div>
</div>
<?php } ?>
<div class = "row">
	<div class="col-sm-6">
		<div class="place-box">
			<div class="well well-lg">
			<img src="images/<?php echo $imagefile;?>" alt="<?php echo $data["name"];?>" width="100%" height="375">
			</div>
		</div>
	</div>
	<div class="col-sm-6">
		<div class="place-box">
			<div class="well well-lg">
				<iframe width="100%" height="350" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" 
					src="https://maps.google.com/maps?ie=UTF8&amp;ll=<?php echo $data["longitude"].",".$data["latitude"];?>&amp;spn=0.07975,0.169086&amp;t=m&amp;z=13&amp;output=embed">
				</iframe>
				<br />
				<small><a href="https://maps.google.com/maps?ie=UTF8&amp;ll=<?php echo $data["longitude"].",".$data["latitude"];?>&amp;spn=0.07975,0.169086&amp;t=m&amp;z=13&amp;source=embed" 
					style="color:#0000FF;text-align:left">View Larger Map</a>
				</small>
			</div>
		</div>
	</div>
</div>
<?php if($data["type"] == "Hotel") { 
$stmt = $mysqli->prepare("SELECT type, price 
						FROM room
						Where pid = ?");
        $stmt->bind_param('i', $id);
        $stmt->execute();    
        $stmt->store_result();
		$stmt->bind_result($roomtype, $roomprice);

?>
<div class="row well well-lg place-well">
	<div class="row">
		<div class="col-sm-2"><strong><span class="fa fa-building"></span> Building Date</strong></div>
		<div class="col-sm-2"><strong><span class="fa fa-dollar"></span> Room types and prices</strong></div>
		<div class="col-sm-3"><strong><span class="fa fa-info"></span> Information</strong></div>
	</div>
	<br>
	<div class="row">
		<div class="col-sm-2"><?php echo $data["building_date"]; ?></div>
		<div class="col-sm-2">
			<?php while($stmt->fetch()) {
				 echo $roomtype.": "."<span class='fa fa-dollar'></span>".$roomprice."<br>";
			} ?>
		</div>
		<div class="col-sm-3"><?php echo $data["text"]; ?></div>
	</div>
</div>
<?php } else if($data["type"] == "Restaurant") { ?>
<div class="row well well-lg place-well">
	<div class="row">
		<div class="col-sm-2"><strong><span class="glyphicon glyphicon-cutlery"></span> Building Date</strong></div>
		<div class="col-sm-2"><strong><span class="glyphicon glyphicon-cutlery"></span> Style</strong></div>
		<div class="col-sm-2"><strong><span class="glyphicon glyphicon-cutlery"></span> Cuisine</strong></div>
		<div class="col-sm-2"><strong><span class="fa fa-info"></span> Information</strong></div>
	</div>
	<br>
	<div class="row">
		<div class="col-sm-2"><?php echo $data["building_date"]; ?></div>
		<div class="col-sm-2"><?php echo $data["style"]; ?></div>
		<div class="col-sm-2"><?php echo $data["cuisine"]; ?></div>
		<div class="col-sm-3"><?php echo $data["text"]; ?></div>
	</div>
</div>
<?php } else if($data["type"] == "Museum") { ?>
<div class="row well well-lg place-well">
	<div class="row">
		<div class="col-sm-2"><strong><span class="fa fa-institution"></span> Building Date</strong></div>
		<div class="col-sm-2"><strong><span class="fa fa-clock-o"></span> Opening hours</strong></div>
		<div class="col-sm-2"><strong><span class="fa fa-clock-o"></span> Closing hours</strong></div>
		<div class="col-sm-2"><strong><span class="fa fa-dollar"></span> Ticket price</strong></div>
		<div class="col-sm-2"><strong><span class="fa fa-info"></span> Information</strong></div>
	</div>
	<br>
	<div class="row">
		<div class="col-sm-2"><?php echo $data["building_date"]; ?></div>
		<div class="col-sm-2"><?php echo $data["openinghours"]; ?></div>
		<div class="col-sm-2"><?php echo $data["closinghours"]; ?></div>
		<div class="col-sm-2"><?php echo $data["ticketprice"]; ?></div>
		<div class="col-sm-3"><?php echo $data["text"]; ?></div>
	</div>
</div>
<?php } else if($data["type"] == "Monument") { ?>
<div class="row well well-lg place-well">
	<div class="row">
		<div class="col-sm-2"><strong><span class="glyphicon glyphicon-tower"></span> Building Date</strong></div>
		<div class="col-sm-2"><strong><span class="fa fa-file-text"></span> Description</strong></div>
		<div class="col-sm-2"><strong><span class="fa fa-info"></span> Information</strong></div>
	</div>
	<br>
	<div class="row">
		<div class="col-sm-2"><?php echo $data["building_date"]; ?></div>
		<div class="col-sm-2"><?php echo $data["description"]; ?></div>
		<div class="col-sm-3"><?php echo $data["text"]; ?></div>
	</div>
</div>
<?php } else if($data["type"] == "City") { ?>
<div class="row well well-lg place-well">
	<div class="row">
		<div class="col-sm-2"><strong><span class="glyphicon glyphicon-flag"></span> Building Date</strong></div>
		<div class="col-sm-2"><strong><span class="fa fa-crosshairs"></span> Location</strong></div>
		<div class="col-sm-2"><strong><span class="fa fa-globe"></span> Coastal</strong></div>
		<div class="col-sm-2"><strong><span class="fa fa-info"></span> Information</strong></div>
	</div>
	<br>
	<div class="row">
		<div class="col-sm-2"><?php echo $data["building_date"]; ?></div>
		<div class="col-sm-2"><?php echo $data["location"]; ?></div>
		<div class="col-sm-2">
		<?php if($data["coastalcity"] == 0 ) echo "No"; else echo "Yes" ;?>
		</div>
		<div class="col-sm-3"><?php echo $data["text"]; ?></div>
	</div>
</div>
<?php } else { ?>
<div class="row well well-lg place-well">
	<div class="row">
		<div class="col-sm-2"><strong><span class="fa fa-building"></span> Building Date</strong></div>
		<div class="col-sm-2"><strong><span class="fa fa-info"></span> Information</strong></div>
	</div>
	<br>
	<div class="row">
		<div class="col-sm-2"><?php echo $data["building_date"]; ?></div>
		<div class="col-sm-3"><?php echo $data["text"]; ?></div>
	</div>
</div>
<?php } ?> 
<div class="row">
	<div class="col-sm-6">
	<div class="well well-lg place-box">
		<h1 class = "subHeaderLabel">Overall Rating: <?php echo round($avgratevalue, 1); ?></h1>
		<div class="rating-stars-lg">
		<?php
		if($avgratevalue < 1.5) {
			echo '<span class="fa fa-star"></span>';
		}
		else if ($avgratevalue < 2) {
			echo '<span class="fa fa-star"></span><span class="fa fa-star-half"></span>';
		}
		else if ($avgratevalue < 2.5) {
			echo '<span class="fa fa-star"></span><span class="fa fa-star"></span>';
		}
		else if ($avgratevalue < 3) {
			echo '<span class="fa fa-star"></span><span class="fa fa-star"></span><span class="fa fa-star-half"></span>';
		}
		else if ($avgratevalue < 3.5) {
			echo '<span class="fa fa-star"></span><span class="fa fa-star"></span><span class="fa fa-star"></span>';
		}
		else if ($avgratevalue < 4) {
			echo '<span class="fa fa-star"></span><span class="fa fa-star"></span><span class="fa fa-star"></span></span><span class="fa fa-star-half"></span>';
		}
		else if ($avgratevalue < 4.5) {
			echo '<span class="fa fa-star"></span><span class="fa fa-star"></span><span class="fa fa-star"></span></span><span class="fa fa-star"></span>';
		}
		else if ($avgratevalue < 5) {
			echo '<span class="fa fa-star"></span><span class="fa fa-star"></span><span class="fa fa-star"></span></span><span class="fa fa-star"></span><span class="fa fa-star-half"></span>';
		}
		else {
			echo '<span class="fa fa-star"></span><span class="fa fa-star"></span><span class="fa fa-star"></span></span><span class="fa fa-star"></span><span class="fa fa-star"></span>';
		}
		?>
		</div>
	</div>
	</div>
	<div class="col-sm-6">
	<div class="well well-lg place-box">
	<?php
	$mysqli->close();
	$mysqli = new mysqli(HOST, USER, PASSWORD, DATABASE);
	$stmt = $mysqli->prepare("CALL view_rating_criterias_of_a_page(?)");
        $stmt->bind_param('i', $id);
        $stmt->execute();    
        $stmt->store_result();
		$stmt->bind_result($cname, $cmfname, $cmlname, $cmemail);
	while($stmt->fetch()) { ?>
		<div class = "row">
			<div class="col-sm-4">
				<div class="subHeaderLabel-sm"><?php echo $cname; ?></div>
			</div>
			<div class="col-sm-4 rating-stars-lg">
				<p><span class="fa fa-star"><span class="fa fa-star"><span class="fa fa-star"><span class="fa fa-star"><span class="fa fa-star"></span></span></span></span></span></p>
			</div>
			<div class="col-sm-4">
				<?php if($admin == 1) { ?>
				<a href="#" class="pull-right btn btn-danger">Remove</a>
				<?php } ?>
			</div>			
		</div>
	<?php } ?>
	</div>
	</div>
</div>
<?php
include "footer.php";
?>