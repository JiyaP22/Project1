
Select * 
From Project..Covid_Deaths
where continent is not null
order by 3,4


Select location, date, total_cases, new_cases, total_deaths, population
From Project..Covid_Deaths
order by 1,2

--Looking at Total cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/nullif(total_cases,0)*100) as DeathPercentage
From Project..Covid_Deaths
Where location like '%canada%'
order by 1,2


--Looking at Total cases vs Population

Select location, date, population, total_cases,  (total_cases/nullif(cast(population as BIGINT),0)*100) as PercentPopulationInfected
From Project..Covid_Deaths
--Where location like '%canada%'
order by 1,2


--Looking at countries at highest Infection rate compared to Population


Select location, population, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/nullif(cast(population as BIGINT),0))*100) as PercentPopulationInfected
From Project..Covid_Deaths
--Where location like '%canada%'
GROUP BY location, population
order by PercentPopulationInfected desc


--Showing Countries With Highest Death Count Per Population 

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From Project..Covid_Deaths
--Where location like '%canada%'
GROUP BY location
order by TotalDeathCount desc


--Showing Continent With the highest death count per population


Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From Project..Covid_Deaths
--Where location like '%canada%'
GROUP BY continent
order by TotalDeathCount desc

--Global Numbers

Select  SUM(cast(new_cases as int))as total_cases , SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(nullif(cast(new_cases as float),0))*100 as  DeathPercentage
From Project..Covid_Deaths
--Where location like '%canada%'
where continent is not null
--Group By date
order by 1,2

--Looking at Total Population vs Vaccination

Select dea.continent, dea.location, dea.date, dea.population , vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location , dea.date) as RollingPeopleVaccinated

From Project..Covid_Deaths dea
Join Project..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date

--use CTE

With PopvsVac(continent , location , date , population ,new_vaccinations,  RoolingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population , vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location , dea.date) as RollingPeopleVaccinated

From Project..Covid_Deaths dea
Join Project..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
)
Select * , (RoolingPeopleVaccinated/nullif(cast(population as float),0))*100
From PopvsVac












