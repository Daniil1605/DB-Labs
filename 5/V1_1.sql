use AdventureWorks2012;
go

/*�������� scalar-valued �������, ������� ����� ��������� � �������� �������� ���������
��� ������ ������� (HumanResources.Department.GroupName) � ���������� ����������
�������, �������� � ��� ������.
*/
create function HumanResources.getcount(@GroupName nvarchar(50)) 
returns int as
begin
	return(select count(*) from HumanResources.Department where HumanResources.Department.GroupName = @GroupName);
end;
go

select HumanResources.getcount ('Manufacturing');
go
/*�������� inline table-valued �������, ������� ����� ��������� � �������� ��������
��������� id ������ (HumanResources.Department.DepartmentID), � ���������� 3 �����
������� ����������, ������� ������ �������� � ������ � 2005 ����.
*/
create function HumanResources.getemp(@DepartmentID int) 
returns table as
return
(
	select top(3) HumanResources.Employee.*
	from HumanResources.Employee
    join HumanResources.EmployeeDepartmentHistory on HumanResources.Employee.BusinessEntityID = HumanResources.EmployeeDepartmentHistory.BusinessEntityID
	where (HumanResources.EmployeeDepartmentHistory.DepartmentID = @DepartmentID) and (YEAR(HumanResources.EmployeeDepartmentHistory.StartDate) = 2005)
    order by HumanResources.Employee.BirthDate
);
go

select * from HumanResources.getemp(3);
go
/*�������� ������� ��� ������� ������, �������� �������� CROSS APPLY. ��������
������� ��� ������� ������, �������� �������� OUTER APPLY.
*/
select * from HumanResources.Department CROSS APPLY HumanResources.getemp(HumanResources.Department.DepartmentID);
select * from HumanResources.Department OUTER APPLY HumanResources.getemp(HumanResources.Department.DepartmentID);
go
/*�������� ��������� inline table-valued �������, ������ �� multistatement table-valued
(�������������� �������� ��� �������� ��� �������� inline table-valued �������).
*/
create function HumanResources.getempv2(@DepartmentID INT) 
returns @etable table (
	[BusinessEntityID] [int] NOT NULL,
	[NationalIDNumber] [nvarchar](15) NOT NULL,
	[LoginID] [nvarchar](256) NOT NULL,
	[OrganizationNode] [hierarchyid] NULL,
	[OrganizationLevel] [smallint] NULL,
	[JobTitle] [nvarchar](50) NOT NULL,
	[BirthDate] [date] NOT NULL,
	[MaritalStatus] [nchar](1) NOT NULL,
	[Gender] [nchar](1) NOT NULL,
	[HireDate] [date] NOT NULL,
	[SalariedFlag] [dbo].[Flag] NOT NULL,
	[VacationHours] [smallint] NOT NULL,
	[SickLeaveHours] [smallint] NOT NULL,
	[CurrentFlag] [dbo].[Flag] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL) AS 
begin
	insert into @etable
	select top(3)
	    HumanResources.Employee.BusinessEntityID,
		HumanResources.Employee.NationalIDNumber,
		HumanResources.Employee.LoginID,
		HumanResources.Employee.OrganizationNode,
		HumanResources.Employee.OrganizationLevel,
		HumanResources.Employee.JobTitle,
		HumanResources.Employee.BirthDate,
		HumanResources.Employee.MaritalStatus,
		HumanResources.Employee.Gender,
		HumanResources.Employee.HireDate,
		HumanResources.Employee.SalariedFlag,
		HumanResources.Employee.VacationHours,
		HumanResources.Employee.SickLeaveHours,
		HumanResources.Employee.CurrentFlag,
		HumanResources.Employee.rowguid,
		HumanResources.Employee.ModifiedDate
	from HumanResources.Employee
    join HumanResources.EmployeeDepartmentHistory on HumanResources.Employee.BusinessEntityID = HumanResources.EmployeeDepartmentHistory.BusinessEntityID
	where (HumanResources.EmployeeDepartmentHistory.DepartmentID = @DepartmentID) and (YEAR(HumanResources.EmployeeDepartmentHistory.StartDate) = 2005)
	order by HumanResources.Employee.BirthDate
	return
end;
go

select * from HumanResources.getemp(3);
go
select * from HumanResources.getempv2(3);
go