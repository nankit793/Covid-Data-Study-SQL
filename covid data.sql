
 select * from deaths$ where continent is not null

--total cases, new cases, total deaths, and poupulation in each each year
select  year(date) covid_year, count(total_cases) total_cases, count(new_cases) new_cases, 
count(total_deaths) total_deaths, count(population) population from deaths$ 
group by year(date) order by 1


--creating view
create view kapd as select  year(date) covid_year, count(total_cases) total_cases, count(new_cases) new_cases, 
count(total_deaths) total_deaths, count(population) population from deaths$ 
group by year(date) 
--order by 1

--date, total_cases and total_deaths in India
select location, max(total_cases) cases, max(total_deaths) deaths
from deaths$ 
where total_cases is not null and total_deaths is not null  and location = 'India'
group by location
order by 1, 2


--countries with highest infection rate

select location, max(total_cases), max(population),
 max((CONVERT(DECIMAL(15, 3), total_cases) / CONVERT(DECIMAL(15, 3), population)) * 100) infection_percentage
from deaths$ 
where total_cases is not null 
group by location
order by 4 desc 

--countries with higest death rate
select location, max(total_deaths), max(population),
 max((CONVERT(DECIMAL(15, 3), total_deaths) / CONVERT(DECIMAL(15, 3), population)) * 100) death_percentage
from deaths$ 
where total_deaths is not null and continent is not null
group by location
order by 4 desc 

--continents with higest death rate
select location continents, sum((CONVERT(DECIMAL(15, 3), total_deaths))) death, max(population) population,
 max((CONVERT(DECIMAL(15, 3), total_deaths) / CONVERT(DECIMAL(15, 3), population)) * 100) death_percentage
from deaths$ 
where total_deaths is not null and continent is  null
group by location
order by 4 desc 

-- total population vs total vaccination on countries
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(CONVERT(DECIMAL(15, 3), total_deaths)) over(partition by dea.location order by dea.location, dea.date) as vaccinated
from deaths$ dea join vaccinations$ vac on 
dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2, 3


