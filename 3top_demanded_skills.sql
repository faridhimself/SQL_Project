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