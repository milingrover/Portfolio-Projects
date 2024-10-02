-- Exploratory Data Analysis --
select * 
from layoffs_copy2;



select *
from layoffs_copy2
order by total_laid_off desc;

select *
from layoffs_copy2
order by funds_raised_millions desc;

select min(`date`), max(`date`)
from layoffs_copy2;

select company, sum(total_laid_off) as sumtotallaidoff
from layoffs_copy2
group by company
order by 2 ;

select industry, sum(total_laid_off) 
from layoffs_copy2
group by industry
order by 2 desc;

select country, sum(total_laid_off) 
from layoffs_copy2
group by country
order by 2 desc;

select year(`date`), sum(total_laid_off)
from layoffs_copy2
group by year(`date`)
order by 2 desc;

-- Progression Of Layoffs using rolling total --
select * 
from layoffs_copy2;

select substring(`date`, 1 , 7) as `month`, sum(total_laid_off)
from layoffs_copy2
where substring(`date`, 1 , 7) is not null
group by `month`
order by 1 asc;

with rolling_total as
(select substring(`date`, 1 , 7) as `MONTH`, sum(total_laid_off) sum_off
from layoffs_copy2
where substring(`date`, 1 , 7) is not null
group by `MONTH`
order by `MONTH` asc)
select `MONTH`, sum_off, sum(sum_off)
over (order by `MONTH`) as roll_total
from rolling_total;


-- ranking according to the number of employees laid off
with cte_company(company, years ,total_laid_off) as
(select company, year(`date`), sum(total_laid_off)
from layoffs_copy2
group by company, year(`date`)
order by sum(total_laid_off) desc)
, cte_ranking as 
(select *,
dense_rank() over(partition by years order by total_laid_off desc) as ranking
from cte_company
where years is not null
order by ranking asc)
select * 
from cte_ranking where
ranking <=5
;





