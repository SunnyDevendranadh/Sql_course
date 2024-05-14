/*
**Question: What are the most in-demand skills for data analysts?**

- Identify the top 5 in-demand skills for a Data Scientist.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market,
 providing insights into the most valuable skills for job seekers.
*/

SELECT
    s.skills AS skill_name,
    COUNT(*) AS skill_count
FROM
    skills_dim s
INNER JOIN skills_job_dim sj ON s.skill_id = sj.skill_id
INNER JOIN job_postings_fact jp ON sj.job_id = jp.job_id
WHERE
    jp.job_title_short = 'Data Scientist'
GROUP BY
    s.skills
ORDER BY
    skill_count DESC
LIMIT 5;
