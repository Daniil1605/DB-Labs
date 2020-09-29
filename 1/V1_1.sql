USE master;
GO

CREATE DATABASE MINE;
GO

USE MINE;
GO

CREATE SCHEMA sales;
GO

CREATE TABLE sales.Orders (OrderNum INT NULL);
GO

USE master;
GO

BACKUP DATABASE MINE TO DISK = 'e:\work\7\ад\1\MINE.bak';

DROP DATABASE MINE;

RESTORE DATABASE MINE
FROM DISK = 'e:\work\7\ад\1\MINE.bak'