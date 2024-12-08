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
