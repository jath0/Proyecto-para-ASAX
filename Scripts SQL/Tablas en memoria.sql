DROP DATABASE IF EXISTS [jathBootcamp]
go
CREATE DATABASE [jathBootcamp]
go
USE [jathBootcamp]
go
ALTER DATABASE CURRENT  
    SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = ON;
GO



-- Crear FILEGROUP optimizado


ALTER DATABASE [jathBootcamp]
	ADD FILEGROUP jathBootcamp_OP
	CONTAINS MEMORY_OPTIMIZED_DATA
GO

-- Necesitamos añadir uno o mas contenedores MEMORY_OPTIMIZED_DATA filegroup

ALTER DATABASE [jathBootcamp]
	ADD FILE (name='jathBootcamp_OP1', 
	filename='c:\DATABASES\jath_bootcamp\jathBootcamp_OP1') 
	TO FILEGROUP jathBootcamp_OP
GO


-- Creamos tabla con memoria optimizada

DROP TABLE IF EXISTS SalesOrder
go

CREATE TABLE matricula
	( id_alta int identity (1,1), 
	alumno varchar(20),  
	fecha_matricula date,
	nombre_bootcamp VARCHAR(32)) 
    WITH  
        (MEMORY_OPTIMIZED = ON,  
        DURABILITY = SCHEMA_AND_DATA);
GO


