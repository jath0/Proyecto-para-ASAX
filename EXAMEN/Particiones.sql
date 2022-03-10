USE master
DROP DATABASE IF EXISTS DB_jath_10_marzo;
GO
CREATE DATABASE DB_jath_10_marzo;
GO
USE DB_jath_10_marzo;
GO
DROP TABLE IF EXISTS table_jath_10_marzo;
CREATE TABLE table_jath_10_marzo(
	[SalesOrderID] [int] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[ShipDate] [datetime] NULL,
	[Status] [tinyint] NOT NULL,
	[OnlineOrderFlag][nvarchar](128)NOT NULL,
	[SalesOrderNumber]  [varchar](128) NULL,
	[PurchaseOrderNumber] [nvarchar](128) NULL,
	[AccountNumber] [nvarchar](128) NULL,
	[CustomerID] [int] NOT NULL,
	[SalesPersonID] [int] NULL,
	[TerritoryID] [int] NULL,
	[BillToAddressID] [int] NOT NULL,
	[ShipToAddressID] [int] NOT NULL,
	[ShipMethodID] [int] NOT NULL,
	[CreditCardID] [int] NULL,
	[CreditCardApprovalCode] [varchar](15) NULL,
	[CurrencyRateID] [int] NULL,
	[SubTotal] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[TotalDue] [varchar](128) NULL,
	[Comment] [nvarchar](128) NULL,
	[rowguid] [nvarchar](128)  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL)
	;

GO

INSERT INTO table_jath_10_marzo
SELECT * FROM AdventureWorks2019.Sales.SalesOrderHeader;
GO

SELECT * FROM AdventureWorks2019.Sales.SalesOrderHeader
ORDER BY OrderDate
;



ALTER DATABASE [DB_jath_10_marzo] ADD FILEGROUP FG_jath_EXTRA;
ALTER DATABASE [DB_jath_10_marzo] ADD FILEGROUP FG_jath_2011;
ALTER DATABASE [DB_jath_10_marzo] ADD FILEGROUP FG_jath_2012;
ALTER DATABASE [DB_jath_10_marzo] ADD FILEGROUP FG_jath_2013;
ALTER DATABASE [DB_jath_10_marzo] ADD FILEGROUP FG_jath_2014;
ALTER DATABASE [DB_jath_10_marzo] ADD FILE(NAME= F_jath_EXTRA, FILENAME='C:\EXAMEN\F_JATH_EXTRA.ndf') TO FILEGROUP FG_jath_EXTRA;
ALTER DATABASE [DB_jath_10_marzo] ADD FILE(NAME= F_jath_2011, FILENAME='C:\EXAMEN\F_JATH_2011.ndf')TO FILEGROUP FG_jath_2011;
ALTER DATABASE [DB_jath_10_marzo] ADD FILE(NAME= F_jath_2012, FILENAME='C:\EXAMEN\F_JATH_2012.ndf')TO FILEGROUP FG_jath_2012;
ALTER DATABASE [DB_jath_10_marzo] ADD FILE(NAME= F_jath_2013, FILENAME='C:\EXAMEN\F_JATH_2013.ndf')TO FILEGROUP FG_jath_2013;
ALTER DATABASE [DB_jath_10_marzo] ADD FILE(NAME= F_jath_2014, FILENAME='C:\EXAMEN\F_JATH_2014.ndf')TO FILEGROUP FG_jath_2014;


CREATE PARTITION FUNCTION FN_jath_Orderdate(datetime)
AS RANGE RIGHT
FOR VALUES ('01-01-2011','01-01-2012','01-01-2013');
GO

CREATE PARTITION SCHEME SCH_jath_orderdate
AS PARTITION FN_jath_Orderdate
TO ('FG_jath_EXTRA','FG_jath_2011','FG_jath_2012','FG_jath_2013','FG_jath_2014');

DROP TABLE IF EXISTS table_jath_10_marzo;
CREATE TABLE table_jath_10_marzo(
	[SalesOrderID] [int] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[ShipDate] [datetime] NULL,
	[Status] [tinyint] NOT NULL,
	[OnlineOrderFlag][nvarchar](128)NOT NULL,
	[SalesOrderNumber]  [varchar](128) NULL,
	[PurchaseOrderNumber] [nvarchar](128) NULL,
	[AccountNumber] [nvarchar](128) NULL,
	[CustomerID] [int] NOT NULL,
	[SalesPersonID] [int] NULL,
	[TerritoryID] [int] NULL,
	[BillToAddressID] [int] NOT NULL,
	[ShipToAddressID] [int] NOT NULL,
	[ShipMethodID] [int] NOT NULL,
	[CreditCardID] [int] NULL,
	[CreditCardApprovalCode] [varchar](15) NULL,
	[CurrencyRateID] [int] NULL,
	[SubTotal] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[TotalDue] [varchar](128) NULL,
	[Comment] [nvarchar](128) NULL,
	[rowguid] [nvarchar](128)  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL)
	ON SCH_jath_orderdate(OrderDate)
	;

GO

INSERT INTO table_jath_10_marzo
SELECT * FROM AdventureWorks2019.Sales.SalesOrderHeader;
GO


SELECT *,$partition.FN_jath_Orderdate(OrderDate) AS PARTITION
FROM table_jath_10_marzo;
GO

SELECT name, create_date, 
VALUE FROM sys.partition_functions f 
INNER JOIN sys.partition_range_values rv 
ON f.function_id=rv.function_id WHERE f.name = 'FN_jath_Orderdate' 
GO

SELECT p.partition_number, p.rows 
FROM sys.partitions p 
INNER JOIN sys.tables t 
on p.object_id=t.object_id AND t.name = 'table_jath_10_marzo' 
GO



ALTER PARTITION FUNCTION FN_jath_Orderdate()
SPLIT RANGE ('01-01-2014');


-- partition_number	rows
-- 1				0
-- 2				1607
-- 3				3915
-- 4				14182
-- 5				11761


ALTER PARTITION FUNCTION FN_jath_Orderdate ()
MERGE RANGE ('01-01-2011');

-- partition_number	rows
-- 1					1607
-- 2					3915
-- 3					14182
-- 4					11761


DROP TABLE IF EXISTS table_jath_10_SWITCH;
CREATE TABLE table_jath_10_SWITCH(
	[SalesOrderID] [int] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[ShipDate] [datetime] NULL,
	[Status] [tinyint] NOT NULL,
	[OnlineOrderFlag][nvarchar](128)NOT NULL,
	[SalesOrderNumber]  [varchar](128) NULL,
	[PurchaseOrderNumber] [nvarchar](128) NULL,
	[AccountNumber] [nvarchar](128) NULL,
	[CustomerID] [int] NOT NULL,
	[SalesPersonID] [int] NULL,
	[TerritoryID] [int] NULL,
	[BillToAddressID] [int] NOT NULL,
	[ShipToAddressID] [int] NOT NULL,
	[ShipMethodID] [int] NOT NULL,
	[CreditCardID] [int] NULL,
	[CreditCardApprovalCode] [varchar](15) NULL,
	[CurrencyRateID] [int] NULL,
	[SubTotal] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[TotalDue] [varchar](128) NULL,
	[Comment] [nvarchar](128) NULL,
	[rowguid] [nvarchar](128)  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL)
	ON FG_jath_EXTRA
;

GO

ALTER TABLE table_jath_10_marzo
SWITCH Partition 1 TO table_jath_10_SWITCH;

--Commands completed successfully.

--Completion time: 2022-03-10T19:16:27.4366920+01:00

SELECT p.partition_number, p.rows 
FROM sys.partitions p 
INNER JOIN sys.tables t 
on p.object_id=t.object_id AND t.name = 'table_jath_10_marzo' 
GO
 --partition_number	rows
 --2				3915
 --3				14182
 --4				11761
 --1				0


 TRUNCATE TABLE table_jath_10_marzo
 WITH (PARTITIONS (4));
 Go

--Commands completed successfully.

--Completion time: 2022-03-10T19:20:20.2652376+01:00

SELECT p.partition_number, p.rows 
FROM sys.partitions p 
INNER JOIN sys.tables t 
on p.object_id=t.object_id AND t.name = 'table_jath_10_marzo' 
GO


-- partition_number	rows
-- 2					3915
-- 3					14182
-- 4					0
-- 1					0