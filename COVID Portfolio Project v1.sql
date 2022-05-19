COVID 19

Skills used: Creating Views, Windowns Functions, CTE, Aggregate Functions, Temp Tables, Converting Data Types, Joins, CTE


Select *
from PortfolioProject..CovidDeaths$
Where continent is not null
order by 3,4

-- Select Data



Select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths$
Where continent is not null
order by 1,2

--Looking at Total Cases Vs Total Deaths
-- Shows the chances of dying if you contract covid 

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
Where location like '%africa%'
and continent is not null
order by 1,2


-- Looking at the Total cases vs Populations
-- Show what percentage of population has contracted covid

Select location, date, population, total_cases, (total_cases/population)*100 as Percentpopulationinfected
From PortfolioProject..CovidDeaths$
Where location like '%africa%'
and continent is not null
order by 1,2

--Countries with highest infection rate to popluation

Select location, population, MAX(total_cases) as Highestinfectioncount, MAX((Total_cases/population))*100 as Percentpopulationinfected
From PortfolioProject..CovidDeaths$
-- Where location like '%africa%'
Group By location, population
order by Percentpopulationinfected desc


-- Countries with Highest Death Count per Population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
-- Where location like '%africa%'
Where continent is not null
Group By location 
order by TotalDeathCount desc


-- BREAKING DOWN BY CONTINENT

-- Continent with Highest Death count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
-- Where location like '%africa%'
Where continent is not null
Group By continent
order by TotalDeathCount desc



-- Global Numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
--Where location like '%africa%'
where continent is not null
--Group by date
order by 1,2



-- Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as PeopleVaccinated
--, (PeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
	order by 2,3



-- USING CTE TO PERFORM CALCULATION

With PopvsVac (Continent, Location, Date, Population, New_vaccinations, PeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as PeopleVaccinated
--, (PeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *, (PeopleVaccinated/Population)*100
from PopvsVac




-- TEMP TABLE

DROP Table if exists #PercentPoppulationVaccinated
Create Table #PercentPoppulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
PeopleVaccinated numeric
)

Insert into #PercentPoppulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as PeopleVaccinated
--, (PeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3

Select *, (PeopleVaccinated/Population)*100
from #PercentPoppulationVaccinated




-- Create View for Visualizations

Create View PercentPoppulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as PeopleVaccinated
--, (PeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3


Create View GlobalNumbers as
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
--Where location like '%africa%'
where continent is not null
Group by date
--order by 1,2


Create View TotalDeathCount as
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
-- Where location like '%africa%'
Where continent is not null
Group By continent
--order by TotalDeathCount desc


Create View HighestInfection as 
Select location, population, MAX(total_cases) as Highestinfectioncount, MAX((Total_cases/population))*100 as Percentpopulationinfected
From PortfolioProject..CovidDeaths$
-- Where location like '%africa%'
Group By location, population
--order by Percentpopulationinfected desc