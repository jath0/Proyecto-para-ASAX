DROP TABLE IF EXISTS jath_Departamento;

CREATE TABLE jath_Departamento
(DeptID int Primary Key Clustered,
DeptName VARCHAR(20),
DeptCreado VARCHAR(20),
NumEmpleados VARCHAR(20),
SysStartTime datetime2 generated always as row start not null,
SysEndTime datetime2 generated always as row end not null,
period for System_time (SysStartTime,SysEndTime) )
with (System_Versioning = ON (History_Table = dbo.jath_Departamento_Historial)
);

SELECT * FROM jath_Departamento; 
SELECT * FROM jath_Departamento_Historial;

UPDATE jath_Departamento
SET NumEmpleados = 20
WHERE DeptName='Contabilidad';

UPDATE jath_Departamento
SET NumEmpleados = 18
WHERE DeptName='Contabilidad';

DELETE FROM dbo.jath_Departamento
WHERE DeptID = 3; 

SELECT * FROM jath_Departamento; 
SELECT * FROM jath_Departamento_Historial;



select * from jath_Departamento for system_time all 
GO

select * from jath_Departamento for system_time as of '2022-03-10 19:06:04.3396435' go


select * from jath_Departamento 
for system_time from '2022-03-10 19:06:04.3396435' 
to '2022-03-10 19:07:06.6526533' 
go

select * from jath_Departamento 
for system_time 
between '2022-03-10 19:06:04.3396435'  and '2022-03-10 19:07:06.6526533' 
go

select * from jath_Departamento 
for system_time contained in ('2022-03-10 19:06:04.3396435', '2022-03-10 19:15:34.5675549') 
GO
