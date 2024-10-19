CREATE DATABASE project_DataAnalyst;

USE project_DataAnalyst;

SELECT * FROM ds_salary;

SELECT
	job_titLe,
    total_salary
FROM (
SELECT
	job_title,
    SUM(salary) total_salary,
    RANK() OVER(ORDER BY SUM(salary) DESC) as ranking_job
FROM ds_salary
GROUP BY job_title) as pp
WHERE ranking_job <= 5;



WITH salary_metrics AS (
  SELECT 
	work_year,
    job_title,
    experience_level,
    employment_type,
    company_location,
    work_type,
    company_size,
    SUM(salary) as total_salary,
    AVG(salary) AS avg_salary,
    MAX(salary) AS max_salary,
    COUNT(job_title) AS total_employees
  FROM 
    ds_salary
  GROUP BY 
    work_year, job_title, experience_level, employment_type, company_location, work_type, company_size
)

SELECT 
	work_year,
    job_title,
    experience_level,
    employment_type,
    company_location,
    work_type,
    company_size,
    total_salary AS "Total Salary",
    total_employees AS "Total Employees",
    CASE 
      WHEN total_salary > 100000 THEN 'High Salary'
      WHEN total_salary BETWEEN 50000 AND 100000 THEN 'Medium Salary'
      ELSE 'Low Salary'
    END AS salary_category,
    LAG(total_salary, 1) OVER(PARTITION BY experience_level ORDER BY work_year) as prev_year_salary,
    ROUND((total_salary - LAG(total_salary, 1) OVER(PARTITION BY experience_level ORDER BY work_year))/
    LAG(total_salary, 1) OVER(PARTITION BY experience_level ORDER BY work_year)*100, 2) as YoY_salary_gwroth
FROM 
    salary_metrics;
    
    
    
SELECT
	experience_level,
    ROUND(AVG(salary),2) as avg_salary
FROM ds_salary
GROUP BY experience_level
ORDER BY avg_salary DESC;

