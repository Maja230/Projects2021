--Pregled podataka

SELECT
    *
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
ORDER BY
    3,
    4;

SELECT
    *
FROM
    covid_vacinations
ORDER BY
    3,
    4;

-- odabir podataka koje cemo koristiti

SELECT
    location,
    dan,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
ORDER BY
    1,
    2;

-- ukupni slucajevi vs ukupne smrti po zemlji
-- pokazuje vjerovatnocu smrti u slucaju zaraze kovidom
SELECT
    location,
    dan,
    total_cases,
    total_deaths,
    ( total_deaths / total_cases ) * 100 AS death_percentage
FROM
    covid_deaths
WHERE
    location LIKE '%Peru%'
    AND continent IS NOT NULL
ORDER BY
    1,
    2;

-- ukupni slucajevi vs populacija
-- pokazuje ukupni procenat populacije koji je dobio korronu
SELECT
    location,
    dan,
    population,
    total_cases,
    ( total_cases / population ) * 100 AS percent_population_infected
FROM
    covid_deaths
--where location like '%Peru%'
ORDER BY
    1,
    2;

-- trazimo zemlje sa najvecim brojem zarazenim po glavi stanovnika

SELECT
    location,
    population,
    MAX(total_cases)                    AS maksimum,
    MAX(total_cases / population) * 100 AS percent_population_infected
FROM
    covid_deaths
--where location like '%Peru%'
GROUP BY
    location,
    population
ORDER BY
    4 DESC;

-- trazimo zemlje sa najvecom smrtnoscu po glavi stanovnika

SELECT
    location,
    MAX(total_deaths) AS total_death_count
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
    AND total_deaths IS NOT NULL
GROUP BY
    location
ORDER BY
    2 DESC;
    
    
-- PO KONTINENTU

-- prikaz kontinenata sa najvecom smrtnoscu po glavi stanovnika

SELECT
    continent,
    MAX(total_deaths) AS total_death_count
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
GROUP BY
    continent
ORDER BY
    2 DESC;
    
-- globalni brojevi

SELECT
    SUM(new_cases)                         AS total_cases,
    SUM(new_deaths)                        AS total_deaths,
    SUM(new_deaths) / SUM(new_cases) * 100 AS deathpercentage
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
ORDER BY
    1,
    2;
    
-- ukupna populacija vs vakcinacije
-- procenat populacije koji je primio barem jednu covid vakcinu

SELECT
    dea.continent,
    dea.location,
    dea.dan,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations)
    OVER(PARTITION BY dea.location
         ORDER BY
             dea.location, dea.dan
    ) AS rollingpeoplevaccinated
--, (RollingPeopleVaccinated/population)*100
FROM
         covid_deaths dea
    JOIN covid_vacinations vac ON dea.location = vac.location
                                   AND dea.dan = vac.dan
WHERE
    dea.continent IS NOT NULL
ORDER BY
    2,
    3;
    
    
-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, dan, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.dan, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.dan) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From covid_deaths dea
Join covid_vacinations vac
	On dea.location = vac.location
	and dea.dan = vac.dan
where dea.continent is not null 
--order by 2,3
)
Select * -- (RollingPeopleVaccinated/Population)*100
From PopvsVac

SELECT
    location,
    MAX(total_deaths),
    MAX(population),
    ( MAX(total_deaths) / MAX(population) ) * 100 AS percent_of_deaths
FROM
    covid_deaths
WHERE
    location IN ( 'Albania', 'Montenegro', 'Serbia', 'Croatia', 'Bosnia and Herzegovina',
                  'Slovenia', 'Kosovo' )
    AND dan = '19.10.2021.'
GROUP BY
    location



SELECT
    location,
    MAX(total_cases),
    MAX(population),
    ( MAX(total_cases) / MAX(population) ) * 100 AS percent_of_cases
FROM
    covid_deaths
WHERE
    location IN ( 'Albania', 'Montenegro', 'Serbia', 'Croatia', 'Bosnia and Herzegovina',
                  'Slovenia', 'Kosovo' )
    AND dan = '19.10.2021.'
GROUP BY
    location



SELECT
    location,
    MAX(rolling_people_vaccinated),
    MAX(population),
    ( MAX(rolling_people_vaccinated) / MAX(population) ) * 100 AS percent_of_vaccinations
FROM
    Percent_Population_Vaccinated
WHERE
    location IN ( 'Albania', 'Montenegro', 'Serbia', 'Croatia', 'Bosnia and Herzegovina',
                      'Slovenia', 'Kosovo' )
    --AND dan = '19.10.2021.'
GROUP BY
    location
    
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

--
select * from tab3


select *
from tab3
--where PropertyAddress is null
order by ParcelID

select a.ParcelID , a.PropertyAddress, b.ParcelID , b.PropertyAddress, coalesce(a.PropertyAddress, b.PropertyAddress)
from tab3 a
join tab3 b 
on a.ParcelID=b.ParcelID
AND a.UniqueID_ <> b.UniqueID_
where a.PropertyAddress is null


update (select a.PropertyAddress as ad1, b.PropertyAddress as ad2, coalesce(a.PropertyAddress, b.PropertyAddress) as ad3, a.ParcelID, b.ParcelID
    from tab3 a
    join tab3 b 
        on a.ParcelID=b.ParcelID
        AND a.UniqueID_ <> b.UniqueID_
        where a.PropertyAddress is null
        )m
    set m.ad1=m.ad3;
    
    
UPDATE tab3 a
    SET PropertyAddress = (SELECT MAX(b.PropertyAddress)
                   FROM tab3 b
                   WHERE a.ParcelID = b.ParcelID AND
                          b.PropertyAddress IS NOT NULL
                  )
    WHERE PropertyAddress IS NULL ;
    
select *
from tab3
where ParcelID='034 07 0B 015.00'


select 
    substr(PropertyAddress, 1, instr(PropertyAddress, ',')-1) as Address
    ,substr(PropertyAddress, instr(PropertyAddress, ',')+1, length(PropertyAddress)) as Address1
    from tab3
        
        
        
alter table tab3
add PropertySplitAddress Varchar2(255);

update tab3
SET PropertySplitAddress = substr(PropertyAddress, 1, instr(PropertyAddress, ',')-1)

alter table tab3
add PropertySplitCity Varchar2(255);

update tab3
SET PropertySplitCity = substr(PropertyAddress, instr(PropertyAddress, ',')+1, length(PropertyAddress))

select *
from tab3


select 
    substr(OwnerAddress, 1, instr(OwnerAddress, ',')-1) as AddressO1
   ,substr(substr(OwnerAddress, instr(Own, instr(OwnerAddress, ',')+1, length(OwnerAddress))), 1, instr(substr(OwnerAddress, instr(Own, instr(OwnerAddress, ',')+1, length(OwnerAddress)),',')-1) as AddressO2
  -- ,substr(, instr(PropertyAddress, ',')+1, length(PropertyAddress)) as AddressO3
    from tab3



