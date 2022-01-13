-- SCRIPT BACKUP

USE MASTER;
GO

DROP PROCEDURE IF EXISTS BACKUP_ALL_DB_PARENTADA;
GO

CREATE OR ALTER PROC BACKUP_ALL_DB_PARENTADA
	@path VARCHAR(256)
AS

DECLARE @name VARCHAR(50),
-- @path VARCHAR (256)
@filename VARCHAR(256),
@fileDate VARCHAR(20),
@backupcount INT

CREATE TABLE [dbo].#tempBackup --#tempbackup es tabla temporal
(intID INT IDENTITY (1,1),
name VARCHAR (200))

--Crear la carpeta backup
-- SET @path = 'C:\Backup\'
-- Includes the data in the filename

SET @filename = CONVERT(VARCHAR(20), GETDATE(), 112)--112 0 formato fecha

