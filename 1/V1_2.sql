USE AdventureWorks2012;
--������� �� ����� �����������, ������� ������� ��������� � ������: �Accounts Manager�,�Benefits Specialist�,�Engineering Manager�,�Finance Manager�,�Maintenance Supervisor�,�Master Scheduler�,�Network Manager�. 
--��������� ������� �� ��������� �������� �=�.
SELECT BusinessEntityID, JobTitle, Gender, HireDate 
FROM HumanResources.Employee 
WHERE
	JobTitle IN ('Accounts Manager','Benefits Specialist','Engineering Manager','Finance Manager','Maintenance Supervisor','Master Scheduler','Network Manager');
-- ������� �� ����� ���������� �����������, �������� �� ������ ����� 2004 ���� (������� 2004 ���).
SELECT COUNT (*) as count
FROM HumanResources.Employee 
WHERE HireDate > '2003-12-31';
-- ������� �� ����� 5(����) ����� ������� �����������, ��������� � �����, ������� ���� ������� �� ������ � 2004 ����.
SELECT TOP (5) BusinessEntityID, JobTitle, MaritalStatus, Gender, BirthDate, HireDate
FROM HumanResources.Employee 
WHERE (HireDate BETWEEN '2004-01-01' AND '2004-12-31') AND (MaritalStatus = 'M')
ORDER BY BirthDate DESC;