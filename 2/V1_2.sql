USE AdventureWorks2012;
GO

-- a) создайте таблицу dbo.Person с такой же структурой как Person.Person, кроме полей xml, uniqueidentifier, не включа€ индексы, ограничени€ и триггеры;
CREATE TABLE dbo.Person 
(
      BusinessEntityID int,
      PersonType nchar(2),
      NameStyle dbo.NameStyle,
      Title nvarchar(8),
      FirstName dbo.Name,
      MiddleName dbo.Name,
      LastName dbo.Name,
      Suffix nvarchar(10),
      EmailPromotion int,
      ModifiedDate datetime,
	  PRIMARY KEY (BusinessEntityID)
);
GO
--b)использу€ инструкцию ALTER TABLE, добавьте в таблицу dbo.Person новое поле ID, которое €вл€етс€ первичным ключом типа bigint и имеет свойство identity.
--Ќачальное значение дл€ пол€ identity задайте 10 и приращение задайте 10;
 ALTER TABLE dbo.Person 
	ADD ID bigint identity(10,10) PRIMARY KEY;
GO
--c)использу€ инструкцию ALTER TABLE, создайте дл€ таблицы dbo.Person ограничение дл€ пол€ Title, чтобы заполнить его можно было только значени€ми СMr.Т или СMs.Т;
 ALTER TABLE dbo.Person
	ADD CONSTRAINT Constraint_Title 
		CHECK (Title = 'Mr.' or Title = 'Ms.');
GO
--d)использу€ инструкцию ALTER TABLE, создайте дл€ таблицы dbo.Person ограничение DEFAULT дл€ пол€ Suffix, задайте значение по умолчанию СN/AТ;
ALTER TABLE dbo.Person
	ADD CONSTRAINT Default_Suffix
		DEFAULT ('N/A') FOR Suffix; 
GO
--e) заполните новую таблицу данными из Person.Person только дл€ тех сотрудников, которые существуют в таблице HumanResources.Employee, 
--исключив сотрудников из отдела СExecutiveТ;

INSERT INTO dbo.Person
SELECT 
	  Person.Person.BusinessEntityID,
      Person.Person.PersonType,
      Person.Person.NameStyle,
      Person.Person.Title,
      Person.Person.FirstName,
      Person.Person.MiddleName,
      Person.Person.LastName,
      Person.Person.Suffix,
      Person.Person.EmailPromotion,
      Person.Person.ModifiedDate
FROM Person.Person
	JOIN (SELECT 
  TempTable2.Name as DepName, TempTable.BusinessEntityID,TempTable.JobTitle, TempTable.ShiftID
FROM
(SELECT
  Employee.BusinessEntityID, Employee.JobTitle, EmployeeDepHis.ShiftID, EmployeeDepHis.DepartmentID
FROM 
	HumanResources.Employee as Employee inner join HumanResources.EmployeeDepartmentHistory as EmployeeDepHis
ON 
	EmployeeDepHis.BusinessEntityID = Employee.BusinessEntityID) as TempTable inner join  HumanResources.Department as TempTable2
	ON TempTable.DepartmentID = TempTable2.DepartmentID) as Table2
	ON Person.Person.BusinessEntityID = Table2.BusinessEntityID
WHERE Table2.DepName != 'Executive';
GO

--f) измените размерность пол€ Suffix, уменьшите размер пол€ до 5-ти символов.
ALTER TABLE dbo.Person
ALTER COLUMN Suffix VARCHAR(5)
