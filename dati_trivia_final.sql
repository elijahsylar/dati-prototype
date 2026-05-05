-- MySQL dump 10.13  Distrib 8.4.7, for Linux (x86_64)
--
-- Host: localhost    Database: dati_trivia
-- ------------------------------------------------------
-- Server version	8.4.7-0ubuntu0.25.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin_users`
--

DROP TABLE IF EXISTS `admin_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `display_name` varchar(100) NOT NULL,
  `role` enum('admin','host') NOT NULL DEFAULT 'host',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_admin_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_users`
--

LOCK TABLES `admin_users` WRITE;
/*!40000 ALTER TABLE `admin_users` DISABLE KEYS */;
INSERT INTO `admin_users` VALUES (1,'admin','$2b$10$cNWHN0QXPXqUO2VBI3k0s.s1oIU/yd6lRPKIDkjCPwNzX83kdwfPS','Cellar Door Admin','admin',1,'2026-02-25 01:40:56','2026-04-25 15:00:45'),(2,'host1','$2b$10$placeholder_hash_replace_on_first_run','Trivia Host','host',0,'2026-02-25 01:40:56','2026-04-17 22:14:23');
/*!40000 ALTER TABLE `admin_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event_state`
--

DROP TABLE IF EXISTS `event_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event_state` (
  `event_id` int NOT NULL,
  `current_question_index` int NOT NULL DEFAULT '-1',
  `current_question_id` int DEFAULT NULL,
  `question_started_at` timestamp NULL DEFAULT NULL,
  `status` enum('lobby','question_active','question_locked','question_revealed','intermission','ended') NOT NULL DEFAULT 'lobby',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`event_id`),
  KEY `fk_event_state_question` (`current_question_id`),
  CONSTRAINT `fk_event_state_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_event_state_question` FOREIGN KEY (`current_question_id`) REFERENCES `questions` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_state`
--

LOCK TABLES `event_state` WRITE;
/*!40000 ALTER TABLE `event_state` DISABLE KEYS */;
INSERT INTO `event_state` VALUES (1,0,1,'2026-05-03 20:22:09','ended','2026-05-03 20:22:21'),(3,6,37,'2026-05-05 17:38:55','ended','2026-05-05 17:39:18'),(4,0,66,'2026-04-25 16:22:01','ended','2026-04-25 16:22:20'),(5,0,56,'2026-04-25 15:02:27','ended','2026-04-25 15:02:42'),(6,0,46,'2026-04-25 22:14:02','ended','2026-04-25 22:14:37');
/*!40000 ALTER TABLE `event_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `theme_id` int NOT NULL,
  `title` varchar(200) NOT NULL,
  `event_date` date NOT NULL,
  `start_time` time NOT NULL DEFAULT '19:00:00',
  `max_teams` int NOT NULL DEFAULT '30',
  `max_players_per_team` int NOT NULL DEFAULT '5',
  `question_count` int NOT NULL DEFAULT '10',
  `time_limit_seconds` int NOT NULL DEFAULT '30',
  `status` enum('draft','published','live','completed','cancelled') NOT NULL DEFAULT 'draft',
  `join_code` varchar(8) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_event_join_code` (`join_code`),
  KEY `idx_events_date` (`event_date`),
  KEY `idx_events_status` (`status`),
  KEY `idx_events_theme` (`theme_id`),
  CONSTRAINT `fk_event_theme` FOREIGN KEY (`theme_id`) REFERENCES `themes` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES (1,1,'Presidents Day History Night','2026-02-19','19:00:00',30,5,15,30,'completed','WDR9UU','2026-02-25 01:40:56','2026-05-03 20:22:21'),(2,2,'Rock & Roll Through the Ages','2026-02-24','19:30:00',30,5,15,30,'published','KP2AXJ','2026-02-25 01:40:56','2026-05-03 20:36:18'),(3,3,'Totally 2000s Throwback Night','2026-02-26','19:00:00',30,5,7,15,'completed','HKPRVY','2026-02-25 01:40:56','2026-05-05 17:39:18'),(4,6,'Pub Grub & Brews Trivia','2026-03-03','20:00:00',25,5,10,30,'published','U88T27','2026-02-25 01:40:56','2026-04-25 23:37:36'),(5,5,'March Madness Sports Trivia','2026-03-10','19:00:00',30,5,15,30,'published','BXVFUR','2026-02-25 01:40:56','2026-04-25 23:37:37'),(6,4,'Science Night at The Cellar Door','2026-03-17','19:00:00',30,5,10,35,'completed','T9SCWZ','2026-02-25 01:40:56','2026-05-01 17:47:22'),(7,1,'Test New Event','2026-04-09','19:00:00',30,5,10,30,'draft',NULL,'2026-04-09 17:42:34','2026-05-03 20:36:22');
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `theme_id` int NOT NULL,
  `question_text` varchar(1000) NOT NULL,
  `option_a` varchar(500) NOT NULL,
  `option_b` varchar(500) NOT NULL,
  `option_c` varchar(500) NOT NULL,
  `option_d` varchar(500) NOT NULL,
  `correct_answer` enum('A','B','C','D') NOT NULL,
  `difficulty` enum('easy','medium','hard') NOT NULL DEFAULT 'medium',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_questions_theme` (`theme_id`),
  KEY `idx_questions_active` (`is_active`),
  CONSTRAINT `fk_question_theme` FOREIGN KEY (`theme_id`) REFERENCES `themes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
INSERT INTO `questions` VALUES (1,1,'In what year was the Declaration of Independence signed?','1774','1776','1778','1781','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(2,1,'Who was the first President of the United States?','John Adams','Thomas Jefferson','George Washington','Benjamin Franklin','C','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(3,1,'Which amendment abolished slavery in the United States?','12th','13th','14th','15th','B','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(4,1,'What was the last state to join the Union?','Alaska','Hawaii','Arizona','New Mexico','B','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(5,1,'Which battle is considered the turning point of the Civil War?','Battle of Antietam','Battle of Gettysburg','Battle of Bull Run','Battle of Shiloh','B','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(6,1,'Who purchased the Louisiana Territory from France?','George Washington','John Adams','Thomas Jefferson','James Madison','C','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(7,1,'In what year did the United States enter World War I?','1914','1915','1916','1917','D','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(8,1,'What document begins with \"We the People\"?','Declaration of Independence','Bill of Rights','U.S. Constitution','Articles of Confederation','C','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(9,1,'Which President issued the Emancipation Proclamation?','Ulysses S. Grant','Abraham Lincoln','Andrew Johnson','James Buchanan','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(10,1,'The Trail of Tears was the forced relocation of which group?','African Americans','Japanese Americans','Native Americans','Mexican Americans','C','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(11,1,'Who was President during the Cuban Missile Crisis?','Dwight Eisenhower','John F. Kennedy','Lyndon Johnson','Richard Nixon','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(12,1,'What year did women gain the right to vote in the U.S.?','1918','1919','1920','1921','C','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(13,1,'Which President served the shortest term in office?','Zachary Taylor','James Garfield','William Henry Harrison','Warren Harding','C','hard',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(14,1,'What was the code name for the Allied invasion of Normandy?','Operation Torch','Operation Overlord','Operation Market Garden','Operation Barbarossa','B','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(15,1,'The Boston Tea Party was a protest against what?','Stamp Act','Sugar Act','Tea Act','Townshend Acts','C','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(16,2,'Which band released the album \"Abbey Road\"?','The Rolling Stones','The Beatles','The Who','Led Zeppelin','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(17,2,'What instrument does a drummer play?','Guitar','Bass','Drums','Keyboard','C','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(18,2,'Who is known as the \"King of Pop\"?','Prince','Michael Jackson','Elvis Presley','Stevie Wonder','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(19,2,'Which artist released \"Purple Rain\" in 1984?','David Bowie','Michael Jackson','Prince','Bruce Springsteen','C','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(20,2,'What genre did The Ramones help pioneer?','Disco','Punk rock','New wave','Grunge','B','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(21,2,'Which Woodstock festival took place in 1969?','Woodstock 94','The original Woodstock','Woodstock 99','Woodstock 2009','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(22,2,'Who sang \"Respect\" and is the Queen of Soul?','Diana Ross','Tina Turner','Aretha Franklin','Whitney Houston','C','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(23,2,'What was Nirvana\'s breakthrough album?','Bleach','Nevermind','In Utero','Unplugged in New York','B','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(24,2,'Which rapper released \"The Marshall Mathers LP\"?','Jay-Z','50 Cent','Eminem','Kanye West','C','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(25,2,'What year did MTV first go on the air?','1979','1980','1981','1982','C','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(26,2,'Which band performed the halftime show at Super Bowl XLII in 2008?','The Rolling Stones','U2','Tom Petty & the Heartbreakers','Bruce Springsteen','C','hard',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(27,2,'Who wrote \"Bohemian Rhapsody\"?','Elton John','Freddie Mercury','David Bowie','Mick Jagger','B','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(28,2,'Which female artist had a hit with \"Like a Virgin\" in 1984?','Cyndi Lauper','Madonna','Whitney Houston','Janet Jackson','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(29,2,'What was Elvis Presley\'s first number-one hit?','Jailhouse Rock','Hound Dog','Heartbreak Hotel','Love Me Tender','C','hard',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(30,2,'Which band is known for the song \"Stairway to Heaven\"?','Pink Floyd','Led Zeppelin','Deep Purple','Black Sabbath','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(31,3,'What social media platform launched in 2004?','Twitter','MySpace','Facebook','Instagram','C','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(32,3,'Which phone was released by Apple in 2007?','iPod Touch','iPhone','iPad','Blackberry','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(33,3,'What was the name of the virtual world game popular in the early 2000s?','Minecraft','Second Life','Club Penguin','Roblox','C','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(34,3,'Which TV show featured the characters Jack, Kate, and Sawyer on a mysterious island?','Survivor','Lost','The OC','Heroes','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(35,3,'What dance move became viral from the song \"Crank That\"?','The Dougie','Superman','The Stanky Leg','The Running Man','B','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(36,3,'Which movie franchise began with \"The Fellowship of the Ring\" in 2001?','Harry Potter','The Matrix','Lord of the Rings','Star Wars Prequels','C','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(37,3,'What portable music player dominated the 2000s?','Zune','Walkman','iPod','MiniDisc','C','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(38,3,'Which reality TV show first aired in 2002 and featured Simon Cowell?','The Voice','American Idol','X Factor','America\'s Got Talent','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(39,3,'What was the name of the popular IM client with a running man logo?','MSN Messenger','Yahoo Messenger','AIM','ICQ','C','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(40,3,'Which video platform launched in 2005?','Vimeo','YouTube','Dailymotion','Twitch','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(41,3,'What flip phone was the best-selling phone of 2004?','Nokia 3310','Motorola Razr','Samsung SGH','LG Chocolate','B','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(42,3,'Which animated movie featured a clownfish searching for his son?','Shark Tale','Finding Nemo','The Little Mermaid 2','SpongeBob Movie','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(43,3,'What was Tom from MySpace famous for?','Creating viral videos','Being everyone\'s first friend','Inventing hashtags','Starting Facebook','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(44,3,'Which gaming console did Nintendo release in 2006?','GameCube','Nintendo DS','Wii','Switch','C','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(45,3,'What low-rise fashion trend was everywhere in the early 2000s?','Bell bottoms','Low-rise jeans','Cargo pants','Skinny jeans','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(46,4,'What planet is known as the Red Planet?','Venus','Mars','Jupiter','Saturn','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(47,4,'What is the chemical symbol for water?','H2O','CO2','O2','NaCl','A','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(48,4,'How many bones are in the adult human body?','186','196','206','216','C','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(49,4,'What is the largest organ in the human body?','Liver','Brain','Lungs','Skin','D','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(50,4,'What gas do plants absorb from the atmosphere?','Oxygen','Nitrogen','Carbon dioxide','Hydrogen','C','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(51,4,'What is the speed of light in miles per second (approx)?','86,000','186,000','286,000','386,000','B','hard',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(52,4,'Which element has the atomic number 1?','Helium','Hydrogen','Oxygen','Carbon','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(53,4,'What is the hardest natural substance on Earth?','Granite','Quartz','Diamond','Topaz','C','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(54,4,'How long does it take light from the Sun to reach Earth?','4 minutes','8 minutes','12 minutes','16 minutes','B','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(55,4,'What animal has the longest lifespan?','Elephant','Blue whale','Galápagos tortoise','Greenland shark','D','hard',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(56,5,'How many rings did Michael Jordan win with the Chicago Bulls?','4','5','6','7','C','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(57,5,'Who holds the record for most home runs in a single MLB season?','Mark McGwire','Barry Bonds','Sammy Sosa','Babe Ruth','B','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(58,5,'In what sport would you perform a \"slam dunk\"?','Football','Basketball','Tennis','Volleyball','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(59,5,'Which country has won the most FIFA World Cup titles?','Germany','Argentina','Brazil','Italy','C','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(60,5,'Who is the all-time leading scorer in NBA history?','Kareem Abdul-Jabbar','Karl Malone','LeBron James','Michael Jordan','C','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(61,5,'What is the length of a marathon in miles (approx)?','20.2','24.2','26.2','28.2','C','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(62,5,'Which boxer was known as \"The Greatest\"?','Mike Tyson','Sugar Ray Leonard','Muhammad Ali','Floyd Mayweather','C','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(63,5,'What NFL team has won the most Super Bowls?','Dallas Cowboys','New England Patriots','Pittsburgh Steelers','San Francisco 49ers','B','hard',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(64,5,'Who won 23 Grand Slam singles titles in tennis?','Roger Federer','Rafael Nadal','Novak Djokovic','Serena Williams','D','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(65,5,'In what year were the first modern Olympic Games held?','1886','1892','1896','1900','C','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(66,6,'What country is the origin of the croissant?','France','Austria','Italy','Belgium','B','hard',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(67,6,'What is the main ingredient in guacamole?','Tomato','Avocado','Lime','Jalapeño','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(68,6,'What type of pasta is shaped like small tubes?','Spaghetti','Fettuccine','Penne','Linguine','C','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(69,6,'Which spirit is the main ingredient in a Margarita?','Rum','Vodka','Tequila','Gin','C','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(70,6,'What is the most consumed beverage in the world after water?','Coffee','Tea','Beer','Milk','B','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(71,6,'Sushi originated in which country?','China','Japan','Korea','Thailand','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(72,6,'What gives bread its rise?','Baking soda','Yeast','Salt','Sugar','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(73,6,'Which cheese is traditionally used on a Margherita pizza?','Cheddar','Parmesan','Mozzarella','Gouda','C','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(74,6,'What fruit is used to make wine?','Apple','Grape','Cherry','Pear','B','easy',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(75,6,'A \"pub\" is short for what?','Public bar','Public house','Pub and grub','Public hub','B','medium',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(76,1,'This is a test question?','Yes','No','I dont know','Possibly ? ','A','medium',1,'2026-04-09 17:43:30','2026-04-09 17:43:30');
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team_answers`
--

DROP TABLE IF EXISTS `team_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `team_answers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `team_id` int NOT NULL,
  `question_id` int NOT NULL,
  `selected_option` enum('A','B','C','D') DEFAULT NULL,
  `response_time_ms` int DEFAULT NULL,
  `points_earned` int NOT NULL DEFAULT '0',
  `submitted_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_team_answer` (`team_id`,`question_id`),
  KEY `fk_team_answer_question` (`question_id`),
  CONSTRAINT `fk_team_answer_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_team_answer_team` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team_answers`
--

LOCK TABLES `team_answers` WRITE;
/*!40000 ALTER TABLE `team_answers` DISABLE KEYS */;
INSERT INTO `team_answers` VALUES (11,26,31,'A',3805,0,'2026-05-05 17:36:32'),(12,18,31,'B',4656,0,'2026-05-05 17:36:32'),(13,14,31,'C',5362,10,'2026-05-05 17:36:33'),(14,13,31,'D',5411,0,'2026-05-05 17:36:33'),(15,22,31,'B',5693,0,'2026-05-05 17:36:33'),(16,25,31,'C',7603,10,'2026-05-05 17:36:35'),(17,16,31,'B',9525,0,'2026-05-05 17:36:37'),(18,15,31,'A',9421,0,'2026-05-05 17:36:37'),(19,21,31,'D',11701,0,'2026-05-05 17:36:39'),(20,23,31,'C',11777,7,'2026-05-05 17:36:40'),(21,19,31,'B',11808,0,'2026-05-05 17:36:40'),(22,24,31,'C',13107,7,'2026-05-05 17:36:41'),(23,20,31,'A',14136,0,'2026-05-05 17:36:42'),(24,17,31,'B',14378,0,'2026-05-05 17:36:42'),(25,18,32,'B',1910,10,'2026-05-05 17:36:50'),(26,28,32,'B',4021,10,'2026-05-05 17:36:52'),(27,17,32,'B',4258,10,'2026-05-05 17:36:52'),(28,25,32,'A',4938,0,'2026-05-05 17:36:53'),(29,14,32,'B',5014,10,'2026-05-05 17:36:53'),(30,16,32,'B',5421,10,'2026-05-05 17:36:53'),(31,22,32,'B',5612,10,'2026-05-05 17:36:53'),(32,13,32,'B',5912,10,'2026-05-05 17:36:53'),(33,21,32,'A',7736,0,'2026-05-05 17:36:55'),(34,20,32,'B',7934,10,'2026-05-05 17:36:56'),(35,19,32,'B',7754,10,'2026-05-05 17:36:56'),(36,23,32,'C',9141,0,'2026-05-05 17:36:57'),(37,15,32,'B',9913,10,'2026-05-05 17:36:58'),(38,26,32,'B',10530,7,'2026-05-05 17:36:58'),(39,24,32,'B',10576,7,'2026-05-05 17:36:58'),(40,27,32,'B',13431,7,'2026-05-05 17:37:01'),(41,14,33,'C',4632,15,'2026-05-05 17:37:13'),(42,13,33,'A',5309,0,'2026-05-05 17:37:13'),(43,28,33,'C',5371,15,'2026-05-05 17:37:13'),(44,25,33,'C',7110,15,'2026-05-05 17:37:15'),(45,19,33,'A',7048,0,'2026-05-05 17:37:15'),(46,26,33,'C',8687,15,'2026-05-05 17:37:17'),(47,17,33,'D',8833,0,'2026-05-05 17:37:17'),(48,24,33,'B',9585,0,'2026-05-05 17:37:18'),(49,21,33,'A',9658,0,'2026-05-05 17:37:18'),(50,18,33,'C',10265,11,'2026-05-05 17:37:18'),(51,20,33,'B',10209,0,'2026-05-05 17:37:18'),(52,16,33,'A',11541,0,'2026-05-05 17:37:19'),(53,27,33,'C',12811,11,'2026-05-05 17:37:21'),(54,22,33,'D',13815,0,'2026-05-05 17:37:22'),(55,14,34,'B',4693,10,'2026-05-05 17:37:31'),(56,24,34,'B',6564,10,'2026-05-05 17:37:33'),(57,22,34,'B',7183,10,'2026-05-05 17:37:34'),(58,21,34,'A',7305,0,'2026-05-05 17:37:34'),(59,18,34,'B',7418,10,'2026-05-05 17:37:34'),(60,19,34,'B',7473,10,'2026-05-05 17:37:34'),(61,20,34,'A',7734,0,'2026-05-05 17:37:34'),(62,15,34,'A',7915,0,'2026-05-05 17:37:34'),(63,25,34,'C',8275,0,'2026-05-05 17:37:35'),(64,13,34,'B',8996,10,'2026-05-05 17:37:35'),(65,23,34,'B',9119,10,'2026-05-05 17:37:36'),(66,17,34,'B',9374,10,'2026-05-05 17:37:36'),(67,16,34,'B',9959,10,'2026-05-05 17:37:36'),(68,27,34,'B',11394,7,'2026-05-05 17:37:38'),(69,26,34,'A',12588,0,'2026-05-05 17:37:39'),(70,28,34,'B',14133,7,'2026-05-05 17:37:41'),(71,14,35,'C',3105,0,'2026-05-05 17:37:58'),(72,22,35,'B',4283,15,'2026-05-05 17:37:59'),(73,18,35,'A',4814,0,'2026-05-05 17:37:59'),(74,26,35,'A',5826,0,'2026-05-05 17:38:00'),(75,15,35,'B',6616,15,'2026-05-05 17:38:01'),(76,25,35,'A',6861,0,'2026-05-05 17:38:02'),(77,19,35,'A',6796,0,'2026-05-05 17:38:02'),(78,16,35,'C',6961,0,'2026-05-05 17:38:02'),(79,27,35,'A',7012,0,'2026-05-05 17:38:02'),(80,23,35,'D',10813,0,'2026-05-05 17:38:06'),(81,20,35,'C',11074,0,'2026-05-05 17:38:06'),(82,28,35,'D',13357,0,'2026-05-05 17:38:08'),(83,22,36,'C',3709,10,'2026-05-05 17:38:39'),(84,28,36,'C',4349,10,'2026-05-05 17:38:40'),(85,15,36,'C',5189,10,'2026-05-05 17:38:40'),(86,19,36,'C',5161,10,'2026-05-05 17:38:41'),(87,20,36,'C',5239,10,'2026-05-05 17:38:41'),(88,17,36,'C',5844,10,'2026-05-05 17:38:41'),(89,25,36,'B',7066,0,'2026-05-05 17:38:42'),(90,27,36,'A',9909,0,'2026-05-05 17:38:45'),(91,23,36,'C',9865,10,'2026-05-05 17:38:45'),(92,21,36,'C',10500,7,'2026-05-05 17:38:46'),(93,18,36,'C',11743,7,'2026-05-05 17:38:47'),(94,18,37,'B',4721,0,'2026-05-05 17:38:59'),(95,25,37,'C',5218,10,'2026-05-05 17:39:00'),(96,28,37,'C',5279,10,'2026-05-05 17:39:00'),(97,19,37,'C',5913,10,'2026-05-05 17:39:01'),(98,21,37,'B',6353,0,'2026-05-05 17:39:01'),(99,22,37,'C',7472,10,'2026-05-05 17:39:02'),(100,26,37,'C',7941,10,'2026-05-05 17:39:03'),(101,20,37,'C',8155,10,'2026-05-05 17:39:03'),(102,23,37,'C',9008,10,'2026-05-05 17:39:04'),(103,27,37,'D',9172,0,'2026-05-05 17:39:04'),(104,15,37,'C',9736,10,'2026-05-05 17:39:05'),(105,17,37,'C',13054,7,'2026-05-05 17:39:08');
/*!40000 ALTER TABLE `team_answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teams` (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_id` int NOT NULL,
  `team_name` varchar(100) NOT NULL,
  `session_token` varchar(64) NOT NULL,
  `member_count` int NOT NULL DEFAULT '1',
  `lifeline_used` tinyint(1) NOT NULL DEFAULT '0',
  `joined_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_team_session_token` (`session_token`),
  UNIQUE KEY `uq_team_event_name` (`event_id`,`team_name`),
  CONSTRAINT `fk_team_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teams`
--

LOCK TABLES `teams` WRITE;
/*!40000 ALTER TABLE `teams` DISABLE KEYS */;
INSERT INTO `teams` VALUES (1,5,'Test Team','cf37015f03fe4790d7e04000e5c9a339b2e879b02a0f64982e185007db772ddc',3,0,'2026-04-25 15:01:57'),(2,6,'Fake team','4faac153ca065b0d2e014a00b46929dbb42ba1ec5eab5fa5fcff62209473892c',3,0,'2026-04-25 15:54:26'),(3,4,'Team4','e2f4d7f2c068c9dbd80ee978092c8699ead62556bf819e881f7f04ba0ffecef5',3,1,'2026-04-25 16:21:15'),(6,6,'Testing','fe38f2ccf720f26b1edcea0c4024d080f936505b879baf6720474b24d23d9e04',2,1,'2026-04-25 22:13:43'),(13,3,'Ninjas','8d03009d65a8db05e07d97e30e4c7d62d74c0e5a87058d2e6d9deec3c636ab44',1,1,'2026-05-05 17:35:47'),(14,3,'Burger','73f760a4c80f89a0e2b3c6d7b5fbd026539aa50ffd9fc28b92c51759cc5dfcd5',1,1,'2026-05-05 17:35:50'),(15,3,'anonm','239830760447cb486ea50a520e048d820adfa5ceea496347756225a1bb631a8e',1,0,'2026-05-05 17:35:55'),(16,3,'Yeeeee','68c9af59a6bd9ddf4a8794735da29b1d89379c49250204098343741b1595eee3',1,0,'2026-05-05 17:35:56'),(17,3,'Royal','6bc20183ed467067272c2b314eb5f240f3a1e4e447d2d70b04d953a701426170',1,1,'2026-05-05 17:35:58'),(18,3,'Wack','9dcd129bf9b1ff856d3c319a8ec93a2d132af97978c726411775d6f0df862752',1,0,'2026-05-05 17:36:01'),(19,3,'Cheez itz','09d7b7a342c89f978908f8a98e39ec0af2d14994ed5a3da9934cfdabf4df337d',1,1,'2026-05-05 17:36:02'),(20,3,'Rhygons','503fb7f289e510f0be0083d0c6626961c31fc06914ff7cea3f43b6cc70a73d08',1,0,'2026-05-05 17:36:03'),(21,3,'Daddyballs','fa5b921a6ddebdf103e1efdc5846f03d6b24bf816c3320cca154d726259c54cc',1,1,'2026-05-05 17:36:04'),(22,3,'Yerrrr','6eb213dfe5ce5699817b6100b4d8be9419f738848b3e804e61f39ded189a7fb1',1,1,'2026-05-05 17:36:11'),(23,3,'Best','fc8e5011749b57144e749c3afb33c1be1298a9729ddfb02ba9737d5b739b47e1',1,1,'2026-05-05 17:36:11'),(24,3,'y','b4bbdb1605112e98650000bb5d116080f231f139f36d907d6f58d00da019e8c2',1,0,'2026-05-05 17:36:12'),(25,3,'yas','0f2a304c4928a27d0c002329e59087aa0ec95276dcf2b612bb1443551d52d7cb',1,1,'2026-05-05 17:36:19'),(26,3,'Ummm','23a170320182ec739ec77bf41c8791be0d7c4b1240278b023269b141886cc386',1,0,'2026-05-05 17:36:23'),(27,3,'Hi!','a8266aff019848649311c3b89c432d8ab9a66bc895718f8f4acec4bab4715e83',1,0,'2026-05-05 17:36:31'),(28,3,'Bananas','d8e1c8737869530a32942db2f14b317778e13594ef356bf9a923adeea4f54392',2,1,'2026-05-05 17:36:31');
/*!40000 ALTER TABLE `teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `themes`
--

DROP TABLE IF EXISTS `themes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `themes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_theme_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `themes`
--

LOCK TABLES `themes` WRITE;
/*!40000 ALTER TABLE `themes` DISABLE KEYS */;
INSERT INTO `themes` VALUES (1,'American History','From the Revolution to modern day — test your knowledge of U.S. history.',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(2,'Music Through the Decades','Hits, artists, and moments that defined each era of music.',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(3,'2000s Nostalgia','Pop culture, tech, TV shows, and trends from the Y2K decade.',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(4,'Science & Nature','The natural world, space, chemistry, and everything in between.',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(5,'Sports Legends','Iconic athletes, championship moments, and record-breakers.',1,'2026-02-25 01:40:56','2026-02-25 01:40:56'),(6,'Food & Drink','Culinary trivia from around the world — perfect for a pub night.',1,'2026-02-25 01:40:56','2026-02-25 01:40:56');
/*!40000 ALTER TABLE `themes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'dati_trivia'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-05 13:48:22
