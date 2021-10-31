<?php
include_once 'includes/db_connect.php';
include_once 'includes/functions.php';

sec_session_start();

if (login_check($mysqli) == true) {
    header('Location: index.php');
} else {
    

?>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Placebook</title>
        <link rel="stylesheet" href="css/bootstrap.css">
        <link rel="stylesheet" href="css/Placebook-stylesheet.css">
        <link rel="stylesheet" href="css/font-awesome_modified.css">
        <script type="text/javascript" src="js/jquery.js"></script>
        <script type="text/javascript" src="js/bootstrap.js"></script>
		<script type="text/JavaScript" src="js/sha512.js"></script> 
        <script type="text/JavaScript" src="js/forms.js"></script> 
		<?php
		if (isset($_GET['error'])) {?> 
		<script>
		$(document).ready(function(){
			$("#loginWell").popover("show");
		});
		</script>       
		<?php  } ?>
    </head>
   <body>
        <div class = "wrap">
            <h1 class = "HMain">Placebook</h1>
            <div class = "wrap-login">
            <div class = "well well-lg" id="loginWell" data-toggle="popover" data-trigger = "focus" data-content="Wrong email or password." data-placement="top">
                <form action="includes/process_login.php" onsubmit ="return formhash(this, this.password);" method="post" name="login_form">  
                    <div class="form-group" id="emailGroup" data-toggle="popover" data-trigger="focus" data-content="Please enter a valid email.">
                        <div class="input-group">
                            <div class="input-group-addon"><span class="fa fa-envelope" aria-hidden="true"></span></div>
                            <input type="text" class="form-control" id="email" placeholder="Enter email">
                        </div>
                    </div>
                    <div class="form-group" id="passGroup" data-toggle="popover" data-trigger="focus" data-content="Password cannot be empty.">
                        <div class="input-group">
                            <div class="input-group-addon"><span class="glyphicon glyphicon-lock" aria-hidden="true"></span></div>
                            <input type="password" class="form-control" id="password" placeholder="Enter password">
                        </div>
                    </div>
                    <button style="width: 100%;"class="btn btn-success" type="submit" >Log in</button> 
                </form>
                <br>
                <a href="register.php" class="btn btn-primary" style="width: 100%;">Sign up now!</a>
            </div>
            </div>
        </div>
    </body>
</html>
<?php } ?>
