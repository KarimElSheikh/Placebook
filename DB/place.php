<?php
include_once 'includes/config.php';
include "header.php";
if(!isset($_GET["id"])){
	header('Location: ./');
}

$id = $_GET["id"];
$email = $_SESSION["email"];
$admin = 0;
$liked = 0;
$visited = 0;
if (isset($_GET['like'])) {
	$stmt = $mysqli->prepare("call like_a_place(?,?)");
    $stmt->bind_param('ss', $email, $id);
    $stmt->execute(); 
    $stmt->close();   
}
if (isset($_FILES["fileToUpload"])) {
	$target_dir = "images/";
$target_file = $target_dir . basename($_FILES["fileToUpload"]["name"]);$uploadOk = 1;
$imageFileType = pathinfo($target_file,PATHINFO_EXTENSION);
// Check if image file is a actual image or fake image

    $check = getimagesize($_FILES["fileToUpload"]["tmp_name"]);
    if($check !== false) {
        $uploadOk = 1;
    } else {
        $uploadOk = 0;
    }

// Check if file already exists
if (file_exists($target_file)) {
    $uploadOk = 0;
}
// Check file size
if ($_FILES["fileToUpload"]["size"] > 500000) {
    $uploadOk = 0;
}
// Allow certain file formats
if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg"
&& $imageFileType != "gif" ) {
    $uploadOk = 0;
}
// Check if $uploadOk is set to 0 by an error
if ($uploadOk == 0) {
// if everything is ok, try to upload file
} else {
    if (move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $target_file)) {
        echo "The file ". basename( $_FILES["fileToUpload"]["name"]). " has been uploaded.";
        $imgname=basename( $_FILES["fileToUpload"]["name"]);
        $stmt = $mysqli->prepare("call upload_image (?,?,?)");
    	$stmt->bind_param('sss', $email ,$imgname, $id);
    	$stmt->execute(); 
    	$stmt->close();  
    } else {
    }
}
}
if (isset($_GET['manage'])) {
	
	$msg='zift ';
	$sys='kimobasha3000@hotmail.com';
	$stmt = $mysqli->prepare("insert into contact_to_add_place values (?,?,?,?)");
    $stmt->bind_param('ssss', $email , $id,$sys,$msg);
    $stmt->execute(); 
    $stmt->close();  

}


if (isset($_GET['remove_criteria'])) {
	$remove_criteria=$_GET['remove_criteria'];
	$stmt = $mysqli->prepare("call remove_rating_criteria(?,?)");
    $stmt->bind_param('ss', $id,$remove_criteria);
    $stmt->execute(); 
    $stmt->close();   
}
if (isset($_GET['manage'])) {
	$stmt = $mysqli->prepare("call remove_rating_criteria(?,?)");
    $stmt->bind_param('ss', $id,$remove_criteria);
    $stmt->execute(); 
    $stmt->close();   
}
if (isset($_GET['criteria_name'])) {
	$criteria_name=$_GET['criteria_name'];
	$stmt = $mysqli->prepare("call add_rating_criteria(?,?,?)");
    $stmt->bind_param('sss', $email,$criteria_name,$id);
    $stmt->execute(); 
    $stmt->close();   
}
if (isset($_GET['comment']) && isset($_GET['options'])) {
	$comment=$_GET['comment'];
	$options=$_GET['options'];
	if($options ==1)
	{
	$stmt = $mysqli->prepare("call add_a_comment(?,?,?)");
    $stmt->bind_param('sss', $email,$id ,$comment);
    $stmt->execute(); 
    $stmt->close();   
	}
	else
	{
	$stmt = $mysqli->prepare("call add_a_hashtag(?,?,?)");
    $stmt->bind_param('sss', $email,$id ,$comment);
    $stmt->execute(); 
    $stmt->close();  
	}

}
if (isset($_GET['visit'])) {
	$stmt = $mysqli->prepare("insert into visited values(?,?)");
    $stmt->bind_param('ss', $email, $id);
    $stmt->execute(); 
    $stmt->close();    
}
if (isset($_GET['criteria'])&&isset($_GET['rate'])) {
	$criteria=$_GET['criteria'];
	$rate=$_GET['rate'];
	$stmt = $mysqli->prepare("call rate_a_criteria(?,?,?,?)");
    $stmt->bind_param('ssss',$email, $criteria, $id,$rate);

    $stmt->execute();    
    $stmt->close(); 
}
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
		$stmt->close();
if($data["type"] == "Hotel") { 
	$stmt = $mysqli->prepare("SELECT type, price 
						FROM room
						Where pid = ?");
        $stmt->bind_param('i', $id);
        $stmt->execute();    
        $stmt->store_result();
		$stmt->bind_result($roomtype, $roomprice);
        $stmt->fetch();
        $stmt->close();
}
$stmt = $mysqli->prepare("CALL avg_rating(?)");
        $stmt->bind_param('i', $id);
        $stmt->execute();    
        $stmt->store_result();
		$stmt->bind_result($avgratevalue);
        $stmt->fetch();
        $stmt->close();

?>
<div class="row well well-lg place-well">
	<div class = "row">
		<div class="col-sm-6 subHeaderLabel"><?php echo $data["name"];?></div>
		<?php if($_SESSION['admin']==1 && ($admin==0) ){ 
			$stmt = $mysqli->prepare("SELECT *
									  FROM contact_to_add_place
									  Where email1 = ? and pid = ?");
			$stmt->bind_param('si', $email, $id);
       		$stmt->execute();    
    	    $stmt->store_result();
            if ($stmt->num_rows() != 1) {

		?>
		<div class="col-sm-2"><a href="place.php?id=<?php echo $id;?>&manage=1" class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa fa-gear"></span> Manage</a></div>
		<?php  } else { ?>
		<div class="col-sm-2"></div>
		<?php	} ?>
		
		<?php } else { ?>
		<div class="col-sm-2"></div>
		<?php } ?>

		<?php if($visited == 0) { ?>
		<div class="col-sm-2"><a class="btn btn-default disabled" style ="width: 80%; margin-top: 18px;"><span class="fa fa-thumbs-up"></span> Like</a></div>
		<div class="col-sm-2"><a  href="place.php?id=<?php echo $id;?>&visit=1"  class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa fa-question"></span> Visited</a></div>
		<?php } else if ($liked == 0) {?> 
		<div class="col-sm-2"><a href="place.php?id=<?php echo $id;?>&like=1" class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa "></span> Like</a></div>
		<div class="col-sm-2"><a class="btn btn-success" style ="width: 80%; margin-top: 18px;"><span class="fa fa-check"></span> Visited</a></div>	
		<?php } else { ?>
		<div class="col-sm-2"><a class="btn btn-success" style ="width: 80%; margin-top: 18px;"><span class="fa fa-check"></span> Liked</a></div>
		<div class="col-sm-2"><a class="btn btn-success" style ="width: 80%; margin-top: 18px;"><span class="fa fa-check"></span> Visited</a></div>	
		<?php } ?>
	</div>
<?php if($admin == 1) { ?>
<div class="row">
		<div class="col-sm-4"></div>
		<div class="col-sm-2"><a class="btn btn-danger dropdown-toggle" data-toggle="dropdown" aria-expanded="false" style ="width: 80%; margin-top: 18px;"><span class="fa fa-close"></span> Delete</a>
		<ul class="dropdown-menu" role="menu">
			<li><a href="./adminAction.php?action=Delete&id=<?php echo $id;?>">Sure?</a></li>
		</ul>
		</div>
		<div class="col-sm-2"><a href="./adminAction.php?action=delete&id=<?php echo $id;?>" class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa fa-plus"></span> Invite</a></div>
		<div class="col-sm-2"><a href="./create_page.php?id=<?php echo $id;?>" class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa fa-refresh"></span> Update</a></div>
		<div class="col-sm-2"><a href="./adminAction.php?action=upload&id=<?php echo $id;?>" class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa fa-image"></span> Upload</a></div>
</div>
<?php } ?>
</div>
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
<?php 
if($data["type"] == "Hotel") { 
$mysqli->close();
$mysqli = new mysqli(HOST, USER, PASSWORD, DATABASE);
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
		<h3 class = "subHeaderLabel-sm">Add a criteria</h3>
		<form action="place.php" role="form" name="criteria_form" method = "GET">
			<div class="input-group" class="width: 100%;">
				<input type="text" class="form-control" name="criteria_name" autocomplete="off">
				<input type="hidden" name="id" value="<?php echo $id; ?>">
				<span class="input-group-btn">
					<button class="btn btn-primary" type="submit">Add</button>
				</span>
			</div>
		</form>
		<br>
		<strong>Notice that already added criteria are not duplicated.</strong>
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
			<div class="col-sm-6 rating-stars-rate">
				<a href="/place.php?id=<?php echo $id;?>&criteria=<?php echo $cname;?>&rate=5" 
					class="fa fa-star-o"></a><a href="place.php?id=<?php echo $id;?>&criteria=<?php echo $cname;?>&rate=4"  
					class="fa fa-star-o"></a><a href="place.php?id=<?php echo $id;?>&criteria=<?php echo $cname;?>&rate=3"   
					class="fa fa-star-o"></a><a href="place.php?id=<?php echo $id;?>&criteria=<?php echo $cname;?>&rate=2"  
					class="fa fa-star-o"></a><a href="place.php?id=<?php echo $id;?>&criteria=<?php echo $cname;?>&rate=1"  
					class="fa fa-star-o"></a>
			</div>
			<div class="col-sm-2">
				<?php if($admin == 1) { ?>
				<a href="/place.php?id=<?php echo $id;?>&remove_criteria=<?php echo $cname;?>" class="pull-right btn btn-danger"><span class="fa fa-close"></span> Remove</a>
				<?php } ?>
			</div>			
		</div>
		<br>
	<?php } ?>
		<div class = "row">
			<div class="col-sm-12">
				<strong>Notice that if you re-rate a criteria you just overwrite your previous rating.</strong>
			</div>
		</div>
	</div>
	</div>
</div>
<div class="row well well-lg place-well">
	<div class="row">
			<div class="col-sm-10 subHeaderLabel-sm">
				User Images
			</div>

			<form action="place.php?id=<?php echo $id;?>" method="post" enctype="multipart/form-data">
    		<input type="file" name="fileToUpload" id="fileToUpload" onchange="this.form.submit()">
			</form>

	</div>
	<br>
	<?php 
	$stmt->close();
	$stmt = $mysqli->prepare("SELECT M.firstname, M.lastname, M.email, I.image_file 
						FROM image I
						INNER JOIN member M ON M.email = I.email
						Where I.pid = ?
						Order By number Desc");
        $stmt->bind_param('i', $id);
        $stmt->execute();    
        $stmt->store_result();
		$stmt->bind_result($ifname, $ilname, $iemail, $userimagefile); ?>
		<?php
		$count=1;
		$open = false;
		while($stmt->fetch()){
			if($count % 3 ==1) {
				echo '<br><div class="row">';
				$open = true;
			}
			?>
			<div class="col-sm-4">
				<a href="./user.php?email=<?php echo $iemail;?>"><?php echo $ifname." ".$ilname; ?></a>
				<br>
				<br>
				<img src="images/<?php echo $userimagefile;?>" alt="<?php echo $ifname."s image" ;?>" width="100%" height="200">
			</div>

			<?php
			if($count % 3 == 0) {
				echo '</div>';
				$open = false;
			}
			$count = $count + 1;
		}
		if($open) {
			echo '</div>';
		}
	?>
</div>
<div class="row">
	<div class="col-sm-6">
	<div class="well well-lg place-box">
		<h3 class = "subHeaderLabel-sm">Add a comment</h3>
		<form action="place.php" role="form" name="comment_form" method = "GET">
			<div class="input-group" class="width: 100%;">
				<input type="text" class="form-control" name="comment" autocomplete="off">
				<input type="hidden" name="id" value="<?php echo $id; ?>">
				<span class="input-group-btn">
					<button class="btn btn-primary" type="submit">Add</button>
				</span>
			</div>
			<br>
			<div class="btn-group" data-toggle="buttons">
			<label class="btn btn-default active">
					<input type="radio" name="options" id="normal" autocomplete="off" value="1" checked> Comment
			</label>
			<label class="btn btn-default">
				<input type="radio" name="options" id="hashtag" autocomplete="off"  value="2"> Hashtag
			</label>
		</div>
		</form>
		
		<br>
		<br>
		<ul class="nav nav-tabs" role="tablist">
			<li role="presentation" class="active"><a href="#comments" aria-controls="comments" role="tab" data-toggle="tab">Comments</a></li>
			<li role="presentation"><a href="#hashtags" aria-controls="hashtags" role="tab" data-toggle="tab">Hashtags</a></li>
		</ul>
		<div class="tab-content">
		<div role="tabpanel" class="tab-pane active" id="comments">
		<?php 
		$stmt->close();
		$stmt = $mysqli->prepare("CALL view_comments(?)");
        $stmt->bind_param('i', $id);
        $stmt->execute();    
        $stmt->store_result();
		$stmt->bind_result($cofname, $colname, $coemail, $cotext);
		while($stmt->fetch()) { ?>
			<div  class="well comment-well" style="margin-top: 0; margin-bottom: 0;">
				<div class="row">
					<div class ="col-sm-8">
						<a href="./user.php?email=<?php echo $coemail;?>"><?php echo $cofname." ".$colname; ?></a>
					</div>
					<?php if($admin == 1) { ?>
					<div class ="col-sm-4">
						<a href= "#" class="btn btn-danger" style="width: 80%; margin-top: 5px"><span class="fa fa-close"></span> Remove</a>
					</div>
					<?php } ?>
				</div>
				<div class="row">
					<div class = "col-sm-12">
						<p><?php echo $cotext; ?></p>
					</div>
				</div>
			</div>
		<?php } ?>
		</div>
		<div role="tabpanel" class="tab-pane" id="hashtags">
		<?php 
		$stmt->close();
		$stmt = $mysqli->prepare("CALL view_hashtags(?)");
        $stmt->bind_param('i', $id);
        $stmt->execute();    
        $stmt->store_result();
		$stmt->bind_result($hfname, $hlname, $hemail, $htext);
		while($stmt->fetch()) { ?>
			<div  class="well comment-well" style="margin-top: 0; margin-bottom: 0;">
				<div class="row">
					<div class ="col-sm-8">
						<a href="./user.php?email=<?php echo $coemail;?>"><?php echo $cofname." ".$colname; ?></a>
					</div>
					<?php if($admin == 1) { ?>
					<div class ="col-sm-4">
						<a href= "#" class="btn btn-danger" style="width: 80%; margin-top: 5px"><span class="fa fa-close"></span> Remove</a>
					</div>
					<?php } ?>
				</div>
				<div class="row">
					<div class = "col-sm-12">
						<p><?php echo $htext; ?></p>
					</div>
				</div>
			</div>
		<?php } ?>
		</div>
		</div>
	</div>
	</div>
	<div class="col-sm-6">
		<?php 
		$res = array();
		$questions = array("firstname", "lastname", "email", "text");
		$stmt->close();
		$stmt = $mysqli->prepare("CALL view_questions(?)");
	
		if($stmt)
		{
		$stmt->bind_param('i', $id);
		$stmt->execute();
	 	$stmt->store_result();
		$meta = $stmt->result_metadata(); 
		while ($field = $meta->fetch_field()) { 
   			$params[] = &$row[$field->name];
   			
   
			}
			call_user_func_array(array($stmt, 'bind_result'), $params);  
			while ($stmt->fetch()) { 
    			foreach($row as $key => $val) { 
        			$c[$key] = $val; 
    			} 
   				 $hits[] = $c; 
			} 
		}
		?>
		<div class="well well-lg place-box">
			<h3 class = "subHeaderLabel-sm">Questions</h3>
			<?php if ($stmt->num_rows() > 0) { 
			foreach($hits as $q) { ?>
			<div  class="well comment-well">
				<a href="./user.php?email=<?php echo $q["email"];?>"><?php echo $q["firstname"]." ".$q["lastname"]; ?></a>
				<p><?php echo $q["text"];?>
				<?php if($admin == 1) { ?>
				<form action="answer_question.php" role="form" name="answer_form" method = "POST">
					<div class="input-group" class="width: 100%;">
						<input type="text" class="form-control" name="answer" autocomplete="off">
						<input type="hidden" name="pid" value="<?php echo $id; ?>">
						<input type="hidden" name="qnum" value="<?php echo $q["question_number"]; ?>">
						<span class="input-group-btn">
							<button class="btn btn-primary" type="submit">Answer</button>
						</span>
					</div>
				</form>
				
				<?php } ?>
				<br>
				<br>
				<strong>Answers</strong>
				<br>
				
				<?php 
				$stmt->close();
				$stmt = $mysqli->prepare("CALL view_answers_of_a_question(? , ?)");
				$stmt->bind_param('ii', $id, $q["question_number"]);
				$stmt->execute();
				$stmt->store_result();
				$stmt->bind_result($afname, $alname, $aemail, $atext);
				while($stmt->fetch()) {
				?>
				<a href="./user.php?email=<?php echo $aemail;?>"><?php echo $afname." ".$alname; ?></a>
				<p><?php echo $atext;?>
				<br>
				<br>
				<?php } ?>
			</div>
			<?php }  ?>
			<?php } else { ?>
				<div class="alert alert-danger wrap-msg"><strong>No questions yet.</strong></div>
			<?php } ?>
		</div>
	</div>
</div>
<?php
include "footer.php";
?>