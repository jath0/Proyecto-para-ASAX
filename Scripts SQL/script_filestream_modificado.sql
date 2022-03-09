-- https://dba-presents.com/index.php/databases/sql-server/59-introduction-to-filestream

-- A BLOB, or Binary Large Object, is an SQL object data type, meaning 
-- it is a reference or pointer to an object. 
-- Typically a BLOB is a file, image, video, or other large object. 
-- In database systems, such as Oracle and SQL Server, a BLOB can hold 
-- as much as 4 gigabytes. 

-- https://docs.microsoft.com/en-us/sql/relational-databases/blob/binary-large-object-blob-data-sql-server?view=sql-server-ver15

-- Options for Storing Blobs

-- FILESTREAM (SQL Server)
-- FILESTREAM enables SQL Server-based applications to store unstructured data, 
	--such as documents and images, on the file system. Applications can leverage the rich streaming APIs and performance of the file system and at the same time maintain transactional consistency between the unstructured data and corresponding structured data.

--FileTables (SQL Server)
--The FileTable feature brings support for the Windows file namespace and compatibility with Windows applications to the file data stored in SQL Server. FileTable lets an application integrate its storage and data management components, and provides integrated SQL Server services - including full-text search and semantic search - over unstructured data and metadata.

--In other words, you can store files and documents in special tables in SQL Server called FileTables, but access them from Windows applications as if they were stored in the file system, without making any changes to your client applications.

--Remote Blob Store (RBS) (SQL Server)
--Remote BLOB store (RBS) for SQL Server lets database administrators store binary large objects (BLOBs) in commodity storage solutions instead of directly on the server. This saves a significant amount of space and avoids wasting expensive server hardware resources. RBS provides a set of API libraries that define a standardized model for applications to access BLOB data. RBS also includes maintenance tools, such as garbage collection, to help manage remote BLOB data.

--RBS is included on the SQL Server installation media, but is not installed by the SQL Server Setup program.


-- https://www.sqlshack.com/viewing-sql-server-filestream-data-with-ssrs/

-- https://blog.sqlauthority.com/2019/03/01/sql-server-sql-server-configuration-manager-missing-from-start-menu/

-------------------------------------------------
-- Before FILESTREAM can be used, it has to be enabled on the instance. 
-- To do this, go to Configuration Manager, select SQL Server Services and double click the instance you would like to have FILESTREAM enabled.

--	A nivel de BD mediante sp_configure @enablelevel, dónde @enablelevel indica:

--0 = Deshabilitado. Este es el valor por defecto.
--1 = Habilitado solo para acceso T-SQL.
--2 = Habilitado solo para T-SQL y acceso local al sistema de ficheros.
--3 = Habilitado para T-SQL, acceso local y remoto al sistema de ficheros.


EXEC sp_configure filestream_access_level, 2
RECONFIGURE
GO

--Configuration option 'filestream access level' changed from 0 to 2. Run the RECONFIGURE statement to install.

-- NOTA:
-- FILESTREAM feature could not be initialized. 
-- The operating system Administrator must enable FILESTREAM on the instance using Configuration Manager.

-- Activa la Opción en el SQL SERVER CONFIGURATION MANAGER
-- IF CONFIGURATION MANAGER  no aparece (a veces ocurre ...)   entonces
-- SQL Server 	SQLServerManager14.msc
-- SQL Server configuration manager, generalmente es accesible como complemento de la consola de administración (microsoft management console: mmc.exe).

--Puedes ejecutarlo directamente desde el cuadro de diálogo ejecutar 
-- (que a su vez puedes invocar con la combinación de teclas Windows + r.

--En dicho diálogo, en el edit Abrir escribe:

--SQLServerManager15.msc para SQL Server 2019
--SQLServerManager14.msc para SQL Server 2017
--SQLServerManager13.msc para SQL Server 2016
--SQLServerManager12.msc para SQL Server 2014
--SQLServerManager11.msc para SQL Server 2012
--SQLServerManager10.msc para SQL Server 2008


-- ENABLE FILESTREAM

-- RESTART MSSQLSERVER SERVICE

EXEC sp_configure filestream_access_level, 2
RECONFIGURE
GO

-- Configuration option 'filestream access level' changed from 2 to 2. Run the RECONFIGURE statement to install.


----------------------

USE [jathBootcamp]
GO

ALTER DATABASE [jathBootcamp] 
	ADD FILEGROUP [PRIMARY_FILESTREAM] 
	CONTAINS FILESTREAM 
GO

ALTER DATABASE [jathBootcamp]
       ADD FILE (
             NAME = 'MyDatabase_filestream',
             FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\filestream'
       )
       TO FILEGROUP [PRIMARY_FILESTREAM]
GO


ALTER TABLE [dbo].[estudiante]
		ADD id_foto UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL UNIQUE,
       foto VARBINARY(MAX) FILESTREAM NULL
;
GO


INSERT INTO [dbo].[estudiante]
		VALUES (01,'jeff','bezos','varon', '1111-11-11',696969696,'jeff@amazon.com','jefazo del mundo',
		NEWID(), (SELECT * FROM OPENROWSET(BULK 'C:\Alumnos\jeff.jpg', SINGLE_BLOB) as jeffb));
GO

INSERT INTO [dbo].[estudiante]
		VALUES (02,'elon','musk','varon', '1111-11-11',696969698,'elonmuskinator@spacex.com','El mundo se queda pequeño para mi me voy a marte',
		NEWID(), (SELECT * FROM OPENROWSET(BULK 'C:\Alumnos\elonmusk.jpg', SINGLE_BLOB) as elomk));
GO

INSERT INTO [dbo].[estudiante]
		VALUES (03,'kevin','mitnik','varon', '1111-11-11',696969696,'miticmitnik@hack.com','Hace 20 años que no toco un pc a ver como ha evolucionado esto',
		NEWID(), (SELECT * FROM OPENROWSET(BULK 'C:\Alumnos\kevinmitnik.jpg', SINGLE_BLOB) as kevinmit));
GO


SELECT id_estudiante,nombre,id_foto,foto FROM estudiante;

-- Filestream columns
SELECT SCHEMA_NAME(t.schema_id) AS [schema], 
    t.[name] AS [table],
    c.[name] AS [column],
    TYPE_NAME(c.user_type_id) AS [column_type]
FROM sys.columns c
JOIN sys.tables t ON c.object_id = t.object_id
WHERE t.filestream_data_space_id IS NOT NULL
    AND c.is_filestream = 1
ORDER BY 1, 2, 3;
-- Filestream files and filegroups
SELECT f.[name] AS [file_name],
    f.physical_name AS [file_path],
    fg.[name] AS [filegroup_name]
FROM sys.database_files f 
JOIN sys.filegroups fg ON f.data_space_id = fg.data_space_id
WHERE f.[type] = 2
ORDER BY 1;
GO

ALTER TABLE [dbo].[estudiante] DROP COLUMN foto
GO
ALTER TABLE [dbo].[estudiante] SET (FILESTREAM_ON="NULL")
GO
ALTER DATABASE [jathBootcamp] REMOVE FILE MyDatabase_filestream;
GO
ALTER DATABASE [jathBootcamp] REMOVE FILEGROUP  [PRIMARY_FILESTREAM]
GO

