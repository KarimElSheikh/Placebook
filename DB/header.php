<?php
include_once 'includes/functions.php';
include_once 'includes/db_connect.php';
sec_session_start();
if (login_check($mysqli) == false) {
    header('Location: login.php');
}
?>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Placebook</title>
		<link type="text/css" rel="stylesheet" href="css/buttons.css">
		<link type="text/css" rel="stylesheet" href="css/bootstrap.css">
		<link type="text/css" rel="stylesheet" href="css/Placebook-stylesheet.css">
		<link type="text/css" rel="stylesheet" href="css/font-awesome_modified.css">
		<script type="text/javascript" src="js/jquery.js"></script>
		<script type="text/javascript" src="js/bootstrap.js"></script>
		<script type="text/javascript" src="js/buttons.js"></script>
		<script type="text/javascript" src="js/scripts.js"></script>
	</head>
	<body>
		<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
			<div class="container">
				<div class="navbar-header">
					<a class="HIco" href="./">Placebook</a>
				</div>
				<div id="navbar" class="navbar-collapse collapse">
					<form class="navbar-form navbar-left" action="search_user.php" method="get" onsubmit="return searchForm();">
						<div class="form-group">
							<input type="text" class="form-control" placeholder="Enter place name" name="name" id="searchBox">
							<input type="hidden" id="searchType" value = "1">
						</div>
						<div class="btn-group" data-toggle="buttons">
							<label class="btn btn-default active">
								<input type="radio" name="options" id="option1" autocomplete="off" value="1" checked> Places
							</label>
							<label class="btn btn-default">
								<input type="radio" name="options" id="option2" autocomplete="off"  value="2"> People
							</label>
						</div>
						<button type="submit" class="btn btn-default"><span class="fa fa-search"></span></button>
					</form>
					<ul class="nav navbar-nav navbar-right">
						<li><a href="#"><span class="fa fa-user"></span></a><li>
						<li><a href="user.php?email=<?php echo $_SESSION['email'];?>" ><?php echo $_SESSION['fname']." ".$_SESSION['lname']; ?></a><li>
						<li class="dropdown">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><span class="fa fa-bars"></span></a>
							<ul class="dropdown-menu" role="menu">	
								<li><a href="friends.php">Friends</a></li>
								<li><a href="threads.php">Messages</a></li>
								<li><a href="invites.php">Invitations</a></li>
								<li class="divider"></li>
								<li><a href="#">Create Place</a></li>
								<li><a href="myplaces.php">My Places</a></li>
								<li class="divider"></li>
								<li><a href="register_success.php">Settings</a></li>
								<li><a href="logout.php">Log out</a></li>
							</ul>
						</li>
					</ul>
				</div>
			</div>
		</nav>
		<br>
		<br>
		<br>
		<br>
		<div class = "wrap">