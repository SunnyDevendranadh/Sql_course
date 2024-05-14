/*
**Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill) for a data analyst?** 

- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis
*/

SELECT
    s.skills AS skill_name,
    ROUND(AVG(jp.salary_year_avg), 2) as avg_salary
FROM
    skills_dim s
INNER JOIN skills_job_dim sj ON sj.skill_id = s.skill_id
INNER JOIN job_postings_fact jp ON jp.job_id = sj.job_id
WHERE
    jp.job_title_short = 'Data Analyst'
    AND jp.salary_year_avg IS NOT NULL
GROUP BY
    s.skills;
