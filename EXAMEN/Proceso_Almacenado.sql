CREATE VIEW  view_jath_10_marzo
AS SELECT* FROM [dbo].[table_jath_10_marzo];

--Commands completed successfully.
--Completion time: 2022-03-10T19:32:12.7309367+01:00



SELECT* FROM [dbo].[table_jath_10_marzo]

ALTER TABLE [dbo].[table_jath_10_marzo] ADD USUARIO VARCHAR(25);
ALTER TABLE [dbo].[table_jath_10_marzo] ADD PASS VARCHAR(25);


UPDATE table_jath_10_marzo
SET USUARIO = 'juan',PASS  = 'juan'
WHERE SalesOrderID = 55539;


SELECT SalesOrderID,USUARIO,PASS FROM [dbo].[table_jath_10_marzo] WHERE  SalesOrderID = 55539;


CREATE OR ALTER PROC SP_acceso_table_jath_10_marzo
@USUARIO VARCHAR(25), @PASS VARCHAR(25)

AS
	IF EXISTS (SELECT * FROM [dbo].[table_jath_10_marzo] WHERE USUARIO=@USUARIO AND PASS=@PASS)
		BEGIN
			UPDATE table_jath_10_marzo
			SET Status = 2
			WHERE USUARIO=@USUARIO;
		END
		
	ELSE
		BEGIN
			PRINT 'NO TIENES PERMISOS SUFICIENTES'
		END
;
GO

EXEC SP_acceso_table_jath_10_marzo jath,jath


SELECT * FROM [dbo].[table_jath_10_marzo] WHERE USUARIO='juan' AND PASS='juan';


EXEC SP_acceso_table_jath_10_marzo juan,juan
