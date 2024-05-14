# Introduction
📊 Let's delve into the data job market! This project zooms in on data analyst roles, exploring 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand intersects with high salary in data science.
🔍 SQL queries? Check them out here: [project_sql](/Users/sunnydevendranadh/Sql_course/project_sql)
# Background
Driven by a quest to navigate the data scientist job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

Data hails from my SQL Course. It's packed with insights on job titles, salaries, locations, and essential skills.

### The questions I wanted to answer through my SQL queries were:
1. What are the top-paying data scientist jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I used
### For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL**: The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL**: The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code**: My go-to for database management and executing SQL queries.
- **Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
 Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

### 1. Top Paying Data Scientist Jobs
I focused my search on remote postings in California under the 'Data Scientist' category in order to find the highest paying jobs. This query reveals the highest-paying jobs in the data science field by filtering on average annual salary and location.

```sql
SELECT
    job_id,
    job_title_short,
    name as company_name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM 
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short  = 'Data Scientist' 
    AND salary_year_avg IS NOT NULL
    AND job_location LIKE '%CA'
ORDER BY salary_year_avg DESC
LIMIT 10;
```
#### Here's the breakdown of the top data scientist jobs:
- **Top-Paying Remote Data Scientist Roles in California:** The query identifies the highest-paying remote data scientist positions in California. By filtering the dataset to include only jobs with non-null average yearly salaries and located in California (with a wildcard search %CA), it focuses on remote opportunities within this specific geographic area. This insight helps job seekers targeting remote data scientist roles in California to prioritize their search based on salary.

- **Data Scientist Salary Distribution:** By ordering the results by average yearly salary in descending order (ORDER BY salary_year_avg DESC), the query reveals the salary distribution among remote data scientist roles in California. This insight provides an overview of the range of salaries offered for these positions, allowing job seekers to understand the competitive landscape and negotiate effectively based on industry standards.

- **Company Preferences for Remote Data Scientist Roles:** The query also joins the company_dim table to include company names (name as company_name) in the results. This additional information enables job seekers to identify the companies offering the highest-paying remote data scientist positions in California. Understanding which companies are leading in terms of salary offerings can help job seekers target their applications towards these organizations or use them as benchmarks for negotiations with other employers.


### 2. Skills for Top Paying Jobs
To unravel the skill requirements for the highest-paying Data Scientist positions, I merged job postings with skills data. This fusion offers valuable insights into the skill sets esteemed by employers for top-compensation roles.

```sql
WITH skill_sort AS(
    SELECT
        sj.job_id,
        s.skills AS skill_name,
        jp.salary_year_avg
    FROM
        skills_dim s
    LEFT JOIN skills_job_dim AS sj ON sj.skill_id = s.skill_id 
    INNER JOIN job_postings_fact AS jp ON jp.job_id = sj.job_id
    WHERE jp.job_title_short = 'Data Scientist'
),
top_jobs AS(
    SELECT
        jp.job_id,
        jp.job_title_short AS job_title,
        c.name AS company_name,
        jp.job_location,
        jp.job_schedule_type,
        jp.salary_year_avg
    FROM 
        job_postings_fact jp
    LEFT JOIN company_dim c ON jp.company_id = c.company_id
    WHERE 
        jp.job_title_short = 'Data Scientist' 
        AND jp.salary_year_avg IS NOT NULL
        AND jp.job_location LIKE '%CA'
    ORDER BY jp.salary_year_avg DESC
    LIMIT 10
)

SELECT
    tj.job_id,
    tj.job_title,
    tj.company_name,
    tj.salary_year_avg,
    ss.skill_name
FROM
    top_jobs tj
    INNER JOIN skill_sort ss ON tj.job_id = ss.job_id
ORDER BY 
    tj.salary_year_avg DESC;
```

#### Here's the breakdown of the skills for top paying jobs:

- **Top-Paying Data Scientist Roles in California:** The query identifies the highest-paying Data Scientist positions in California by filtering job postings based on average yearly salary and location. This insight helps job seekers target lucrative opportunities in a specific geographic area.

- **Skill Requirements Analysis:** By joining the job postings with skills data, the query provides insights into the specific skills valued by employers for high-compensation Data Scientist roles. Understanding these skill requirements can guide job seekers in enhancing their skill sets to align with industry demands.

- **Company and Location Insights:** The query not only reveals the top-paying Data Scientist roles but also provides information about the companies offering these positions and their locations. This insight enables job seekers to target their applications towards specific companies and geographical areas where high-paying opportunities exist.

### 3. In-Demand Skills for Data Scientist Roles
To discern the most prevalent skills sought after for Data Scientist roles, I aggregated skills data and counted their occurrences within job postings. This analysis unveils the top five skills in demand, providing insights into the essential competencies valued by employers in the Data Scientist domain

```sql
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
```
#### Here's the breakdown of the  In-Demand Skills for Data Scientist Roles:
- **Top Skills for Data Scientist Roles:** The query identifies and counts the occurrences of various skills within job postings for Data Scientist positions. By aggregating this data, it reveals the most frequently mentioned skills sought after by employers.

- **Insight into Skill Demand:** By grouping the skills and ordering them by count in descending order (ORDER BY skill_count DESC), the query highlights the skills that are most in demand for Data Scientist roles. This insight helps job seekers understand which skills are essential to focus on developing or emphasizing in their resumes and interviews.

- **Focus on Top Skills:** The query limits the results to the top five skills (LIMIT 5), providing a concise overview of the most critical competencies. This allows job seekers to prioritize their skill development efforts based on the skills with the highest demand in the job market for Data Scientists.

### 4.Skills Based on Salary
To gauge the correlation between specific skills and average salaries in Data Analyst roles, I aggregated skills data and calculated the average yearly salary associated with each skill. This analysis provides insights into the relationship between skill sets and salary expectations within the Data Analyst domain.

```sql
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
```
#### Here's the breakdown of the kills Based on Salary:
- **Skill-Salary Correlation Analysis:** The query evaluates the relationship between individual skills and average salaries for Data Analyst positions. By joining skills data with job postings and aggregating by skill, it enables the examination of how different skills impact salary expectations within the Data Analyst field.

- **Average Salary Calculation:** The query calculates the average yearly salary (avg_salary) associated with each skill, rounded to two decimal places using the ROUND function. This provides a numerical representation of the average compensation level attributed to specific skills, aiding in understanding their relative value in the job market.

- **Insights into Skill Valuation:** Grouping the results by skill allows for a comprehensive analysis of how each skill contributes to salary variations in Data Analyst roles. This breakdown offers insights into which skills are highly valued by employers and potentially command higher compensation packages.

### 5. Most Optimal Skills to Learn
To comprehensively understand the landscape of high-paying Data Scientist roles, I've analyzed the correlation between skills, job demand, and average salaries. By merging data on job postings, skills, and salaries, this analysis unveils the top ten skills highly sought after in the Data Scientist domain, considering both job demand and associated average salaries.

```sql
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
```
#### Here's the breakdown of the kills Based on Salary:
- **Identification of High-Paying Data Scientist Roles:** The query begins by filtering job postings to focus solely on Data Scientist positions (job_title_short = 'Data Scientist') with non-null average yearly salaries (salary_year_avg IS NOT NULL). It sorts these roles by salary in descending order to isolate the highest-paying jobs.

- **Assessment of Skill Demand:** The skill_demand Common Table Expression (CTE) calculates the count of job postings for each skill among the identified high-paying Data Scientist roles. This step provides insights into the demand for various skills within this specialized field.

- **Calculation of Average Skill-Based Salaries:** Another CTE named skill_avg_salary computes the average salary associated with each skill among the high-paying Data Scientist roles. This analysis helps in understanding the monetary value attributed to different skills in the job market.

- **Integration of Skill, Job Count, and Average Salary:** Finally, the main query combines data from the previous CTEs (skill_demand and skill_avg_salary) with the skills_dim table to present a comprehensive view. It showcases the top ten skills (LIMIT 10) highly sought after in high-paying Data Scientist roles, considering both the demand for each skill (job_count) and the average salary (avg_salary) associated with it.

- **Sorting Criteria:** The results are ordered first by job count (job_count) in descending order, indicating the popularity of skills among high-paying Data Scientist roles. In case of ties in job count, the average salary (avg_salary) is used as a secondary sorting criterion in descending order to prioritize skills with higher associated salaries.

# What I Learned
Throughout my SQL journey, I've unleashed the full potential of my toolkit, elevating my skills to new heights:

🧩 Advanced Query Mastery: I've honed my ability to craft intricate SQL queries, seamlessly merging tables and executing complex WITH clauses for agile data manipulation.

📊 Agile Data Aggregation: With finesse, I've embraced the power of GROUP BY, harnessing aggregate functions like COUNT() and AVG() to distill vast datasets into actionable insights.

💡 Analytical Ingenuity: Armed with a knack for problem-solving, I've transformed real-world challenges into opportunities, leveraging SQL to uncover meaningful patterns and drive informed decision-making.

# Conclusions
This project journey through the data analyst job market has been a rewarding exploration into the realms of high-paying roles, in-demand skills, and the intersection of demand with salary in data science. By leveraging the power of SQL, I've dissected vast datasets to extract actionable insights that illuminate the landscape of opportunities for aspiring data analysts.

From uncovering the top-paying data scientist roles to dissecting the essential skills required for these positions, each query has provided valuable insights into the dynamic job market. The analysis has not only identified the most sought-after skills but also shed light on the correlation between skillsets and salary expectations, empowering individuals to make informed decisions about their career paths.

Through this journey, I've deepened my proficiency in crafting advanced SQL queries, mastering techniques for data aggregation, and honing my analytical prowess. Armed with these newfound skills and insights, I'm equipped to navigate the data analyst job market with confidence, unlocking opportunities and driving success in the ever-evolving world of data science
