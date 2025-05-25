-- MoonMissions 

-- SELECT * FROM MoonMissions;

SELECT
  Spacecraft, 
  [Launch date], 
  [Carrier rocket], 
  Operator, 
  [Mission type]
INTO 
  SuccessfulMissions
FROM 
  MoonMissions
WHERE 
  [Outcome] = 'Successful';

-- SELECT * FROM SuccessfulMissions;

GO

UPDATE 
  SuccessfulMissions
SET 
  Operator = LTRIM(Operator);

GO

UPDATE 
  SuccessfulMissions
SET 
  Spacecraft = TRIM(
          LEFT(Spacecraft, CHARINDEX('(', Spacecraft) - 1))
WHERE 
  Spacecraft
LIKE 
  '%(%';

GO

SELECT 
  Operator,
  [Mission type],
  COUNT(*) AS [Mission count]
INTO 
  MissionCounts
FROM 
  SuccessfulMissions
GROUP BY 
  Operator, 
  [Mission type]
HAVING 
  COUNT(*) > 1
ORDER BY 
  Operator, 
  [Mission type];

-- SELECT * FROM MissionCounts;

GO

-- Users

SELECT * FROM Users;

SELECT
  *,
  FirstName + ' ' + LastName AS Name,
CASE WHEN
  CAST(
    RIGHT(ID, 2) AS INT) % 2 = 0 
THEN 
  'Female'
ELSE 
  'Male'
END AS 
  Gender
INTO 
  NewUsers
FROM 
  Users;

-- SELECT * FROM NewUsers
    
GO

SELECT
UserName,
  COUNT(*) AS Duplicates
INTO
  UsersDuplicates
FROM 
  NewUsers
GROUP BY 
  UserName
HAVING 
  COUNT(*) > 1;

GO

-- SELECT * FROM UsersDuplicates

-- SELECT * FROM UsersAlternative

SELECT 
  * 
INTO 
  UsersAlternative 
FROM 
  NewUsers;

ALTER TABLE 
  UsersAlternative
ALTER 
  COLUMN UserName VARCHAR(10);
WITH Duplicates AS (
  SELECT 
    ID,
    UserName,
    ROW_NUMBER() OVER (PARTITION BY UserName ORDER BY ID) AS rn
  FROM 
    UsersAlternative)
UPDATE 
  UsersAlternative
SET 
  UserName = UsersAlternative.UserName + LEFT(
    CAST(UsersAlternative.ID AS VARCHAR), 2)
FROM 
  Duplicates
WHERE UsersAlternative.ID = Duplicates.ID
AND 
  Duplicates.rn > 1;

GO

SELECT 
  *
FROM 
  UsersAlternative
WHERE (
  CAST(
    SUBSTRING(ID ,LEN(ID) - 1, 1) as INT) % 2 <> 0 
AND 
  CAST(
    LEFT(ID, 2) AS INT) >= 70);

GO

SELECT 
  *
FROM 
  NewUsers
WHERE 
  Gender = 'Female'
  AND 
  CAST(LEFT(ID,2) AS INT) < 70;
DELETE FROM 
  NewUsers
WHERE 
  Gender = 'Female'
  AND CAST(LEFT(ID,2) AS INT) < 70;

SELECT * FROM NewUsers;

GO

INSERT 
  INTO 
    UsersAlternative(ID, UserName, [Password], FirstName, LastName, Email, Phone, [Name], Gender) 
  VALUEs('960224-3474','yarphotz', 'wrestlerhero', 'Kenneth', 'Hotz', 'yarp.hotz@gmail.com', 0770707070, 'Kenneth Hotz', 'Male');

GO

SELECT 
Gender,
  AVG(
    CAST(
      DATEDIFF(
        YEAR,
        CONVERT(DATE, SUBSTRING(ID, 1, 6), 12),
        GETDATE()) AS FLOAT)) AS [Average Age]
FROM
  UsersAlternative
GROUP BY
  Gender;

GO

-- SELECT * FROM company.products

SELECT 
  Id, ProductName, SupplierId, CategoryId 
FROM
  company.products;

GO

-- SELECT * FROM company.regions

-- SELECT * FROM company.employee_territory

SELECT
  r.RegionDescription AS Region,
  COUNT(e.Id) AS NumberOfEmployees
FROM
  company.regions AS r
LEFT JOIN
  company.employee_territory AS e
    ON e.EmployeeId = r.Id
GROUP BY
  r.RegionDescription
ORDER BY
  r.RegionDescription;

GO

-- SELECT * FROM company.employees

SELECT
  e.Id,
  e.Title + ' ' + e.FirstName + ' ' + e.LastName AS [Employee Summary],
  ISNULL(s.Title + ' ' + s.FirstName + ' ' + s.LastName, 'Nobody!') AS [Reports to]
FROM 
  Company.employees AS e
LEFT JOIN 
  company.employees AS s
ON 
  e.ReportsTo = s.Id;








      


