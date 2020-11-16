use AdventureWorks2012;
go

/*������� �������� ����� [BusinessEntityID], [NationalIDNumber] � [JobTitle] �� �������
[HumanResources].[Employee] � ���� xml, ������������ � ����������. ������ xml
������ ��������������� �������:
*/
select
        HumanResources.Employee.BusinessEntityID '@ID',
        HumanResources.Employee.NationalIDNumber as 'NationalIDNumber',
        HumanResources.Employee.JobTitle as 'JobTitle'
    from
        HumanResources.Employee
    for xml
        path ('Employee'),
        root ('Employees')
/*
������� ��������� ������� � ��������� � ������� �� ����������, ���������� xml.
*/
declare @xml xml;
set @xml = (
select
        HumanResources.Employee.BusinessEntityID '@ID',
        HumanResources.Employee.NationalIDNumber as 'NationalIDNumber',
        HumanResources.Employee.JobTitle as 'JobTitle'
    from
        HumanResources.Employee
    for xml
        path ('Employee'),
        root ('Employees')
);

create table dbo.tempEmployee
(
    BusinessEntityID int,
	NationalIDNumber nvarchar(15),
	JobTitle nvarchar(50)
);

insert into dbo.tempEmployee
select
   tempxml.Employee.value('@ID', 'int') as BusinessEntityID,
   tempxml.Employee.query('NationalIDNumber').value('.', 'nvarchar(15)') as NationalIDNumber,
   tempxml.Employee.query('JobTitle').value('.', 'nvarchar(50)') as JobTitle
from @xml.nodes('Employees/Employee') as tempxml (Employee)

select * from dbo.tempEmployee;