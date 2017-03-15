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
		<div class = "wrap">
			<h1 class = "HMain">Placebook</h1>
			<div class = "wrap-signup">
			<div class = "well well-lg" id="signupWell">
				<p>All fields are required</p>
				<form role="form">
					<div class="form-group">
						<label for="fName">First name</label>
						<input type="text" class="form-control" id="fName" placeholder="Enter first name">
					</div>
					<div class="form-group">
						<label for="lName">Last name</label>
						<input type="text" class="form-control" id="lName" placeholder="Enter last name">
					</div>
					<div class="form-group">
						<label for="signupEmail">Email address</label>
						<input type="text" class="form-control" id="signupEmail" placeholder="Enter email">
					</div>
					<div class="form-group">
						<label for="signupPass">Password</label>
						<input type="password" class="form-control" id="signupPass" placeholder="Enter password">
					</div>
					<div class="form-group">
						<label for="signupConPass">Confirm password</label>
						<input type="password" class="form-control" id="signupPass" placeholder="Re-enter password">
					</div>
					<button type = "submit" style="width: 100%;"class="btn btn-primary">Continue</button>
			</div>
			</div>
		</div>
	</body>
</html>