<?php
include_once 'config.php';

function sec_session_start() {
    $session_name = 'sec_session_id';   // Set a custom session name 
    $secure = SECURE;
    $httponly = true;
    if (ini_set('session.use_only_cookies', 1) === FALSE) {
        header("Location: ../error.php?err=Could not initiate a safe session (ini_set)");
        exit();
    }
    $cookieParams = session_get_cookie_params();
    session_set_cookie_params($cookieParams["lifetime"], $cookieParams["path"], $cookieParams["domain"], $secure, $httponly);
    session_name($session_name);
    session_start();            
    session_regenerate_id();

}

function add_info ($mysqli,$email,$fname,$lname,$nationality,$address)
{
     $sql = "call input_personal_data(?,?,?,?,?)";
     $stmt = $mysqli->prepare($sql);
     if($stmt)
     {
     $stmt->bind_param('sssss',$email,$fname,$lname,$nationality,$address);
     $stmt->execute();
     }
     
}
function search_member($mysqli,$str)
{
    if($str!=='')
     {
        $sql = "call search_members_by_email(?)";
        $stmt = $mysqli->prepare($sql);
        if($stmt)
        {
        $stmt->bind_param('s',$str);
        $stmt->execute();
        }

     }
}
function add_phone ($mysqli,$email,$phone)
{
     if($phone!=='')
     {
        $sql = "call input_phone_number(?,?)";
        $stmt = $mysqli->prepare($sql);
        if($stmt)
        {
        $stmt->bind_param('ss',$email,$phone);
        $stmt->execute();
        }
    }
 }
    
function login($email, $password, $mysqli) {
        
        $stmtb = $mysqli->prepare($sql);

    if ($stmt = $mysqli->prepare("SELECT password,firstname,lastname
                  FROM member WHERE email = ? LIMIT 1")) {
        $stmt->bind_param('s', $email);  // Bind "$email" to parameter.
        $stmt->execute();    // Execute the prepared query.
        $stmt->store_result();

        // get variables from result.
        $stmt->bind_result($db_password,$fname,$lname);

        $stmt->fetch();
        
        $password = hash('sha512', $password);
        if ($stmt->num_rows == 1) {
                    header('Location: ../error.php?err='.$db_password. "---".$password );
                if ($db_password == $password) {
                    

                    $sql = "SELECT * from administrator where email =? ";
                    $user_browser = $_SERVER['HTTP_USER_AGENT'];
                    
                    $stmtb = $mysqli->prepare($sql);
                    $stmtb->bind_param('s', $email);
                    $stmtb->execute();    
                    $stmtb->store_result();


                    $_SESSION['admin']=0;
                    $_SESSION['email'] = $email;
                    $_SESSION['fname'] = $fname;
					$_SESSION['lname'] = $lname;
                    if ($stmtb->num_rows == 1)
                    {
                        $_SESSION['admin']=1;
                    }


                    $_SESSION['login_string'] = hash('sha512', $password . $user_browser);
                    return true;
                } 
            //}
        } else {
            // No user exists. 
            return false;
        }
    } else {
        // Could not create a prepared statement
        header("Location: ../error.php?err=Database error: cannot prepare statement");
        exit();
    }
}

function checkbrute($email, $mysqli) {
   return true;
    // Get timestamp of current time 
   /* $now = time();

    // All login attempts are counted from the past 2 hours. 
    $valid_attempts = $now - (2 * 60 * 60);

    if ($stmt = $mysqli->prepare("SELECT time 
                                  FROM login_attempts 
                                  WHERE email = ? AND time > '$valid_attempts'")) {
        $stmt->bind_param('s', $email);

        // Execute the prepared query. 
        $stmt->execute();
        $stmt->store_result();

        // If there have been more than 5 failed logins 
        if ($stmt->num_rows > 5) {
            return true;
        } else {
            return false;
        }
    } else {
        // Could not create a prepared statement
        header("Location: ../error.php?err=Database error: cannot prepare statement");
        exit();
       
    } */
}

function login_check($mysqli) {
    // Check if all session variables are set 
    if (isset($_SESSION['email'], $_SESSION['login_string'])) {
        $email = $_SESSION['email'];
        $login_string = $_SESSION['login_string'];
        
        // Get the user-agent string of the user.
        $user_browser = $_SERVER['HTTP_USER_AGENT'];

        if ($stmt = $mysqli->prepare("SELECT password 
                      FROM member
                      WHERE email = ? LIMIT 1")) {
            // Bind "$user_id" to parameter. 
            $stmt->bind_param('s', $email);
            $stmt->execute();   // Execute the prepared query.
            $stmt->store_result();

            if ($stmt->num_rows == 1) {
                // If the user exists get variables from result.
                $stmt->bind_result($password);
                $stmt->fetch();
                $login_check = hash('sha512', $password . $user_browser);

                if ($login_check == $login_string) {
                    // Logged In!!!! 
                    return true;
                } else {
                    // Not logged in 


                    return false;
                }
            } else {
                // Not logged in 
                return false;
            }
        } else {
            // Could not prepare statement
            header("Location: ../error.php?err=Database error: cannot prepare statement");
            exit();
        }
    } else {
        // Not logged in 
        return false;
    }
}

function esc_url($url) {

    if ('' == $url) {
        return $url;
    }

    $url = preg_replace('|[^a-z0-9-~+_.?#=!&;,/:%@$\|*\'()\\x80-\\xff]|i', '', $url);
    
    $strip = array('%0d', '%0a', '%0D', '%0A');
    $url = (string) $url;
    
    $count = 1;
    while ($count) {
        $url = str_replace($strip, '', $url, $count);
    }
    
    $url = str_replace(';//', '://', $url);

    $url = htmlentities($url);
    
    $url = str_replace('&amp;', '&#038;', $url);
    $url = str_replace("'", '&#039;', $url);

    if ($url[0] !== '/') {
        // We're only interested in relative links from $_SERVER['PHP_SELF']
        return '';
    } else {
        return $url;
    }
}

function action($a, $b, $o) {
	echo '?action='.$a.'&actionBy='.$b.'&actionOn='.$o;
}