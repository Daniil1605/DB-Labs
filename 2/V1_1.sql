USE AdventureWorks2012;
GO

-- Вывести на экран список сотрудников с указанием максимальной ставки, по которой им выплачивали денежные средства.
SELECT
	Employee.BusinessEntityID, Employee.JobTitle, EmployeePay.BiggestRate as MaxRate
FROM 
	HumanResources.Employee as Employee inner join 
	(SELECT HumanResources.EmployeePayHistory.BusinessEntityID, MAX(HumanResources.EmployeePayHistory.Rate) AS BiggestRate
    FROM HumanResources.EmployeePayHistory
	GROUP BY HumanResources.EmployeePayHistory.BusinessEntityID) as EmployeePay
ON 
	EmployeePay.BusinessEntityID = Employee.BusinessEntityID
--Разбить все почасовые ставки на группы таким образом, чтобы одинаковые ставки входили в одну группу. Номера групп должны быть распределены по возрастанию ставок. Назовите столбец [RankRate].
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
--Вывести на экран информацию об отделах и работающих в них сотрудниках, отсортированную по полю ShiftID в отделе ‘Document Control’ и по полю BusinessEntityID во всех остальных отделах
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