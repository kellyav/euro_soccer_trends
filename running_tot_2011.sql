/* running total of goals scored by the FC Utrecht during the 2011/2012 season. 
Do they score more goals at the end of the season as the home or away team? */

-- when they were the home team:
SELECT 
	date,
	home_goal,
	away_goal,
    -- Create a running total and running average of home goals
	SUM(home_goal) OVER(ORDER BY date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total,
    AVG(home_goal) OVER(ORDER BY date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_avg
FROM match
WHERE	hometeam_id = 9908 
    AND season = '2011/2012’;


-- how does FC Utrecht perform when they're the away team?
SELECT 
    date,
    home_goal,
    away_goal,
    SUM(home_goal) OVER(ORDER BY date DESC
         ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS running_total,
    AVG(home_goal) OVER(ORDER BY date DESC
         ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS running_avg
FROM match
WHERE awayteam_id = 9908 
    AND season = '2011/2012';
