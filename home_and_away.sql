/* How do you get both the home and away team names into one final query result? 
There are three ways to do this. 

The first method will use nested subqueries: */


SELECT
	m.date, 
-- both the home and away team names, and respective goal counts
	hometeam,
	awayteam,
    	m.home_goal,
    	m.away_goal
FROM match AS m

-- Join the home subquery to the match table
LEFT JOIN (
  		SELECT match.id, team.team_long_name AS hometeam
  		FROM match
 		LEFT JOIN team
  		ON match.hometeam_id = team.team_api_id) 
	AS home
	ON home.id = m.id

/* ^ just inner joined home and match. 
Now we need to join the away subquery to this inner joined table */

-- Join the away subquery to the match table
LEFT JOIN (
  		SELECT match.id, team.team_long_name AS awayteam
  		FROM match
  		LEFT JOIN team
		ON match.awayteam_id = team.team_api_id)
	AS away  -- Get the away team ID in the subquery
	ON away.id = m.id;




/* The second method will use correlated subqueries:  (simpler, but slower) */

SELECT
    m.date,
    (SELECT team_long_name
     FROM team AS t
     WHERE t.team_api_id = m.hometeam_id) AS hometeam,
    -- Connect the team to the match table
    (SELECT team_long_name
     FROM team AS t
     WHERE t.team_api_id = m.awayteam_id) AS awayteam,
    -- Select home and away goals
     home_goal,
     away_goal
FROM match AS m;


/* The third method will use CTEs:   */

WITH home AS (
  SELECT m.id, m.date, 
  		 t.team_long_name AS hometeam, m.home_goal
  FROM match AS m
  LEFT JOIN team AS t 
  ON m.hometeam_id = t.team_api_id),

-- Declare and set up the away CTE
away AS (
  SELECT m.id, m.date, 
  	        t.team_long_name AS awayteam, 
  	        m.away_goal
  FROM match AS m
  LEFT JOIN team AS t 
  ON m.awayteam_id = t.team_api_id)

-- Select date, home_goal, and away_goal
SELECT 
    home.date,
    home.hometeam,
    away.awayteam,
    home.home_goal,
    away.away_goal
FROM home

-- Join away and home on the id column
INNER JOIN away
ON home.id = away.id;
