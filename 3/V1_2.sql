use AdventureWorks2012;
go

--  ��������� ���, ��������� �� ������ ������� ������ ������������ ������. �������� � ������� dbo.Person ���� SalesYTD MONEY, SalesLastYear MONEY � OrdersNum INT. ����� �������� � ������� ����������� ���� SalesDiff, ��������� ������� �������� � ����� SalesYTD � SalesLastYear;
alter table dbo.Person
	add SalesYTD money,
	SalesLastYear money,
	OrdersNum int,
	SalesDiff as SalesYTD - SalesLastYear;
go
-- �������� ��������� ������� #Person, � ��������� ������ �� ���� BusinessEntityID. ��������� ������� ������ �������� ��� ���� ������� dbo.Person �� ����������� ���� SalesDiff;
create table #Person(
BusinessEntityID int primary key not null,
PersonType nchar(2),
NameStyle bit not null,
Title varchar(8),
FirstName nvarchar(50),
MiddleName nvarchar(50),
LastName nvarchar(50),
Suffix nvarchar(10),
EmailPromotion int,
ModifiedDate datetime,
SalesYTD money,
SalesLastYear money,
OrdersNum int
);
go
-- ��������� ��������� ������� ������� �� dbo.Person. ���� SalesYTD � SalesLastYear ��������� ���������� �� ������� Sales.SalesPerson. ���������� ���������� �������, ����������� ������ ��������� (SalesPersonID) � ������� Sales.SalesOrderHeader � ��������� ����� ���������� ���� OrdersNum. ������� ���������� ������� ����������� � Common Table Expression (CTE);
with CTE (SalesPersonID, OrderNum)  
as  
(  
    select SalesPersonID, count(*) as OrderNum  
    from Sales.SalesOrderHeader  
    where SalesPersonID IS NOT NULL 
	group by SalesPersonID
) 
insert into #Person (
	BusinessEntityID,
	PersonType,
	NameStyle,
	Title,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion,
	ModifiedDate,
	SalesYTD,
	SalesLastYear,
	OrdersNum)
select 
	person.BusinessEntityID,
	person.PersonType,
	person.NameStyle,
	person.Title,
	person.FirstName,
	person.MiddleName,
	person.LastName,
	person.Suffix,
	person.EmailPromotion,
	person.ModifiedDate,
	myperson.SalesYTD,
	myperson.SalesLastYear,
	cte.OrderNum as OrdersNum
from dbo.Person as person
left join Sales.SalesPerson as myperson on myperson.BusinessEntityID = person.BusinessEntityID
left join CTE as cte on cte.SalesPersonID = person.BusinessEntityID
go
-- ������� �� ������� dbo.Person ���� ������ (��� BusinessEntityID = 290);
delete from dbo.Person where BusinessEntityID = 290;
-- �������� Merge ���������, ������������ dbo.Person ��� target, � ��������� ������� ��� source. ��� ����� target � source ����������� BusinessEntityID. �������� ���� SalesYTD, SalesLastYear � OrdersNum ������� dbo.Person, ���� ������ ������������ � � source � � target. ���� ������ ������������ �� ��������� �������, �� �� ���������� � target, �������� ������ � dbo.Person. ���� � dbo.Person ������������ ����� ������, ������� �� ���������� �� ��������� �������, ������� ������ �� dbo.Person.
merge dbo.Person as mytarget
using #Person as mysource
on mytarget.BusinessEntityID = mysource.BusinessEntityID
when MATCHED then update set	
	mytarget.SalesYTD = mysource.SalesYTD,
	mytarget.SalesLastYear = mysource.SalesLastYear,
	mytarget.OrdersNum = mysource.OrdersNum
when NOT MATCHED by target then	insert 
(
	BusinessEntityID,
	PersonType,
	NameStyle,
	Title,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion,
	ModifiedDate,
	SalesYTD,
	SalesLastYear,
	OrdersNum
)
values
(
	mysource.BusinessEntityID, 
	mysource.PersonType, 
	mysource.NameStyle,
	mysource.Title,
	mysource.FirstName,
	mysource.MiddleName,
	mysource.LastName,
	mysource.Suffix,
	mysource.EmailPromotion,
	mysource.ModifiedDate,
	mysource.SalesYTD,
	mysource.SalesLastYear,
	mysource.OrdersNum
)
when NOT MATCHED by SOURCE then delete;