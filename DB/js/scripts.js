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
$(document).ready(function(){
  $("#scrollDown").on("click",function(){
     $('html, body').animate({
        scrollTop: $(document).height()
    }, 'slow');
	$("#messageGroup").removeClass("fixed-bottom");
	$("#empty").removeClass("empty1");
	$("#empty").addClass("empty2");
    return false;
  });
});
$(document).ready(function(){
  $("#scrollUp").on("click",function(){
     $('html, body').animate({
        scrollTop:0
    }, 'slow');
    return false;
  });
});


$(document).ready(function(){
    $(document).scroll(function() {
        var height = $(document).height();
		var top = $(document).scrollTop();
        if (top < height - 1000) {
			$("#empty").addClass("empty1");
			$("#empty").removeClass("empty2");
			$("#messageGroup").addClass("fixed-bottom");
			
		}
        else {
			$("#empty").removeClass("empty1");
			$("#empty").addClass("empty2");
			$("#messageGroup").removeClass("fixed-bottom");
		}
    });
});
$(document).ready(function(){
    if($(window).height() == $(document).height()) {
		$("#empty").removeClass("empty1");
			$("#empty").addClass("empty2");
			$("#messageGroup").removeClass("fixed-bottom");
    }
});