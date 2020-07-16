/* SQL

How does each months total goals differ from the average monthly total goals scored? */

SELECT 
	EXTRACT(MONTH FROM date) AS month,	
	SUM(m.home_goal + m.away_goal) AS total_goals,
	SUM(m.home_goal + m.away_goal) -
		(SELECT AVG(goals)
		FROM (SELECT 
				EXTRACT(MONTH FROM date) AS month,
				SUM(home_goal + away_goal) AS goals
			FROM match
			GROUP BY month) ) AS avg_diff
FROM match as m
GROUP BY month;

--Breakdown: (Subquery first)
(SELECT 
	EXTRACT(MONTH FROM date) AS month,
	SUM(home_goal + away_goal) AS goals
FROM match
GROUP BY month);
/* logic: first, select the sum of goals scored in each month. Month is taken from date.
Returns: two columns in a table, first is month (1-12), second is goals. */


-- Secondmost outer (scalar) subquery:
(SELECT AVG(goals)
FROM (SELECT 
		EXTRACT(MONTH FROM date) AS month,
		SUM(home_goal + away_goal) AS goals
	FROM match
	GROUP BY month) ) AS avg_diff ;
/* this section calculates an average of the values generated in the previous table.
Returns: 2944.75, which is the average monthly goals scored. 

The entire nested subquery returns a scalar value to compare to the SUM of goals scored in each month. */
