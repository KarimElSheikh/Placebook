-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 14, 2017 at 12:23 AM
-- Server version: 5.6.17
-- PHP Version: 5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `tourism`
--
CREATE DATABASE IF NOT EXISTS `tourism` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `tourism`;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `accept_friend_request`(IN `email1` VARCHAR(50), IN `email2` VARCHAR(50))
BEGIN
UPDATE add_friend
SET accept = 1
WHERE sender_email = email1 and reciever_email = email2;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `accept_invitation`(
IN inRecieverEmail varchar(50),
IN inPid int
)
BEGIN
DELETE FROM invite
WHERE admin2 = inRecieverEmail and pid = inPid;
INSERT INTO manage_place VALUES (inPID, inRecieverEmail);
IF (NOT EXISTS (SELECT * FROM administrator where email = inRecieverEmail)) THEN
INSERT INTO admin (email) VALUES (inRecieverEmail);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_admin_of_a_place`(
IN inEmail varchar(50),
IN inNameOfPlace varchar(50)
)
BEGIN
IF (NOT EXISTS (SELECT * FROM administrator where email = inEmail)) THEN
INSERT INTO administrator (email) VALUES (inEmail);
END IF;
INSERT INTO place (name) VALUES (inNameOfPlace);
SET @last_id = LAST_INSERT_ID();
INSERT INTO manage_place (email, pid) VALUES (inEmail, @last_id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_a_comment`(
IN inEmail varchar(50),
IN inPID int,
IN inText varchar(100)
)
BEGIN
INSERT INTO member_comment (pid, text, email, type) VALUES (inPID, inText, inEmail, 0);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_a_hashtag`(
IN inEmail varchar(50),
IN inPID int,
IN inText varchar(50)
)
BEGIN
INSERT INTO member_comment (pid, text, email, type) VALUES (inPID, inText, inEmail, 1);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_rating_criteria`(
In inEmail varchar(50),
IN inCriteriaName varchar(50),
IN inPid int
)
BEGIN
IF (NOT EXISTS (SELECT * FROM rating_criteria WHERE pid = inPid and criteria_name = inCriteriaName)) THEN  
INSERT iNTO rating_criteria VALUES (inPid, inCriteriaName, inEmail);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `answer_question`(
IN inEmail varchar(50),
IN inQuestionNumber int,
IN inPid int,
IN inText varchar(1000)
)
BEGIN
IF (EXISTS (SELECT * FROM manage_place where email = inEmail and pid = inPid)) THEN
INSERT INTO answer (pid, question_number, text, email) VALUES (inPid, inQuestionNumber, inText, inEmail);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `avg_rating`(
IN inPID int
)
BEGIN
Select AVG(AR.rating)
From (Select pid, AVG(rate_value) as rating
	From rate
	WHERE pid = inPID
	Group by criteria_name) AR
Group by AR.pid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `check_information_of_profile`(
IN inEmail varchar(50)
)
BEGIN
SELECT firstname, lastname, email, nationality, address
FROM member
WHERE email = inEmail;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `check_phone_numbers_of_profile`(
IN inEmail varchar(50)
)
BEGIN
SELECT phone_numbers
FROM phone_number
WHERE email = inEmail;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_page`(
IN inPid int
)
BEGIN
DELETE FROM place
WHERE pid = inPid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Enter_info_of_city`(
IN inPID int,
IN inCoastalCity bit,
IN inLocation varchar (50)
)
BEGIN
IF (EXISTS (SELECT * FROM city WHERE pid = inPID)) THEN
UPDATE city
SET coastalcity = inCoastalCity , location = inLocation
WHERE pid = inPID;
ELSE
INSERT INTO city (location, coastalcity, pid) VALUES (inLocation, inCoastalCity, inPID);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Enter_info_of_facility`(
IN inPID int,
IN inDescription varchar (1000)
)
BEGIN
INSERT INTO facility (pid, description) VALUES (inPID, inDescription);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Enter_info_of_monument`(
IN inPID int,
IN inDescription varchar (1000)
)
BEGIN
IF (EXISTS (SELECT * FROM monument WHERE pid = inPID)) THEN
UPDATE monument
SET description = inDescription
WHERE pid = inPID;
ELSE
INSERT INTO monument (description, pid) VALUES (inDescription, inPID);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Enter_info_of_museum`(
IN inPID int,
IN inOpeninghours varchar (500),
IN inClosingHours varchar (500),
IN inTicketPrice decimal (9, 2)
)
BEGIN
IF (EXISTS (SELECT * FROM museum WHERE pid = inPID)) THEN
UPDATE museum
SET openinghours = inOpeninghours , closinghours = inClosingHours, ticketprice = inTicketPrice
WHERE pid = inPID;
ELSE
INSERT INTO museum (openinghours, closinghours, ticketprice, pid) VALUES (inOpeninghours, inClosingHours, inTicketPrice, inPID);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Enter_info_of_place`(
IN inPID int,
IN inName varchar(50),
IN inDate datetime,
IN inLongitude Decimal (7,2),
IN inLatitude Decimal (7,2),
IN inInfo varchar(1000)
)
BEGIN
UPDATE place
SET name = inName, building_date = inDate, longitude = inLongitude, latitude = inLatitude
WHERE pid = inPID;
IF(NOT EXISTS (SELECT * FROM information WHERE pid = inPID)) THEN
INSERT INTO information (text) VALUES (inInfo);
ELSE
UPDATE information
SET text = inInfo
WHERE pid = inPID;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Enter_info_of_restaurant`(
IN inPID int,
IN inCuisine varchar (50),
IN inStyle varchar (50)
)
BEGIN
IF (EXISTS (SELECT * FROM restaurant WHERE pid = inPID)) THEN
UPDATE restaurant
SET cuisine = inCuisine , style = inStyle
WHERE pid = inPID;
ELSE
INSERT INTO restaurant (cuisine, style, pid) VALUES (inCuisine, inStyle, inPID);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Enter_info_of_room`(
IN inPID int,
IN inType varchar(50),
IN inPrice decimal (9,2)
)
BEGIN
IF (EXISTS (SELECT * FROM room WHERE pid = inPID and type = inType)) THEN
UPDATE room
SET price = inPrice
WHERE pid = inPID and type = inType;
ELSE
INSERT INTO room (pid, type, price) VALUES (inPID, inType, inPrice);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_city_with_most_likes`()
BEGIN
SELECT C.pid, P.name as PID
FROM city C
inner join member_liked ML on C.pid = ML.pid
inner join Place P on C.pid = P.pid
Group by C.pid
Having count(*) =  (Select Max(maximum.count)
				    From(Select C2.pid, count(*) as count
				    From city C2 
				    inner join member_liked ML2 on C2.pid = ML2.pid
				    Group by C2.pid) maximum);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_hotels_sort_by_avg_room_price`()
BEGIN
Select H.pid as PID, P.name, AVG(R.price) as Price
From hotel H
inner join room R on H.pid = R.pid
inner join Place P on H.pid = P.pid
Group by  H.pid
Order by Price asc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_hotel_with_most_likes`()
BEGIN
SELECT H.pid, P.name as PID
FROM hotel H
inner join member_liked ML on H.pid = ML.pid
inner join Place P on H.pid = P.pid
Group by H.pid
Having count(*) =  (Select Max(maximum.count)
				    From(Select H2.pid, count(*) as count
				    From hotel H2 
				    inner join member_liked ML2 on H2.pid = ML2.pid
				    Group by H2.pid) maximum);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_monument_with_most_likes`()
BEGIN
SELECT M.pid, P.name
FROM monument M
inner join member_liked ML on M.pid = ML.pid
inner join Place P on M.pid = P.pid
Group by M.pid
Having count(*) =  (Select Max(maximum.count)
				    From(Select M2.pid, count(*) as count
				    From monument M2 
				    inner join member_liked ML2 on M2.pid = ML2.pid
				    Group by M2.pid) maximum);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_museums_sort_by_ticket_price`()
BEGIN
SELECT M.pid as PID, P.name , ticketprice as Price
FROM museum M
inner join Place P on M.pid = P.pid
Order by ticketprice asc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_museum_with_most_likes`()
BEGIN
SELECT M.pid, P.name
FROM museum M
inner join member_liked ML on M.pid = ML.pid
inner join Place P on M.pid = P.pid
Group by M.pid
Having count(*) =  (Select Max(maximum.count)
				    From(Select M2.pid, count(*) as count
				    From museum M2 
				    inner join member_liked ML2 on M2.pid = ML2.pid
				    Group by M2.pid) maximum);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_recommended_places`(
IN inEmail varchar(50)
)
BEGIN
SELECT T3.ID, T2.Name, AVG(Rating) as 'overall_rating'
FROM (Select distinct M3.pid as ID From(SELECT M2.member_email as Email,count(*) as likes
FROM (SELECT * FROM member_liked WHERE member_email = inEmail) M1
inner join member_liked M2 on M1.pid = M2.pid and inEmail <> M2.member_email
GROUP BY M2.member_email
ORDER BY likes DESC
LIMIT 10) T1
inner join member_liked M3 on T1.Email = M3.member_email) T3
inner join (SELECT P.pid as PID, P.name as Name, AVG(R.rate_value) as Rating
FROM place P inner join rate R on P.pid = R.pid
GROUP BY P.pid, R.criteria_name
) T2 on T2.PID = T3.ID
WHERE NOT EXISTS(SELECT * FROM visited V2 WHERE V2.pid = T3.ID and V2.member_email = inEmail)
Group By T3.ID
ORDER BY 'Overall Rating' DESC
LIMIT 5;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_restaurant_with_most_likes`()
BEGIN
SELECT R.pid, P.name
FROM restaurant R
inner join member_liked ML on R.pid = ML.pid
inner join Place P on R.pid = P.pid
Group by R.pid
Having count(*) =  (Select Max(maximum.count)
				    From(Select R2.pid, count(*) as count
				    From restaurant R2 
				    inner join member_liked ML2 on R2.pid = ML2.pid
				    Group by R2.pid) maximum);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_the_overall_rating_of_a_place`(
IN inPID int
)
BEGIN
SELECT AVG(Rating) as 'Overall Rating' FROM (
SELECT R.criteria_name, AVG(R.rate_value) as Rating
FROM place P inner join rate R on P.pid = R.pid
WHERE P.pid = inPID
GROUP BY R.criteria_name
) JustATableName;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_10_common`(
IN inEmail varchar(50)
)
BEGIN
Select M2.member_email,M.firstname, M.lastname,count(*) as likes
From (Select *
From member_liked
Where member_email = inEmail) M1
Inner join member_liked M2
On M1.pid = M2.pid and M1.member_email <> M2.member_email
Inner join member M on M.email=M2.member_email
Group By M2.member_email 
Order By likes desc
Limit 10;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `input_personal_data`(
IN inEmail varchar(50),
IN inFname varchar(50),
IN inLname varchar(50),
IN inNationality varchar(50),
IN inAddress varchar(200)
)
BEGIN
if(inFname <> '') Then
UPDATE member
Set firstname = inFname
WHERE email = inEmail;
End if;

if(inLname <> '') Then
UPDATE member
Set lastname = inLname
WHERE email = inEmail;
End if;

if(inNationality <> '') Then
UPDATE member
Set nationality = inNationality
WHERE email = inEmail;
End if;

if(inAddress <> '') Then
UPDATE member
Set address = inAddress
WHERE email = inEmail;
End if;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `input_phone_number`(
IN inEmail varchar(50),
IN inPhoneNumber varchar(50)
)
BEGIN
IF (NOT EXISTS (SELECT * FROM phone_number WHERE phone_numbers = inPhoneNumber)) THEN
INSERT INTO phone_number (email, phone_numbers) VALUES (inEmail, inPhoneNumber);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `invite_to_manage_my_place`(
IN inEmail1 varchar(50),
IN inEmail2 varchar(50),
IN inPid int
)
BEGIN
IF (EXISTS (SELECT * FROM administrator where email = inEmail1)) THEN
INSERT INTO invite VALUES (inEmail1, inEmail2, inPid);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `leave_question`(
IN inEmail varchar(50),
IN inText varchar(1000),
IN inPid int
)
BEGIN
INSERT INTO question (email, pid, text) VALUES (inEmail, inPid, inText);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `like_a_place`(
IN inEmail varchar(50),
IN inPID int
)
BEGIN
IF (EXISTS (Select * FROM visited WHERE member_email = inEmail and pid = inPID)) THEN
INSERT INTO member_liked VALUES (inEmail, inPID);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `open_images_uploaded_by`(
IN inEmail varchar(50)
)
BEGIN
SELECT image_file
FROM image
WHERE email = inEmail;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rate_a_criteria`(
IN inEmail varchar(50),
IN inCriteriaName varchar(50),
IN inPid int,
IN inValue int
)
BEGIN
IF (NOT EXISTS (SELECT * FROM rate WHERE pid = inPid and criteria_name = inCriteriaName and member_email = inEmail)) THEN  
INSERT INTO rate VALUES (inEmail, inPid, inCriteriaName, inValue);
ELSE
UPDATE rate
SET rate_value = inValue
WHERE member_email = inEmail and pid = inPid and criteria_name = inCriteriaName;
END IF; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reject_friend_request`(
	IN email1 varchar(50),
    IN email2 varchar(50)
)
BEGIN
DELETE FROM add_friend
WHERE sender_email = email1 and reciever_email = email2 and accept = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reject_invitation`(
IN inSenderEmail varchar(50),
IN inRecieverEmail varchar(50),
IN inPid int
)
BEGIN
DELETE FROM invite
WHERE admin1 = inSenderEmail and admin2 = inRecieverEmail and pid = inPid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `remove_comment`(
IN inPid int,
IN inCommentNumber int
)
BEGIN
DELETE FROM member_comment
WHERE pid = inPid and comment_number = inCommentNumber;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `remove_rating_criteria`(
IN inPid int,
IN inCriteriaName varchar(50)
)
BEGIN
DELETE FROM rating_criteria
WHERE pid = inPid and criteria_name = inCriteriaName;
DELETE FROM rate
WHERE pid = inPid and criteria_name = inCriteriaName;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `restItem`(
IN inName varchar(50)
)
Begin
Select I.name, I.itemId
From Item I 
inner join Place P on I.restaurant_id = P.pid
Where P.name = inName and I.price = (Select Min(I2.price)
									From Item I2
									Where I2.restaurant_id = P.pid);


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `search_members_by_email`(
In inputString varchar(50)
)
Begin
Select firstname, lastname, email, nationality, address
From member
Where email like (CONCAT('%',inputString,'%'));
End$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `search_members_by_name`(
In inputString varchar(100)
)
Begin
Select firstname, lastname, email, nationality, address
From member
Where (CONCAT(firstname,' ',lastname)) like (CONCAT('%',inputString,'%'));
End$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `search_place_by_name`(
IN inputString varchar(50)
)
Begin
Select name, building_date, longitude, latitude,pid
From place
Where name like (CONCAT('%',inputString,'%'));
End$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `send_email_to_be_admin_of_a_place`(
IN inEmail varchar(50),
IN inPid int,
IN sysAdminEmail varchar(50),
IN inText varchar(1000)
)
BEGIN
IF (EXISTS (SELECT * FROM administrator where email = inEmail)) THEN
INSERT INTO contact_to_add_place (email1, pid, email2, message) VALUES (inEmail, inPid, sysAdminEmail, inText);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `send_friendship_request`(
IN inEmail varchar(50),
IN inEmail2 varchar(50)
)
BEGIN
IF (NOT EXISTS (SELECT * FROM add_friend WHERE sender_email = inEmail and reciever_email = inEmail2 or sender_email = inEmail2 and reciever_email = inEmail)) THEN
Insert Into add_friend (sender_email, reciever_email)  Values (inEmail, inEmail2);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `send_message`(
	IN inText varchar (1000),
    IN inEmail1 varchar(50),
    IN inEmail2 varchar(50)
)
BEGIN
IF (EXISTS (SELECT * FROM message WHERE inEmail1 = sender_email and inEmail2 = reciever_email
or inEmail1 = reciever_email and inEmail2 = sender_email)) THEN
SELECT @x := MAX(message_number) + 1 FROM message WHERE inEmail1 = sender_email and inEmail2 = reciever_email
or inEmail1 = reciever_email and inEmail2 = sender_email;
INSERT INTO message (sender_email, reciever_email, message_number, message) VALUES (inEmail1, inEmail2, @x, inText);
ELSE
INSERT INTO message (sender_email, reciever_email, message_number, message) VALUES (inEmail1, inEmail2, 1, inText);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sign_up`(IN `inEmail` VARCHAR(50), IN `inPass` VARCHAR(500))
Begin
IF (NOT EXISTS (Select * FROM member WHERE email = inEmail)) THEN
	INSERT INTO member(email, password) VALUES (inEmail, inPass);
ELSE
	SELECT '';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `upload_image`(
IN inEmail varchar(50),
IN inImageFile varchar(200),
IN inPID int
)
BEGIN
IF (EXISTS (Select * FROM member_liked WHERE member_email = inEmail and pid = inPID)
or EXISTS (Select * FROM rate WHERE member_email = inEmail and pid = inPID)) THEN
INSERT INTO image (email, image_file, pid) VALUES (inEmail, inImageFile, inPID);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `upload_professional_photo`(
IN inEmail varchar(50),
IN inImageFile varchar(200),
IN inPid int
)
BEGIN
IF (EXISTS (SELECT * FROM administrator where email = inEmail)) THEN
INSERT INTO professional_picture (email, image_file, pid) VALUES (inEmail, inImageFile, inPid);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_answers_of_a_question`(
IN inPID int,
inQuestionNumber int
)
BEGIN
Select M.firstname, M.lastname, M.email, A.text
From answer A
inner join member M on A.email = M.email
WHERE A.pid = inPID and A.question_number = inQuestionNumber;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_cities_according_to_rating_criteria`(
IN inCriteriaName varchar(50)
)
BEGIN
SELECT C.pid, P.name, AVG(R.rate_value) as Rating
FROM city C inner join rate R on C.pid = R.pid
inner join place P on C.pid = P.pid
WHERE criteria_name = inCriteriaName
Group By C.pid
ORDER BY Rating DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_comments`(
IN inPID int
)
BEGIN
Select M.firstname, M.lastname, M.email, MC.text
From member_comment MC
inner join member M on MC.email = M.email
WHERE MC.pid = inPID and MC.type = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_friends`(
IN inEmail varchar(50)
)
BEGIN
	SELECT M1.firstname as firstname, M1.lastname as lastname, AF1.reciever_email as email
    FROM add_friend AF1
    inner join member M1 on AF1.reciever_email = M1.email
    WHERE sender_email = inEmail and accept = 1
    UNION
	SELECT M2.firstname as firstname, M2.lastname as lastname, AF2.sender_email as email
    FROM add_friend AF2
    inner join member M2 on AF2.sender_email = M2.email
    WHERE reciever_email = inEmail and accept = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_hashtags`(
IN inPID int
)
BEGIN
Select M.firstname, M.lastname, M.email, MC.text
From member_comment MC
inner join member M on MC.email = M.email
WHERE MC.pid = inPID and MC.type = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_hotels_according_to_rating_criteria`(
IN inCriteriaName varchar(50)
)
BEGIN
SELECT H.pid, P.name, AVG(R.rate_value) as Rating
FROM hotel H inner join rate R on H.pid = R.pid
inner join place P on H.pid = P.pid
WHERE criteria_name = inCriteriaName
Group By H.pid
ORDER BY Rating DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_information`(
IN inPID int
)
BEGIN
IF (EXISTS (SELECT * FROM hotel WHERE inPID = pid)) THEN
Select P.name, P.building_date, P.longitude, P.latitude, 'Hotel' as type, I.text
From place P inner join Information I on P.pid = I.pid
inner join hotel H on P.pid = H.pid
WHERE P.pid = inPID;
ELSEIF (EXISTS (SELECT * FROM museum WHERE inPID = pid)) THEN
Select P.name, P.building_date, P.longitude, P.latitude, 'Museum' as type, M.openinghours, M.closinghours, M.ticketprice, I.text
From place P inner join Information I on P.pid = I.pid
inner join museum M on P.pid = M.pid
WHERE P.pid = inPID;
ELSEIF (EXISTS (SELECT * FROM monument WHERE inPID = pid)) THEN
Select P.name, P.building_date, P.longitude, P.latitude, 'Monument' as type, M.description, I.text
From place P inner join Information I on P.pid = I.pid
inner join monument M on P.pid = M.pid
WHERE P.pid = inPID;
ELSEIF (EXISTS (SELECT * FROM city WHERE inPID = pid)) THEN
Select P.name, P.building_date, P.longitude, P.latitude, 'City' as type, C.location, C.coastalcity, I.text
From place P inner join Information I on P.pid = I.pid
inner join city C on P.pid = C.pid
WHERE P.pid = inPID;
ELSE
Select P.name, P.building_date, P.longitude, P.latitude, 'Other' as type, I.text
From place P inner join Information I on P.pid = I.pid
WHERE P.pid = inPID;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_invites`(
IN inEmail varchar(50)
)
BEGIN
SELECT I.admin1, P.pid, P.name ,M.firstname,M.lastname
FROM invite I
inner join place P on I.pid = P.pid
inner join member M on M.email=I.admin1
WHERE I.admin2 = inEmail;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_monuments_according_to_rating_criteria`(
IN inCriteriaName varchar(50)
)
BEGIN
SELECT M.pid, P.name, AVG(R.rate_value) as Rating
FROM monument M inner join rate R on M.pid = R.pid
inner join place P on M.pid = P.pid
WHERE criteria_name = inCriteriaName
Group By M.pid
ORDER BY Rating DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_museums_according_to_rating_criteria`(
IN inCriteriaName varchar(50)
)
BEGIN
SELECT M.pid, P.name, AVG(R.rate_value) as Rating
FROM museum M inner join rate R on M.pid = R.pid
inner join place P on M.pid = P.pid
WHERE criteria_name = inCriteriaName
Group By M.pid
ORDER BY Rating DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_pending_incoming_requests`(
IN inEmail varchar(50)
)
BEGIN
	SELECT sender_email,m.firstname,m.lastname
    FROM add_friend AF
    INNER JOIN member M
    on M.email = AF.sender_email
    Where reciever_email = inEmail and accept = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_pending_outgoing_requests`(
IN inEmail varchar(50)
)
BEGIN
	SELECT reciever_email
    FROM add_friend
    Where sender_email = inEmail and accept = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_places_managed_by_member`(
IN inEmail varchar(50)
)
BEGIN

SELECT P.pid, P.name
FROM manage_place MP
inner join place P on MP.pid = P.pid
WHERE MP.email = inEmail;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_places_visited_by_friends`(
IN inEmail varchar(50)
)
BEGIN
SELECT DISTINCT P.pid, P.name
FROM place P
inner join visited V on P.pid = V.pid
inner join add_friend AF on V.member_email = AF.sender_email or V.member_email = AF.reciever_email
WHERE V.member_email <> inEmail and AF.accept = 1 and (AF.sender_email = inEmail or AF.reciever_email = inEmail);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_questions`(
IN inPID int
)
BEGIN
Select M.firstname, M.lastname, M.email, Q.question_number, Q.text
From question Q
inner join member M on Q.email = M.email
WHERE Q.pid = inPID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_questions_in_my_places`(
IN inEmail varchar(50)
)
BEGIN
IF (EXISTS (SELECT * FROM administrator where email = inEmail)) THEN
SELECT P.pid, P.name, M.firstname, M.lastname, M.email, Q.text
FROM manage_place MP
inner join place P on MP.pid = P.pid
inner join question Q on MP.pid = Q.pid
inner join member M on Q.email = M.email
WHERE MP.email = inEmail;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_rate_value_of_rating_criterias`(
IN inPID int
)
BEGIN
Select criteria_name, AVG(rate_value) as average_rating
From rate
WHERE pid = inPID
Group by criteria_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_rating_criterias_of_a_page`(
IN inPID int
)
BEGIN
Select RC.criteria_name, M.firstname, M.lastname, M.email
From rating_criteria RC inner join member M on RC.member_email = M.email
WHERE RC.pid = inPID
Group by RC.criteria_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_restaurants_according_to_rating_criteria`(
IN inCriteriaName varchar(50)
)
BEGIN
SELECT R.pid, P.name, AVG(R2.rate_value) as Rating
FROM restaurant R inner join rate R2 on R.pid = R2.pid
inner join place P on R.pid = P.pid
WHERE criteria_name = inCriteriaName
Group By R.pid
ORDER BY Rating DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_thread`(
    IN inEmail1 varchar(50),
    IN inEmail2 varchar(50)
)
BEGIN
SELECT M1.firstname, M1.lastname, M.message 
FROM message M
inner join member M1 on M.sender_email = M1.email
inner join member M2 on M.reciever_email = M2.email
WHERE (M.sender_email = inEmail1 and M.reciever_email = inEmail2) or (M.reciever_email = inEmail1 and M.sender_email = inEmail2)
ORDER BY message_number;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_threads`(
    IN inEmail varchar(50)
)
BEGIN
SELECT DISTINCT M1.firstname, M1.lastname, M1.email
FROM message M
inner join member M1 on M.sender_email = M1.email
WHERE M.reciever_email = inEmail
UNION
SELECT DISTINCT M2.firstname, M2.lastname, M2.email
From message M
inner join member M2 on M.reciever_email = M2.email
WHERE M.sender_email = inEmail;
End$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_visited_places`(
	IN inEmail varchar(50)
)
BEGIN
SELECT P.pid, P.name
FROM visited V
inner join place P on V.pid = P.pid
WHERE V.member_email = inEmail;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `add_friend`
--

CREATE TABLE IF NOT EXISTS `add_friend` (
  `sender_email` varchar(50) NOT NULL DEFAULT '',
  `reciever_email` varchar(50) NOT NULL DEFAULT '',
  `accept` bit(1) DEFAULT b'0',
  PRIMARY KEY (`reciever_email`,`sender_email`),
  KEY `sender_email` (`sender_email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `add_friend`
--

INSERT INTO `add_friend` (`sender_email`, `reciever_email`, `accept`) VALUES
('b@b.com', 'a.n.s.a.r.y@hotmail.com', b'0'),
('a.n.s.a.r.y@hotmail.com', 'ansary510@gmail.com', b'1'),
('blueberry@yahoo.com', 'ansary510@gmail.com', b'0'),
('velilog@db.dmet', 'ansary510@gmail.com', b'0'),
('verilog@databases.dmet', 'ansary510@gmail.com', b'0'),
('a.n.s.a.r.y@hotmail.com', 'bagar80@gmail.com', b'0'),
('verilog@databases.dmet', 'bagar80@gmail.com', b'0'),
('verilog@databases.dmet', 'blueberry@yahoo.com', b'0'),
('ansary510@gmail.com', 'dragon15@gmail.com', b'1'),
('verilog@databases.dmet', 'kaltaz80@gmail.com', b'0'),
('a.n.s.a.r.y@hotmail.com', 'khalid.abdulnasser@gmail.com', b'0'),
('verilog@databases.dmet', 'khalid2355@yahoo.com', b'0'),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', b'0'),
('ansary510@gmail.com', 'kimobasha3000@hotmail.com', b'0'),
('verilog@databases.dmet', 'kimobasha3000@hotmail.com', b'0'),
('verilog@databases.dmet', 'lionofthedesert@yahoo.com', b'0'),
('ansary510@gmail.com', 'princesslamia@hotmail.com', b'1'),
('kimobasha3000@hotmail.com', 'slim.abdennadher@guc.edu.eg', b'0'),
('marwa@hotmail.com', 'verilog@databases.dmet', b'0'),
('ziadelwa7sh@hotmail.com', 'verilog@databases.dmet', b'1');

-- --------------------------------------------------------

--
-- Table structure for table `administrator`
--

CREATE TABLE IF NOT EXISTS `administrator` (
  `email` varchar(50) NOT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `administrator`
--

INSERT INTO `administrator` (`email`) VALUES
('a.n.s.a.r.y@hotmail.com'),
('a@a.com'),
('ansary510@gmail.com'),
('b@bb.com'),
('khalid2355@yahoo.com'),
('kimobasha3000@hotmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `answer`
--

CREATE TABLE IF NOT EXISTS `answer` (
  `pid` int(11) NOT NULL DEFAULT '0',
  `question_number` int(11) NOT NULL DEFAULT '0',
  `answer_number` int(11) NOT NULL DEFAULT '0',
  `text` varchar(1000) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`pid`,`question_number`,`answer_number`),
  KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `answer`
--

INSERT INTO `answer` (`pid`, `question_number`, `answer_number`, `text`, `email`) VALUES
(1, 1, 1, '50 bucks', 'kimobasha3000@hotmail.com'),
(1, 1, 2, 'scscdsc', 'bagar80@gmail.com'),
(1, 2, 1, 'blabla', 'a.n.s.a.r.y@hotmail.com');

--
-- Triggers `answer`
--
DROP TRIGGER IF EXISTS `answer_before_ins_trig`;
DELIMITER //
CREATE TRIGGER `answer_before_ins_trig` BEFORE INSERT ON `answer`
 FOR EACH ROW begin
declare v_id int unsigned default 0;
  select next_table_id + 1 into v_id from question where pid = new.pid and question_number = new.question_number;
  set new.answer_number = v_id;
  update question set next_table_id = v_id where pid = new.pid and question_number = new.question_number;
end
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `city`
--

CREATE TABLE IF NOT EXISTS `city` (
  `pid` int(11) NOT NULL,
  `location` varchar(50) DEFAULT NULL,
  `coastalcity` bit(1) DEFAULT NULL,
  PRIMARY KEY (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `city`
--

INSERT INTO `city` (`pid`, `location`, `coastalcity`) VALUES
(9, 'Egypt', b'0'),
(10, 'Egypt', b'1'),
(11, 'USA', b'0'),
(12, 'Germany', b'0');

-- --------------------------------------------------------

--
-- Table structure for table `contact_to_add_place`
--

CREATE TABLE IF NOT EXISTS `contact_to_add_place` (
  `email1` varchar(50) NOT NULL DEFAULT '',
  `pid` int(11) NOT NULL DEFAULT '0',
  `email2` varchar(50) DEFAULT NULL,
  `message` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`email1`,`pid`),
  KEY `pid` (`pid`),
  KEY `email2` (`email2`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `contact_to_add_place`
--

INSERT INTO `contact_to_add_place` (`email1`, `pid`, `email2`, `message`) VALUES
('a.n.s.a.r.y@hotmail.com', 17, 'kimobasha3000@hotmail.com', 'zift '),
('b@bb.com', 1, 'kimobasha3000@hotmail.com', 'zift ');

-- --------------------------------------------------------

--
-- Table structure for table `facility`
--

CREATE TABLE IF NOT EXISTS `facility` (
  `pid` int(11) NOT NULL DEFAULT '0',
  `fid` int(11) NOT NULL DEFAULT '0',
  `description` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`pid`,`fid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `facility`
--
DROP TRIGGER IF EXISTS `facility_before_ins_trig`;
DELIMITER //
CREATE TRIGGER `facility_before_ins_trig` BEFORE INSERT ON `facility`
 FOR EACH ROW begin
declare v_id int unsigned default 0;
  select next_table_id + 1 into v_id from hotel where pid = new.pid;
  set new.fid = v_id;
  update hotel set next_table_id = v_id where pid = new.pid;
end
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `hotel`
--

CREATE TABLE IF NOT EXISTS `hotel` (
  `pid` int(11) NOT NULL,
  `next_table_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `hotel`
--

INSERT INTO `hotel` (`pid`, `next_table_id`) VALUES
(3, 0),
(4, 0),
(5, 0);

-- --------------------------------------------------------

--
-- Table structure for table `image`
--

CREATE TABLE IF NOT EXISTS `image` (
  `email` varchar(50) DEFAULT NULL,
  `pid` int(11) NOT NULL DEFAULT '0',
  `number` int(11) NOT NULL DEFAULT '0',
  `image_file` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`pid`,`number`),
  KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `image`
--

INSERT INTO `image` (`email`, `pid`, `number`, `image_file`) VALUES
('kimobasha3000@hotmail.com', 1, 1, '1.jpg'),
('kimobasha3000@hotmail.com', 1, 2, '1.jpg'),
('kimobasha3000@hotmail.com', 1, 3, '1.jpg'),
('a.n.s.a.r.y@hotmail.com', 1, 4, '1.jpg'),
('a.n.s.a.r.y@hotmail.com', 2, 1, '66b705da03962841ed19f0b6234970391478c43441797c08d0339f531d56f6c1.jpg');

--
-- Triggers `image`
--
DROP TRIGGER IF EXISTS `image_before_ins_trig`;
DELIMITER //
CREATE TRIGGER `image_before_ins_trig` BEFORE INSERT ON `image`
 FOR EACH ROW begin
declare v_id int unsigned default 0;
  select next_table_id3 + 1 into v_id from place where pid = new.pid;
  set new.number = v_id;
  update place set next_table_id3 = v_id where pid = new.pid;
end
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `information`
--

CREATE TABLE IF NOT EXISTS `information` (
  `pid` int(11) NOT NULL,
  `text` varchar(1000) DEFAULT NULL,
  `admin_email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`pid`),
  KEY `admin_email` (`admin_email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `information`
--

INSERT INTO `information` (`pid`, `text`, `admin_email`) VALUES
(1, 'A very good place to visit', 'kimobasha3000@hotmail.com'),
(2, 'A very good place to visit', 'ansary510@gmail.com'),
(3, 'A very good place to visit', 'kimobasha3000@hotmail.com'),
(4, 'ggggggg', 'kimobasha3000@hotmail.com'),
(5, 'A very good place to visit', 'kimobasha3000@hotmail.com'),
(6, 'A very good place to visit', 'ansary510@gmail.com'),
(7, 'A very good place to visit', 'kimobasha3000@hotmail.com'),
(8, 'A very good place to visit', 'kimobasha3000@hotmail.com'),
(9, 'A very good place to visit', 'ansary510@gmail.com'),
(10, 'A very good place to visit', 'ansary510@gmail.com'),
(11, 'A very good place to visit', 'ansary510@gmail.com'),
(12, 'A very good place to visit', 'khalid2355@yahoo.com'),
(13, 'A very good place to visit', 'khalid2355@yahoo.com'),
(14, 'A very good place to visit', 'khalid2355@yahoo.com'),
(15, 'ggggggg', 'kimobasha3000@hotmail.com'),
(16, 'A very good place to visit', 'khalid2355@yahoo.com'),
(17, 'A very good place to visit', 'khalid2355@yahoo.com'),
(18, 'A very good place to visit', 'khalid2355@yahoo.com'),
(19, 'A very good place to visit', 'khalid2355@yahoo.com'),
(20, 'ggggggg', 'ansary510@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `invite`
--

CREATE TABLE IF NOT EXISTS `invite` (
  `admin1` varchar(50) NOT NULL DEFAULT '',
  `admin2` varchar(50) NOT NULL DEFAULT '',
  `pid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`admin1`,`admin2`,`pid`),
  KEY `admin2` (`admin2`),
  KEY `pid` (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `invite`
--

INSERT INTO `invite` (`admin1`, `admin2`, `pid`) VALUES
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 10),
('ansary510@gmail.com', 'kimobasha3000@hotmail.com', 10),
('ansary510@gmail.com', 'kimobasha3000@hotmail.com', 11);

-- --------------------------------------------------------

--
-- Table structure for table `manage_place`
--

CREATE TABLE IF NOT EXISTS `manage_place` (
  `pid` int(11) NOT NULL DEFAULT '0',
  `email` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`pid`,`email`),
  KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `manage_place`
--

INSERT INTO `manage_place` (`pid`, `email`) VALUES
(1, 'a.n.s.a.r.y@hotmail.com'),
(2, 'a.n.s.a.r.y@hotmail.com'),
(9, 'a.n.s.a.r.y@hotmail.com'),
(10, 'a.n.s.a.r.y@hotmail.com'),
(1, 'a@a.com'),
(2, 'ansary510@gmail.com'),
(6, 'ansary510@gmail.com'),
(9, 'ansary510@gmail.com'),
(10, 'ansary510@gmail.com'),
(11, 'ansary510@gmail.com'),
(20, 'ansary510@gmail.com'),
(12, 'khalid2355@yahoo.com'),
(13, 'khalid2355@yahoo.com'),
(14, 'khalid2355@yahoo.com'),
(16, 'khalid2355@yahoo.com'),
(17, 'khalid2355@yahoo.com'),
(18, 'khalid2355@yahoo.com'),
(19, 'khalid2355@yahoo.com'),
(1, 'kimobasha3000@hotmail.com'),
(3, 'kimobasha3000@hotmail.com'),
(4, 'kimobasha3000@hotmail.com'),
(5, 'kimobasha3000@hotmail.com'),
(7, 'kimobasha3000@hotmail.com'),
(8, 'kimobasha3000@hotmail.com'),
(15, 'kimobasha3000@hotmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `member`
--

CREATE TABLE IF NOT EXISTS `member` (
  `email` varchar(50) NOT NULL,
  `password` varchar(300) NOT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `address` varchar(200) DEFAULT NULL,
  `nationality` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `member`
--

INSERT INTO `member` (`email`, `password`, `firstname`, `lastname`, `address`, `nationality`) VALUES
('a.n.s.a.r.y@hotmail.com', '1a66ef70c3c36721412958c62ffaeaae9c9ec9721e915f0838dd1a5e64afe6e3a0fee6eafb949e32dc983466f2995ed50eee648c637310797a7d1693c7fb41d6', 'Mohammed', 'El-ansary', ' ', ' '),
('a@a.com', 'ee02b3dd5b2c06e4e61888d141998abac194d57692f77ae7a28d748fdf9b9f28f756d980687f7290f1306857edf3fe01f8ebf4626880d49a33e029399cb2d700', 'Mohammed', 'El-Ansary', 'sherton', 'masry'),
('ansary510@gmail.com', '195827346', 'Mohamed', 'El-Ansary', 'Giza, Fakhry Mahmoud st., 30', 'Egyptian'),
('b@b.com', 'a3f5893996a1e3fae0aff70198025d3b8a90b41eda39f917aadcaaae77ec595932c4a22863e030db9b48692ed0a230914a905a324150874572010e575ffc9b70', 'b', 'b', NULL, NULL),
('b@bb.com', 'a3f5893996a1e3fae0aff70198025d3b8a90b41eda39f917aadcaaae77ec595932c4a22863e030db9b48692ed0a230914a905a324150874572010e575ffc9b70', 'b', 'b', NULL, NULL),
('bagar80@gmail.com', 'Ahmedtyson', 'Ahmed', 'Aly', 'Cairo, ElTagamo3, EL Shaheed Ahmed Hamdy st., 12 ', 'Egyptian'),
('barbar@hotmail.com', 'blackzwhitea', 'Joe', 'Saied', 'London, Eagles, Abraham Lincoln st., 12 ', 'British'),
('blueberry@yahoo.com', 'midomashakel', 'Andrew', 'Magdy', 'Cairo, Heliopolis, El Khalifa El Maamoon st., 13', 'Egyptian'),
('dragon15@gmail.com', 'sajguids', 'Marc', 'Samuel', 'Cairo, ElTagamo3, Ibrahim st., 5 ', 'Egyptian'),
('fg@ddsfs.com', '27cbfa54d12d869622becfd633785436aed210dbdb38b2b82d3f10656a408a13b30ef138927f4cc56e04cca42635e0a0f0e5b0290833f27cec012f56050910e5', 'cxvf', 'gerge', NULL, NULL),
('hossam.saraya@gmail.com', 'd3d9e793dda31b1676adba286919e71526fd634d1cfb65b6b6ef4f45a13616f98b64d53ae9295bb01581b6afeb701daa7a84c1727edc602be8c2231030932bc8', 'hossam', 'saraya', '15 mokhtar St. manial - roda', 'Egyptian'),
('kaltaz80@gmail.com', 'sabjab3', 'Mathew', 'James', 'London, Flower, Downtown st., 12 ', 'British'),
('khalid.abdulnasser@gmail.com', 'entakeda7omar', 'Khalid', 'Abdulnasser', 'Cairo, ElTagamo3, abdelhamid st., 5 ', 'Egyptian'),
('khalid2355@yahoo.com', 'zawba3a', 'Khalid', 'Jamal', 'Cairo, New Cairo, 67', 'Kuwaitian'),
('kimobasha3000@hotmail.com', 'abcja', 'Karim', 'El-Sheikh', 'Alexandria, Semouha, El Mostashar Mahmoud El Attar st., 20', 'Egyptian'),
('lionofthedesert@yahoo.com', 'uu7777uuu', 'Mazen', 'Gawad', 'Vienna, Fahlen st., 5 ', 'Netherlandic'),
('marwa@hotmail.com', 'kungfupanda', 'Marwa', 'Baher', 'New York, Bones st., 79 ', 'American'),
('princesslamia@hotmail.com', 'LOLlollol5', 'Lamia', 'Serag', 'Frankfut, Kaufer st., 5 ', 'German'),
('s@s.com', 'f18f901189bacfede4e6db238b5ca15788140b7ade94ee66d846b002aba70e77656cf16f1b27d589b98986396eb026aa6ef9e7843adadfab1aa5c8469728ea4b', 'Salma', 'Ansary', NULL, NULL),
('slim.abdennadher@guc.edu.eg', 'balabizoo', 'Slim', 'Abdennadher', 'Cairo, Rehab, 3 st. ,46 ', 'Tunisian'),
('superhesham3@yahoo.com', 'jaja1x', 'Hesham', 'Saddam', 'Port Said, El Mahalla el kobra, 17', 'Egyptian'),
('velilog@db.dmet', 'ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a', NULL, NULL, NULL, NULL),
('verilog@databases.dmet', 'ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f', 'ans', 'ans', NULL, NULL),
('ziadelwa7sh@hotmail.com', 'lafajag', 'Ziad', 'Hassan', 'Cairo, Hussien Kamel, 70', 'Egyptian');

-- --------------------------------------------------------

--
-- Table structure for table `member_comment`
--

CREATE TABLE IF NOT EXISTS `member_comment` (
  `pid` int(11) NOT NULL DEFAULT '0',
  `comment_number` int(11) NOT NULL DEFAULT '0',
  `type` bit(1) DEFAULT NULL,
  `text` varchar(100) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`pid`,`comment_number`),
  KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `member_comment`
--

INSERT INTO `member_comment` (`pid`, `comment_number`, `type`, `text`, `email`) VALUES
(1, 1, b'0', 'I liked it. It was very cool!', 'superhesham3@yahoo.com'),
(1, 2, b'1', '#BestHolidayEver', 'superhesham3@yahoo.com'),
(1, 3, b'0', 'hi', 'superhesham3@yahoo.com'),
(1, 4, b'0', 'hahahha', 'a@a.com'),
(1, 5, b'1', 'sdsdsds', 'a.n.s.a.r.y@hotmail.com'),
(1, 6, b'1', 'ggggggggggggg', 'a.n.s.a.r.y@hotmail.com'),
(1, 7, b'1', 'sssssssssssssssssssssssssssssss', 'a.n.s.a.r.y@hotmail.com'),
(1, 8, b'0', 'test', 'hossam.saraya@gmail.com'),
(1, 9, b'0', '<script>alert(''xss'')</script>', 'hossam.saraya@gmail.com'),
(1, 10, b'0', '<img onerror="alert(1)" src=x>', 'hossam.saraya@gmail.com'),
(1, 11, b'0', '<script>alert(''xss'')</script>', 'hossam.saraya@gmail.com'),
(1, 12, b'0', '<script>alert(''xss'')</script>', 'hossam.saraya@gmail.com'),
(9, 1, b'0', 'rere', 'a.n.s.a.r.y@hotmail.com');

--
-- Triggers `member_comment`
--
DROP TRIGGER IF EXISTS `member_comment_before_ins_trig`;
DELIMITER //
CREATE TRIGGER `member_comment_before_ins_trig` BEFORE INSERT ON `member_comment`
 FOR EACH ROW begin
declare v_id int unsigned default 0;
  select next_table_id2 + 1 into v_id from place where pid = new.pid;
  set new.comment_number = v_id;
  update place set next_table_id2 = v_id where pid = new.pid;
end
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `member_liked`
--

CREATE TABLE IF NOT EXISTS `member_liked` (
  `member_email` varchar(50) NOT NULL DEFAULT '',
  `pid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`member_email`,`pid`),
  KEY `pid` (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `member_liked`
--

INSERT INTO `member_liked` (`member_email`, `pid`) VALUES
('b@bb.com', 1),
('barbar@hotmail.com', 1),
('dragon15@gmail.com', 1),
('kaltaz80@gmail.com', 1),
('khalid.abdulnasser@gmail.com', 1),
('khalid2355@yahoo.com', 1),
('kimobasha3000@hotmail.com', 1),
('lionofthedesert@yahoo.com', 1),
('marwa@hotmail.com', 1),
('slim.abdennadher@guc.edu.eg', 1),
('a.n.s.a.r.y@hotmail.com', 2),
('ansary510@gmail.com', 2),
('bagar80@gmail.com', 2),
('barbar@hotmail.com', 2),
('dragon15@gmail.com', 2),
('kaltaz80@gmail.com', 2),
('khalid.abdulnasser@gmail.com', 2),
('kimobasha3000@hotmail.com', 2),
('lionofthedesert@yahoo.com', 2),
('slim.abdennadher@guc.edu.eg', 2),
('superhesham3@yahoo.com', 2),
('ansary510@gmail.com', 3),
('barbar@hotmail.com', 3),
('blueberry@yahoo.com', 3),
('dragon15@gmail.com', 3),
('kaltaz80@gmail.com', 3),
('kimobasha3000@hotmail.com', 3),
('marwa@hotmail.com', 3),
('princessLamia@hotmail.com', 3),
('s@s.com', 3),
('slim.abdennadher@guc.edu.eg', 3),
('ansary510@gmail.com', 4),
('bagar80@gmail.com', 4),
('kaltaz80@gmail.com', 4),
('khalid.abdulnasser@gmail.com', 4),
('khalid2355@yahoo.com', 4),
('lionofthedesert@yahoo.com', 4),
('marwa@hotmail.com', 4),
('princessLamia@hotmail.com', 4),
('slim.abdennadher@guc.edu.eg', 4),
('bagar80@gmail.com', 5),
('barbar@hotmail.com', 5),
('khalid2355@yahoo.com', 5),
('princessLamia@hotmail.com', 5),
('slim.abdennadher@guc.edu.eg', 5),
('ansary510@gmail.com', 6),
('barbar@hotmail.com', 6),
('dragon15@gmail.com', 6),
('kaltaz80@gmail.com', 6),
('khalid.abdulnasser@gmail.com', 6),
('khalid2355@yahoo.com', 6),
('lionofthedesert@yahoo.com', 6),
('marwa@hotmail.com', 6),
('slim.abdennadher@guc.edu.eg', 6),
('ansary510@gmail.com', 7),
('bagar80@gmail.com', 7),
('barbar@hotmail.com', 7),
('dragon15@gmail.com', 7),
('kaltaz80@gmail.com', 7),
('khalid.abdulnasser@gmail.com', 7),
('kimobasha3000@hotmail.com', 7),
('lionofthedesert@yahoo.com', 7),
('slim.abdennadher@guc.edu.eg', 7),
('ansary510@gmail.com', 8),
('barbar@hotmail.com', 8),
('blueberry@yahoo.com', 8),
('dragon15@gmail.com', 8),
('kaltaz80@gmail.com', 8),
('kimobasha3000@hotmail.com', 8),
('marwa@hotmail.com', 8),
('princessLamia@hotmail.com', 8),
('slim.abdennadher@guc.edu.eg', 8),
('a.n.s.a.r.y@hotmail.com', 9),
('ansary510@gmail.com', 9),
('bagar80@gmail.com', 9),
('hossam.saraya@gmail.com', 9),
('kaltaz80@gmail.com', 9),
('khalid.abdulnasser@gmail.com', 9),
('khalid2355@yahoo.com', 9),
('lionofthedesert@yahoo.com', 9),
('marwa@hotmail.com', 9),
('princessLamia@hotmail.com', 9),
('slim.abdennadher@guc.edu.eg', 9),
('bagar80@gmail.com', 10),
('barbar@hotmail.com', 10),
('khalid2355@yahoo.com', 10),
('princessLamia@hotmail.com', 10),
('slim.abdennadher@guc.edu.eg', 10),
('ansary510@gmail.com', 11),
('barbar@hotmail.com', 11),
('dragon15@gmail.com', 11),
('kaltaz80@gmail.com', 11),
('khalid.abdulnasser@gmail.com', 11),
('khalid2355@yahoo.com', 11),
('kimobasha3000@hotmail.com', 11),
('lionofthedesert@yahoo.com', 11),
('marwa@hotmail.com', 11),
('slim.abdennadher@guc.edu.eg', 11),
('ansary510@gmail.com', 12),
('bagar80@gmail.com', 12),
('barbar@hotmail.com', 12),
('dragon15@gmail.com', 12),
('kaltaz80@gmail.com', 12),
('khalid.abdulnasser@gmail.com', 12),
('kimobasha3000@hotmail.com', 12),
('lionofthedesert@yahoo.com', 12),
('slim.abdennadher@guc.edu.eg', 12),
('ansary510@gmail.com', 13),
('barbar@hotmail.com', 13),
('blueberry@yahoo.com', 13),
('dragon15@gmail.com', 13),
('kaltaz80@gmail.com', 13),
('kimobasha3000@hotmail.com', 13),
('marwa@hotmail.com', 13),
('princessLamia@hotmail.com', 13),
('slim.abdennadher@guc.edu.eg', 13),
('ansary510@gmail.com', 14),
('bagar80@gmail.com', 14),
('kaltaz80@gmail.com', 14),
('khalid.abdulnasser@gmail.com', 14),
('khalid2355@yahoo.com', 14),
('lionofthedesert@yahoo.com', 14),
('marwa@hotmail.com', 14),
('princessLamia@hotmail.com', 14),
('slim.abdennadher@guc.edu.eg', 14),
('bagar80@gmail.com', 15),
('barbar@hotmail.com', 15),
('khalid2355@yahoo.com', 15),
('princessLamia@hotmail.com', 15),
('slim.abdennadher@guc.edu.eg', 15),
('ansary510@gmail.com', 16),
('barbar@hotmail.com', 16),
('dragon15@gmail.com', 16),
('kaltaz80@gmail.com', 16),
('khalid.abdulnasser@gmail.com', 16),
('khalid2355@yahoo.com', 16),
('kimobasha3000@hotmail.com', 16),
('lionofthedesert@yahoo.com', 16),
('marwa@hotmail.com', 16),
('slim.abdennadher@guc.edu.eg', 16),
('a.n.s.a.r.y@hotmail.com', 17),
('ansary510@gmail.com', 17),
('bagar80@gmail.com', 17),
('barbar@hotmail.com', 17),
('dragon15@gmail.com', 17),
('fg@ddsfs.com', 17),
('kaltaz80@gmail.com', 17),
('khalid.abdulnasser@gmail.com', 17),
('kimobasha3000@hotmail.com', 17),
('lionofthedesert@yahoo.com', 17),
('slim.abdennadher@guc.edu.eg', 17),
('ansary510@gmail.com', 18),
('barbar@hotmail.com', 18),
('blueberry@yahoo.com', 18),
('dragon15@gmail.com', 18),
('kaltaz80@gmail.com', 18),
('kimobasha3000@hotmail.com', 18),
('marwa@hotmail.com', 18),
('princessLamia@hotmail.com', 18),
('slim.abdennadher@guc.edu.eg', 18),
('ansary510@gmail.com', 19),
('bagar80@gmail.com', 19),
('kaltaz80@gmail.com', 19),
('khalid.abdulnasser@gmail.com', 19),
('khalid2355@yahoo.com', 19),
('lionofthedesert@yahoo.com', 19),
('marwa@hotmail.com', 19),
('princessLamia@hotmail.com', 19),
('slim.abdennadher@guc.edu.eg', 19),
('superhesham3@yahoo.com', 19),
('ansary510@gmail.com', 20),
('bagar80@gmail.com', 20),
('barbar@hotmail.com', 20),
('khalid2355@yahoo.com', 20),
('princessLamia@hotmail.com', 20),
('slim.abdennadher@guc.edu.eg', 20);

-- --------------------------------------------------------

--
-- Table structure for table `message`
--

CREATE TABLE IF NOT EXISTS `message` (
  `sender_email` varchar(50) NOT NULL DEFAULT '',
  `reciever_email` varchar(50) NOT NULL DEFAULT '',
  `message_number` int(11) NOT NULL DEFAULT '0',
  `message` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`reciever_email`,`sender_email`,`message_number`),
  KEY `sender_email` (`sender_email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `message`
--

INSERT INTO `message` (`sender_email`, `reciever_email`, `message_number`, `message`) VALUES
('blueberry@yahoo.com', 'ansary510@gmail.com', 2, 'It was awful :((, my parents are gonna spank me'),
('kimobasha3000@hotmail.com', 'ansary510@gmail.com', 2, 'Easy =)))'),
('verilog@databases.dmet', 'ansary510@gmail.com', 2, 'hi'),
('verilog@databases.dmet', 'ansary510@gmail.com', 3, NULL),
('verilog@databases.dmet', 'ansary510@gmail.com', 4, NULL),
('verilog@databases.dmet', 'ansary510@gmail.com', 5, 'ggd'),
('verilog@databases.dmet', 'ansary510@gmail.com', 6, 'lol'),
('ansary510@gmail.com', 'blueberry@yahoo.com', 1, 'Hello, how was today''s networks quiz?'),
('a.n.s.a.r.y@hotmail.com', 'khalid.abdulnasser@gmail.com', 1, 'hi'),
('a.n.s.a.r.y@hotmail.com', 'khalid.abdulnasser@gmail.com', 2, 'hello'),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 1, 'Hi'),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 2, 'klklk'),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 3, 'jhjhjh'),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 4, 'kjkjkjkjk'),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 5, 'hi'),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 6, 'Hello'),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 7, 'alloha'),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 8, 'halabela'),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 9, 'adkjdkada'),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 10, 'k'),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 11, 'kok'),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 12, 'kjkjkjk'),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 13, 'asas'),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 14, 'asasas'),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 15, 'ansbansba'),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 16, 'sdsds'),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 17, 'dsdsdsd'),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 18, 'sdsdsds'),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 19, 'sdsdsd'),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 20, ''),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 21, ''),
('a.n.s.a.r.y@hotmail.com', 'kimobasha3000@hotmail.com', 22, 'asdadad'),
('ansary510@gmail.com', 'kimobasha3000@hotmail.com', 1, 'Hello, how was today''s networks quiz?'),
('verilog@databases.dmet', 'kimobasha3000@hotmail.com', 1, 'hi'),
('ansary510@gmail.com', 'verilog@databases.dmet', 1, 'hi');

-- --------------------------------------------------------

--
-- Table structure for table `monument`
--

CREATE TABLE IF NOT EXISTS `monument` (
  `pid` int(11) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `monument`
--

INSERT INTO `monument` (`pid`, `description`) VALUES
(13, 'Symbol of Liberty'),
(14, 'Made in Ancient Greece'),
(15, 'House of Horror'),
(16, 'To Honor the great Ziad');

-- --------------------------------------------------------

--
-- Table structure for table `museum`
--

CREATE TABLE IF NOT EXISTS `museum` (
  `pid` int(11) NOT NULL,
  `openinghours` varchar(500) DEFAULT NULL,
  `closinghours` varchar(500) DEFAULT NULL,
  `ticketprice` decimal(9,2) DEFAULT NULL,
  PRIMARY KEY (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `museum`
--

INSERT INTO `museum` (`pid`, `openinghours`, `closinghours`, `ticketprice`) VALUES
(6, 'Everyday at 13:00', 'Everyday at 22:00', '15.00'),
(7, 'Everyday at 12:00', 'Everyday at 18:00', '12.00'),
(8, 'Everyday at 14:00', 'Everyday at 21:00', '9.50');

-- --------------------------------------------------------

--
-- Table structure for table `phone_number`
--

CREATE TABLE IF NOT EXISTS `phone_number` (
  `email` varchar(50) NOT NULL DEFAULT '',
  `phone_numbers` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`email`,`phone_numbers`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `phone_number`
--

INSERT INTO `phone_number` (`email`, `phone_numbers`) VALUES
('a@a.com', '123'),
('a@a.com', '456'),
('ansary510@gmail.com', '0111497348'),
('hossam.saraya@gmail.com', '+201000629998'),
('khalid2355@yahoo.com', '01118124570'),
('kimobasha3000@hotmail.com', '01221470559'),
('kimobasha3000@hotmail.com', '01226801193'),
('ziadelwa7sh@hotmail.com', '0111855588');

-- --------------------------------------------------------

--
-- Table structure for table `place`
--

CREATE TABLE IF NOT EXISTS `place` (
  `pid` int(11) NOT NULL AUTO_INCREMENT,
  `next_table_id` int(10) unsigned NOT NULL DEFAULT '0',
  `next_table_id2` int(10) unsigned NOT NULL DEFAULT '0',
  `next_table_id3` int(10) unsigned NOT NULL DEFAULT '0',
  `next_table_id4` int(10) unsigned NOT NULL DEFAULT '0',
  `name` varchar(50) DEFAULT NULL,
  `building_date` varchar(50) DEFAULT NULL,
  `longitude` decimal(7,2) DEFAULT NULL,
  `latitude` decimal(7,2) DEFAULT NULL,
  PRIMARY KEY (`pid`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=21 ;

--
-- Dumping data for table `place`
--

INSERT INTO `place` (`pid`, `next_table_id`, `next_table_id2`, `next_table_id3`, `next_table_id4`, `name`, `building_date`, `longitude`, `latitude`) VALUES
(1, 3, 12, 4, 0, 'Dandi Mall', '2000-05-14 00:00:00', '31.00', '78.24'),
(2, 0, 0, 1, 0, 'City Stars', '2005-02-28 00:00:00', '66.40', '4.00'),
(3, 0, 0, 0, 0, 'Sheraton', '1996-10-06 00:00:00', '5.21', '16.00'),
(4, 0, 0, 0, 0, 'jaka', '0000-00-00 00:00:00', '22.00', '43.00'),
(5, 0, 0, 0, 0, 'Mizo', '1990-01-02 00:00:00', '1.00', '2.00'),
(6, 0, 0, 0, 0, 'Egyptian Museum', '2010-01-02 00:00:00', '4.00', '2.00'),
(7, 0, 0, 0, 0, 'Air Museum', '2012-05-15 00:00:00', '30.30', '44.99'),
(8, 0, 0, 0, 0, 'Prehistoric Museum', '2011-11-11 00:00:00', '66.30', '10.79'),
(9, 1, 1, 0, 1, 'Cairo', '1220-05-22 00:00:00', '30.05', '31.23'),
(10, 0, 0, 0, 0, 'Alexandria', '0880-07-03 00:00:00', '10.00', '1.15'),
(11, 0, 0, 0, 0, 'New York', '1440-07-03 00:00:00', '55.38', '24.28'),
(12, 0, 0, 0, 0, 'Frankfurt', '1904-07-03 00:00:00', '72.00', '4.00'),
(13, 0, 0, 0, 0, 'Statue of Liberty', '1905-07-03 00:00:00', '2.00', '4.00'),
(14, 0, 0, 0, 0, 'Stonehenge', '1908-02-03 00:00:00', '2.00', '24.41'),
(15, 0, 0, 0, 0, 'jaka', '0000-00-00 00:00:00', '22.00', '43.00'),
(16, 0, 0, 0, 0, 'Ziad Monument', '1890-02-03 00:00:00', '19.00', '22.22'),
(17, 0, 0, 0, 0, 'Pizza Hut', '1790-02-03 00:00:00', '19.00', '16.22'),
(18, 0, 0, 0, 0, 'KFC', '1888-02-03 00:00:00', '19.00', '12.22'),
(19, 0, 0, 0, 0, 'Mcdonald''s', '1989-02-03 00:00:00', '19.00', '71.77'),
(20, 0, 0, 0, 0, 'jaka', '0000-00-00 00:00:00', '22.00', '43.00');

-- --------------------------------------------------------

--
-- Table structure for table `professional_picture`
--

CREATE TABLE IF NOT EXISTS `professional_picture` (
  `email` varchar(50) DEFAULT NULL,
  `pid` int(11) NOT NULL DEFAULT '0',
  `number` int(11) NOT NULL DEFAULT '0',
  `image_file` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`pid`,`number`),
  KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `professional_picture`
--

INSERT INTO `professional_picture` (`email`, `pid`, `number`, `image_file`) VALUES
('a.n.s.a.r.y@hotmail.com', 9, 1, '1.jpg');

--
-- Triggers `professional_picture`
--
DROP TRIGGER IF EXISTS `professional_picture_before_ins_trig`;
DELIMITER //
CREATE TRIGGER `professional_picture_before_ins_trig` BEFORE INSERT ON `professional_picture`
 FOR EACH ROW begin
declare v_id int unsigned default 0;
  select next_table_id4 + 1 into v_id from place where pid = new.pid;
  set new.number = v_id;
  update place set next_table_id4 = v_id where pid = new.pid;
end
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `question`
--

CREATE TABLE IF NOT EXISTS `question` (
  `pid` int(11) NOT NULL DEFAULT '0',
  `next_table_id` int(10) unsigned NOT NULL DEFAULT '0',
  `question_number` int(11) NOT NULL DEFAULT '0',
  `text` varchar(1000) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`pid`,`question_number`),
  KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `question`
--

INSERT INTO `question` (`pid`, `next_table_id`, `question_number`, `text`, `email`) VALUES
(1, 2, 1, 'What is the cost of a cinema ticket there?', 'superhesham3@yahoo.com'),
(1, 2, 2, 'test', 'superhesham3@yahoo.com'),
(1, 1, 3, 'kokokokoko', 'barbar@hotmail.com'),
(12, 2, 1, 'hahahhahahahah', 'a.n.s.a.r.y@hotmail.com');

--
-- Triggers `question`
--
DROP TRIGGER IF EXISTS `question_before_ins_trig`;
DELIMITER //
CREATE TRIGGER `question_before_ins_trig` BEFORE INSERT ON `question`
 FOR EACH ROW begin
declare v_id int unsigned default 0;
  select next_table_id + 1 into v_id from place where pid = new.pid;
  set new.question_number = v_id;
  update place set next_table_id = v_id where pid = new.pid;
end
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `rate`
--

CREATE TABLE IF NOT EXISTS `rate` (
  `member_email` varchar(50) NOT NULL DEFAULT '',
  `pid` int(11) NOT NULL DEFAULT '0',
  `criteria_name` varchar(50) NOT NULL DEFAULT '',
  `rate_value` int(11) DEFAULT NULL,
  PRIMARY KEY (`member_email`,`pid`,`criteria_name`),
  KEY `pid` (`pid`,`criteria_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `rate`
--

INSERT INTO `rate` (`member_email`, `pid`, `criteria_name`, `rate_value`) VALUES
('a.n.s.a.r.y@hotmail.com', 1, 'Value', 4),
('dragon15@gmail.com', 1, 'Fun Factor', 2),
('dragon15@gmail.com', 1, 'Service', 2),
('dragon15@gmail.com', 2, 'Fun Factor', 2),
('dragon15@gmail.com', 2, 'Service', 2),
('dragon15@gmail.com', 3, 'Fun Factor', 2),
('dragon15@gmail.com', 3, 'Service', 2),
('dragon15@gmail.com', 4, 'Service', 2),
('dragon15@gmail.com', 5, 'Fun Factor', 2),
('dragon15@gmail.com', 5, 'Service', 2),
('dragon15@gmail.com', 6, 'Fun Factor', 2),
('dragon15@gmail.com', 6, 'Service', 2),
('dragon15@gmail.com', 7, 'Service', 2),
('dragon15@gmail.com', 8, 'Fun Factor', 2),
('dragon15@gmail.com', 8, 'Service', 2),
('dragon15@gmail.com', 9, 'Fun Factor', 2),
('dragon15@gmail.com', 9, 'Service', 2),
('dragon15@gmail.com', 10, 'Service', 2),
('dragon15@gmail.com', 11, 'Fun Factor', 2),
('dragon15@gmail.com', 11, 'Service', 2),
('dragon15@gmail.com', 12, 'Fun Factor', 2),
('dragon15@gmail.com', 12, 'Service', 2),
('dragon15@gmail.com', 13, 'Service', 2),
('dragon15@gmail.com', 14, 'Fun Factor', 2),
('dragon15@gmail.com', 14, 'Service', 2),
('dragon15@gmail.com', 15, 'Fun Factor', 2),
('dragon15@gmail.com', 15, 'Service', 2),
('dragon15@gmail.com', 16, 'Service', 2),
('dragon15@gmail.com', 17, 'Fun Factor', 2),
('dragon15@gmail.com', 17, 'Service', 2),
('dragon15@gmail.com', 18, 'Fun Factor', 2),
('dragon15@gmail.com', 18, 'Service', 2),
('dragon15@gmail.com', 19, 'Service', 2),
('dragon15@gmail.com', 20, 'Fun Factor', 2),
('dragon15@gmail.com', 20, 'Service', 2),
('fg@ddsfs.com', 17, 'Fun Factor', 3),
('fg@ddsfs.com', 17, 'Value', 4),
('hossam.saraya@gmail.com', 9, 'Cleanliness', 4),
('hossam.saraya@gmail.com', 9, 'Service', 4),
('kimobasha3000@hotmail.com', 1, 'Cleanliness', 5),
('kimobasha3000@hotmail.com', 1, 'Fun Factor', 4),
('kimobasha3000@hotmail.com', 2, 'Cleanliness', 5),
('kimobasha3000@hotmail.com', 2, 'Fun Factor', 4),
('kimobasha3000@hotmail.com', 3, 'Cleanliness', 5),
('kimobasha3000@hotmail.com', 3, 'Fun Factor', 4),
('kimobasha3000@hotmail.com', 4, 'Cleanliness', 5),
('kimobasha3000@hotmail.com', 4, 'Fun Factor', 5),
('kimobasha3000@hotmail.com', 5, 'Cleanliness', 5),
('kimobasha3000@hotmail.com', 5, 'Fun Factor', 1),
('kimobasha3000@hotmail.com', 6, 'Cleanliness', 5),
('kimobasha3000@hotmail.com', 6, 'Fun Factor', 4),
('kimobasha3000@hotmail.com', 7, 'Cleanliness', 5),
('kimobasha3000@hotmail.com', 7, 'Fun Factor', 5),
('kimobasha3000@hotmail.com', 8, 'Cleanliness', 5),
('kimobasha3000@hotmail.com', 8, 'Fun Factor', 1),
('kimobasha3000@hotmail.com', 9, 'Cleanliness', 5),
('kimobasha3000@hotmail.com', 9, 'Fun Factor', 4),
('kimobasha3000@hotmail.com', 10, 'Cleanliness', 5),
('kimobasha3000@hotmail.com', 10, 'Fun Factor', 5),
('kimobasha3000@hotmail.com', 11, 'Cleanliness', 5),
('kimobasha3000@hotmail.com', 11, 'Fun Factor', 1),
('kimobasha3000@hotmail.com', 12, 'Cleanliness', 5),
('kimobasha3000@hotmail.com', 12, 'Fun Factor', 4),
('kimobasha3000@hotmail.com', 13, 'Cleanliness', 5),
('kimobasha3000@hotmail.com', 13, 'Fun Factor', 5),
('kimobasha3000@hotmail.com', 14, 'Cleanliness', 5),
('kimobasha3000@hotmail.com', 14, 'Fun Factor', 1),
('kimobasha3000@hotmail.com', 15, 'Cleanliness', 5),
('kimobasha3000@hotmail.com', 15, 'Fun Factor', 4),
('kimobasha3000@hotmail.com', 16, 'Cleanliness', 5),
('kimobasha3000@hotmail.com', 16, 'Fun Factor', 5),
('kimobasha3000@hotmail.com', 17, 'Cleanliness', 5),
('kimobasha3000@hotmail.com', 17, 'Fun Factor', 1),
('kimobasha3000@hotmail.com', 18, 'Cleanliness', 5),
('kimobasha3000@hotmail.com', 18, 'Fun Factor', 4),
('kimobasha3000@hotmail.com', 19, 'Cleanliness', 5),
('kimobasha3000@hotmail.com', 19, 'Fun Factor', 5),
('kimobasha3000@hotmail.com', 20, 'Cleanliness', 5),
('kimobasha3000@hotmail.com', 20, 'Fun Factor', 1),
('princesslamia@hotmail.com', 1, 'Value', 2),
('princesslamia@hotmail.com', 2, 'Value', 2),
('princesslamia@hotmail.com', 3, 'Value', 2),
('princesslamia@hotmail.com', 4, 'Value', 2),
('princesslamia@hotmail.com', 5, 'Fun Factor', 2),
('princesslamia@hotmail.com', 5, 'Value', 2),
('princesslamia@hotmail.com', 6, 'Value', 2),
('princesslamia@hotmail.com', 7, 'Value', 2),
('princesslamia@hotmail.com', 8, 'Fun Factor', 2),
('princesslamia@hotmail.com', 8, 'Value', 2),
('princesslamia@hotmail.com', 9, 'Value', 2),
('princesslamia@hotmail.com', 10, 'Value', 2),
('princesslamia@hotmail.com', 11, 'Fun Factor', 2),
('princesslamia@hotmail.com', 11, 'Value', 2),
('princesslamia@hotmail.com', 12, 'Value', 2),
('princesslamia@hotmail.com', 13, 'Value', 2),
('princesslamia@hotmail.com', 14, 'Fun Factor', 2),
('princesslamia@hotmail.com', 14, 'Value', 2),
('princesslamia@hotmail.com', 15, 'Value', 2),
('princesslamia@hotmail.com', 16, 'Value', 2),
('princesslamia@hotmail.com', 17, 'Fun Factor', 2),
('princesslamia@hotmail.com', 17, 'Value', 2),
('princesslamia@hotmail.com', 18, 'Value', 2),
('princesslamia@hotmail.com', 19, 'Value', 2),
('princesslamia@hotmail.com', 20, 'Fun Factor', 2),
('princesslamia@hotmail.com', 20, 'Value', 2);

-- --------------------------------------------------------

--
-- Table structure for table `rating_criteria`
--

CREATE TABLE IF NOT EXISTS `rating_criteria` (
  `pid` int(11) NOT NULL DEFAULT '0',
  `criteria_name` varchar(50) NOT NULL DEFAULT '',
  `member_email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`pid`,`criteria_name`),
  KEY `member_email` (`member_email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `rating_criteria`
--

INSERT INTO `rating_criteria` (`pid`, `criteria_name`, `member_email`) VALUES
(1, 'Service', 'dragon15@gmail.com'),
(2, 'Service', 'dragon15@gmail.com'),
(3, 'Service', 'dragon15@gmail.com'),
(4, 'Service', 'dragon15@gmail.com'),
(5, 'Service', 'dragon15@gmail.com'),
(6, 'Service', 'dragon15@gmail.com'),
(7, 'Service', 'dragon15@gmail.com'),
(8, 'Service', 'dragon15@gmail.com'),
(9, 'Service', 'dragon15@gmail.com'),
(10, 'Service', 'dragon15@gmail.com'),
(11, 'Service', 'dragon15@gmail.com'),
(12, 'Service', 'dragon15@gmail.com'),
(13, 'Service', 'dragon15@gmail.com'),
(14, 'Service', 'dragon15@gmail.com'),
(15, 'Service', 'dragon15@gmail.com'),
(16, 'Service', 'dragon15@gmail.com'),
(17, 'Service', 'dragon15@gmail.com'),
(18, 'Service', 'dragon15@gmail.com'),
(19, 'Service', 'dragon15@gmail.com'),
(20, 'Service', 'dragon15@gmail.com'),
(1, 'Cleanliness', 'kimobasha3000@hotmail.com'),
(1, 'Fun Factor', 'kimobasha3000@hotmail.com'),
(2, 'Cleanliness', 'kimobasha3000@hotmail.com'),
(2, 'Fun Factor', 'kimobasha3000@hotmail.com'),
(3, 'Cleanliness', 'kimobasha3000@hotmail.com'),
(3, 'Fun Factor', 'kimobasha3000@hotmail.com'),
(4, 'Cleanliness', 'kimobasha3000@hotmail.com'),
(4, 'Fun Factor', 'kimobasha3000@hotmail.com'),
(5, 'Cleanliness', 'kimobasha3000@hotmail.com'),
(5, 'Fun Factor', 'kimobasha3000@hotmail.com'),
(6, 'Cleanliness', 'kimobasha3000@hotmail.com'),
(6, 'Fun Factor', 'kimobasha3000@hotmail.com'),
(7, 'Cleanliness', 'kimobasha3000@hotmail.com'),
(7, 'Fun Factor', 'kimobasha3000@hotmail.com'),
(8, 'Cleanliness', 'kimobasha3000@hotmail.com'),
(8, 'Fun Factor', 'kimobasha3000@hotmail.com'),
(9, 'Cleanliness', 'kimobasha3000@hotmail.com'),
(9, 'Fun Factor', 'kimobasha3000@hotmail.com'),
(10, 'Cleanliness', 'kimobasha3000@hotmail.com'),
(10, 'Fun Factor', 'kimobasha3000@hotmail.com'),
(11, 'Cleanliness', 'kimobasha3000@hotmail.com'),
(11, 'Fun Factor', 'kimobasha3000@hotmail.com'),
(12, 'Cleanliness', 'kimobasha3000@hotmail.com'),
(12, 'Fun Factor', 'kimobasha3000@hotmail.com'),
(13, 'Cleanliness', 'kimobasha3000@hotmail.com'),
(13, 'Fun Factor', 'kimobasha3000@hotmail.com'),
(14, 'Cleanliness', 'kimobasha3000@hotmail.com'),
(14, 'Fun Factor', 'kimobasha3000@hotmail.com'),
(15, 'Cleanliness', 'kimobasha3000@hotmail.com'),
(15, 'Fun Factor', 'kimobasha3000@hotmail.com'),
(16, 'Cleanliness', 'kimobasha3000@hotmail.com'),
(16, 'Fun Factor', 'kimobasha3000@hotmail.com'),
(17, 'Cleanliness', 'kimobasha3000@hotmail.com'),
(17, 'Fun Factor', 'kimobasha3000@hotmail.com'),
(18, 'Cleanliness', 'kimobasha3000@hotmail.com'),
(18, 'Fun Factor', 'kimobasha3000@hotmail.com'),
(19, 'Cleanliness', 'kimobasha3000@hotmail.com'),
(19, 'Fun Factor', 'kimobasha3000@hotmail.com'),
(20, 'Cleanliness', 'kimobasha3000@hotmail.com'),
(20, 'Fun Factor', 'kimobasha3000@hotmail.com'),
(1, 'Value', 'princesslamia@hotmail.com'),
(2, 'Value', 'princesslamia@hotmail.com'),
(3, 'Value', 'princesslamia@hotmail.com'),
(4, 'Value', 'princesslamia@hotmail.com'),
(5, 'Value', 'princesslamia@hotmail.com'),
(6, 'Value', 'princesslamia@hotmail.com'),
(7, 'Value', 'princesslamia@hotmail.com'),
(8, 'Value', 'princesslamia@hotmail.com'),
(9, 'Value', 'princesslamia@hotmail.com'),
(10, 'Value', 'princesslamia@hotmail.com'),
(11, 'Value', 'princesslamia@hotmail.com'),
(12, 'Value', 'princesslamia@hotmail.com'),
(13, 'Value', 'princesslamia@hotmail.com'),
(14, 'Value', 'princesslamia@hotmail.com'),
(15, 'Value', 'princesslamia@hotmail.com'),
(16, 'Value', 'princesslamia@hotmail.com'),
(17, 'Value', 'princesslamia@hotmail.com'),
(18, 'Value', 'princesslamia@hotmail.com'),
(19, 'Value', 'princesslamia@hotmail.com'),
(20, 'Value', 'princesslamia@hotmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `restaurant`
--

CREATE TABLE IF NOT EXISTS `restaurant` (
  `pid` int(11) NOT NULL,
  `style` varchar(50) DEFAULT NULL,
  `cuisine` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `restaurant`
--

INSERT INTO `restaurant` (`pid`, `style`, `cuisine`) VALUES
(17, 'American', 'American'),
(18, 'American', 'American'),
(19, 'American', 'American'),
(20, 'American', 'American');

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

CREATE TABLE IF NOT EXISTS `room` (
  `pid` int(11) NOT NULL DEFAULT '0',
  `type` varchar(50) NOT NULL DEFAULT '',
  `price` decimal(9,2) DEFAULT NULL,
  PRIMARY KEY (`pid`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`pid`, `type`, `price`) VALUES
(3, 'Double', '220.00'),
(4, 'Double', '120.00'),
(4, 'Single', '80.00'),
(4, 'Triple', '210.00'),
(5, 'Double', '150.00'),
(5, 'Quadruple', '350.00'),
(5, 'Single', '50.00'),
(5, 'Triple', '250.00');

-- --------------------------------------------------------

--
-- Table structure for table `sys_admin`
--

CREATE TABLE IF NOT EXISTS `sys_admin` (
  `email` varchar(50) NOT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `sys_admin`
--

INSERT INTO `sys_admin` (`email`) VALUES
('kimobasha3000@hotmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `visited`
--

CREATE TABLE IF NOT EXISTS `visited` (
  `member_email` varchar(50) NOT NULL DEFAULT '',
  `pid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`member_email`,`pid`),
  KEY `pid` (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `visited`
--

INSERT INTO `visited` (`member_email`, `pid`) VALUES
('b@bb.com', 1),
('barbar@hotmail.com', 1),
('dragon15@gmail.com', 1),
('kaltaz80@gmail.com', 1),
('khalid.abdulnasser@gmail.com', 1),
('khalid2355@yahoo.com', 1),
('kimobasha3000@hotmail.com', 1),
('lionofthedesert@yahoo.com', 1),
('marwa@hotmail.com', 1),
('slim.abdennadher@guc.edu.eg', 1),
('a.n.s.a.r.y@hotmail.com', 2),
('ansary510@gmail.com', 2),
('bagar80@gmail.com', 2),
('barbar@hotmail.com', 2),
('dragon15@gmail.com', 2),
('kaltaz80@gmail.com', 2),
('khalid.abdulnasser@gmail.com', 2),
('kimobasha3000@hotmail.com', 2),
('lionofthedesert@yahoo.com', 2),
('slim.abdennadher@guc.edu.eg', 2),
('superhesham3@yahoo.com', 2),
('ansary510@gmail.com', 3),
('barbar@hotmail.com', 3),
('blueberry@yahoo.com', 3),
('dragon15@gmail.com', 3),
('kaltaz80@gmail.com', 3),
('kimobasha3000@hotmail.com', 3),
('marwa@hotmail.com', 3),
('princessLamia@hotmail.com', 3),
('s@s.com', 3),
('slim.abdennadher@guc.edu.eg', 3),
('ansary510@gmail.com', 4),
('bagar80@gmail.com', 4),
('kaltaz80@gmail.com', 4),
('khalid.abdulnasser@gmail.com', 4),
('khalid2355@yahoo.com', 4),
('lionofthedesert@yahoo.com', 4),
('marwa@hotmail.com', 4),
('princessLamia@hotmail.com', 4),
('slim.abdennadher@guc.edu.eg', 4),
('bagar80@gmail.com', 5),
('barbar@hotmail.com', 5),
('khalid2355@yahoo.com', 5),
('princessLamia@hotmail.com', 5),
('slim.abdennadher@guc.edu.eg', 5),
('ansary510@gmail.com', 6),
('barbar@hotmail.com', 6),
('dragon15@gmail.com', 6),
('kaltaz80@gmail.com', 6),
('khalid.abdulnasser@gmail.com', 6),
('khalid2355@yahoo.com', 6),
('lionofthedesert@yahoo.com', 6),
('marwa@hotmail.com', 6),
('slim.abdennadher@guc.edu.eg', 6),
('ansary510@gmail.com', 7),
('bagar80@gmail.com', 7),
('barbar@hotmail.com', 7),
('dragon15@gmail.com', 7),
('kaltaz80@gmail.com', 7),
('khalid.abdulnasser@gmail.com', 7),
('kimobasha3000@hotmail.com', 7),
('lionofthedesert@yahoo.com', 7),
('slim.abdennadher@guc.edu.eg', 7),
('ansary510@gmail.com', 8),
('barbar@hotmail.com', 8),
('blueberry@yahoo.com', 8),
('dragon15@gmail.com', 8),
('kaltaz80@gmail.com', 8),
('kimobasha3000@hotmail.com', 8),
('marwa@hotmail.com', 8),
('princessLamia@hotmail.com', 8),
('slim.abdennadher@guc.edu.eg', 8),
('a.n.s.a.r.y@hotmail.com', 9),
('ansary510@gmail.com', 9),
('bagar80@gmail.com', 9),
('hossam.saraya@gmail.com', 9),
('kaltaz80@gmail.com', 9),
('khalid.abdulnasser@gmail.com', 9),
('khalid2355@yahoo.com', 9),
('lionofthedesert@yahoo.com', 9),
('marwa@hotmail.com', 9),
('princessLamia@hotmail.com', 9),
('slim.abdennadher@guc.edu.eg', 9),
('bagar80@gmail.com', 10),
('barbar@hotmail.com', 10),
('khalid2355@yahoo.com', 10),
('princessLamia@hotmail.com', 10),
('slim.abdennadher@guc.edu.eg', 10),
('ansary510@gmail.com', 11),
('barbar@hotmail.com', 11),
('dragon15@gmail.com', 11),
('kaltaz80@gmail.com', 11),
('khalid.abdulnasser@gmail.com', 11),
('khalid2355@yahoo.com', 11),
('kimobasha3000@hotmail.com', 11),
('lionofthedesert@yahoo.com', 11),
('marwa@hotmail.com', 11),
('slim.abdennadher@guc.edu.eg', 11),
('ansary510@gmail.com', 12),
('bagar80@gmail.com', 12),
('barbar@hotmail.com', 12),
('dragon15@gmail.com', 12),
('kaltaz80@gmail.com', 12),
('khalid.abdulnasser@gmail.com', 12),
('kimobasha3000@hotmail.com', 12),
('lionofthedesert@yahoo.com', 12),
('slim.abdennadher@guc.edu.eg', 12),
('ansary510@gmail.com', 13),
('barbar@hotmail.com', 13),
('blueberry@yahoo.com', 13),
('dragon15@gmail.com', 13),
('kaltaz80@gmail.com', 13),
('kimobasha3000@hotmail.com', 13),
('marwa@hotmail.com', 13),
('princessLamia@hotmail.com', 13),
('slim.abdennadher@guc.edu.eg', 13),
('ansary510@gmail.com', 14),
('bagar80@gmail.com', 14),
('kaltaz80@gmail.com', 14),
('khalid.abdulnasser@gmail.com', 14),
('khalid2355@yahoo.com', 14),
('lionofthedesert@yahoo.com', 14),
('marwa@hotmail.com', 14),
('princessLamia@hotmail.com', 14),
('slim.abdennadher@guc.edu.eg', 14),
('bagar80@gmail.com', 15),
('barbar@hotmail.com', 15),
('khalid2355@yahoo.com', 15),
('princessLamia@hotmail.com', 15),
('slim.abdennadher@guc.edu.eg', 15),
('ansary510@gmail.com', 16),
('barbar@hotmail.com', 16),
('dragon15@gmail.com', 16),
('kaltaz80@gmail.com', 16),
('khalid.abdulnasser@gmail.com', 16),
('khalid2355@yahoo.com', 16),
('kimobasha3000@hotmail.com', 16),
('lionofthedesert@yahoo.com', 16),
('marwa@hotmail.com', 16),
('slim.abdennadher@guc.edu.eg', 16),
('a.n.s.a.r.y@hotmail.com', 17),
('ansary510@gmail.com', 17),
('bagar80@gmail.com', 17),
('barbar@hotmail.com', 17),
('dragon15@gmail.com', 17),
('fg@ddsfs.com', 17),
('kaltaz80@gmail.com', 17),
('khalid.abdulnasser@gmail.com', 17),
('kimobasha3000@hotmail.com', 17),
('lionofthedesert@yahoo.com', 17),
('slim.abdennadher@guc.edu.eg', 17),
('ansary510@gmail.com', 18),
('barbar@hotmail.com', 18),
('blueberry@yahoo.com', 18),
('dragon15@gmail.com', 18),
('kaltaz80@gmail.com', 18),
('kimobasha3000@hotmail.com', 18),
('marwa@hotmail.com', 18),
('princessLamia@hotmail.com', 18),
('slim.abdennadher@guc.edu.eg', 18),
('ansary510@gmail.com', 19),
('bagar80@gmail.com', 19),
('kaltaz80@gmail.com', 19),
('khalid.abdulnasser@gmail.com', 19),
('khalid2355@yahoo.com', 19),
('lionofthedesert@yahoo.com', 19),
('marwa@hotmail.com', 19),
('princessLamia@hotmail.com', 19),
('slim.abdennadher@guc.edu.eg', 19),
('superhesham3@yahoo.com', 19),
('ansary510@gmail.com', 20),
('bagar80@gmail.com', 20),
('barbar@hotmail.com', 20),
('khalid2355@yahoo.com', 20),
('kimobasha3000@hotmail.com', 20),
('princessLamia@hotmail.com', 20),
('slim.abdennadher@guc.edu.eg', 20);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `add_friend`
--
ALTER TABLE `add_friend`
  ADD CONSTRAINT `add_friend_ibfk_1` FOREIGN KEY (`reciever_email`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `add_friend_ibfk_2` FOREIGN KEY (`sender_email`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `administrator`
--
ALTER TABLE `administrator`
  ADD CONSTRAINT `administrator_ibfk_1` FOREIGN KEY (`email`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `answer`
--
ALTER TABLE `answer`
  ADD CONSTRAINT `answer_ibfk_1` FOREIGN KEY (`pid`, `question_number`) REFERENCES `question` (`pid`, `question_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `answer_ibfk_2` FOREIGN KEY (`email`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `city`
--
ALTER TABLE `city`
  ADD CONSTRAINT `city_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `place` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `contact_to_add_place`
--
ALTER TABLE `contact_to_add_place`
  ADD CONSTRAINT `contact_to_add_place_ibfk_1` FOREIGN KEY (`email1`) REFERENCES `administrator` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `contact_to_add_place_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `place` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `contact_to_add_place_ibfk_3` FOREIGN KEY (`email2`) REFERENCES `sys_admin` (`email`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `facility`
--
ALTER TABLE `facility`
  ADD CONSTRAINT `facility_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `hotel` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `hotel`
--
ALTER TABLE `hotel`
  ADD CONSTRAINT `hotel_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `place` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `image`
--
ALTER TABLE `image`
  ADD CONSTRAINT `image_ibfk_1` FOREIGN KEY (`email`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `image_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `place` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `information`
--
ALTER TABLE `information`
  ADD CONSTRAINT `information_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `place` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `information_ibfk_2` FOREIGN KEY (`admin_email`) REFERENCES `administrator` (`email`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `invite`
--
ALTER TABLE `invite`
  ADD CONSTRAINT `invite_ibfk_1` FOREIGN KEY (`admin1`) REFERENCES `administrator` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `invite_ibfk_2` FOREIGN KEY (`admin2`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `invite_ibfk_3` FOREIGN KEY (`pid`) REFERENCES `place` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `manage_place`
--
ALTER TABLE `manage_place`
  ADD CONSTRAINT `manage_place_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `place` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `manage_place_ibfk_2` FOREIGN KEY (`email`) REFERENCES `administrator` (`email`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `member_comment`
--
ALTER TABLE `member_comment`
  ADD CONSTRAINT `member_comment_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `place` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `member_comment_ibfk_2` FOREIGN KEY (`email`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `member_liked`
--
ALTER TABLE `member_liked`
  ADD CONSTRAINT `member_liked_ibfk_1` FOREIGN KEY (`member_email`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `member_liked_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `place` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `message`
--
ALTER TABLE `message`
  ADD CONSTRAINT `message_ibfk_1` FOREIGN KEY (`reciever_email`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `message_ibfk_2` FOREIGN KEY (`sender_email`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `monument`
--
ALTER TABLE `monument`
  ADD CONSTRAINT `monument_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `place` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `museum`
--
ALTER TABLE `museum`
  ADD CONSTRAINT `museum_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `place` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `phone_number`
--
ALTER TABLE `phone_number`
  ADD CONSTRAINT `phone_number_ibfk_1` FOREIGN KEY (`email`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `professional_picture`
--
ALTER TABLE `professional_picture`
  ADD CONSTRAINT `professional_picture_ibfk_1` FOREIGN KEY (`email`) REFERENCES `administrator` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `professional_picture_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `place` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `question`
--
ALTER TABLE `question`
  ADD CONSTRAINT `question_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `place` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `question_ibfk_2` FOREIGN KEY (`email`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `rate`
--
ALTER TABLE `rate`
  ADD CONSTRAINT `rate_ibfk_1` FOREIGN KEY (`member_email`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `rate_ibfk_2` FOREIGN KEY (`pid`, `criteria_name`) REFERENCES `rating_criteria` (`pid`, `criteria_name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `rating_criteria`
--
ALTER TABLE `rating_criteria`
  ADD CONSTRAINT `rating_criteria_ibfk_1` FOREIGN KEY (`member_email`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `rating_criteria_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `place` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `restaurant`
--
ALTER TABLE `restaurant`
  ADD CONSTRAINT `restaurant_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `place` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `room`
--
ALTER TABLE `room`
  ADD CONSTRAINT `room_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `hotel` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `sys_admin`
--
ALTER TABLE `sys_admin`
  ADD CONSTRAINT `sys_admin_ibfk_1` FOREIGN KEY (`email`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `visited`
--
ALTER TABLE `visited`
  ADD CONSTRAINT `visited_ibfk_1` FOREIGN KEY (`member_email`) REFERENCES `member` (`email`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `visited_ibfk_2` FOREIGN KEY (`pid`) REFERENCES `place` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
