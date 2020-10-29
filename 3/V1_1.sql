use AdventureWorks2012;
go

-- добавьте в таблицу dbo.Person поле FullName типа nvarchar размерностью 100 символов;
alter table dbo.Person 
add FullName nvarchar(100);
go
-- объ€вите табличную переменную с такой же структурой как dbo.Person и заполните ее данными из dbo.Person. ѕоле Title заполните на основании данных из пол€ Gender таблицы HumanResources.Employee, если gender=M тогда Title=ТMr.Т, если gender=F тогда Title=ТMs.Т;
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
-- обновите поле FullName в dbo.Person данными из табличной переменной, объединив информацию из полей Title, FirstName, LastName (например СMr. Jossef GoldbergТ);
 update dbo.Person
set 
FullName = concat(MyTable.Title, MyTable.FirstName, MyTable.LastName)
FROM
dbo.Person
inner join @newPerson as MyTable on MyTable.BusinessEntityID = dbo.Person.BusinessEntityID
go
-- удалите данные из dbo.Person, где количество символов в поле FullName превысило 20 символов;
delete from dbo.Person
where len(dbo.Person.FullName) > 20;
go
-- удалите все созданные ограничени€ и значени€ по умолчанию. ѕосле этого, удалите поле ID.
alter table dbo.Person drop constraint Constraint_Title
alter table dbo.Person drop constraint Default_Suffix
alter table dbo.Person drop column ID;
go
-- удалите таблицу dbo.Person.
drop table dbo.Person