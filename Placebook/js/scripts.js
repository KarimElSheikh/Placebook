function validateForm() {
	var email = document.getElementById("emailBox").value;
	var pass = document.getElementById("passBox").value;
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
	return emailRegEx.test(email) && (pass != null) && (pass != "");
}

function addPhoneNo() {
	$(document).ready(function(){
		if($("#phone2").hasClass("hidden")){
			$("#phone2").removeClass("hidden");
		}
		else {
			$("#phone3").removeClass("hidden");
			$("#add").remove();
		}
	});
}

$(document).ready(function(){
  $("#emailBox").on("focus input",function(){
    $("#emailGroup").removeClass("has-error");
	$("#emailGroup").popover("hide");
  });
});
$(document).ready(function(){
  $("#passBox").on("focus input",function(){
    $("#passGroup").removeClass("has-error");
	$("#passGroup").popover("hide");
  });
});
$(document).ready(function(){
  $("#option1").on("change",function(){
    $("#searchBox").attr("placeholder", "Enter place name");
	$("#searchType").val("1");
  });
});
$(document).ready(function(){
  $("#option2").on("change",function(){
    $("#searchBox").attr("placeholder", "Enter member name or email");
	$("#searchType").val("2");
  });
});
$(document).ready(function(){
  $('[data-toggle="tooltip"]').tooltip({'placement': 'top'});
});

function searchForm() {
	var query = document.getElementById("searchBox").value;
	return (query != null) && (query != "");
}