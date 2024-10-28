use campusx;
select * from salaries

/*1.You're a Compensation analyst employed by a multinational corporation. Your Assignment is to Pinpoint Countries who give work fully remotely, 
for the title'managers’ Paying salaries Exceeding $90,000 USD.*/
(select distinct company_location from salaries where job_title like '%Manager%' and salary_in_usd>90000 and remote_ratio=100);


/*2.AS a remote work advocate Working for a progressive HR tech startup who place their freshers’ clients IN large tech firms. you're tasked WITH 
Identifying top 5 Country Having  greatest count of large(company size) number of companies.*/
select company_location ,count(*) as 'cnt'from
(select * from salaries where experience_level='EN' and company_size='L')t group by company_location
order by cnt desc
limit 5;


/*3. Picture yourself AS a data scientist Working for a workforce management platform. Your objective is to calculate the percentage of employees. 
Who enjoy fully remote roles WITH salaries Exceeding $100,000 USD, Shedding light ON the attractiveness of high-paying remote positions IN today's job market.*/
set @total=(select count(*) from salaries where salary_in_usd>100000);
set @count=(select count(*) from salaries where salary_in_usd>100000 and remote_ratio=100);
set @percentage=round(((select @count)/(select @total))*100,2);
select @percentage as "percentage"


/*4.	Imagine you're a data analyst Working for a global recruitment agency. Your Task is to identify the Locations where entry-level average salaries exceed the 
average salary for that job title in market for entry level, helping your agency guide candidates towards lucrative countries.*/
select t.job_title,company_location, t.average, m.average_per_country from 
(
select job_title, avg(salary_in_usd)as 'average' from salaries where experience_level="EN" group by job_title
)t
inner join(
select company_location, job_title, avg(salary_in_usd)as 'average_per_country' from salaries where experience_level='EN' group by job_title , company_location
)m on t.job_title = m.job_title where average_per_country>average 


/*5. You've been hired by a big HR Consultancy to look at how much people get paid IN different Countries. Your job is to Find out for each job title which
Country pays the maximum average salary. This helps you to place your candidates IN those countries.*/
select * from
(
select * ,dense_rank()over(partition by job_title order by average desc ) as "num" from
(
select company_location, job_title, avg(salary_in_usd) as "average"  from salaries group by company_location, job_title
)t
)k where num=1



/*6.  AS a data-driven Business consultant, you've been hired by a multinational corporation to analyze salary trends across different company Locations.
 Your goal is to Pinpoint Locations WHERE the average salary Has consistently Increased over the Past few years (Countries WHERE data is available for 3 years Only(this and pst two years) 
 providing Insights into Locations experiencing Sustained salary growth.*/

 with abc as
 (
 select * from salaries where company_location in
 (
 select company_location from
 (
select company_location, avg(salary_in_usd) as 'average' , count(distinct work_year)as 'cnt' from salaries where work_year>=year(current_date())-2
 group by company_location having cnt=3)t
 )
 )
 select company_location, 
   MAX(CASE WHEN work_year = 2022 THEN  average END) AS AVG_salary_2022,
   MAX(CASE WHEN work_year = 2023 THEN  average END) AS AVG_salary_2023,
   MAX(CASE WHEN work_year = 2024 THEN  average END) AS AVG_salary_2024
   from (
 select company_location, work_year, avg(salary_in_usd) as 'average' from abc group by company_location,work_year)o 
 group by company_location having  AVG_salary_2024>  AVG_salary_2023 and  AVG_salary_2023> AVG_salary_2022 


 /* 7.	Picture yourself AS a workforce strategist employed by a global HR tech startup. Your missiON is to determINe the percentage of  fully remote work for each 
 experience level IN 2021 and compare it WITH the correspONdINg figures for 2024, highlightINg any significant INcreASes or decreASes IN remote work adoptiON
 over the years.*/
select experience_level, count(*)as total from salaries where work_year=2021 group by experience_level
select experience_level, count(*)as cnt from salaries where work_year=2021 and remote_ratio=100 group by experience_level







 

