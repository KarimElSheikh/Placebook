<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Placebook</title>
		<link rel="stylesheet" href="css/bootstrap.css">
		<link rel="stylesheet" href="css/styles.css">
		<link rel="stylesheet" href="css/font-awesome.css">
		<script type="text/javascript" src="js/jquery.js"></script>
		<script type="text/javascript" src="js/bootstrap.js"></script>
		<script type="text/javascript" src="js/scripts.js"></script>
	</head>
	<body>
		<div class = "wrap">
			<h1 class = "HMain">Placebook</h1>
			<div class = "wrap-login">
			<div class = "well well-lg" id="loginWell">
				<form role="form" name="loginForm" onsubmit="return validateForm()" method = "POST">
					<div class="form-group" id="emailGroup" data-toggle="popover" data-trigger="focus" data-content="Please enter a valid email.">
						<div class="input-group">
							<div class="input-group-addon"><span class="fa fa-envelope" aria-hidden="true"></span></div>
							<input type="text" class="form-control" id="emailBox" placeholder="Enter email">
						</div>
					</div>
					<div class="form-group" id="passGroup" data-toggle="popover" data-trigger="focus" data-content="Password cannot be empty.">
						<div class="input-group">
							<div class="input-group-addon"><span class="glyphicon glyphicon-lock" aria-hidden="true"></span></div>
							<input type="password" class="form-control" id="passBox" placeholder="Enter password">
						</div>
					</div>
					<button type = "submit" style="width: 100%;"class="btn btn-success">Log in</button>
				</form>
				<br>
				<a href="#" class="btn btn-primary" style="width: 100%;">Sign up now!</a>
			</div>
			</div>
		</div>
	</body>
</html>