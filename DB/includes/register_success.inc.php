<?php
include_once 'db_connect.php';
include_once 'functions.php';

sec_session_start(); 
if(isset($_SESSION['email']))
{
    $nationality = filter_input(INPUT_POST, 'nationality', FILTER_SANITIZE_STRING);
    $address = filter_input(INPUT_POST, 'address', FILTER_SANITIZE_STRING);
    $phone1 = filter_input(INPUT_POST, 'phone1', FILTER_SANITIZE_STRING);
    $phone2 = filter_input(INPUT_POST, 'phone2', FILTER_SANITIZE_STRING);
    $phone3 = filter_input(INPUT_POST, 'phone3', FILTER_SANITIZE_STRING);
    $email = $_SESSION['email'];
    add_info($mysqli,$email,"","",$nationality,$address);
    add_phone($mysqli,$email,$phone1);
    add_phone($mysqli,$email,$phone2);
    add_phone($mysqli,$email,$phone3);
    header('Location: ../index.php');        
    exit();
}