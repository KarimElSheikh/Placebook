<?php
include_once 'includes/functions.php';
?>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Placebook</title>
		<link rel="stylesheet" href=css/buttons.css">
		<link rel="stylesheet" href="css/bootstrap.css">
		<link rel="stylesheet" href="css/styles.css">
		<link rel="stylesheet" href="css/font-awesome.css">
		<script type="text/javascript" src="js/jquery.js"></script>
		<script type="text/javascript" src="js/bootstrap.js"></script>
		<script type="text/javascript" src="js/buttons.js"></script>
		<script type="text/javascript" src="js/scripts.js"></script>
	</head>

	<body>
		<div class = "wrap">
			<h1 class = "HMain">Placebook</h1>
			<div class = "wrap-signup">
			<div class = "well well-lg" id="signupWell">
				<p>All fields are optional</p>
        <form method="post" name="registration_form" action="includes/register_success.inc.php">
				<div class="form-group">
						<label for="fName">Nationality</label>
						<input type="text" class="form-control" name="nationality" placeholder="Enter nationality">
					</div>
					<div class="form-group">
						<label for="lName">Address</label>
						<input type="text" class="form-control" name="address" placeholder="Enter address">
					</div>
					<div class="form-group">
						<label for="signupEmail">Phone number(s)</label>
						<input type="text" class="form-control" name="phone1"id="phone1" placeholder="Enter number">
					</div>
					<div class="form-group">
						<input type="text" class="form-control hidden" name="phone2"id="phone2" placeholder="Enter number">
					</div>
					<div class="form-group">
						<input type="text" class="form-control hidden" name="phone3" id="phone3" =placeholder="Enter number">
					</div>
					<a class="btn btn-primary" id="add" onclick="addPhoneNo();">Add</a>
					<br>
					<br>
					<button type = "submit" style="width: 100%;"class="btn btn-primary" onclick=" return provide_info(this.form)">Save</button>
			</div>
			</div>
		</div>
	</body>
</html>