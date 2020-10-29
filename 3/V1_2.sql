use AdventureWorks2012;
go

--  выполните код, созданный во втором задании второй лабораторной работы. ƒобавьте в таблицу dbo.Person пол€ SalesYTD MONEY, SalesLastYear MONEY и OrdersNum INT. “акже создайте в таблице вычисл€емое поле SalesDiff, считающее разницу значений в пол€х SalesYTD и SalesLastYear;
alter table dbo.Person
	add SalesYTD money,
	SalesLastYear money,
	OrdersNum int,
	SalesDiff as SalesYTD - SalesLastYear;
go
-- создайте временную таблицу #Person, с первичным ключом по полю BusinessEntityID. ¬ременна€ таблица должна включать все пол€ таблицы dbo.Person за исключением пол€ SalesDiff;
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
-- заполните временную таблицу данными из dbo.Person. ѕол€ SalesYTD и SalesLastYear заполните значени€ми из таблицы Sales.SalesPerson. ѕосчитайте количество заказов, оформленных каждым продавцом (SalesPersonID) в таблице Sales.SalesOrderHeader и заполните этими значени€ми поле OrdersNum. ѕодсчет количества заказов осуществите в Common Table Expression (CTE);
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
-- удалите из таблицы dbo.Person одну строку (где BusinessEntityID = 290);
delete from dbo.Person where BusinessEntityID = 290;
-- напишите Merge выражение, использующее dbo.Person как target, а временную таблицу как source. ƒл€ св€зи target и source используйте BusinessEntityID. ќбновите пол€ SalesYTD, SalesLastYear и OrdersNum таблицы dbo.Person, если запись присутствует и в source и в target. ≈сли строка присутствует во временной таблице, но не существует в target, добавьте строку в dbo.Person. ≈сли в dbo.Person присутствует така€ строка, которой не существует во временной таблице, удалите строку из dbo.Person.
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