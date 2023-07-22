CREATE DATABASE tennis;
USE tennis;

SELECT * FROM tennis.mens_tennis_grand_slam_winner;

RENAME TABLE tennis.mens_tennis_grand_slam_winner TO tennis.gs;

SELECT * FROM tennis.gs;

-- 1. Show the totalMatches from GSWinners
SELECT COUNT(*) AS totalMatches
FROM tennis.gs;

-- 2. Show the total number of GSWinners
SELECT COUNT(DISTINCT(WINNER)) as totalWinners
FROM tennis.gs;

-- 3. Show the total number of wins per player in decreasing order
SELECT WINNER, COUNT(WINNER) as totalWins
FROM tennis.gs
GROUP BY WINNER
ORDER BY totalWins DESC;

-- 4. Show me all tournament surfaces 
SELECT DISTINCT(TOURNAMENT_SURFACE)
FROM tennis.gs;

-- 4. Show me the most used surface in decreasing order
SELECT tournament_surface, COUNT(tournament_surface) AS mostUsedSurface
FROM tennis.gs
GROUP BY tournament_surface
ORDER BY mostUsedSurface DESC; 

-- 5. total tournament money grouped by year -> Interesting data because of CORONA
SELECT year, SUM(winner_prize) as totalPrizeMoney
FROM tennis.gs
GROUP BY year
ORDER BY totalPrizeMoney DESC;

-- 6. most wins by player on each surface type
SELECT winner, tournament_surface, COUNT(winner) as Wins
FROM tennis.gs
GROUP BY winner, tournament_surface
ORDER BY Wins DESC;

-- 7. most wins by player on each tournament and tournament surface
SELECT winner, tournament, tournament_surface, COUNT(winner) as Wins
FROM tennis.gs
GROUP BY winner, tournament, tournament_surface
ORDER BY Wins DESC
LIMIT 10;

-- 8. Most prize money by winner
SELECT winner, SUM(winner_prize) as lifePrizeMoney
FROM tennis.gs
GROUP BY winner
ORDER BY lifePrizeMoney DESC;

-- 9. Most Runner-Ups
SELECT `runner-up`, COUNT(*) AS finals
FROM tennis.gs
GROUP BY `runner-up`
ORDER BY finals DESC;

-- 10. Winners and Opponents
SELECT `runner-up`, winner, COUNT(*) AS h2h
FROM tennis.gs
GROUP BY `runner-up`, winner
ORDER BY h2h DESC;

-- 11. Total final appearances of all players by using subquery
SELECT playerName, COUNT(*) as totalAppearances
FROM ( SELECT winner as playerName 
       FROM tennis.gs
       UNION ALL
       SELECT `runner-up` as playerName 
       FROM tennis.gs ) AS a
GROUP BY playerName
ORDER BY totalAppearances DESC;

-- 12. Top Tennis Player after 2000 until 2009
SELECT winner as playerName, COUNT(*) AS wins, tournament
FROM tennis.gs
WHERE year < 2010 and year > 2000
GROUP BY playerName, tournament
ORDER BY wins DESC;

-- 13. Most wins by right handed player
SELECT winner, COUNT(*) AS wins, winner_left_or_right_handed
FROM tennis.gs
WHERE winner_left_or_right_handed = 'right'
GROUP BY winner, winner_left_or_right_handed
ORDER BY wins DESC;

-- 14. Most wins by country
SELECT winner_nationality, COUNT(*) AS wins
FROM tennis.gs
GROUP BY winner_nationality
ORDER BY wins DESC;

-- 15. Most wins by players of each country
SELECT winner, winner_nationality, COUNT(*) AS wins
FROM tennis.gs
GROUP BY winner_nationality, winner
HAVING wins = 
            (SELECT MAX(winCount)
             FROM ( SELECT winner_nationality as country, winner, COUNT(*) as winCount
                    FROM tennis.gs
                    GROUP BY country, winner ) as a
			 WHERE country = winner_nationality )
ORDER BY wins DESC;

-- 16. Most played surface based on year range
SELECT tournament_surface, COUNT(*) as matches
FROM tennis.gs
WHERE year > 2010
GROUP BY tournament_surface
ORDER BY matches DESC;


