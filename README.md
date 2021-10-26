# Placebook
Placebook is a social media website as well as a place/location recommendation website where users sign up for accounts using their emails. The users can add other members as friends on the system, they can specify the places that they've been to, like, or rate them. They can pose questions about the places and get recommendations of places to visit or friends who have similar likings.

## Users
The users can add other members as friends.
Friends can send a thread of messages to each other.
A user can like a place he has been to and give it a rating.
There are the normal users in the website, however, a user can also be the manager/adminsrator of a speciﬁc place on our network.

## Places
To be able to help diﬀerent tourists all over the world, the system allows its users to rate diﬀerent types of places including cities, hotels, restaurants, museums, monuments.

The system records the name of the place, it’s building date (if known) and rest of attributes. Every place provides its google map attributes (longitude and latitude) to be used in the recommendation.
For every city, the system keeps track of its location. In addition, the system also records whether it is a coastal city.
For restaurants, the system keeps track of the cuisine and style.
For every hotel, the price of the diﬀerent types of room is recorded (if known) along with the available facilities in the hoteland, their descriptions (e.g. beach, pool, activities area).
For museums, the hours of opening and closing is saved along with the price of the tickets if available.
A short description is available for all monuments.

The admin/manager(s) of a place upload professional pictures to try and attract people. In addition, users can upload images for a speciﬁc place they have liked or rated.
Each place has a page on our system. Such page displays the information provided by the place
page’s manager(s)/administrator(s). In addition, it should also contain the various ratings and comments given by the users. Through this page, users are able to ask questions regarding the place as discussed later.

In order to add a new place to the system, the manager/admin of the place should contact our system’s administrator to invite him/her to the system as an admin to the place. A place admin/manager can invite other admins to the system to manage the place’s page.

## Rating
Diﬀerent types of places are rated according to diﬀerent criteria. A user can add a rating criteria. People can rate places they have been to in order to advise others to it.
Here are some of the criteria places could be rated through:
* For Hotels: Sleep Quality, Location, Rooms, Service, Value, Cleanliness: Excellent, Very good,
Average, Poor, Terrible.
* For Restaurants: Food, Service, Value, Atmosphere
## Comments
Our system aims at helping its users make a quick decision based on the numbers they see and the recommendations they get. Thus, they are only able to provide small comments about a place. A comment can be a maximum of 100 charcters long.
In addition, users can use hashtag comments for the places. Hashtags should contain a maximum of 50 charachters.
## Questions and Answers
Each member of the system can add questions on the diﬀerent pages. The manager/adminsrator of a speciﬁc place can respond to such questions.
The questions and their responses could be viewed on the place page.

# Information
This project is made using HTML/CSS, [PHP](https://www.php.net/) for the backend, and [MySQL](https://www.mysql.com/) for the database.

# Usage instructions (for windows)
* Download and install WampServer
&nbsp;&nbsp; If you get "mysqld.exe can't start because MSVCR120.dll is missing" or a similar
&nbsp;&nbsp; message during the install, download and install ALL versions of Microsoft Visual C/C++
&nbsp;&nbsp; Redistributable both x86 and x64 (2008 , 2010 , 2012 , 2013 , 2015).
&nbsp;&nbsp;&nbsp;&nbsp; Download links for all of these versions are available here: [x86](http://files.drax.ir/wampserver/vcredist_x86_Allversions.zip) and [x64](http://files.drax.ir/wampserver/vcredist_x64_Allversions.zip).
* Run WampServer and open localhost (http://localhost/). In the following, currently you **must** use the default phpMyAdmin login of Username root and a blank password.
* Choose phpMyAdmin and login, next choose import then select the file "tourism.sql" and click "Go" to build the database called "tourism" with its record entries for users and places, as well as add the MySQL procedures needed for the various website functions (If you happen to already have a database called "tourism" then rename it before this step).
* From localhost add the website folder "DB" as a Virtual Host, then proceed to run the website and login using any email that you can find in the table "member" and the unified password **abcja**. You can now use the various website features talked about in the description above.
* Note: in the table "administraor" you will find the users who are managers of one or more places, and in the table "sys_admin" you will find the users who are system administrators of the website.
# To do
* Add a video showcasing the website in action (**Important!!**).
* Clean up the project's files more (Currently a lot of different versions of the website are present which were used during the development/testing).
* Fix/implement the broken/missing features:
  * Upload a photo feature for a place's manager or a user isn't working at the moment.
  * View the specific ratings of a place by the different users.
* Modify "tourism.sql" and the website so that the steps required to run the website allow you to create/use a database with any name, and login to phpMyAdmin using the username and password that you specify.