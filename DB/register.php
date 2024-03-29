<?php
/**
 * Copyright (C) 2013 peredur.net
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
include_once 'includes/register.inc.php';
include_once 'includes/functions.php';
?>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Sign up</title>
        <link rel="stylesheet" href="styles/main.css" />
        <meta charset="UTF-8">
        <title>Placebook</title>
        <link rel="stylesheet" href="css/buttons.css">
        <link rel="stylesheet" href="css/bootstrap.css">
        <link rel="stylesheet" href="css/Placebook-stylesheet.css">
        <link rel="stylesheet" href="css/font-awesome_modified.css">
        <script type="text/javascript" src="js/jquery.js"></script>
        <script type="text/javascript" src="js/bootstrap.js"></script>
        <script type="text/javascript" src="js/buttons.js"></script>
        <script type="text/javascript" src="js/scripts.js"></script>
		<script type="text/JavaScript" src="js/sha512.js"></script> 
        <script type="text/JavaScript" src="js/forms.js"></script>
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
                        <input type="password" name="password" class="form-control" id="signupPass" placeholder="Enter password">
                    </div>
                    <div class="form-group">
                        <label for="signupConPass">Confirm password</label>
                        <input type="password" name="confirmpwd" class="form-control" id="signupPass" placeholder="Re-enter password">
                    </div>
                    <button type = "submit" style="width: 100%;"class="btn btn-primary "onclick="return regformhash(this.form,
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
