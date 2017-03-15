<?php
include_once 'includes/db_connect.php';
$error = filter_input(INPUT_GET, 'err', $filter = FILTER_SANITIZE_STRING);
$sql = "call search_place_by_name(?)";
$stmt = $mysqli->prepare($sql);

if($stmt)
	{
		$place='city';
		$stmt->bind_param('s', $place);
		$stmt->execute();
	 	$stmt->store_result();
		$meta = $stmt->result_metadata(); 
		while ($field = $meta->fetch_field()) { 
   			$params[] = &$row[$field->name];
   			
   
			}
			call_user_func_array(array($stmt, 'bind_result'), $params);  
			while ($stmt->fetch()) { 
    			foreach($row as $key => $val) { 
        			$c[$key] = $val; 
        			echo $c[$key] ."<br>" ;
    			} 
   				 $hits[] = $c; 
   				 echo $hits[0]['name'].'<br>';
			} 
		$stmt->close(); 
	 } 



