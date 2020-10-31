use AdventureWorks2012;
go

-- �������� ������� Production.ProductCategoryHst, ������� ����� ������� ���������� �� ���������� � ������� Production.ProductCategory.
create table Production.ProductCategoryHst(
	ID int identity(1, 1) primary key,
	MyAction nvarchar(6) not null,
	ModifiedDate datetime not null,
	SourceID nvarchar(10) not null,
	UserName nvarchar(20) not null
);

go
-- �������� ���� AFTER ������� ��� ���� �������� INSERT, UPDATE, DELETE ��� ������� Production.ProductCategory. ������� ������ ��������� ������� Production.ProductCategoryHst � ��������� ���� �������� � ���� Action � ����������� �� ���������, ���������� �������.
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
-- �������� ������������� VIEW, ������������ ��� ���� ������� Production.ProductCategory.
create view Production.ProductCategory_View
with encryption
as 
	select * from Production.ProductCategory;
go
-- �������� ����� ������ � Production.ProductCategory ����� �������������. �������� ����������� ������. ������� ����������� ������. ���������, ��� ��� ��� �������� ���������� � Production.ProductCategoryHst.
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