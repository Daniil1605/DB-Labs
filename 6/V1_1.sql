use AdventureWorks2012;
go

/*�������� �������� ���������, ������� ����� ���������� ������� ������� (��������
PIVOT), ������������ ������ � ��������� ���������� ��������� ���������
(Sales.SalesOrderDetail.OrderQty) �� ������������ ��� (Sales.SalesOrderHeader.OrderDate).
������ ��� ��������� � ��������� ����� ������� ��������.
*/

create procedure dbo.sales(@years nvarchar(30)) as
	declare @sql as nvarchar(700);
	set @sql = '
	select [Name] as Name ,
		' + @years + '
		from (
		    select Production.Product.Name as Name, avz.OrderQty, OrderDate as OrderDate
			from
			(select Sales.SalesOrderDetail.ProductID as ProductID ,Sales.SalesOrderDetail.OrderQty, YEAR(Sales.SalesOrderHeader.OrderDate) as OrderDate
			from Sales.SalesOrderDetail
				 join Sales.SalesOrderHeader
					on Sales.SalesOrderDetail.SalesOrderID = Sales.SalesOrderHeader.SalesOrderID) as avz
					join Production.Product on avz.ProductID = Production.Product.ProductID
			) as temp
		PIVOT
		(
			SUM(temp.OrderQty)
			FOR temp.OrderDate IN (' + @years + ')
		) AS pvt'
    exec sp_executesql @sql;
go
exec dbo.sales '[2008],[2007],[2006]';
go