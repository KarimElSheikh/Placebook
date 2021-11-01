<?php
include_once 'includes/functions.php';
include_once 'header.php';
?>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Placebook</title>
	<link rel="stylesheet" href="../css/buttons.css">
	<link rel="stylesheet" href="../css/bootstrap.css">
	<link rel="stylesheet" href="../css/styles.css">
	<link rel="stylesheet" href="../css/font-awesome.css">
	<script type="text/javascript" src="../js/jquery.js"></script>
	<script type="text/javascript" src="../js/bootstrap.js"></script>
	<script type="text/javascript" src="../js/buttons.js"></script>
	<script type="text/javascript" src="../js/scripts.js"></script>
</head>

<body>
	<form method="get" name="registration_form" action="includes/create_page.inc.php">
		
		<div class="form-group">
			<label for="lName">Name</label>
			<input type="text" class="form-control" name="name" placeholder="Enter name">
		</div>
		<div class="form-group">
			<label for="signupEmail">Date</label>
			<input type="text" class="form-control" name="date"i placeholder="Enter Date">
		</div>
		<div class="form-group">
			<label for="signupEmail">Longitude</label>
			<input type="text" class="form-control" name="Longitude"i placeholder="Enter Longitude">
		</div>
		<div class="form-group">
			<label for="signupEmail">Latitude</label>
			<input type="text" class="form-control" name="Latitude"i placeholder="Enter Latitude">
		</div>
		<div class="form-group">
			<label for="signupEmail">Info</label>
			<input type="text" class="form-control" name="Info"i placeholder="Enter Info">
		</div>
		<div class="btn-group" data-toggle="buttons">
			<label class="btn btn-default active">
					<input type="radio" name="options" id="normal" autocomplete="off" value="100" checked> Comment
			</label>
			<label class="btn btn-default">
				<input type="radio" name="options" id="hashtag" autocomplete="off"  value="2"> Hashtag
			</label>
		</div>
		<br><br>

		<button type = "submit" style="width: 100%;"class="btn btn-primary" onclick=" this.form.submit()">Save</button>
		</form>
	</div>
</div>
</div>
</body>
</html>