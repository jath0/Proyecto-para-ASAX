USE jathBootcamp;
DROP TABLE IF EXISTS matricula;
DROP TABLE IF EXISTS matricula_historial;

CREATE TABLE matricula
	(  id_alta int Primary Key Clustered,
	alumno varchar(20),  
	fecha_matricula date,
	nombre_bootcamp VARCHAR(32),
	SysStartTime datetime2 generated always as row start not null,  
	SysEndTime datetime2 generated always as row end not null,  
	period for System_time (SysStartTime,SysEndTime) ) 
	with (System_Versioning = ON (History_Table = dbo.matricula_historial)
	) 
go



-- Inserto valores para probar


INSERT INTO matricula ([id_alta],[alumno],[fecha_matricula],[nombre_bootcamp])
	Values 
('1','Lisette', '2018-06-01', 'Introducción Metasploit'),
('2','Timmy', '2016-11-18', 'Introduccion a SQL'),
('3','Caroline', '2016-11-01', 'Hacking Ético'),
('4','Ellette', '2015-04-10', 'Hacking Ético'),
('5','Merl', '2016-02-15', 'Hacking Ético'),
('6','Shirlene', '2019-06-17', 'Introducción Metasploit'),
('7','Minnaminnie', '2016-03-11', 'Hacking Ético');
Go


SELECT * FROM matricula;
SELECT * FROM matricula_historial;



-- Como no ha registrado modificaciones porque no ha habido ocasion aún, hacemos una.
update matricula 
	set fecha_matricula = '03/08/2022'
	where alumno = 'Timmy'
GO

SELECT * FROM matricula;
SELECT * FROM matricula_historial;


update matricula 
	set alumno = 'Carolina'
	where alumno = 'Caroline'
GO
update matricula 
	set nombre_bootcamp = 'Introducción Metasploit'
	where alumno = 'Caroline'
GO

update matricula 
	set nombre_bootcamp = 'Introducción Metasploit'
	where alumno = 'Ellette'
GO

DELETE FROM matricula
WHERE id_alta = 7;
GO

SELECT * FROM matricula;
SELECT * FROM matricula_historial;


INSERT INTO matricula ([id_alta],[alumno],[fecha_matricula],[nombre_bootcamp])
	Values 
('8','juan', '2022-03-03', 'Introducción Metasploit')
Go
SELECT * FROM matricula;
SELECT * FROM matricula_historial;


SELECT * FROM matricula_historial;


-- NUEVAS CONSULTAS
-- podemos ver todos los cambios
select * 
from matricula
for system_time all 
go

-- en un punto de tiempo

select * 
from matricula
for system_time as of '2022-03-08 01:59:03.8871014' 
go

-- Con “for system_time from ‘fecha’ to ‘fecha’” vemos los cambios sufridos en la tabla en un rango de fechas

select * 
from matricula 
for system_time from '2022-03-08 02:05:26.4226593' to '2022-03-08 02:17:07.0919668'
go


-- Between es similar al anterior pero toma referencia el SysStartTime

select * 
from matricula 
for system_time between '2022-03-08 01:59:03.8871014' and '2022-03-08 02:10:24.2256028'
go


-- Con “for system_time contained in” se ven los registros que se introdujeron entre las 10:13 
-- y se cambiaron hasta las 10:21

select * 
from matricula 
for system_time contained in ('2022-03-08 01:59:03.8871014', '2022-03-08 02:17:07.0919668')
GO

