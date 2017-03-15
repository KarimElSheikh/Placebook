
function provide_info (form)

{
   //add regEx
    form.submit();
}

function formhash(form, password) {
    var email = document.getElementById("email").value;
	var pass = document.getElementById("password").value;
	//emailRegex regular expression obtained from http://stackoverflow.com/questions/46155/validate-email-address-in-javascript's answer.
	var emailRegEx = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
	if (!emailRegEx.test(email)) {
		$(document).ready(function(){
			$("#emailGroup").addClass("has-error");
			$("#emailGroup").popover("show");
		});
    }
	if(pass == null || pass == "") {
		$(document).ready(function(){
			$("#passGroup").addClass("has-error");
			$("#passGroup").popover("show");
		});
	}
	if(emailRegEx.test(email) && (pass != null) && (pass != "")) {
		var p = document.createElement("input");
		// Add the new element to our form. 
		form.appendChild(p);
		p.name = "p";
		p.type = "hidden";
		p.value = hex_sha512(password.value);
		
		
		var e = document.createElement("input");
		// Add the new element to our form. 
		form.appendChild(e);
		e.name = "e";
		e.type = "hidden";
		e.value = form.email.value;
		// Make sure the plaintext password doesn't get sent. 
		password.value = "";
		form.submit();
	} else {
		return false;
	}
}

$(document).ready(function(){
  $("#email").on("focus input",function(){
    $("#emailGroup").removeClass("has-error");
	$("#emailGroup").popover("hide");
	$("#loginWell").popover("hide");
  });
});
$(document).ready(function(){
  $("#password").on("focus input",function(){
    $("#passGroup").removeClass("has-error");
	$("#passGroup").popover("hide");
	$("#loginWell").popover("hide");
  });
});


function regformhash(form,  email, fname,lname,password, conf) {
    // Check each field has a value
    if (email.value == '' || password.value == '' || conf.value == '' || fname.value == ''|| lname.value == '') {
        alert('You must provide all the requested details. Please try again');
        return false;
    }
    
    // Check the username
     
    // Check that the password is sufficiently long (min 6 chars)
    // The check is duplicated below, but this is included to give more
    // specific guidance to the user
    //if (password.value.length < 6) {
        //alert('Passwords must be at least 6 characters long.  Please try again');
       // form.password.focus();
      //  return false;
    //}
    
    // At least one number, one lowercase and one uppercase letter 
    // At least six characters 
    //var re = /(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}/; 
    //if (!re.test(password.value)) {
       // alert('Passwords must contain at least one number, one lowercase and one uppercase letter.  Please try again');
     //   return false;
   // }
    
    // Check password and confirmation are the same
    if (password.value != conf.value) {
        alert('Your password and confirmation do not match. Please try again');
        form.password.focus();
        return false;
    }
        
    // Create a new element input, this will be our hashed password field. 
    var p = document.createElement("input");

    // Add the new element to our form. 
    form.appendChild(p);
    p.name = "p";
    p.type = "hidden";
    p.value = hex_sha512(password.value);
    
    // Make sure the plaintext password doesn't get sent. 
    password.value = "";
    conf.value = "";

    // Finally submit the form. 
    form.submit();
    return true;
}
