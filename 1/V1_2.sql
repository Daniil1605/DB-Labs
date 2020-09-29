USE AdventureWorks2012;
--¬ывести на экран сотрудников, позици€ которых находитс€ в списке: СAccounts ManagerТ,ТBenefits SpecialistТ,ТEngineering ManagerТ,ТFinance ManagerТ,ТMaintenance SupervisorТ,ТMaster SchedulerТ,ТNetwork ManagerТ. 
--¬ыполните задание не использу€ оператор С=Т.
SELECT BusinessEntityID, JobTitle, Gender, HireDate 
FROM HumanResources.Employee 
WHERE
	JobTitle IN ('Accounts Manager','Benefits Specialist','Engineering Manager','Finance Manager','Maintenance Supervisor','Master Scheduler','Network Manager');
-- ¬ывести на экран количество сотрудников, прин€тых на работу позже 2004 года (включа€ 2004 год).
SELECT COUNT (*) as count
FROM HumanResources.Employee 
WHERE HireDate > '2003-12-31';
-- ¬ывести на экран 5(п€ть) самых молодых сотрудников, состо€щих в браке, которые были прин€ты на работу в 2004 году.
SELECT TOP (5) BusinessEntityID, JobTitle, MaritalStatus, Gender, BirthDate, HireDate
FROM HumanResources.Employee 
WHERE (HireDate BETWEEN '2004-01-01' AND '2004-12-31') AND (MaritalStatus = 'M')
ORDER BY BirthDate DESC;