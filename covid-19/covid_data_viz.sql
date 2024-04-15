-- Overall death rate 
select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths,
(sum(cast(new_deaths as float))/sum(new_cases)) * 100 as death_rate
from CovidDeaths
where continent is not null
order by 1,2

-- Total death count per contitnent 
select location as continent, sum(new_deaths) as total_death_count
from CovidDeaths
where continent is null
and location != 'World' and location not like '%income' and location not like '% union'
group by location 
order by 2

-- Percentage of population infected per country
select location, population, max(total_cases) as highest_infected_count,
max(cast(total_cases as float)/population) * 100 as population_infected_percent
from CovidDeaths
where continent is not null
group by location, population
order by 1

-- Percentage of population infected per day per country
select location, population, date, max(total_cases) as highest_infected_count,
max((cast(total_cases as float)/population) * 100) as population_infected_percent
from CovidDeaths
where continent is not null
group by location, population, date 
order by 1, population_infected_percent desc

select date, max(total_cases) as highest_infected_count,
max((cast(total_cases as float)/population) * 100) as population_infected_percent
from CovidDeaths
where continent is not null
group by date 
order by 1, population_infected_percent desc


select date, sum(total_cases) as total_cases, sum(new_cases) as new_cases, sum(population) as total_population, 
(convert(float, sum(total_cases))/sum(population)) * 100 as infected_rate,
(convert(float, sum(new_cases))/sum(population)) * 100 as infected_rate_x
from CovidDeaths
where continent is not null
and year(date) = '2020'
group by date 
order by date 

-- Death rate per year 
select year(date) as years, sum(new_cases) as total_cases, sum(new_deaths) as total_death,
sum(population) as population, (sum(new_deaths)/convert(float, sum(new_cases))) * 100 as death_rate
from CovidDeaths
where continent is not null
-- and year(date) = '2020'
group by year(date) 
order by years