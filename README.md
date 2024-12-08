# SQL_Project

## Introduction  
This repository demonstrates an SQL-based analysis of job market trends and skill demands using a structured dataset. It features queries that explore high-paying jobs, the skills associated with them, and the most in-demand and optimal skills for key analytical roles.

## Background  
The project analyzes job postings to achieve the following objectives:  
1. Identify top-paying jobs and their associated skills.  
2. Determine the most demanded skills for analytical roles.  
3. Rank skills based on demand and salary to guide job seekers and recruiters in understanding the market.

This analysis focuses on Data Analyst and Business Analyst roles across several European countries.

## Tools I Used  
- **SQL**: For database querying and data manipulation.  
- **PostgreSQL**: As the relational database management system.  
- **GitHub**: For version control and collaboration.

---

## Queries and Analysis  

### 1. Top-Paying Jobs  
**Query**:  
```sql
SELECT
    job_id,
    name as company_name,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM job_postings_fact jp
LEFT JOIN company_dim c
ON jp.company_id = c.company_id
WHERE job_title_short = 'Data Analyst' AND
      job_location in ('Luxembourg','Netherlands','Germany','Austria','Hungary') AND
      salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 100;
```
**Objective**:  
Identify the top 100 highest-paying Data Analyst jobs in Luxembourg, Netherlands, Germany, Austria, and Hungary.

---

### 2. Skills for Top-Paying Jobs  
**Query**:  
```sql
With top_paying_jobs as (
    SELECT
        job_id,
        name as company_name,
        job_title,
        salary_year_avg
    FROM job_postings_fact jp
    LEFT JOIN company_dim c
    ON jp.company_id = c.company_id
    WHERE job_title_short = 'Data Analyst' AND
        job_location in ('Luxembourg','Netherlands','Germany','Austria','Hungary') AND
        salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 100
)
SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;
```
**Objective**:  
Identify skills associated with the top-paying Data Analyst jobs.

---

### 3. Most Demanded Skills  
**Query**:  
```sql
SELECT 
    skills,
    count(jp.job_id) as demand_count
FROM job_postings_fact jp
INNER JOIN skills_job_dim ON jp.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short in ('Data Analyst','Business Analyst') AND 
      job_location in ('Germany','Netherlands','Austria','Belgium','Hungary','Luxembourg')
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 10;
```
**Objective**:  
Rank the top 10 most demanded skills for Data Analysts and Business Analysts across Europe.

---

### 4. Top-Paying Skills  
**Query**:  
```sql
SELECT  
    skills,
   ROUND(AVG(salary_year_avg),0) as average_salary
FROM job_postings_fact jp
INNER JOIN skills_job_dim ON jp.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short in ('Data Analyst','Business Analyst') AND 
      salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY average_salary DESC
LIMIT 25;
```
**Objective**:  
Identify the top 25 highest-paying skills for analytical roles, ranked by average salary.

---

### 5. Optimal Skills (Demand & Salary)  
**Query**:  
```sql
WITH skills_demand AS (
    SELECT 
        skills_job_dim.skill_id,
        skills,
        COUNT(jp.job_id) AS demand_count
    FROM job_postings_fact jp
    INNER JOIN skills_job_dim ON jp.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short IN ('Data Analyst', 'Business Analyst') 
          AND salary_year_avg IS NOT NULL
    GROUP BY skills_job_dim.skill_id, skills
),
avg_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        skills,
        ROUND(AVG(salary_year_avg), 0) AS average_salary
    FROM job_postings_fact jp
    INNER JOIN skills_job_dim ON jp.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short IN ('Data Analyst', 'Business Analyst') 
          AND salary_year_avg IS NOT NULL
    GROUP BY skills_job_dim.skill_id, skills
)
SELECT 
    skills_demand.skill_id, 
    skills_demand.skills,
    skills_demand.demand_count,
    avg_salary.average_salary
FROM skills_demand
INNER JOIN avg_salary ON skills_demand.skill_id = avg_salary.skill_id
ORDER BY skills_demand.demand_count DESC;
```
**Objective**:  
Identify skills that balance both demand and average salary, providing a comprehensive overview of optimal skills for analytical roles.

---

## What I Learned  
1. Writing complex SQL queries using subqueries, `CTEs`, joins, and aggregations.  
2. Analyzing datasets to uncover patterns in job markets and skill demands.  
3. Ranking and filtering data based on salary, demand, and location to derive actionable insights.  
4. Utilizing SQL for real-world decision-making scenarios.

## Conclusion  
This project provided valuable insights into the job market for analysts, emphasizing the importance of understanding both demand and salary dynamics. The queries highlight the value of SQL in uncovering trends and helping stakeholders make informed decisions.

Feel free to explore the repository and provide your feedback!
