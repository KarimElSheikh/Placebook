<?php
include "header.php";
if(!isset($_GET["email"]) || ($_GET["email"] == $_SESSION["email"])){
	header('Location: ./threads.php');
}
$email = $_GET["email"];
$stmt = $mysqli->prepare("SELECT * FROM member where email = ?");
        $stmt->bind_param('s',$email);
		$stmt->execute();    
        $stmt->store_result();
if (!($stmt->num_rows > 0)) {
	header('Location: ./threads.php');
}
$stmt = $mysqli->prepare("CALL view_thread(?, ?)");
        $stmt->bind_param('ss', $_SESSION["email"], $email);
		$stmt->execute();    
        $stmt->store_result();
		$stmt->bind_result($fname,$lname,$msg);
?>
<div class="wrap-msg">
	<button id="scrollDown" class="btn btn-primary float-middle"  data-toggle="tooltip" data-placement="top" title="Scroll to bottom"><span class="fa fa-chevron-down"></span></button>
</div>
<br>
<?php while ($stmt->fetch()) { ?>
<div class="well well-lg wrap-msg">
	<div class="subHeaderLabel-sm"><?php echo $fname.' '.$lname; ?></div>
	<h4><?php echo $msg; ?></h4>
</div>
<?php } ?>
<div class="wrap-msg">
	<button id="scrollUp" class="btn btn-primary float-middle"  data-toggle="tooltip" data-placement="top" title="Scroll to top"><span class="fa fa-chevron-up"></span></button>
</div>
<div id="empty" class="empty1"></div>
<div class="well well-lg wrap-msg fixed-bottom" id="messageGroup">
	<form action="send_message.php"role="form" name="message_form" onsubmit="return validate" method = "GET">
		<div class="row">
			<div class="col-sm-12">
				<div class="input-group">
					<input type="text" class="form-control" name="message" autocomplete="off">
					<input type="hidden" name="email" value="<?php echo $email; ?>">
					<span class="input-group-btn">
						<button class="btn btn-primary" type="submit">Send</button>
					</span>
				</div>
			</div>
		</div>
	</form>
</div>

<?php
include "footer.php";
?>	