/***********************************************
**                MSc ANALYTICS 
**     DATA ENGINEERING PLATFORMS (MSCA 31012)
** File:   transfrmarket DML - Final project
** Desc:   Creating the transfrmarket DDL file (Group 3)
** Auth:   Devdutt Sharma, Keerthana Adavelli, Shefali Gupta, Sravani Kotha, Urvaj Shah
** Date:   12/1/2022, Last updated 12/7/2022
************************************************/

CREATE SCHEMA IF NOT EXISTS `transfrmarket_3nf` DEFAULT CHARACTER SET latin1 ;

USE `transfrmarket_3nf` ;

#------------- Creating table date --------------------
CREATE TABLE IF NOT EXISTS transfrmarket_3nf.date (
  `date_key` BIGINT NOT NULL auto_increment,
  `date` DATE NOT NULL,
  `timestamp` BIGINT NULL DEFAULT NULL,
  `weekend` CHAR(10) NOT NULL DEFAULT 'Weekday',
  `day_of_week` CHAR(10) NULL DEFAULT NULL,
  `month_num` INT NULL DEFAULT NULL,
  `month` CHAR(10) NULL DEFAULT NULL,
  `month_day` INT NULL DEFAULT NULL,
  `year` INT NULL DEFAULT NULL,
  `week_starting_monday` CHAR(2) NULL DEFAULT NULL,
  PRIMARY KEY (`date_key`),
  UNIQUE INDEX `date` (`date` ASC),
  INDEX `year_week` (`year` ASC, `week_starting_monday` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

#------------- Creating table numbers_small --------------------
CREATE TABLE IF NOT EXISTS transfrmarket_3nf.numbers_small (
  `number` INT NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

#------------- Creating table numbers--------------------
CREATE TABLE IF NOT EXISTS transfrmarket_3nf.numbers (
  `number` BIGINT NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

#------------- Creating table country --------------------
CREATE TABLE IF NOT EXISTS transfrmarket_3nf.country (
    `country_id` SMALLINT NOT NULL AUTO_INCREMENT,
    `country_name` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`country_id`)
)  ENGINE=INNODB;

#------------- Creating table competition --------------------
CREATE TABLE IF NOT EXISTS transfrmarket_3nf.competition (
  `competition_id` SMALLINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `type` VARCHAR(45) NULL,
  `country_id` SMALLINT NULL,
  PRIMARY KEY (`Competition_id`),
  INDEX `fk_Competition_Country1_idx` (`country_id` ASC) VISIBLE,
  CONSTRAINT `fk_Competition_Country1`
    FOREIGN KEY (`country_id`)
    REFERENCES transfrmarket_3nf.Country (Country_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

#------------- Creating table club --------------------
CREATE TABLE IF NOT EXISTS transfrmarket_3nf.club (
  `club_id` SMALLINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`club_id`))
ENGINE = InnoDB;


#------------- Creating table player --------------------
CREATE TABLE IF NOT EXISTS transfrmarket_3nf.player (
  `player_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `country_id_of_citizenship` SMALLINT NOT NULL,
  `date_of_birth_id` int NOT NULL,
  `position` VARCHAR(45) NOT NULL,
  `sub_position` VARCHAR(45) NOT NULL,
  `foot` VARCHAR(45) NOT NULL,
  `height_in_cm` smallint NOT NULL,
   `club_id` SMALLINT NOT NULL,
   `p_id` INT NOT NULL,
  PRIMARY KEY (`player_id`),
  INDEX `fk_Player_Club1_idx` (`club_id` ASC) VISIBLE,
  CONSTRAINT `fk_Player_Club1`
    FOREIGN KEY (`club_id`)
    REFERENCES `transfrmarket_3nf`.`club` (`club_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

#------------- Creating table: player valuation --------------------
CREATE TABLE IF NOT EXISTS transfrmarket_3nf.player_valuation (
  `valuation_id` INT NOT NULL AUTO_INCREMENT,
  `player_id` INT NOT NULL,
  `yr` YEAR NOT NULL,
  `market_value_usd` INT NOT NULL,
   PRIMARY KEY (`Valuation_id`),
  INDEX `fk_Player_valuation_Player1_idx` (`player_id` ASC) VISIBLE,
  CONSTRAINT `fk_Player_valuation_Player1`
    FOREIGN KEY (`player_id`)
    REFERENCES transfrmarket_3nf.player (`player_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

#------------- Creating table: game --------------------
CREATE TABLE IF NOT EXISTS transfrmarket_3nf.game (
  `game_id` INT NOT NULL auto_increment,
  `season` YEAR NOT NULL,
  `round` VARCHAR(45) NOT NULL,
  `home_club_goals` TINYINT NOT NULL,
  `away_club_goals` TINYINT NOT NULL,
  `competition_id` SMALLINT NOT NULL,
  `home_club_id` SMALLINT NULL,
  `away_club_id` SMALLINT NULL,
  `date_id` BIGINT NOT NULL,
  `g_id` int not null, 
  PRIMARY KEY (`game_id`),
  INDEX `fk_Game_Competition1_idx` (`Competition_id` ASC) VISIBLE,
  INDEX `fk_Game_Club1_idx` (`home_club_id` ASC) VISIBLE,
  INDEX `fk_Game_Club2_idx` (`away_club_id` ASC) VISIBLE,
  INDEX `fk_Game_CalendarTime1_idx` (`date_id` ASC) VISIBLE,
  CONSTRAINT `fk_Game_Competition1`
    FOREIGN KEY (`competition_id`)
    REFERENCES transfrmarket_3nf.competition (competition_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Game_Club1`
    FOREIGN KEY (`home_club_id`)
    REFERENCES transfrmarket_3nf.`club` (club_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Game_Club2`
    FOREIGN KEY (`away_club_id`)
    REFERENCES transfrmarket_3nf.`club` (club_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Game_CalendarTime1`
    FOREIGN KEY (`date_id`)
    REFERENCES transfrmarket_3nf.date (date_key)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

#------------- Creating table: appearances --------------------
CREATE TABLE IF NOT EXISTS transfrmarket_3nf.appearances (
  `appearence_id` INT NOT NULL auto_increment,
  `player_id` INT NOT NULL,
  `game_id` INT NULL,
  `goals` TINYINT NOT NULL,
  `assists` TINYINT NOT NULL,
  `minutes_played` TINYINT NOT NULL,
  `yellow_cards` TINYINT NOT NULL,
  `red_cards` TINYINT NOT NULL,
  `rating` FLOAT NOT NULL,
  `tacklePerGame` TINYINT NULL,
  `interceptionPerGame` TINYINT NULL,
  `shotsPerGame` TINYINT NULL,
  `passSuccesspercentage` FLOAT NULL,
  PRIMARY KEY (`appearence_id`),
  INDEX `fk_Appearences_Player_idx` (`player_id` ASC) VISIBLE,
  INDEX `fk_Appearences_Game1_idx` (`game_id` ASC) VISIBLE,
  CONSTRAINT `fk_Appearences_Player`
    FOREIGN KEY (`player_id`)
    REFERENCES transfrmarket_3nf.`player` (`player_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Appearences_Game1`
    FOREIGN KEY (`game_id`)
    REFERENCES transfrmarket_3nf.`game` (`game_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;