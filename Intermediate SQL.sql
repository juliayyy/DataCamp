-- Chapter 1: CASE
-- Chapter 2: Short & Simple Subqueries
-- Chapter 3: Correlated Queries, Nested Queries, and Common table expressions
-- Chapter 4: Window Functions

-- Chapter 1: Case
-- WHEN, THEN, ELSE, END
SELECT
    id,
    home_goal,
    away_goal,
    CASE WHEN home_goal > away_goal THEN 'HOME team WIN'
         WHEN home_goal < away_goal THEN 'Away Team Win'
         ELSE 'Tie' END AS outcome
FROM match
WHERE season = '2013/2014'

-- Basic CASE statements
-- Identify the home team as Bayern Munich, Schalke 04, or neither
SELECT
	CASE WHEN hometeam_id = 10189 THEN 'FC Schalke 04'
        WHEN hometeam_id = 9823 THEN 'FC Bayern Munich'
         ELSE 'Other' END AS home_team,
	COUNT(id) AS total_matches
FROM matches_germany
-- Group by the CASE statement alias
GROUP BY home_team;

SELECT
	m.date,
	t.team_long_name AS opponent,
    -- Complete the CASE statement with an alias
	CASE WHEN m.home_goal >  m.away_goal THEN 'Barcelona win!'
        WHEN m.home_goal <  m.away_goal THEN 'Barcelona loss :('
        ELSE 'Tie' END AS outcome
FROM matches_spain AS m
LEFT JOIN teams_spain AS t
ON m.awayteam_id = t.team_api_id
-- Filter for Barcelona as the home team
WHERE m.hometeam_id = 8634;

-- In case things get more complex
-- CASE WHEN ...AND THEN
-- WHERE CASE WHEN... AND...THEN...END IS NOT NULL
-- In CASE of rivalry
SELECT
	date,
	-- Identify the home team as Barcelona or Real Madrid
	CASE WHEN  hometeam_id = 8634 THEN 'FC Barcelona'
        ELSE 'Real Madrid CF' END AS home,
    -- Identify the away team as Barcelona or Real Madrid
	CASE WHEN awayteam_id = 8634 THEN 'FC Barcelona'
        ELSE 'Real Madrid CF' END AS away
FROM matches_spain
WHERE (awayteam_id = 8634 OR hometeam_id = 8634)
      AND (awayteam_id = 8633 OR hometeam_id = 8633);

SELECT
	date,
	CASE WHEN hometeam_id = 8634 THEN 'FC Barcelona'
         ELSE 'Real Madrid CF' END as home,
	CASE WHEN awayteam_id = 8634 THEN 'FC Barcelona'
         ELSE 'Real Madrid CF' END as away,
	-- Identify all possible match outcomes
	CASE WHEN home_goal > away_goal AND hometeam_id = 8634 THEN 'Barcelona win!'
        WHEN home_goal > away_goal AND hometeam_id = 8633 THEN 'Real Madrid win!'
        WHEN home_goal < away_goal AND awayteam_id = 8634 THEN 'Barcelona win!'
        WHEN home_goal < away_goal AND awayteam_id = 8633 THEN 'Real Madrid win!'
        ELSE 'Tie!' END AS outcome
FROM matches_spain
WHERE (awayteam_id = 8634 OR hometeam_id = 8634)
      AND (awayteam_id = 8633 OR hometeam_id = 8633);

--Filtering your CASE statement
-- Select the season, date, home_goal, and away_goal columns
-- Select the season, date, home_goal, and away_goal columns

SELECT
	season,
    date,
	home_goal,
	away_goal
FROM matches_italy
WHERE
-- Exclude games not won by Bologna
	CASE WHEN hometeam_id = 9857 AND home_goal > away_goal THEN 'Bologna Win'
		WHEN awayteam_id = 9857 AND away_goal > home_goal THEN 'Bologna Win'
		END IS NOT NULL;

-- CASE WHEN with aggregate functions
-- count
SELECT
    season,
    Count(case WHEN hometeam_id = 8650
               And home_goal > away_goal
               THEN id END) as home_wins
    Count(case WHEN awayteam_id_id = 8650
               And away_goal > home_goal
               THEN id END) as away_wins
FROM match
GROUP BY season
-- sum
SELECT
    season,
    sum(case WHEN hometeam_id = 8650
               THEN home_goal END) as home_goals
    sum(case WHEN awayteam_id_id = 8650
               THEN away_goal END) as away_goals
FROM match
GROUP BY season

-- Avg & round
SELECT
    season,
    round(avg(case WHEN hometeam_id = 8650
               THEN home_goal END),2) as home_goals
    round(avg(case WHEN awayteam_id_id = 8650
               THEN away_goal END),2) as away_goals
FROM match
GROUP BY season

-- percentage

-- Avg & round
SELECT
    season,
    AVG(case WHEN hometeam_id = 8650
               And home_goal > away_goal
               THEN 1
             WHEN hometeam_id = 8650
               And home_goal < away_goal
               THEN 0 END) as pct_homewins
    AVG(case WHEN awayteam_id_id = 8650
               And away_goal > home_goal
               THEN id 1
               WHEN awayteam_id_id = 8650
               And away_goal < home_goal
               THEN id 0 END) as away_wins
FROM match
GROUP BY season

-- COUNT using CASE WHEN
SELECT
	c.name AS country,
    -- Count matches in each of the 3 seasons
	Count(case when m.season = '2012/2013' THEN m.id END) AS matches_2012_2013,
	Count(case when m.season = '2013/2014' THEN m.id END) AS matches_2013_2014,
	Count(case when m.season = '2014/2015' THEN m.id END) AS matches_2014_2015
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
-- Group by country name alias
GROUP BY country;

-- COUNT and CASE WHEN with multiple conditions
SELECT
	c.name AS country,
    -- Sum the total records in each season where the home team won
	SUM(case when m.season = '2012/2013' AND m.home_goal > m.away_goal
        THEN 1 ELSE 0 END) AS matches_2012_2013,
 	SUM(case when m.season = '2013/2014' AND m.home_goal > m.away_goal
        THEN 1 ELSE 0 END) AS matches_2013_2014,
	SUM(case when m.season = '2014/2015' AND m.home_goal > m.away_goal
        THEN 1 ELSE 0 END) AS matches_2014_2015
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
-- Group by country name alias
GROUP BY country;

-- Calculating percent with CASE and AVG
SELECT
	c.name AS country,
    -- Calculate the percentage of tied games in each season
	avg(case when m.season='2013/2014' AND m.home_goal = m.away_goal THEN 1
			WHEN m.season='2013/2014' AND m.home_goal != m.away_goal THEN 0
			END) AS ties_2013_2014,
	avg(case when m.season='2014/2015' AND m.home_goal = m.away_goal THEN 1
			WHEN m.season='2014/2015' AND m.home_goal != m.away_goal THEN 0
			END) AS ties_2014_2015
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
GROUP BY country;

-- Calculating percent with CASE and AVG

SELECT
	c.name AS country,
    -- Round the percentage of tied games to 2 decimal points
	Round(avg(CASE WHEN m.season='2013/2014' AND m.home_goal = m.away_goal THEN 1
			 WHEN m.season='2013/2014' AND m.home_goal != m.away_goal THEN 0
			 END),2) AS pct_ties_2013_2014,
	ROund(avg(CASE WHEN m.season='2014/2015' AND m.home_goal = m.away_goal THEN 1
			 WHEN m.season='2014/2015' AND m.home_goal != m.away_goal THEN 0
			 END),2) AS pct_ties_2014_2015
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
GROUP BY country;

-- Chapter 2: Short and Simple Subqueries
-- Where
-- Filtering using scalar subqueries
SELECT
	-- Select the date, home goals, and away goals scored
    date,
	home_goal,
	away_goal
FROM  matches_2013_2014
-- Filter for matches where total goals exceeds 3x the average
WHERE ( home_goal+ away_goal) >
       (SELECT 3 * AVG(home_goal + away_goal)
        FROM matches_2013_2014);

-- Filtering using a subquery with a list
SELECT
	-- Select the team long and short names
	team_long_name,
	team_short_name
FROM team
-- Exclude all values from the subquery
WHERE team_api_id NOT IN
     (SELECT DISTINCT hometeam_ID FROM match);

-- Filtering with more complex subquery conditions
SELECT
	-- Select the team long and short names
	team_long_name,
	team_short_name
FROM team
-- Filter for teams with 8 or more home goals
WHERE team_api_id IN
	  (SELECT hometeam_ID
       FROM match
       WHERE home_goal >= 8);

-- FROM
-- Joining Subqueries in FROM
SELECT
	-- Select country name and the count match IDs
    c.name AS country_name,
    COUNT(sub.id) AS matches
FROM country AS c
-- Inner join the subquery onto country
-- Select the country id and match id columns
Inner Join (SELECT country_id, id
           FROM match
           -- Filter the subquery by matches with 10+ goals
           WHERE (home_goal + away_goal) >= 10) AS sub
ON c. id = sub.country_id
GROUP BY country_name;

-- Building on Subqueries in FROM
SELECT
	-- Select country, date, home, and away goals from the subquery
    country,
    date,
    home_goal,
    away_goal
FROM
	-- Select country name, date, and total goals in the subquery
	(SELECT c.name AS country,
     	    m.date,
     		m.home_goal,
     		m.away_goal,
           (m.home_goal + m.away_goal) AS total_goals
    FROM match AS m
    LEFT JOIN country AS c
    ON m.country_id = c.id) AS subquery
-- Filter by total goals scored in the main query
WHERE total_goals >= 10;

-- SELECT
-- Add a subquery to the SELECT clause
SELECT
	l.name AS league,
    -- Select and round the league's total goals
    ROUND(avg(m.home_goal + m.away_goal), 2) AS avg_goals,
    -- Select & round the average total goals for the season
    (SELECT round(avg(home_goal + away_goal), 2)
     FROM match
     WHERE season = '2013/2014') AS overall_avg
FROM league AS l
LEFT JOIN match AS m
ON l.country_id = m.country_id
-- Filter for the 2013/2014 season
WHERE season = '2013/2014'
GROUP BY league;

--Subqueries in Select for Calculations
SELECT
	-- Select the league name and average goals scored
	l.name AS league,
	ROUND(avg(m.home_goal + m.away_goal),2) AS avg_goals,
    -- Subtract the overall average from the league average
	ROUND(AVG(m.home_goal + m.away_goal) -
		(SELECT avg(home_goal + away_goal)
		 FROM match
         WHERE season = '2013/2014'),2) AS diff
FROM league AS l
LEFT JOIN match AS m
ON l.country_id = m.country_id
-- Only include 2013/2014 results
WHERE season = '2013/2014'
GROUP BY l.name;

-- Subqueries everywhere!
-- ALL the subqueries EVERYWHERE
SELECT
	-- Select the stage and average goals for each stage
	m.stage,
    ROUND(avg(m.home_goal + m.away_goal),2) AS avg_goals,
    -- Select the average overall goals for the 2012/2013 season
    ROUND((SELECT avg(home_goal + away_goal)
           FROM match
           WHERE season = '2012/2013'),2) AS overall
FROM match AS m
-- Filter for the 2012/2013 season
WHERE season = '2012/2013'
-- Group by stage
GROUP BY m.stage;

-- Add a subquery in FROM
SELECT
	-- Select the stage and average goals from the subquery
	stage,
	ROUND(avg_goals,2) AS avg_goals
FROM
	-- Select the stage and average goals in 2012/2013
	(SELECT
		 stage,
         avg(home_goal + away_goal) AS avg_goals
	 FROM match
	 WHERE season = '2012/2013'
	 GROUP BY stage) AS s
WHERE
	-- Filter the main query using the subquery
	s.avg_goals > (SELECT avg(home_goal + away_goal)
                    FROM match WHERE season = '2012/2013');

-- Add a subquery in SELECT
SELECT
	-- Select the stage and average goals from s
	stage,
    ROUND(avg_goals,2) AS avg_goal,
    -- Select the overall average for 2012/2013
    (SELECT avg(home_goal + away_goal) FROM match WHERE season = '2012/2013') AS overall_avg
FROM
	-- Select the stage and average goals in 2012/2013 from match
	(SELECT
		 stage,
         avg(home_goal + away_goal) AS avg_goals
	 FROM match
	 WHERE season = '2012/2013'
	 GROUP BY stage) AS s
WHERE
	-- Filter the main query using the subquery
	s.avg_goals >  (SELECT avg(home_goal + away_goal)
                    FROM match WHERE season = '2012/2013');
-- Chapter 3 Correlated subqueries
-- Basic Correlated Subqueries
SELECT
	-- Select country ID, date, home, and away goals from match
	main.country_id,
    date,
    main.home_goal,
    away_goal
FROM match AS main
WHERE
	-- Filter the main query by the subquery
	(home_goal + away_goal) >
        (SELECT AVG((sub.home_goal + sub.away_goal) * 3)
         FROM match AS sub
         -- Join the main query to the subquery in WHERE
         WHERE main.country_id = sub.country_id);

--Correlated subquery with multiple conditions
SELECT
	-- Select country ID, date, home, and away goals from match
	main.country_id,
    date,
    main.home_goal,
    away_goal
FROM match AS main
WHERE
	-- Filter for matches with the highest number of goals scored
	(home_goal + away_goal) =
        (SELECT max(sub.home_goal + sub.away_goal)
         FROM match AS sub
         WHERE main.country_id = sub.country_id
               AND 	main.season = sub.season);

-- Nested Subqueries
SELECT
    EXTRACT (month FROM date) AS month,
    sum(m.home_goal + m.away_goal) as total_goals,
    sum(m.home_goal + m.away_goal) -
    (select AVG(goals)
    FROM (select
             EXTRACT (month FROM date) AS month,
             sum(m.home_goal + m.away_goal) as goals,
             from match
             Group by month)) as avg_diff
FROM match as m
group by month

-- Nested simple subqueries
SELECT
	-- Select the season and max goals scored in a match
	season,
    max(home_goal + away_goal) AS max_goals,
    -- Select the overall max goals scored in a match
   (SELECT max(home_goal + away_goal) FROM match) AS overall_max_goals,
   -- Select the max number of goals scored in any match in July
   (SELECT max(home_goal + away_goal)
    FROM match
    WHERE id IN (
          SELECT id FROM match WHERE EXTRACT(MONTH FROM date) = 07)) AS july_max_goals
FROM match
GROUP BY season;

-- Nest a subquery in FROM
-- Count match ids
SELECT
    country_id,
    season,
    Count(country_id) AS matches
-- Set up and alias the subquery
FROM (
	SELECT
    	country_id,
    	season,
    	id
	FROM match
	WHERE home_goal >= 5 OR away_goal >= 5) as subquery
-- Group by country_id and season
GROUP BY country_id, season;

-- Nest a subquery in FROM
SELECT
	c.name AS country,
    -- Calculate the average matches per season
	avg(outer_s.matches) AS avg_seasonal_high_scores
FROM country AS c
-- Left join outer_s to country
Left join (
  SELECT country_id, season,
         COUNT(id) AS matches
  FROM (
    SELECT country_id, season, id
	FROM match
	WHERE home_goal >= 5 OR away_goal >= 5) AS inner_s
  -- Close parentheses and alias the subquery
  GROUP BY country_id, season) as outer_s
ON c.id = outer_s.country_id
GROUP BY country;

-- Common Table Expressions
-- Clean up with CTEs
-- Set up your CTE
with match_list as (
    SELECT
  		country_id,
  		id
    FROM match
    WHERE (home_goal + away_goal) >= 10)
-- Select league and count of matches from the CTE
SELECT
    l.name AS league,
    COUNT(match_list.id) AS matches
FROM league AS l
-- Join the CTE to the league table
LEFT JOIN match_list ON l.id = match_list.country_id
GROUP BY l.name;

-- Organizing with CTEs
-- Set up your CTE
WITH match_list as (
  -- Select the league, date, home, and away goals
    SELECT
  		l.name AS league,
     	date,
  		m.home_goal,
  		m.away_goal,
       (m.home_goal + m.away_goal) AS total_goals
    FROM match AS m
    LEFT JOIN league as l ON m.country_id = l.id)
-- Select the league, date, home, and away goals from the CTE
SELECT league, date, home_goal, away_goal
FROM match_list
-- Filter by total goals
WHERE total_goals >= 10;

-- CTEs with nested subqueries
-- Set up your CTE
WITH match_list AS (
    SELECT
  		country_id,
  	   (home_goal + away_goal) AS goals
    FROM match
  	-- Create a list of match IDs to filter data in the CTE
    WHERE id IN (
       SELECT id
       FROM match
       WHERE season = '2013/2014' AND EXTRACT(MONTH FROM date) = 8))
-- Select the league name and average of goals in the CTE
SELECT
	l.name,
    avg(match_list.goals)
FROM league AS l
-- Join the CTE onto the league table
LEFT JOIN match_list ON l.id = match_list.country_id
GROUP BY l.name;

-- Deciding on Techniques to use
-- Joins: combine 2 tales - for simple operations/aggregations: 2 + tables
-- Correlated Subqueries match subqueries & table - avoid limit of joins, high processing time: matching
-- Multi/Nested Subqueries: multi-step transformations - improve accuracy and reproducibility: multiple steps
-- Common Table Expression: organize sub sequentially: repetitive

-- Get team names with a subquery
SELECT
	m.date,
    -- Get the home and away team names
    hometeam,
    awayteam,
    m.home_goal,
    m.away_goal
FROM match AS m

-- Join the home subquery to the match table
left join (
  SELECT match.id, team.team_long_name AS hometeam
  FROM match
  LEFT JOIN team
  ON match.hometeam_id = team.team_api_id) AS home
ON home.id = m.id

-- Join the away subquery to the match table
left join (
  SELECT match.id, team.team_long_name AS awayteam
  FROM match
  LEFT JOIN team
  -- Get the away team ID in the subquery
  ON match.awayteam_id = team.team_api_id) AS away
ON away.id = m.id;


-- Get team names with correlated subqueries
SELECT
    m.date,
    (SELECT team_long_name
     FROM team AS t
     WHERE t.team_api_id = m.hometeam_id) AS hometeam,
    -- Connect the team to the match table
    (SELECT team_long_name
     FROM team AS t
     WHERE t.team_api_id  = m.awayteam_id) AS awayteam,
    -- Select home and away goals
     home_goal,
     away_goal
FROM match AS m;

--Get team names with CTEs
 WITH home AS (
  SELECT m.id, m.date,
  		 t.team_long_name AS hometeam, m.home_goal
  FROM match AS m
  LEFT JOIN team AS t
  ON m.hometeam_id = t.team_api_id),
-- Declare and set up the away CTE
away AS (
  SELECT m.id, m.date,
  		 t.team_long_name AS awayteam, m.away_goal
  FROM match AS m
  LEFT JOIN team AS t
  ON m.	awayteam_id = t.team_api_id)
-- Select date, home_goal, and away_goal
SELECT
	home.date,
    home.hometeam,
    away.awayteam,
    home.home_goal,
    away.away_goal
-- Join away and home on the id column
FROM home
INNER JOIN away
ON home.id = away.id;

-- Chapter 4 Windows Functions
-- OVER
SELECT
    date,
    (home_goal + away_goal) AS goals,
    avg(home_goal + away_goal) OVER () as overall_avg
FROM match
WHERE season = '2011/2012'
-- Rank
SELECT
    date,
    (home_goal + away_goal) AS goals,
    RANK() OVER (ORDER BY home_goal + away_goal DESC) as goals_rank
FROM match
WHERE season = '2011/2012'

-- The match is OVER
SELECT
	-- Select the id, country name, season, home, and away goals
	m.id,
    c.name AS country,
    m.season,
	m.home_goal,
	m.away_goal,
    -- Use a window to include the aggregate average in each row
	avg(m.home_goal + m.away_goal) OVER() AS overall_avg
FROM match AS m
LEFT JOIN country AS c ON m.country_id = c.id;

-- What's OVER here?
SELECT
	-- Select the league name and average goals scored
	l.name AS league,
    avg(m.home_goal + m.away_goal) AS avg_goals,
    -- Rank each league according to the average goals
    Rank() OVER(ORDER BY AVG(m.home_goal + m.away_goal)) AS league_rank
FROM league AS l
LEFT JOIN match AS m
ON l.id = m.country_id
WHERE m.season = '2011/2012'
GROUP BY l.name
-- Order the query by the rank you created
ORDER BY league_rank;

-- Flip OVER your results
SELECT
	-- Select the league name and average goals scored
	l.name AS league,
    avg(m.home_goal + m.away_goal) AS avg_goals,
    -- Rank leagues in descending order by average goals
    RANK() OVER(ORDER BY AVG(m.home_goal + m.away_goal) DESC) AS league_rank
FROM league AS l
LEFT JOIN match AS m
ON l.id = m.country_id
WHERE m.season = '2011/2012'
GROUP BY l.name
-- Order the query by the rank you created
ORDER BY league_rank;

-- OVER with a PARTITION
SELECT
    date,
    (home_goal + away_goal) AS goals,
    AVG(home_goal + away_goal) OVER(PARTITION BY season) AS season_avg
FROM match

SELECT
    c.name,
    m.season,
    (home_goal + away_goal) AS goals,
    AVG(home_goal + away_goal) OVER(PARTITION BY m.season,c.name) AS season_ctry_avg
FROM country as c
LEFT JOIN match as m
ON c.id = m.country_id

-- PARTITION BY a column
SELECT
	date,
	season,
	home_goal,
	away_goal,
	CASE WHEN hometeam_id = 8673 THEN 'home'
		 ELSE 'away' END AS warsaw_location,
    -- Calculate the average goals scored partitioned by season
    AVG(home_goal) OVER(PARTITION BY season) AS season_homeavg,
    AVG(away_goal) OVER(PARTITION BY season) AS season_awayavg
FROM match
-- Filter the data set for Legia Warszawa matches only
WHERE
	hometeam_id = 8673
    OR awayteam_id = 8673
ORDER BY (home_goal + away_goal) DESC;

-- PARTITION BY multiple columns
SELECT
	date,
	season,
	home_goal,
	away_goal,
	CASE WHEN hometeam_id = 8673 THEN 'home'
         ELSE 'away' END AS warsaw_location,
	-- Calculate average goals partitioned by season and month
    avg(home_goal) OVER(PARTITION BY season,
         	EXTRACT(month FROM date)) AS season_mo_home,
    avg(away_goal) OVER(PARTITION BY season,
            EXTRACT(month FROM date)) AS season_mo_away
FROM match
WHERE
	hometeam_id = 8673
    OR awayteam_id = 8673
ORDER BY (home_goal + away_goal) DESC;

-- Sliding windows
-- ROWS BETWEEN <start> AND <finish>
-- PRECEDING, FOLLOWING, UNBOUNDED PRECEDING, UNBOUNDED FOLLOWING, CURRENT ROW
SELECT
	date,
	season,
	home_goal,
	away_goal,
	SUM(home_goal) OVER(ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM match
WHERE hometeam_id = 8456
    AND season = '2011/2012'

SELECT
	date,
	season,
	home_goal,
	away_goal,
	SUM(home_goal) OVER(ORDER BY date ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS last2
FROM match
WHERE hometeam_id = 8456
    AND season = '2011/2012'

--Slide to the left
SELECT
	date,
	home_goal,
	away_goal,
    -- Create a running total and running average of home goals
    SUM(home_goal) OVER (ORDER BY date
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total,
    AVG(home_goal) OVER(ORDER BY DATE
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_avg
FROM match
WHERE
	hometeam_id = 9908
	AND season = '2011/2012';

-- Slide to the right
SELECT
	-- Select the date, home goal, and away goals
	date,
    home_goal,
    away_goal,
    -- Create a running total and running average of home goals
    sum(home_goal) OVER (ORDER BY date DESC
         ROWS BETWEEN current row AND unbounded following) AS running_total,
    avg(home_goal) over(ORDER BY date DESC
         ROWS BETWEEN current row AND unbounded following) AS running_avg
FROM match
WHERE
	awayteam_id = 9908
    AND season = '2011/2012';

-- Bring it All together
-- Setting up the home team CTE
SELECT
	m.id,
    t.team_long_name,
    -- Identify matches as home/away wins or ties
	CASE WHEN m.home_goal > m.away_goal THEN 'MU Win'
		WHEN m.home_goal < m.away_goal THEN 'MU Loss'
        ELSE 'Tie' END AS outcome
FROM match AS m
-- Left join team on the home team ID and team API id
LEFT JOIN team AS t
ON m.hometeam_id = t.team_api_id
WHERE
	-- Filter for 2014/2015 and Manchester United as the home team
	m.season = '2014/2015'
	AND t.team_long_name = 'Manchester United';

--Setting up the away team CTE
SELECT
	m.id,
    t.team_long_name,
    -- Identify matches as home/away wins or ties
	CASE WHEN m.home_goal > m.away_goal THEN 'MU Loss'
		WHEN m.home_goal < m.away_goal THEN 'MU Win'
        ELSE 'Tie' END AS outcome
-- Join team table to the match table
FROM match AS m
LEFT JOIN team AS t
ON m.awayteam_id = t.team_api_id
WHERE
	-- Filter for 2014/2015 and Manchester United as the away team
	m.season = '2014/2015'
	AND t.team_long_name = 'Manchester United';

-- Putting the CTEs together
-- Set up the home team CTE
WITH home AS (
  SELECT m.id, t.team_long_name,
	  CASE WHEN m.home_goal > m.away_goal THEN 'MU Win'
		   WHEN m.home_goal < m.away_goal THEN 'MU Loss'
  		   ELSE 'Tie' END AS outcome
  FROM match AS m
  LEFT JOIN team AS t ON m.hometeam_id = t.team_api_id),
-- Set up the away team CTE
away AS (
  SELECT m.id, t.team_long_name,
	  CASE WHEN m.home_goal > m.away_goal THEN 'MU Win'
		   WHEN m.home_goal < m.away_goal THEN 'MU Loss'
  		   ELSE 'Tie' END AS outcome
  FROM match AS m
  LEFT JOIN team AS t ON m.awayteam_id = t.team_api_id)
-- Select team names, the date and goals
SELECT DISTINCT
    m.date,
    home.team_long_name AS home_team,
    away.team_long_name AS away_team,
    m.home_goal,
    m.away_goal
-- Join the CTEs onto the match table
FROM match AS m
left JOIN home ON m.id = home.id
left JOIN away ON m.id = away.id
WHERE m.season = '2014/2015'
      AND (home.team_long_name = 'Manchester United'
           OR away.team_long_name = 'Manchester United');

-- Add a window function
-- Set up the home team CTE
WITH home AS (
  SELECT m.id, t.team_long_name,
	  CASE WHEN m.home_goal > m.away_goal THEN 'MU Win'
		   WHEN m.home_goal < m.away_goal THEN 'MU Loss'
  		   ELSE 'Tie' END AS outcome
  FROM match AS m
  LEFT JOIN team AS t ON m.hometeam_id = t.team_api_id),
-- Set up the away team CTE
away AS (
  SELECT m.id, t.team_long_name,
	  CASE WHEN m.home_goal > m.away_goal THEN 'MU Loss'
		   WHEN m.home_goal < m.away_goal THEN 'MU Win'
  		   ELSE 'Tie' END AS outcome
  FROM match AS m
  LEFT JOIN team AS t ON m.awayteam_id = t.team_api_id)
-- Select columns and and rank the matches by date
SELECT DISTINCT
    m.date,
    home.team_long_name AS home_team,
    away.team_long_name AS away_team,
    m.home_goal, m.away_goal,
    rank() OVER(ORDER BY ABS(home_goal - away_goal) DESC) as match_rank
-- Join the CTEs onto the match table
FROM match AS m
left JOIN home ON m.id = home.id
left JOIN away ON m.id = away.id
WHERE m.season = '2014/2015'
      AND ((home.team_long_name = 'Manchester United' AND home.outcome = 'MU Loss')
      OR (away.team_long_name = 'Manchester United' AND away.outcome = 'MU Loss'));