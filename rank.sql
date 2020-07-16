--What is the rank of matches based on number of goals scored?

SELECT
	date,
    	(home_goal + away_goal) AS goals,
	RANK() OVER(ORDER BY home_goal + away_goal DESC) AS goals_rank
FROM match
GROUP BY season; 
