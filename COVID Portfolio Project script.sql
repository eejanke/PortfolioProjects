Select *
From PortfolioProject..CovidDeaths
Where continent is not null
Order By 3,4


Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order By 1,2

-- Total Cases vs Total Deaths
-- Shows likelihood of dying of covid once contracted

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Order By 1,2

-- Total Cases vs Total Deaths US

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
	and location = 'United States'
Order By 1,2

-- Total Cases vs Population
Select location, date, population, total_cases, (total_cases/population)*100 as CasePercentage
From PortfolioProject..CovidDeaths
Where continent is not null
	and location = 'United States'
Order By 1,2

-- Total Cases vs ICU Patients
Select location, date, population, total_cases, icu_patients
From CovidDeaths
Where icu_patients is not null
	--and location = 'United States'
Order by location, date

-- ICU Rates
Select location, date, population, total_cases, icu_patients, (icu_patients/total_cases)*100 as ICUPecentage
From CovidDeaths
Where icu_patients is not null
	--and location = 'United States'
Order by location, date

-- Countries with highest infection rate compared to Population
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as CasePercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location, population
Order By CasePercentage desc

-- Countries with Highest Death Count per Population
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location
Order By TotalDeathCount desc

--Continent with the Highest Death Count per Population
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
Order By TotalDeathCount desc

-- Continent Total Cases vs Total Deaths

Select continent, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Order By 1,2


---- Countries with highest infection rate compared to Population
--Select continent, SUM(population) as TotalPopulation, SUM(new_cases) as TotalCases, (SUM(new_cases)/Sum(population))*100 as InfectionRate --MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as CasePercentage
--FROM PortfolioProject..CovidDeaths
--Where continent is not null
--Group by continent


-- Global Numbers, Death Percentage per Day
Select date, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group by date
Order by 1,2

-- Overall Global Death Percentage
Select SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2

--Covid Vaccinations
Select *
From PortfolioProject..CovidVaccinations

--Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingNumberVaccinated
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

--CTE
With PopVsVac (Continent, location, date, population, new_vaccinations, RollingNumberVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingNumberVaccinated
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)

Select *, (RollingNumberVaccinated/population)*100 as RollingVaccinatedPercentage
From PopVsVac

--Temp Table
Drop Table if Exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric, 
New_vaccinations numeric,
RollingNumberVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingNumberVaccinated
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

Select *, (RollingNumberVaccinated/Population)*100
From #PercentPopulationVaccinated

--Create view to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingNumberVaccinated
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null