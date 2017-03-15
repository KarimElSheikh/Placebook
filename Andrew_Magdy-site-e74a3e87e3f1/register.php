<?php

include_once 'includes/register.inc.php';
include_once 'includes/functions.php';
?>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Secure Login: Registration Form</title>
        <script type="text/JavaScript" src="js/sha512.js"></script> 
        <script type="text/JavaScript" src="js/forms.js"></script>
        <link rel="stylesheet" href="styles/main.css" />
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
       
        <?php
        if (!empty($error_msg)) {
            echo $error_msg;
        }
        ?>

        <div class = "wrap">
            <h1 class = "HMain">Placebook</h1>
            <div class = "wrap-signup">
            <div class = "well well-lg" id="signupWell">
                <p>All fields are required</p>


        <form method="post" name="registration_form" action="<?php echo esc_url($_SERVER['PHP_SELF']); ?>">
            <div class="form-group">
                        <label for="fName">First name</label>
                        <input type="text" name ="fname" class="form-control" id="fName" placeholder="Enter first name">
                    </div>
                    <div class="form-group">
                        <label for="lName">Last name</label>
                        <input type="text" name="lname" class="form-control" id="lName" placeholder="Enter last name">
                    </div>
                    <div class="form-group">
                        <label for="signupEmail">Email address</label>
                        <input type="text" name="email"  class="form-control" id="signupEmail" placeholder="Enter email">
                    </div>
                    <div class="form-group">
                        <label for="signupPass">Password</label>
                        <input type="password" id="password" class="form-control" id="signupPass" placeholder="Enter password">
                    </div>
                    <div class="form-group">
                        <label for="signupConPass">Confirm password</label>
                        <input type="password" name="confirmpwd" class="form-control" id="signupPass" placeholder="Re-enter password">
                    </div>
                    <button type = "submit" style="width: 100%;"class="btn btn-primary " onclick="return regformhash(this.form,
                                   this.form.email,
                                   this.form.fname,
                                   this.form.lname,
                                   this.form.password,
                                   this.form.confirmpwd);" >Continue</button>
            </div>
            </div>
        </div>
           
        </form>
    </body>
</html>
