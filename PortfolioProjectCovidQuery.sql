
-- Original source was 1 table, was divided into two table to perform several skills
-- adding a column showing percentage of total cases vs total deaths

SELECT location, date, total_cases, total_deaths, total_deaths*100/total_cases AS death_percentage
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2

-- adding a column showing percentage of what percentage of the population got covid

SELECT location, date, total_cases, population, cast(total_cases as decimal)*100/population AS sick_percentage
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2

-- countries with highest infection rate compared to population, showing highest countries first

SELECT location, population, MAX(total_cases) AS highest_infect_count, MAX((total_cases*100.00/population)) AS infected_population_percent
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY infected_population_percent DESC

-- countries with highest death count compared to population, showing highest countries first

SELECT location, population, MAX(total_deaths) AS highest_death_count, MAX((total_deaths*100.00/population)) AS deaths_to_population_percent
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY highest_death_count DESC

-- continents with highest death count, removing irrelevant locations 

SELECT location, MAX(total_deaths) AS total_deaths_count
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL AND location NOT LIKE '%income%' AND location NOT LIKE '%union%' AND location NOT LIKE 'world' AND location NOT LIKE 'international'
GROUP BY location
ORDER BY total_deaths_count DESC


-- highest death count based on income level

SELECT location, MAX(total_deaths) AS total_deaths_count
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL AND location LIKE '%income%'
GROUP BY location
ORDER BY total_deaths_count DESC


-- global numbers per day

SELECT date, SUM(new_cases) as sum_new_cases, SUM(new_deaths) as sum_new_deaths, SUM(new_deaths*100.00)/SUM(new_cases) as death_to_cases_percentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL AND continent NOT LIKE '%income%'
GROUP BY date
ORDER BY 1, 2

-- global numbers 

SELECT MAX(population) AS population, SUM(new_deaths)*100.00/MAX(population) AS percentage_of_deaths_to_population, SUM(new_cases) AS sum_new_cases
, SUM(new_deaths) AS sum_new_deaths, SUM(new_deaths)*100.00/SUM(new_cases) AS percentage_of_deaths_to_cases
FROM PortfolioProject..CovidDeaths
WHERE location LIKE 'world'


-- total population vs vacc's (vaccinations) with joining both tables

-- using CTE (temporary named result which can be referenced within a SELECT)
-- some countries started 2nd, 3rd and 4th vaccination hence the over 100% results

WITH pop_vs_vaccs (continent, location, date, population, new_vaccinations, total_vaccs_per_country)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS total_vaccs_per_country
--, total_vaccs_per_country/dea.population*100.00 AS vaccs_per_population_percentage
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, total_vaccs_per_country*100.00/population AS vacc_per_pop
FROM pop_vs_vaccs
ORDER BY 2, 3



-- Create view for later visualozations, in desired database

USE PortfolioProject --desired database
GO
CREATE VIEW percent_population_vaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS total_vaccs_per_country
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL


