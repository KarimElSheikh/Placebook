<?php
include_once"header.php";
if (isset($_GET['options']))
{
	$options=$_GET['options'];

	if($options =='2')
	{


if (isset($_GET['name']) ) {
	$name =$_GET['name'];

	 if(filter_var($name, FILTER_VALIDATE_EMAIL)) {
        $sql = "call search_members_by_email(?)";
    }
    else {
 			$sql = "call search_members_by_name(?)";
    }
	
	
	$stmt = $mysqli->prepare($sql);
	if($stmt)
	{
		$stmt->bind_param('s', $name);
		$stmt->execute();
	 	$stmt->store_result();
		$stmt->bind_result($fname,$lname,$email,$nat,$address);

	while ($stmt->fetch()) {
?>
<div class="well well-lg wrap-msg">
	<div><a href="user.php?email=<?php echo $email;?>" class="HIco"><?php echo $fname.' '.$lname;?></a></div>
</div>
<?php
}
}
}
}
else if($options =='1')
{
	if (isset($_GET['name'])) {

	$place =$_GET['name'];
	$sql = "call search_place_by_name(?)";
	$stmt = $mysqli->prepare($sql);
	if($stmt)
	{
		$stmt->bind_param('s', $place);
		$stmt->execute();
	 	$stmt->store_result();
		$stmt->bind_result($name,$building_date,$longitude,$latitude,$pid);

	while ($stmt->fetch()) {
?>

<div class="HIco well well-lg wrap-msg" style="float: none;">
	<a href="place.php?id=<?php echo $pid;?>"><?php echo $name;?></a>
</div>
<?php
}
}
}
}
}
include "footer.php";
?>	


	