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
ORDER BY skills_demand.demand_count DESC; -- Optional: Order by demand
