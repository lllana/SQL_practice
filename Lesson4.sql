###Subqueries
/*
Part 1. On which day-channel pair did the most events occur.
*/
SELECT
    DATE_TRUNC('day', occurred_at) AS event_date,
		channel,
		COUNT(*) AS count_events
FROM web_events
GROUP BY 1,2
ORDER BY 3 desc;

/*
Part 2. Match each channel to its corresponding average number of events per day.
*/
SELECT 	channel,
		    AVG(count_events) AS Avg_count_events
FROM    (SELECT DATE_TRUNC('day', occurred_at) AS event_date,
		           channel,
		           COUNT(*) AS count_events
        FROM web_events
        GROUP BY 1,2) sub
 GROUP BY 1
 ORDER BY 2 desc;

 /*
 */

 /*
 */

 /*
 */

 /*
 */

 /*
 */

 /*
 */
