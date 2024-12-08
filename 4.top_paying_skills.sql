SELECT 
    skills,
   ROUND(AVG(salary_year_avg),0) as average_salary
FROM job_postings_fact jp
INNER JOIN skills_job_dim ON jp.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short in ('Data Analyst','Business Analyst') AND 
      --job_location in ('Germany','Netherlands','Austria','Belgium','Hungary','Luxembourg') AND
      salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY average_salary DESC
LIMIT 25;