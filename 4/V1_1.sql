use AdventureWorks2012;
go

-- Создайте таблицу Production.ProductCategoryHst, которая будет хранить информацию об изменениях в таблице Production.ProductCategory.
create table Production.ProductCategoryHst(
	ID int identity(1, 1) primary key,
	MyAction nvarchar(6) not null,
	ModifiedDate datetime not null,
	SourceID nvarchar(10) not null,
	UserName nvarchar(20) not null
);

go
-- Создайте один AFTER триггер для трех операций INSERT, UPDATE, DELETE для таблицы Production.ProductCategory. Триггер должен заполнять таблицу Production.ProductCategoryHst с указанием типа операции в поле Action в зависимости от оператора, вызвавшего триггер.
create trigger Production.ProductCategory_Insert on Production.ProductCategory
 after insert as 
     begin
	     insert into Production.ProductCategoryHst(MyAction, ModifiedDate, SourceId, UserName)
		 select 'insert', getdate(), inserted.ProductCategoryID, user_name()
		 from inserted as inserted
	 end
go

create trigger Production.ProductCategory_Update on Production.ProductCategory
 after insert as 
     begin
	     insert into Production.ProductCategoryHst(MyAction, ModifiedDate, SourceId, UserName)
		 select 'update', getdate(), updated.ProductCategoryID, user_name()
		 from inserted as updated
	 end
go

create trigger Production.ProductCategory_Delete on Production.ProductCategory
 after insert as 
     begin
	     insert into Production.ProductCategoryHst(MyAction, ModifiedDate, SourceId, UserName)
		 select 'deleted', getdate(), deleted.ProductCategoryID, user_name()
		 from deleted as deleted
	 end
go
-- Создайте представление VIEW, отображающее все поля таблицы Production.ProductCategory.
create view Production.ProductCategory_View
with encryption
as 
	select * from Production.ProductCategory;
go
-- Вставьте новую строку в Production.ProductCategory через представление. Обновите вставленную строку. Удалите вставленную строку. Убедитесь, что все три операции отображены в Production.ProductCategoryHst.
insert into Production.ProductCategory_View (
	Name, 
	rowguid, 
	ModifiedDate)
values ('BBBB', newid(), getdate());
go

update Production.ProductCategory_View set Name = 'AAAA' where Name = 'BBBB';
go

delete Production.ProductCategory_View where Name = 'AAAA';
go

select * 
from Production.ProductCategoryHst;