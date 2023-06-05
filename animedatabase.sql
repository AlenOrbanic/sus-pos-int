CREATE DATABASE animedatabase;
USE animedatabase;

CREATE TABLE `Source` (
  `Source_Id` INT,
  `Source_Type` VARCHAR(30),
  PRIMARY KEY (`Source_Id`)
);

CREATE TABLE `Anime_Type` (
  `Anime_Type_Id` INT,
  `Anime_Type_Name` VARCHAR(20),
  PRIMARY KEY (`Anime_Type_Id`)
);

CREATE TABLE `Raiting_Type` (
  `Raiting_Type_Id` INT,
  `Raiting_Type_Name` VARCHAR(40),
  PRIMARY KEY (`Raiting_Type_Id`)
);

CREATE TABLE `Anime` (
  `MAL_ID` INT,
  `Name` VARCHAR(170),
  `Score` INT,
  `Genre` VARCHAR(170),
  `Anime_Type_Id` INT,
  `Episodes` INT,
  `Aired` DATE,
  `Description` VARCHAR(50),
  `Producers` VARCHAR(170),
  `Licensors` VARCHAR(170),
  `Studios` VARCHAR(170),
  `Source_Id` INT,
  `Duration` VARCHAR(50),
  `Raiting_Type_Id` INT,
  PRIMARY KEY (`MAL_ID`),
  FOREIGN KEY (`Source_Id`) REFERENCES `Source`(`Source_Id`),
  FOREIGN KEY (`Anime_Type_Id`) REFERENCES `Anime_Type`(`Anime_Type_Id`),
  FOREIGN KEY (`Raiting_Type_Id`) REFERENCES `Raiting_Type`(`Raiting_Type_Id`)
);

CREATE TABLE `Score` (
  `MAL_ID` INT,
  `Score_1` INT,
  `Score_2` INT,
  `Score_3` INT,
  `Score_4` INT,
  `Score_5` INT,
  `Score_6` INT,
  `Score_7` INT,
  `Score_8` INT,
  `Score_9` INT,
  `Score_10` INT,
  FOREIGN KEY (`MAL_ID`) REFERENCES `Anime`(`MAL_ID`)
);

CREATE TABLE `Watching_status` (
  `Status_Id` INT,
  `Status_Description` VARCHAR(20),
  PRIMARY KEY (`Status_Id`)
);

CREATE TABLE `Community_Feedback` (
  `MAL_ID` INT,
  `Ranked` INT,
  `Popularity` INT,
  `Members` INT,
  `Favorites` INT,
  FOREIGN KEY (`MAL_ID`) REFERENCES `Anime`(`MAL_ID`)
);

CREATE TABLE `User_Watching` (
  `User_Id` INT,
  `MAL_ID` INT,
  `Status_Id` INT,
  `Watched_episodes` INT,
  `Raiting` Float,
  FOREIGN KEY (`MAL_ID`) REFERENCES `Anime`(`MAL_ID`),
  FOREIGN KEY (`Status_Id`) REFERENCES `Watching_status`(`Status_Id`)
);

DELIMITER //

CREATE TRIGGER generate_dates_score
BEFORE INSERT ON DIM_Score
FOR EACH ROW
BEGIN
    SET NEW.start_date = DATE_SUB(CURRENT_DATE(), INTERVAL FLOOR(RAND() * 365) DAY);
    SET NEW.end_date = DATE_ADD(CURRENT_DATE(), INTERVAL FLOOR(RAND() * 30) DAY);
END //

DELIMITER ;

CREATE TABLE `DIM_Score` (
  `DIM_Scores_ID` INT AUTO_INCREMENT PRIMARY KEY,
  `Score_1` INT,
  `Score_2` INT,
  `Score_3` INT,
  `Score_4` INT,
  `Score_5` INT,
  `Score_6` INT,
  `Score_7` INT,
  `Score_8` INT,
  `Score_9` INT,
  `Score_10` INT,
  `start_date` DATE,
  `end_date` DATE,
  `MALS_ID` INT,
  FOREIGN KEY (`MALS_ID`) REFERENCES `FT_Anime`(`MALS_ID`)
);

DELIMITER //

CREATE TRIGGER generate_dates_creators
BEFORE INSERT ON DIM_Creators
FOR EACH ROW
BEGIN
    SET NEW.start_date = DATE_SUB(CURRENT_DATE(), INTERVAL FLOOR(RAND() * 365) DAY);
    SET NEW.end_date = DATE_ADD(CURRENT_DATE(), INTERVAL FLOOR(RAND() * 30) DAY);
END //

DELIMITER ;

CREATE TABLE `DIM_Creators` (
  `Producers` VARCHAR(170),
  `Licensors` VARCHAR(170),
  `Studios` VARCHAR(170),
  `Source` VARCHAR(30),
  `start_date` DATE,
  `end_date` DATE,
  `DIM_Creators_ID` INT PRIMARY KEY AUTO_INCREMENT,
  `MALS_ID` INT,
  FOREIGN KEY (`MALS_ID`) REFERENCES `FT_Anime`(`MALS_ID`)
);

CREATE TABLE `DIM_Dates` (
  `DIM_dates_id` INT AUTO_INCREMENT PRIMARY KEY,
  `Year` INT,
  `Month` INT,
  `Day` INT,
  `First_aired` DATE
);

DELIMITER //
CREATE TRIGGER increment_date_values
BEFORE INSERT ON `DIM_Dates`
FOR EACH ROW
BEGIN
    SET NEW.`Year` = YEAR(NEW.`First_aired`);
    SET NEW.`Month` = MONTH(NEW.`First_aired`);
    SET NEW.`Day` = DAY(NEW.`First_aired`);
END //
DELIMITER ;

DELIMITER //

CREATE TRIGGER generate_dates
BEFORE INSERT ON FT_Anime
FOR EACH ROW
BEGIN
    SET NEW.start_date = DATE_SUB(CURRENT_DATE(), INTERVAL FLOOR(RAND() * 365) DAY);
    SET NEW.end_date = DATE_ADD(CURRENT_DATE(), INTERVAL FLOOR(RAND() * 30) DAY);
END //

DELIMITER ;

CREATE TABLE `FT_Anime` (
  `MALS_ID` INT,
  `Name` VARCHAR(170),
  `Source` VARCHAR(30),
  `Genre` VARCHAR(170),
  `Anime_Type` VARCHAR(100),
  `Episodes` INT,
  `DIM_dates_id` INT AUTO_INCREMENT,
  `start_date` DATE,
  `end_date` DATE,
  PRIMARY KEY (`MALS_ID`),
  FOREIGN KEY (`DIM_dates_id`) REFERENCES `DIM_Dates`(`DIM_dates_id`)
);

DELIMITER //

CREATE TRIGGER generate_dates_raiting
BEFORE INSERT ON DIM_Raiting
FOR EACH ROW
BEGIN
    SET NEW.start_date = DATE_SUB(CURRENT_DATE(), INTERVAL FLOOR(RAND() * 365) DAY);
    SET NEW.end_date = DATE_ADD(CURRENT_DATE(), INTERVAL FLOOR(RAND() * 30) DAY);
END //

DELIMITER ;

CREATE TABLE `DIM_Raiting` (
  `DIM_Raitings_ID` INT PRIMARY KEY AUTO_INCREMENT,
  `MALS_ID` INT,
  `Ranked` INT,
  `Popularity` INT,
  `Members` INT,
  `Favorites` INT,
  `Raiting_type` VARCHAR(20),
  `Overall_score` Float,
  `start_date` DATE,
  `end_date` DATE,
  FOREIGN KEY (`MALS_ID`) REFERENCES `FT_Anime`(`MALS_ID`)
);

DELIMITER //

CREATE TRIGGER generate_dates_user
BEFORE INSERT ON DIM_User
FOR EACH ROW
BEGIN
    SET NEW.start_date = DATE_SUB(CURRENT_DATE(), INTERVAL FLOOR(RAND() * 365) DAY);
    SET NEW.end_date = DATE_ADD(CURRENT_DATE(), INTERVAL FLOOR(RAND() * 30) DAY);
END //

DELIMITER ;

CREATE TABLE `DIM_User` (
  `DIM_Users_Id` INT,
  `MALS_ID` INT,
  `Anime_watch_status` VARCHAR(20),
  `Anime_Raiting` INT,
  `start_date` DATE,
  `end_date` DATE,
  FOREIGN KEY (`MALS_ID`) REFERENCES `FT_Anime`(`MALS_ID`)
);