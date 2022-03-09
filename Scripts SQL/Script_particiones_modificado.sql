
-- Primero voy a colocar todos los archivos de mi BBDD en la misma carpeta por tenerlos mejor localizados.
Use jathBootcamp;

ALTER DATABASE jathBootcamp
	MODIFY FILE (NAME = jathBootcamp,
	FILENAME ='C:\DATABASES\jath_bootcamp\jathBootcamp.mdf'
	);
GO

ALTER DATABASE jathBootcamp
	MODIFY FILE (NAME = jathBootcamp_log,
	FILENAME ='C:\DATABASES\jath_bootcamp\jathBootcamp_log.ldf'
	);
GO

-- Ahora voy a crear los filegroups 
ALTER DATABASE jathBootcamp ADD FILEGROUP [FG_matriculashasta2020] 
GO 
ALTER DATABASE jathBootcamp ADD FILEGROUP [FG_matriculas2020] 
GO 
ALTER DATABASE jathBootcamp ADD FILEGROUP [FG_matriculas2021] 
GO 
ALTER DATABASE jathBootcamp ADD FILEGROUP [FG_matriculas2022adelante] 
GO 


select * from sys.filegroups
GO

-- -- CREAMOS LOS ARCHIVOS 

ALTER DATABASE jathBootcamp ADD FILE ( NAME = 'Matriculahasta2020', FILENAME = 'c:\DATABASES\jath_bootcamp\matriculahasta2020.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_matriculashasta2020]  
GO
ALTER DATABASE jathBootcamp ADD FILE ( NAME = 'Matricula_2020', FILENAME = 'c:\DATABASES\jath_bootcamp\matricula2020.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_matriculas2020] 
GO
ALTER DATABASE jathBootcamp ADD FILE ( NAME = 'Matricula_2021', FILENAME = 'c:\DATABASES\jath_bootcamp\matricula2021.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_matriculas2021] 
GO
ALTER DATABASE jathBootcamp ADD FILE ( NAME = 'Matricula2022adelante', FILENAME = 'c:\DATABASES\jath_bootcamp\matriculas2022adelante.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_matriculas2022adelante] 
GO


select * from sys.filegroups
GO

select * from sys.database_files
GO

-- Creamos la funcion que repartirá la tabla

CREATE PARTITION FUNCTION FN_matricula_fecha (date) 
AS RANGE RIGHT 
	FOR VALUES ('2020-01-01','2021-01-01','2022-01-01')
GO

-- 'RIGHT' SE REFIERE QUE EN UN RANGO (IMAGINA UNA LINEA CON SEGMENTOS CADA SEGMENTO UN RANGO) COMO LA DIRECCIÓN A QUE LA ASIGNA

-- TODOS LOS ANTERIORES			01/01/2020			01/01/2021		01/01/2022    RESTANTES
--------------------------------|----------------------|--------------|-----------------

-- Asignamos la funcion de las particiones a un esquema y filegroups

CREATE PARTITION SCHEME matricula_esq
AS PARTITION FN_matricula_fecha 
	TO (FG_matriculashasta2020,FG_matriculas2020,FG_matriculas2021,FG_matriculas2022adelante) 
GO

--Partition scheme 'matriculas_esq' has been created successfully. 'FG_matriculas2022adelante' is marked as the next used filegroup in partition scheme 'matriculas_esq'.

--Completion time: 2022-03-07T23:22:45.1900001+01:00



-- Aplicamos la función a una tabla de ejemplo

CREATE TABLE matricula
	( id_alta int identity (1,1), 
	alumno varchar(20),  
	fecha_matricula date,
	nombre_bootcamp VARCHAR(32)) 
	ON matricula_esq 
		(fecha_matricula) 
GO

-- Inserto valores para probar
-- SSMS TABLE PROPERTIES PARTITIONS

INSERT INTO matricula 
	Values ('Minnaminnie', '2016-03-11', 'Hacking Ético'),
('Lisette', '2018-06-01', 'Introducción Metasploit'),
('Timmy', '2016-11-18', 'Introduccion a SQL'),
('Caroline', '2016-11-01', 'Hacking Ético'),
('Ellette', '2015-04-10', 'Hacking Ético'),
('Merl', '2016-02-15', 'Hacking Ético'),
('Shirlene', '2019-06-17', 'Introducción Metasploit'),
('Yancy', '2021-01-31', 'Hacking Ético'),
('Conny', '2017-01-02', 'Introducción Metasploit'),
('Mylo', '2018-10-25', 'Introducción Metasploit'),
('Sonia', '2015-12-04', 'Hacking Ético'),
('Vallie', '2016-11-09', 'Introducción Metasploit'),
('Wendie', '2015-06-27', 'Introducción Metasploit'),
('Wynn', '2020-09-01', 'Hacking Ético'),
('Milena', '2019-05-02', 'Introducción Metasploit'),
('Lauren', '2020-06-23', 'Introducción Metasploit'),
('Evelyn', '2016-12-11', 'Introducción Metasploit'),
('Katine', '2021-04-15', 'Hacking Ético'),
('Reynard', '2018-10-07', 'Introduccion a SQL'),
('Hernando', '2017-01-16', 'Hacking Ético');

Go



SELECT *,$Partition.[FN_matricula_fecha](fecha_matricula) AS Partition
FROM matricula
GO

--id_alta	alumno		fecha_matricula	nombre_bootcamp		Partition
--1			Minnaminnie	2016-03-11		Hacking Ético			1
--2			Lisette		2018-06-01		Introducción Metasploit	1
--3			Timmy		2016-11-18		Introduccion a SQL		1
--4			Caroline	2016-11-01		Hacking Ético			1
--5			Ellette		2015-04-10		Hacking Ético			1
--6			Merl		2016-02-15		Hacking Ético			1
--7			Shirlene	2019-06-17		Introducción Metasploit	1
--9			Conny		2017-01-02		Introducción Metasploit	1
--10		Mylo		2018-10-25		Introducción Metasploit	1
--11		Sonia		2015-12-04		Hacking Ético			1
--12		Vallie		2016-11-09		Introducción Metasploit	1
--13		Wendie		2015-06-27		Introducción Metasploit	1
--15		Milena		2019-05-02		Introducción Metasploit	1
--17		Evelyn		2016-12-11		Introducción Metasploit	1
--19		Reynard		2018-10-07		Introduccion a SQL		1
--20		Hernando	2017-01-16		Hacking Ético			1
--14		Wynn		2020-09-01		Hacking Ético			2
--16		Lauren		2020-06-23		Introducción Metasploit	2
--8			Yancy		2021-01-31		Hacking Ético			3
--18		Katine		2021-04-15		Hacking Ético			3


-- Mostrar limites creados por la función
select name, create_date, value from sys.partition_functions f 
inner join sys.partition_range_values rv 
on f.function_id=rv.function_id 
where f.name = 'FN_matricula_fecha'
GO

-- Mostrar particiones y contenidos
select p.partition_number, p.rows from sys.partitions p 
inner join sys.tables t 
on p.object_id=t.object_id and t.name = 'matricula' 
GO


DECLARE @TableName NVARCHAR(200) = N'matricula' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

INSERT INTO matricula 
	Values 
('Rourke', '2022-02-15', 'Hacking Ético'),
('Belle', '2022-01-10', 'Introducción Metasploit'),
('Rafferty', '2022-02-23', 'Introduccion a SQL'),
('Tamera', '2022-02-15', 'Introduccion a SQL'),
('Ricard', '2022-01-19', 'Introduccion a SQL');

select p.partition_number, p.rows from sys.partitions p 
inner join sys.tables t 
on p.object_id=t.object_id and t.name = 'matricula' 
GO

--MERGE--

DECLARE @TableName NVARCHAR(200) = N'matricula' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

ALTER PARTITION FUNCTION FN_matricula_fecha ()
MERGE RANGE ('2021-01-01'); 
GO

USE master
GO

-- El FILEGROUP NO SE USA POR EL MERGE LO ELIMINAMOS
ALTER DATABASE [jathBootcamp] REMOVE FILE matricula_2021
go

ALTER DATABASE [jathBootcamp] REMOVE FILEGROUP FG_matriculas2021
GO


--SPLIT--

SELECT *,$Partition.[FN_matricula_fecha](fecha_matricula) AS Partition
FROM matricula ORDER BY fecha_matricula;
GO


ALTER PARTITION FUNCTION FN_matricula_fecha() 
	SPLIT RANGE ('2017-01-01'); 
GO

---------------------------ERROR
--Msg 7710, Level 16, State 1, Line 198
---Warning: The partition scheme 'matricula_esq' does not have any next used filegroup. Partition scheme has not been changed.


-- SWITCH --

USE [jathBootcamp]
go


SELECT *,$Partition.[FN_matricula_fecha](fecha_matricula) AS Partition
FROM matricula ORDER BY fecha_matricula;
GO

DECLARE @TableName NVARCHAR(200) = N'matricula' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO


CREATE TABLE matriculas_antiguas
	( id_alta int identity (1,1), 
	alumno varchar(20),  
	fecha_matricula date,
	nombre_bootcamp VARCHAR(32) )
ON FG_matriculashasta2020
GO


ALTER TABLE matricula 
	SWITCH Partition 1 to matriculas_antiguas
go


SELECT * FROM  matricula
GO

SELECT * FROM matriculas_antiguas
Go


TRUNCATE TABLE matricula
	WITH (PARTITIONS (3));
go