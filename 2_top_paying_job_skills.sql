
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