CREATE DATABASE animedatabase;
USE animedatabase;

CREATE TABLE `Source` (
  `Source_Id` INT,
  `Source_Type` VARCHAR(30),
  PRIMARY KEY (`Source_Id`)
);

SELECT * FROM Anime_Type;

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

SELECT * FROM Raiting_Type;

CREATE TABLE `Anime` (
  `MAL_ID` INT,
  `Name` VARCHAR(170),
  `Score` INT,
  `Genre` VARCHAR(170),
  `Anime_Type_Id` INT,
  `Episodes` INT,
  `Aired` DATE,
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

CREATE TABLE `DIM_Dates` (
  `DIM_dates_id` INT AUTO_INCREMENT,
  `Year` INT,
  `Month` INT,
  `Day` INT,
  `First_aired` DATE,
  PRIMARY KEY (`DIM_dates_id`)
);

CREATE TABLE `FT_Anime` (
  `MALS_ID` INT,
  `Name` VARCHAR(170),
  `Source` VARCHAR(30),
  `Genre` VARCHAR(170),
  `Anime_Type` VARCHAR(20),
  `Episodes` INT,
  `DIM_dates_id` INT AUTO_INCREMENT,
  `Score` INT,
  `start_date` DATE,
  `end_date` DATE,
  `Favorites` INT,
  `Ranked` INT,
  `Popularity` INT,
  `Members` INT,
  PRIMARY KEY (`MALS_ID`),
  FOREIGN KEY (`DIM_dates_id`) REFERENCES `DIM_Dates`(`DIM_dates_id`)
);

CREATE TABLE `DIM_Creators` (
  `Producers` VARCHAR(170),
  `Licensors` VARCHAR(170),
  `Studios` VARCHAR(170),
  `Source` VARCHAR(30),
  `start_date` DATE,
  `end_date` DATE,
  `MALS_ID` INT,
  FOREIGN KEY (`MALS_ID`) REFERENCES `FT_Anime`(`MALS_ID`)
);

CREATE TABLE `DIM_Users_raiting` (
  `DIM_Users_Id` INT,
  `end_date` DATE,
  `start_date` DATE,
  `MALS_ID` INT,
  `Raiting` INT,
  FOREIGN KEY (`MALS_ID`) REFERENCES `FT_Anime`(`MALS_ID`)
);

CREATE TABLE `DIM_Score` (
  `MALS_ID` INT,
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


DELIMITER //

CREATE TRIGGER generate_dates_user
BEFORE INSERT ON DIM_Users_raiting
FOR EACH ROW
BEGIN
    SET NEW.start_date = DATE_SUB(CURRENT_DATE(), INTERVAL FLOOR(RAND() * 365) DAY);
    SET NEW.end_date = DATE_ADD(CURRENT_DATE(), INTERVAL FLOOR(RAND() * 30) DAY);
END //

DELIMITER ;