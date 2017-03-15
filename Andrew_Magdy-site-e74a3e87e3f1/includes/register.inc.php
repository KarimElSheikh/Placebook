<?php
include_once 'db_connect.php';
include_once 'functions.php';
$error_msg = "";


if (isset($_POST['email'], $_POST['p'],$_POST['fname'],$_POST['lname'])) {
    // Sanitize and validate the data passed in
    
    $email = filter_input(INPUT_POST, 'email', FILTER_SANITIZE_EMAIL);
    $email = filter_var($email, FILTER_VALIDATE_EMAIL);
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        // Not a valid email
        $error_msg .= '<p class="error">The email address you entered is not valid</p>';
    }
    
    $password = filter_input(INPUT_POST, 'p', FILTER_SANITIZE_STRING);
    if (strlen($password) != 128) {
        // The hashed pwd should be 128 characters long.
        // If it's not, something really odd has happened
        $error_msg .= '<p class="error">Invalid password configuration.</p>';
    }
    $fname = filter_input(INPUT_POST, 'fname', FILTER_SANITIZE_STRING);
    if (strlen($fname) < 1) {
             $error_msg .= '<p class="error">Invalid first name</p>';
    }
    $lname = filter_input(INPUT_POST, 'lname', FILTER_SANITIZE_STRING);
    if (strlen($lname) < 1) {
             $error_msg .= '<p class="error">Invalid last name.</p>';
    }
    
    $prep_stmt = "SELECT * FROM member WHERE email = ? LIMIT 1";
    $stmt = $mysqli->prepare($prep_stmt);
    
    if ($stmt) {
        $stmt->bind_param('s', $email);
        $stmt->execute();
        $stmt->store_result();
        
        if ($stmt->num_rows == 1) {
            // A user with this email address already exists
            $error_msg .= '<p class="error">A user with this email address already exists.</p>';
        }
    } else {
        $error_msg .= '<p class="error">Database error</p>';
    }

    if (empty($error_msg)) {
        // Create a random salt
        //$random_salt = hash('sha512', uniqid(openssl_random_pseudo_bytes(16), TRUE));

        // Create salted password 
        $hpassword = hash('sha512', $password);

        // Insert the new user into the database 
        if ($insert_stmt = $mysqli->prepare("call sign_up (?,?)")) {
            $insert_stmt->bind_param('ss',$email, $hpassword);
            // Execute the prepared query.
            if (! $insert_stmt->execute()) {
                header('Location: ../error.php?err=Registration failure: INSERT');
                exit();
            }
        }
        add_info($mysqli,$email,$fname,$lname," "," ");
         sec_session_start(); 
         if (login($email, $password, $mysqli) == true) {
         header('Location: ./register_success.php');
        exit();
        } else {
       header('Location: ../login.php?error=1');
        exit();
        }
    }
}