USE AdventureWorks2012;
GO

-- a) �������� ������� dbo.Person � ����� �� ���������� ��� Person.Person, ����� ����� xml, uniqueidentifier, �� ������� �������, ����������� � ��������;
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
--b)��������� ���������� ALTER TABLE, �������� � ������� dbo.Person ����� ���� ID, ������� �������� ��������� ������ ���� bigint � ����� �������� identity.
--��������� �������� ��� ���� identity ������� 10 � ���������� ������� 10;
 ALTER TABLE dbo.Person 
	ADD ID bigint identity(10,10) PRIMARY KEY;
GO
--c)��������� ���������� ALTER TABLE, �������� ��� ������� dbo.Person ����������� ��� ���� Title, ����� ��������� ��� ����� ���� ������ ���������� �Mr.� ��� �Ms.�;
 ALTER TABLE dbo.Person
	ADD CONSTRAINT Constraint_Title 
		CHECK (Title = 'Mr.' or Title = 'Ms.');
GO
--d)��������� ���������� ALTER TABLE, �������� ��� ������� dbo.Person ����������� DEFAULT ��� ���� Suffix, ������� �������� �� ��������� �N/A�;
ALTER TABLE dbo.Person
	ADD CONSTRAINT Default_Suffix
		DEFAULT ('N/A') FOR Suffix; 
GO
--e) ��������� ����� ������� ������� �� Person.Person ������ ��� ��� �����������, ������� ���������� � ������� HumanResources.Employee, 
--�������� ����������� �� ������ �Executive�;

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

--f) �������� ����������� ���� Suffix, ��������� ������ ���� �� 5-�� ��������.
ALTER TABLE dbo.Person
ALTER COLUMN Suffix VARCHAR(5)
