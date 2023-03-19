/***********************************************
**                MSc ANALYTICS 
**     DATA ENGINEERING PLATFORMS (MSCA 31012)
** File:   transfrmarket DML - Final project
** Desc:   Creating the transfrmarket DML file (Group 3)
** Auth:   Devdutt Sharma, Keerthana Adavelli, Shefali Gupta, Sravani Kotha, Urvaj Shah
** Date:   12/1/2022, Last updated 12/7/2022
************************************************/

USE `transfrmarket` ;

#------------- Inserting data into numbers_small --------------------
INSERT INTO transfrmarket_3nf.numbers_small VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

#------------- Inserting data into numbers --------------------
INSERT INTO transfrmarket_3nf.numbers
SELECT 
    thousands.number * 1000 + hundreds.number * 100 + tens.number * 10 + ones.number
FROM
    numbers_small thousands,
    numbers_small hundreds,
    numbers_small tens,
    numbers_small ones
LIMIT 1500000;

#------------- Inserting data into date --------------------
#1
INSERT INTO transfrmarket_3nf.date (date)
SELECT 
    DATE_ADD('1980-01-01',
        INTERVAL number DAY)
FROM
    numbers
WHERE
    DATE_ADD('1980-01-01',
        INTERVAL number DAY) BETWEEN '1980-01-01' AND '2023-01-01'
ORDER BY number;

#2
INSERT INTO transfrmarket_3nf.date (date)
SELECT 
    DATE_ADD('2007-05-19',
        INTERVAL number DAY)
FROM
    numbers
WHERE
    DATE_ADD('2007-05-19',
        INTERVAL number DAY) BETWEEN '2007-05-19' AND '2023-01-01'
ORDER BY number;

#3
SET SQL_SAFE_UPDATES = 0;
UPDATE transfrmarket_3nf.date 
SET 
    timestamp = UNIX_TIMESTAMP(date),
    day_of_week = DATE_FORMAT(date, '%W'),
    weekend = IF(DATE_FORMAT(date, '%W') IN ('Saturday' , 'Sunday'),
        'Weekend',
        'Weekday'),
    month = DATE_FORMAT(date, '%M'),
    month_num = DATE_FORMAT(date, '%m'),
    year = DATE_FORMAT(date, '%Y'),
    month_day = DATE_FORMAT(date, '%d');

#4
UPDATE transfrmarket_3nf.date 
SET 
    week_starting_monday = DATE_FORMAT(date, '%v');
    
#------------- Inserting data into country --------------------
INSERT INTO transfrmarket_3nf.country (country_name)(
SELECT DISTINCT
    country_name
FROM
    transfrmarket.competitions_raw
WHERE
    country_name IS NOT NULL
        AND country_name <> '' 
UNION DISTINCT SELECT DISTINCT
    country_of_citizenship
FROM
    transfrmarket.players_raw
WHERE
    country_of_citizenship IS NOT NULL
        AND country_of_citizenship <> '');
        
#------------- Inserting data into competition --------------------
INSERT INTO transfrmarket_3nf.competition (name, type, country_id)
SELECT 
    name, type, cntry.country_id
FROM
    transfrmarket.competitions_raw comp
LEFT JOIN
    transfrmarket_3nf.country cntry
    ON comp.country_name = cntry.country_name
GROUP BY 1 , 2 , 3;

#------------- Inserting data into club --------------------
INSERT INTO transfrmarket_3nf.club (name) (
SELECT 
    pretty_name
FROM
    transfrmarket.clubs_raw
GROUP BY 1);

#------------- Inserting data into player --------------------
INSERT INTO transfrmarket_3nf.player (first_name, last_name, country_id_of_citizenship, date_of_birth_id, position, sub_position, foot, height_in_cm, club_id, p_id) (
SELECT 
    SUBSTRING_INDEX(pr.name, ' ', 1) AS first_name,
    SUBSTRING_INDEX(pr.name, ' ', - 1) AS last_name,
    cntry.country_id,
    d.date_key,
    position,
    sub_position,
    foot,
    height_in_cm,
    c.club_id,
    pr.player_id
FROM
    transfrmarket.players_raw pr
        LEFT JOIN
    transfrmarket_3nf.country cntry ON pr.country_of_citizenship = cntry.country_name
        LEFT JOIN
    transfrmarket.clubs_raw cr ON pr.club_id = cr.club_id
        LEFT JOIN
    transfrmarket_3nf.club c ON cr.pretty_name = c.name
        LEFT JOIN
    transfrmarket_3nf.date d ON STR_TO_DATE(pr.date_of_birth, '%m/%d/%Y') = d.date);
    
#------------- Inserting data into player_valuation --------------------
INSERT INTO transfrmarket_3nf.player_valuation (player_id, yr, market_value_usd) (
SELECT 
    p.player_id, d.year, AVG(market_value)
FROM
    transfrmarket.player_valuations_raw pvr
        LEFT JOIN
    date d ON STR_TO_DATE(pvr.date, '%m/%d/%Y') = d.date
        LEFT JOIN
    player p ON pvr.player_id = p.p_id
GROUP BY 1 , 2);

#------------- Inserting data into game --------------------
INSERT INTO transfrmarket_3nf.game (season,round, home_club_goals, away_club_goals, competition_id, home_club_id, away_club_id, date_id, g_id) (
SELECT 
    season,
    round,
    home_club_goals,
    away_club_goals,
    comp.Competition_id,
    ch.club_id,
    ca.club_id,
    date_key,
    gr.game_id
FROM
    transfrmarket.games_raw gr
        LEFT JOIN
    transfrmarket.competitions_raw compr ON gr.competition_code = compr.competition_id
        LEFT JOIN
    transfrmarket_3nf.competition comp ON compr.name = comp.name
        LEFT JOIN
    transfrmarket.clubs_raw crh ON gr.home_club_id = crh.club_id
        LEFT JOIN
    transfrmarket_3nf.club ch ON crh.pretty_name = ch.name
        LEFT JOIN
    transfrmarket.clubs_raw cra ON gr.away_club_id = cra.club_id
        LEFT JOIN
    transfrmarket_3nf.club ca ON cra.pretty_name = ca.name
        LEFT JOIN
    transfrmarket_3nf.date d ON STR_TO_DATE(gr.date, '%m/%d/%Y') = d.date);
    
#------------- Inserting data into appearances --------------------
INSERT INTO transfrmarket_3nf.appearances (
player_id, game_id, goals, assists, minutes_played, yellow_cards, red_cards, rating, tacklePerGame, interceptionPerGame, shotsPerGame, passSuccesspercentage)
(SELECT 
    p.player_id,
    g.game_id,
    goals,
    assists,
    minutes_played,
    yellow_cards,
    red_cards,
    rating,
    tacklePerGame,
    interceptionPerGame,
    shotsPerGame,
    passSuccesspercentage
FROM
    transfrmarket.appearances_raw ar
        LEFT JOIN
    transfrmarket_3nf.player p ON ar.player_id = p.p_id
        LEFT JOIN
    transfrmarket_3nf.game g ON ar.game_id = g.g_id);
