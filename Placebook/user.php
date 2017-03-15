<?php
include "header.php";
?>
<div class="row well well-lg">
	<div class="row">
		<div class="col-md-6 subHeaderLabel"><p>Mohammed El-Ansary</p></div>
		<div class="col-md-2"><p></p></div>
		<!-- If not friend -->
		<!-- 
		<div class="col-md-2"><a href="#" class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa fa-plus"></span> Add Friend</a></div>
		<div class="col-md-2"><a class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa fa-comments-o"></span> Message</a></div>
		-->
		<!-- If pending friend -->
		<!--
		<div class="col-md-2"><a class="btn btn-primary" style ="width: 80%; margin-top: 18px;"><span class="fa fa-spinner"></span> Pending</a></div>
		<div class="col-md-2"><a class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa fa-comments-o"></span> Message</a></div>
		-->
		<!-- If friend -->
		
		<div class="col-md-2"><a class="btn btn-success dropdown-toggle" data-toggle="dropdown" aria-expanded="false" style ="width: 80%; margin-top: 18px;"><span class="fa fa-check fa-inverted"></span> Friend</span></a>
		<ul class="dropdown-menu" role="menu">
			<li><a href="#">Unfriend</a></li>
		</ul>
		</div>
		<div class="col-md-2"><a class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa fa-comments-o"></span> Message</a></div>
		
		<!-- If logged in user -->
		<!--
		<div class="col-md-2"><p></p></div>
		<div class="col-md-2"><a class="btn btn-default" style ="width: 80%; margin-top: 18px;"><span class="fa fa-gears"></span> Settings</a></div>
		-->
	</div>
	<br>
	<div class="row">
		<div class="col-md-3"><strong><span class="fa fa-envelope"></span> Email</strong></div>
		<div class="col-md-3"><strong><span class="fa fa-flag"></span> Nationality</strong></div>
		<div class="col-md-3"><strong><span class="fa fa-home"></span> Address</strong></div>
		<div class="col-md-3"><strong><span class="fa fa-phone"></span> Phone number(s)</strong></div>
	</div>
	<br>
	<div class="row">
		<div class="col-md-3">a.n.s.a.r.y@hotmail.com</div>
		<div class="col-md-3">Egyptian</div>
		<div class="col-md-3">12, 4th Zone, Sheraton Heliopolis, Cairo, Egypt</div>
		<div class="col-md-3">01006855102<br>01001111111</div>
	</div>
</div>
<div class="row well well-lg">
	<div class="col-md-12 subHeaderLabel">Likes</div>
</div>
<div class="row well well-lg">
	<div class="col-md-12 subHeaderLabel">Visited</div>
</div>
<?php
include "footer.php";
?>	