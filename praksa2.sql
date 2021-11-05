--1. 

SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM covid_deaths
WHERE continent is not null
ORDER BY 1,2

--2.

SELECT location, SUM(new_deaths) AS TotalDeathCount
FROM covid_deaths
WHERE continent is null
AND location not in ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount desc

--3.

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 AS PercentPopulationInfected 
FROM covid_deaths
GROUP BY location, population
ORDER BY PercentPopulationInfected desc

--4.

SELECT location, population, dan, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 AS PercentPopulationInfected
FROM covid_deaths
GROUP BY location, population, dan
ORDER BY PercentPopulationInfected desc