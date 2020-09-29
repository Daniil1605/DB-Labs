USE AdventureWorks2012;
GO

-- ������� �� ����� ������ ����������� � ��������� ������������ ������, �� ������� �� ����������� �������� ��������.
SELECT
	Employee.BusinessEntityID, Employee.JobTitle, EmployeePay.BiggestRate as MaxRate
FROM 
	HumanResources.Employee as Employee inner join 
	(SELECT HumanResources.EmployeePayHistory.BusinessEntityID, MAX(HumanResources.EmployeePayHistory.Rate) AS BiggestRate
    FROM HumanResources.EmployeePayHistory
	GROUP BY HumanResources.EmployeePayHistory.BusinessEntityID) as EmployeePay
ON 
	EmployeePay.BusinessEntityID = Employee.BusinessEntityID
--������� ��� ��������� ������ �� ������ ����� �������, ����� ���������� ������ ������� � ���� ������. ������ ����� ������ ���� ������������ �� ����������� ������. �������� ������� [RankRate].
SELECT 
  TempTable.BusinessEntityID,TempTable.JobTitle,TempTable.Rate, DENSE_RANK() OVER(ORDER BY TempTable.Rate ASC) AS RankRate
FROM 
(SELECT
	Employee.BusinessEntityID, Employee.JobTitle, EmployeePay.Rate
FROM 
	HumanResources.Employee as Employee inner join  HumanResources.EmployeePayHistory as EmployeePay
ON 
	EmployeePay.BusinessEntityID = Employee.BusinessEntityID
GROUP BY Employee.BusinessEntityID, Employee.JobTitle, EmployeePay.Rate
) as TempTable
--������� �� ����� ���������� �� ������� � ���������� � ��� �����������, ��������������� �� ���� ShiftID � ������ �Document Control� � �� ���� BusinessEntityID �� ���� ��������� �������
SELECT 
  TempTable2.Name as DepName, TempTable.BusinessEntityID,TempTable.JobTitle, TempTable.ShiftID
FROM
(SELECT
  Employee.BusinessEntityID, Employee.JobTitle, EmployeeDepHis.ShiftID, EmployeeDepHis.DepartmentID
FROM 
	HumanResources.Employee as Employee inner join HumanResources.EmployeeDepartmentHistory as EmployeeDepHis
ON 
	EmployeeDepHis.BusinessEntityID = Employee.BusinessEntityID) as TempTable inner join  HumanResources.Department as TempTable2
	ON TempTable.DepartmentID = TempTable2.DepartmentID
ORDER BY 
 CASE WHEN TempTable2.Name != 'Document Control' THEN TempTable.DepartmentID END ASC,
 CASE WHEN TempTable2.Name = 'Document Control' THEN TempTable.ShiftID END ASC