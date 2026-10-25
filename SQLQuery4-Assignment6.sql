-->Q1
SELECT WardId, COUNT(*) AS PatientCount
FROM Patients
GROUP BY WardId;

-->Q2
SELECT AVG(Salary) AS AverageSalary
FROM Consultants;

-->Q3
SELECT
    MIN(Salary) AS MinimumSalary,
    MAX(Salary) AS MaximumSalary,
    AVG(Salary) AS AverageSalary,
    SUM(Salary) AS TotalSalary
FROM Consultants;

-->Q4
SELECT WardId, COUNT(*) AS PatientCount
FROM Patients
GROUP BY WardId
ORDER BY PatientCount DESC;

-->Q5
SELECT p.Id, p.Name, COALESCE(SUM(da.Quantity), 0) AS TotalQuantity
FROM Patients p
LEFT JOIN DrugAdministrations da ON p.Id = da.PatientId
GROUP BY p.Id, p.Name;

-->Q6
SELECT
    p.Id AS PatientId,
    COUNT(da.PatientId) AS AdministrationCount
FROM Patients p
LEFT JOIN DrugAdministrations da
    ON p.Id = da.PatientId
GROUP BY p.Id;

-->Q7
SELECT
    w.Id AS WardId,
    w.Name AS WardName,
    COUNT(p.Id) AS PatientCount
FROM Wards w
LEFT JOIN Patients p
    ON w.Id = p.WardId
GROUP BY w.Id, w.Name;

-->Q8
SELECT
    w.Id AS WardId,
    w.Name AS WardName,
    AVG(n.Salary) AS AverageSalary
FROM Wards w
LEFT JOIN Nurses n
    ON w.Id = n.ServesInWardId
GROUP BY w.Id, w.Name;


-->Q9
SELECT
    w.Id AS WardId,
    w.Name AS WardName,
    COUNT(p.Id) AS PatientCount
FROM Wards w
INNER JOIN Patients p
    ON w.Id = p.WardId
GROUP BY w.Id, w.Name
HAVING COUNT(p.Id) > 3;

-->Q10
SELECT
    p.Id AS PatientId,
    p.Name
FROM Patients p
INNER JOIN DrugAdministrations da
    ON p.Id = da.PatientId
GROUP BY p.Id, p.Name
HAVING COUNT(*) > 5;

-->Q11
SELECT *
FROM Consultants
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Consultants
);

-->Q12
SELECT *
FROM Nurses
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Nurses
);

-->Q13
SELECT *
FROM Patients
WHERE WardId IN (
    SELECT TOP 1 WITH TIES WardId
    FROM Patients
    WHERE WardId IS NOT NULL
    GROUP BY WardId
    ORDER BY COUNT(*) DESC
);

-->Q14
SELECT *
FROM Consultants
WHERE Salary = (
    SELECT MAX(Salary)
    FROM Consultants
);

-->Q15
SELECT *
FROM Patients
WHERE Id IN (
    SELECT PatientId
    FROM DrugAdministrations
);

-->Q16
SELECT *
FROM Patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM DrugAdministrations da
    WHERE da.PatientId = p.Id
);

-->Q17
SELECT
    p.Id AS PatientId,
    p.Name,
    COUNT(da.PatientId) AS AdministrationCount
FROM Patients p
LEFT JOIN DrugAdministrations da
    ON p.Id = da.PatientId
GROUP BY p.Id, p.Name;

-->Q18
SELECT
    p.Id AS PatientId,
    p.Name,
    COALESCE(SUM(da.Quantity), 0) AS TotalQuantity
FROM Patients p
LEFT JOIN DrugAdministrations da
    ON p.Id = da.PatientId
GROUP BY p.Id, p.Name;

-->Q19
SELECT c.*
FROM Consultants c
CROSS JOIN (
    SELECT AVG(Salary) AS AverageSalary
    FROM Consultants
) AS SalaryStats
WHERE c.Salary > SalaryStats.AverageSalary;

-->Q20
WITH PatientQuantities AS (
    SELECT
        PatientId,
        SUM(Quantity) AS TotalQuantity
    FROM DrugAdministrations
    GROUP BY PatientId
)
SELECT *
FROM PatientQuantities
WHERE TotalQuantity > (
    SELECT AVG(TotalQuantity)
    FROM PatientQuantities
);

-->Q21
SELECT *
INTO PatientBackup
FROM Patients;

-->Q22
SELECT Id, Name, DOB
INTO BasicPatientInfo
FROM Patients;

-->Q23
SELECT Id, Name, Salary
INTO ConsultantSalaryReport
FROM Consultants;

-->Q24
SELECT
    p.Id AS PatientId,
    p.Name AS PatientName,
    w.Id AS WardId,
    w.Name AS WardName
INTO PatientWardReport
FROM Patients p
LEFT JOIN Wards w
    ON p.WardId = w.Id;

-->Q25
SELECT
    p.Id AS PatientId,
    p.Name AS PatientName,
    c.Id AS ConsultantId,
    c.Name AS ConsultantName
INTO PatientConsultantReport
FROM Patients p
INNER JOIN PatientConsultantAssignments pca
    ON p.Id = pca.PatientId
INNER JOIN Consultants c
    ON c.Id = pca.ConsultantId;

-->Q26
SELECT *
INTO HighSalaryConsultants
FROM Consultants
WHERE Salary > 50000;

-->Q27
SELECT *
INTO YoungPatients
FROM Patients
WHERE DOB > '20000101';

-->Q28
SELECT
    n.Number AS NurseNumber,
    n.Name AS NurseName,
    n.Salary,
    w.Id AS WardId,
    w.Name AS WardName
INTO HighSalaryNurseReport
FROM Nurses n
INNER JOIN Wards w
    ON n.ServesInWardId = w.Id
WHERE n.Salary > 30000;

-->Q29
SELECT
    w.Id AS WardId,
    w.Name AS WardName,
    COUNT(p.Id) AS PatientCount
INTO WardPatientSummary
FROM Wards w
LEFT JOIN Patients p
    ON w.Id = p.WardId
GROUP BY w.Id, w.Name;

-->Q30
SELECT
    p.Id AS PatientId,
    p.Name AS PatientName,
    COALESCE(SUM(da.Quantity), 0) AS TotalQuantity
INTO PatientMedicationSummary
FROM Patients p
LEFT JOIN DrugAdministrations da
    ON p.Id = da.PatientId
GROUP BY p.Id, p.Name;

-->Q31
CREATE FUNCTION CalculatePatientAge
(
    @DOB DATE
)
RETURNS INT
AS
BEGIN
    RETURN
    DATEDIFF(YEAR, @DOB, GETDATE())
    - CASE
    WHEN DATEADD(
    YEAR,
    DATEDIFF(YEAR, @DOB, GETDATE()),
    @DOB
    ) > GETDATE()
    THEN 1
    ELSE 0
    END;
END;
Go

-->Q32
CREATE FUNCTION CalculateAnnualSalary
(
    @MonthlySalary DECIMAL(10,2)
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    RETURN @MonthlySalary * 12;
END;
Go

-->Q33
CREATE FUNCTION CalculateMedicationCost
(
    @Quantity INT,
    @UnitPrice DECIMAL(10,2)
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    RETURN @Quantity * @UnitPrice;
END;
GO

-->Q34
CREATE FUNCTION GetPatientsByWard
(
    @WardId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Patients
    WHERE WardId = @WardId
);
GO

-->Q35
CREATE FUNCTION GetConsultantsByMinimumSalary
(
    @MinimumSalary DECIMAL(10,2)
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Consultants
    WHERE Salary >= @MinimumSalary
);
GO

-->Q36
CREATE FUNCTION GetPatientsWithTheirWard
(
    @WardId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        p.Id AS PatientId,
        p.Name AS PatientName,
        p.DOB,
        p.WardId,
        w.Name AS WardName
    FROM Patients p
    INNER JOIN Wards w
        ON p.WardId = w.Id
    WHERE p.WardId = @WardId
);
GO

-->Q37
CREATE FUNCTION GetPatientsWithAge
(
    @MinimumAge INT
)
RETURNS @Result TABLE
(
    Id INT,
    Name NVARCHAR(100),
    DOB DATE,
    WardId INT
)
AS
BEGIN
    INSERT INTO @Result
    SELECT Id, Name, DOB, WardId
    FROM Patients
    WHERE DOB <= DATEADD(YEAR, -@MinimumAge, GETDATE());

    RETURN;
END;
GO

-->Q38
CREATE FUNCTION GetPatientMedicationSummary
(
    @PatientId INT
)
RETURNS @Result TABLE
(
    PatientId INT,
    TotalQuantity INT,
    AdministrationCount INT
)
AS
BEGIN
    INSERT INTO @Result
    SELECT
        @PatientId,
        COALESCE(SUM(Quantity), 0),
        COUNT(*)
    FROM DrugAdministrations
    WHERE PatientId = @PatientId;

    RETURN;
END;
GO

-->Q39
CREATE FUNCTION ClassifyConsultantSalaries
(
    @MinimumSalary DECIMAL(10,2)
)
RETURNS @Result TABLE
(
    Id INT,
    Name NVARCHAR(100),
    Salary DECIMAL(10,2),
    SalaryClassification NVARCHAR(20)
)
AS
BEGIN
    INSERT INTO @Result
    SELECT
    Id,
    Name,
    Salary,
    CASE
    WHEN Salary >= @MinimumSalary THEN 'High Salary'
    ELSE 'Below Minimum'
    END
    FROM Consultants
    WHERE Salary >= @MinimumSalary;

    RETURN;
END;
GO

-->Q40
SELECT
    p.Id AS PatientId,
    p.Name,
    COUNT(da.PatientId) AS AdministrationCount,
    COALESCE(SUM(da.Quantity), 0) AS TotalQuantity,
    AVG(CAST(da.Quantity AS DECIMAL(10,2))) AS AverageQuantity
FROM Patients p
LEFT JOIN DrugAdministrations da
    ON p.Id = da.PatientId
GROUP BY p.Id, p.Name;

-->Q41
WITH WardCounts AS (
    SELECT
        w.Id,
        w.Name,
        COUNT(p.Id) AS PatientCount
    FROM Wards w
    LEFT JOIN Patients p
        ON w.Id = p.WardId
    GROUP BY w.Id, w.Name
)
SELECT *
FROM WardCounts
WHERE PatientCount > (
    SELECT AVG(CAST(PatientCount AS DECIMAL(10,2)))
    FROM WardCounts
);

-->Q42
SELECT
    p.Id AS PatientId,
    p.Name,
    COUNT(*) AS AdministrationCount
INTO HighActivityPatients
FROM Patients p
INNER JOIN DrugAdministrations da
    ON p.Id = da.PatientId
GROUP BY p.Id, p.Name
HAVING COUNT(*) > 5;

-->Q43
SELECT
    Id AS ConsultantId,
    Name,
    Salary AS MonthlySalary,
    dbo.CalculateAnnualSalary(Salary) AS AnnualSalary
INTO ConsultantAnnualSalaryReport
FROM Consultants;

-->Q44
SELECT *
FROM dbo.GetConsultantsByMinimumSalary(50000)
WHERE Name LIKE 'A%';

-->Q45
SELECT *
FROM dbo.GetPatientsWithAge(30)
ORDER BY DOB ASC;

-->Q46
SELECT
    p.Id AS PatientId,
    p.Name AS PatientName,
    w.Name AS WardName,
    dbo.CalculatePatientAge(p.DOB) AS PatientAge,
    COALESCE(m.AdministrationCount, 0) AS AdministrationCount,
    COALESCE(m.TotalQuantity, 0) AS TotalQuantity
FROM Patients p
LEFT JOIN Wards w
    ON p.WardId = w.Id
LEFT JOIN (
    SELECT
        PatientId,
        COUNT(*) AS AdministrationCount,
        SUM(Quantity) AS TotalQuantity
    FROM DrugAdministrations
    GROUP BY PatientId
) m
    ON p.Id = m.PatientId;