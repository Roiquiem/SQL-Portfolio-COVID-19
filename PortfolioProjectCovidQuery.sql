


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
WHERE continent IS NULL AND location NOT LIKE '%income%' AND location NOT LIKE '%union%'
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


