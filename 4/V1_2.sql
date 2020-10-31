use AdventureWorks2012;
go

--  �������� ������������� VIEW, ������������ ������ �� ������ Production.ProductCategory � Production.ProductSubcategory. �������� ����������� �������� ��������� ���� �������������. �������� ���������� ���������� ������ � ������������� �� ����� ProductCategoryID, ProductSubcategoryID.
create view Production.ProductCategorySubCategory_View
with schemabinding, encryption as
select
	category.ProductCategoryID as CategoryID,
	category.Name as CategoryName,
	category.rowguid as CategoryRowguid,
	category.ModifiedDate as CategoryModifiedDate,
	subcategory.ProductSubcategoryID as SubcategoryID,
	subcategory.Name as SubcategoryName,
	subcategory.rowguid as SubcategoryRowguid,
	subcategory.ModifiedDate as SubcategoryModifiedDate
from Production.ProductCategory as category
join Production.ProductSubcategory as subcategory on subcategory.ProductCategoryID = category.ProductCategoryID
go

create unique clustered index uniqueindex
on Production.ProductCategorySubCategory_View (CategoryID, SubcategoryID);
go

-- �������� ��� INSTEAD OF �������� ��� ������������� �� �������� INSERT, UPDATE, DELETE. ������ ������� ������ ��������� ��������������� �������� � �������� Production.ProductCategory � Production.ProductSubcategory.
create trigger Production.ProductCategorySubCategory_Insert on Production.ProductCategorySubCategory_View
instead of insert as
begin
	insert into Production.ProductCategory
	select 
		Name = inserted.CategoryName,
		rowguid = inserted.CategoryRowguid,
		ModifiedDate = inserted.CategoryModifiedDate
	from inserted as inserted;

	insert into Production.ProductSubcategory
	select 
		ProductCategoryID = category.ProductCategoryID,
		Name = inserted.SubcategoryName,
		rowguid = newid(),
		ModifiedDate = getdate()
	from inserted as inserted
	join Production.ProductCategory as category 
		on category.rowguid = inserted.CategoryRowguid
end;
go

create trigger Production.ProductCategorySubCategory_Update on Production.ProductCategorySubCategory_View
instead of update as
begin
		update	Production.ProductCategory  set
				Name = updated.CategoryName,
				ModifiedDate = CategoryModifiedDate
		from inserted as updated
		where updated.CategoryID = Production.ProductCategory.ProductCategoryID

		update	Production.ProductSubcategory  set
				Name = updated.SubcategoryName,
				ModifiedDate = getdate()
		from inserted as updated
		where updated.SubcategoryID = Production.ProductSubcategory.ProductSubcategoryID
end;
go

create trigger Production.ProductCategorySubCategory_Delete ON Production.ProductCategorySubCategory_View
instead of delete as
begin
		delete from Production.ProductSubcategory 
		where ProductSubcategoryID in (select SubcategoryID from deleted)

		delete from Production.ProductCategory 
		where ProductCategoryID in (select CategoryID from deleted)
end;
go
-- �������� ����� ������ � �������������, ������ ����� ������ ��� ProductCategory � ProductSubcategory. ������� ������ �������� ����� ������ � ������� Production.ProductCategory � Production.ProductSubcategory. �������� ����������� ������ ����� �������������. ������� ������.

insert into Production.ProductCategorySubCategory_View (
	CategoryName,
	SubcategoryName,
	CategoryRowguid,
	CategoryModifiedDate
)
values ('AAAA', 'BBBB', newid(), getdate());

update Production.ProductCategorySubCategory_View set
	CategoryName = 'CCCC',
	SubcategoryName = 'DDDD'
where CategoryName = 'AAAA';

delete from Production.ProductCategorySubCategory_View
where CategoryName = 'CCCC';

