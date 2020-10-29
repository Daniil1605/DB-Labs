use AdventureWorks2012;
go

-- �������� � ������� dbo.Person ���� FullName ���� nvarchar ������������ 100 ��������;
alter table dbo.Person 
add FullName nvarchar(100);
go
-- �������� ��������� ���������� � ����� �� ���������� ��� dbo.Person � ��������� �� ������� �� dbo.Person. ���� Title ��������� �� ��������� ������ �� ���� Gender ������� HumanResources.Employee, ���� gender=M ����� Title=�Mr.�, ���� gender=F ����� Title=�Ms.�;
declare @newPerson table (
BusinessEntityID int primary key not null,
PersonType nchar(2),
NameStyle bit not null,
Title varchar(8),
FirstName nvarchar(50),
MiddleName nvarchar(50),
LastName nvarchar(50),
Suffix nvarchar(10),
EmailPromotion int,
ModifiedDate datetime
);
insert into @newPerson (
	BusinessEntityID,
	PersonType,
	NameStyle,
	Title,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion,
	ModifiedDate
	)
select 
	 MyPerson.BusinessEntityID,
	MyPerson.PersonType,
	MyPerson.NameStyle,
	case
    when tmp.Gender = 'M' then 'Mr.'
    when tmp.Gender = 'F' then 'Ms.'
    else 'No title.'
	end as Title,
	MyPerson.FirstName,
	MyPerson.MiddleName,
	MyPerson.LastName,
	MyPerson.Suffix,
	MyPerson.EmailPromotion,
	MyPerson.ModifiedDate
from dbo.Person as MyPerson
inner join humanResources.Employee as tmp on tmp.BusinessEntityID = MyPerson.BusinessEntityID
-- �������� ���� FullName � dbo.Person ������� �� ��������� ����������, ��������� ���������� �� ����� Title, FirstName, LastName (�������� �Mr. Jossef Goldberg�);
 update dbo.Person
set 
FullName = concat(MyTable.Title, MyTable.FirstName, MyTable.LastName)
FROM
dbo.Person
inner join @newPerson as MyTable on MyTable.BusinessEntityID = dbo.Person.BusinessEntityID
go
-- ������� ������ �� dbo.Person, ��� ���������� �������� � ���� FullName ��������� 20 ��������;
delete from dbo.Person
where len(dbo.Person.FullName) > 20;
go
-- ������� ��� ��������� ����������� � �������� �� ���������. ����� �����, ������� ���� ID.
alter table dbo.Person drop constraint Constraint_Title
alter table dbo.Person drop constraint Default_Suffix
alter table dbo.Person drop column ID;
go
-- ������� ������� dbo.Person.
drop table dbo.Person