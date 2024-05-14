/*
**Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill) for a data analyst?** 

- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis
*/
WITH high_salary_jobs AS (
    SELECT
        job_id,
        salary_year_avg
    FROM
        job_postings_fact
    WHERE
        job_title_short = 'Data Scientist'
        AND salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
),
skill_demand AS (
    SELECT
        sj.skill_id,
        COUNT(*) AS job_count
    FROM
        skills_job_dim sj
    INNER JOIN high_salary_jobs hs ON sj.job_id = hs.job_id
    GROUP BY
        sj.skill_id
),
skill_avg_salary AS (
    SELECT
        sj.skill_id,
        AVG(hs.salary_year_avg) AS avg_salary
    FROM
        skills_job_dim sj
    INNER JOIN high_salary_jobs hs ON sj.job_id = hs.job_id
    GROUP BY
        sj.skill_id
)
SELECT
    s.skills AS skill_name,
    sd.job_count,
    ROUND(sa.avg_salary,2) as avg_salary
FROM
    skill_demand sd
INNER JOIN skills_dim s ON sd.skill_id = s.skill_id
INNER JOIN skill_avg_salary sa ON sd.skill_id = sa.skill_id
ORDER BY
    sd.job_count DESC, sa.avg_salary DESC
LIMIT 10;
