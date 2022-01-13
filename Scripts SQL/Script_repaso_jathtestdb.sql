-- CONTROLAMOS LA EXISTENCIA DE LA BASE DE DATOS
DROP DATABASE IF EXISTS JathTestDB;
GO
-- CREAMOS BASE DE DATOS
CREATE DATABASE JathTestDB;
GO
-- NOS UBICAMOS EN LA BASE DE DATOS
USE JathTestDB;
GO
--CONTROLAMOS LA EXISTENCIA DEL ESQUEMA
DROP SCHEMA IF EXISTS HR;
GO
-- CREAMOS ESQUEMA
CREATE SCHEMA HR;
GO

--CONTROLAMOS EXISTENCIA DE TABLA
DROP TABLE IF EXISTS HR.Employee
GO
-- CREAMOS TABLA
CREATE TABLE HR.Employee
(
	EmployeeID CHAR(2),
	GivenName VARCHAR(50),
	Surname VARCHAR(50),
	SSN CHAR(9)
);
GO

-- Importar archivo texto plano CSV

-- ESTO ES MIO HAY QUE PROBAR QUE IMPORTE
--BULK INSERT Sales.Orders
--FROM 'ruta';

-- COMPROBAMOS CONTENIDO DE TABLA
SELECT * FROM HR.Employee;
GO
-- CONTROLAMOS EXISTENCIA DE LA VISTA
DROP VIEW IF EXISTS HR.LookupEmployee;
GO
-- CREAMOS LA VISTA CON PARTE DE LA TABLA
CREATE VIEW HR.LookupEmployee
AS
SELECT 
	EmployeeID, GivenName, Surname
FROM HR.Employee
GO

-- CONTROLAMOS LA EXISTENCIA DEL ROL
DROP ROLE IF EXISTS HumanResourcesAnalyst;
GO

--CREAMOS ROL
CREATE ROLE HumanResourcesAnalyst;
GO

-- ASIGNAMOS PERMISOS SOBRE EL ROL
GRANT SELECT ON HR.LookupEmployee TO HumanResourcesAnalyst;
GO
	-- Para comprobar vamos a roles y en las propiedades del rol

--CONTROLAMOS EXISTENCIA DE USUARIO 
DROP USER IF EXISTS JaneDoe;
GO

-- CREAMOS USUARIO
CREATE USER JaneDoe WITHOUT LOGIN;
GO

-- AÑADIMOS EL NUEVO USUARIO AL ROL
ALTER ROLE HumanResourcesAnalyst
ADD MEMBER JaneDoe;
GO

-- AHORA EJECUTAMOS COMANDOS COMO JANEDOE
EXECUTE AS USER = 'JaneDoe';
GO

-- PROBAMOS QUE PODEMOS VER LA VISTA
SELECT * FROM HR.LookupEmployee;
GO

-- PROBAMOS QUE NO PODEMOS VER LA TABLA
SELECT * FROM HR.Employee;
GO
-- Msg 229, Level 14, State 5, Line 85
-- Se denegó el permiso SELECT en el objeto 'Employee', base de datos 'JathTestDB', esquema 'HR'.

-- CONFIRMAMOS QUE SOMOS JANEDOE
PRINT USER;
GO
--JaneDoe

-- VOLVEMOS AL USUARIO DBO
REVERT;
GO


-- CREAMOS UN PROCESO ALMACENADO PARA LA INSERCION DE EMPLEADOS
CREATE OR ALTER PROC HR.InsertNewEmployee
	-- Parámetros de entrada
	@Employee INT,
	@GivenName VARCHAR(50),
	@Surname VARCHAR(59),
	@SSN CHAR(9)
AS
BEGIN
	INSERT INTO HR.Employee
		(EmployeeID,GivenName,Surname,SSN)
		VALUES
		(@Employee,@GivenName,@Surname,@SSN);
END;

GO


-- CREAMOS UN ROL
CREATE ROLE HumanResoucesRecruiter;
GO

-- DAMOS PERMISOS DE EJECUCION SOBRE EL ESQUEMA
GRANT EXECUTE ON SCHEMA :: [HR] TO HumanResoucesRecruiter;
GO


-- CREAMOS EL USUARIO PARA PROBAR
CREATE USER JohnSmith WITHOUT LOGIN;
GO

-- AÑADIMOS EL USUARIO AL ROL
ALTER ROLE HumanResoucesRecruiter
ADD MEMBER JohnSmith;
GO

-- INTENTAMOS INSERTAR EN LA TABLA DE EMPLEADOS (no puede)
EXECUTE AS USER = 'JohnSmith';
GO

INSERT INTO HR.Employee
   ( EmployeeID, GivenName, Surname, SSN )
   -- (GivenName, Surname, SSN ) con IDENTITY
   VALUES
   (4, 'Miguel', 'Martinez', '444' );
GO 

--Msg 229, Level 14, State 5, Line 135
--Se denegó el permiso INSERT en el objeto 'Employee', base de datos 'JathTestDB', esquema 'HR'.

REVERT;
GO

-- AHORA INTENTAMOS AÑADIR UN REGISTRO EN LA TABLA PERO MEDIANTE UN PROCESO ALMACENADO
EXECUTE AS USER = 'JohnSmith';
GO 

EXEC HR.InsertNewEmployee
	@Employee = 4,
	@GivenName = 'Miguel',
	@Surname='Martinez',
	@SSN= '444';
GO

---  1 row affected

PRINT USER
GO

--johnSmith


-- COMPROBAMOS QUE NO PUEDE VER EL CONTENIDO DE LA TABLA
SELECT * FROM HR.Employee
GO

-- Msg 229, Level 14, State 5, Line 165
-- Se denegó el permiso SELECT en el objeto 'Employee', base de datos 'JathTestDB', esquema 'HR'.

--
SELECT * FROM Employee
GO

-- Msg 208, Level 16, State 1, Line 165
-- El nombre de objeto 'Employee' no es válido.

REVERT;
GO

-- POR ULTIMO SIENDO DBO COMPROBAMOS QUE SE AÑADIÓ EL REGISTRO
SELECT EmployeeID, GivenName, Surname, SSN 
FROM HR.Employee;
GO 

-- EmployeeID	GivenName	Surname		SSN
-- 1			Luis		Arias		111
-- 2			Ana			Gomez		222
-- 3			Juan		Perez		333
-- 4			Miguel		Martinez	444
