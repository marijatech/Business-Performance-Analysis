#  SQL Exploratory Analysis – Business Performance Dashboard

SELECT * 
FROM projects;

SELECT DISTINCT ProjectStatus
FROM projects;

SELECT COUNT(ClientName)
FROM projects;

SELECT DISTINCT ProjectName
FROM projects
LIMIT 5;

SELECT DISTINCT Department
FROM projects;

-- Count the number of projects grouped by their current status
-- This helps understand the overall distribution of active, completed, and at-risk projects

SELECT ProjectStatus, COUNT(*) AS TotalProjects
FROM projects
GROUP BY ProjectStatus;

-- Total revenue generated from each global region

SELECT Region, FORMAT(SUM(Revenue), 0) AS TotalRevenue
FROM projects
GROUP BY Region
ORDER BY TotalRevenue DESC;

-- Compute the average satisfaction score reported by clients in each region

SELECT Region,  ROUND(AVG(ClientSatisfactionScore), 2) AS AvgSatisfaction
FROM projects
GROUP BY Region;

-- Calculate how many consultants are typically assigned per project in each department

SELECT Department, ROUND(AVG(ConsultantCount), 2) AS AvgConsultants
FROM projects
GROUP BY Department;

-- Total Projects and Average Revenue per Year

SELECT YEAR(StartDate) AS ProjectYear, COUNT(*) AS TotalProjects, FORMAT(AVG(Revenue), 0) AS AvgRevenue
FROM projects
GROUP BY YEAR(StartDate)
ORDER BY ProjectYear;

-- Top 5 Clients by Total Revenue

SELECT ClientName, FORMAT(SUM(Revenue),0) AS TotalRevenue
FROM projects
GROUP BY ClientName
ORDER BY TotalRevenue DESC
LIMIT 5;

-- Most common Project Types per Department

SELECT Department, COUNT(*) AS TotalProjects
FROM projects
GROUP BY Department
ORDER BY TotalProjects DESC;

-- Average Satisfaction by Department and Region

SELECT Department, Region, ROUND(AVG(ClientSatisfactionScore), 2) AS AvgSatisfaction
FROM projects
GROUP BY Department, Region
ORDER BY AvgSatisfaction DESC;

-- Average Revenue per Deparment (Completed Projects Only)

WITH CompletedProjects AS(
SELECT Department, Revenue
FROM projects
WHERE ProjectStatus = 'Completed'
)
SELECT Department, ROUND(AVG(Revenue), 2) AS AvgCompletedRevenue
FROM projects
GROUP BY Department;

-- Revenue Rank per Region

SELECT ProjectID, ClientName, Region, Revenue,
RANK() OVER (PARTITION BY Region ORDER BY Revenue DESC) AS RevenueRank
FROM projects;

-- Projects with Revenue Above Company Average

SELECT ProjectID, ProjectName, Revenue
FROM projects
WHERE Revenue > (
SELECT AVG(Revenue) FROM projects
);

-- Top Project per Department
-- For each department, get the single top-revenue project 

SELECT *
FROM (
SELECT ProjectID, ProjectName, Department, Revenue,
ROW_NUMBER() OVER(PARTITION BY Department ORDER BY Revenue DESC) AS rn
FROM projects
) AS Ranked
WHERE rn = 1;

-- Running Revenue Total per Region

WITH RegionRevenue AS (
SELECT Region, ProjectID, Revenue, SUM(Revenue) OVER (PARTITION BY Region ORDER BY ProjectID) AS CumulativeRevenue
FROM projects
) SELECT * FROM RegionRevenue;
