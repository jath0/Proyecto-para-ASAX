# Proyecto BBDD Bootcamp

Este repositorio ha sido creado para complementar un proyecto para la asignatura de Gestión de bases de datos del 2º año de ASIR, consta de varias partes:

* Instalación y conexión de Sql server en diferentes SO
* Instalación y conexión Oracle Sql con SQL server.
* Uso de Oracle Tools
* Modelado de una base de datos
* Aplicación de conocimientos obtenidos en 1ª y 2ª evaluación a nuestra base de datos.
-----

## Índice

* [Modelado](#modelado)
* [Scripts](#scripts)
* [Errores conocidos](#errores-conocidos)

-----

## BASE DE DATOS TECNOBOOTCAMP

Es una base de datos que incluye las tablas básicas, en mi opinión, para la gestión de una web que ofrezca cursos de informática. Tiene un apartado referente a los estudiantes, profesores, pagos, cursos ofrecidos y una parte también dedicada a los ejercicios.

## Modelado
El [modelado](https://github.com/jath0/Proyecto-para-ASAX/tree/master/proyecto%20ASAX/Modelado) se ha llevado ha hecho con el programa *SQL DATAMODELER*.
El archivo [TecnoBootcamp_script.ddl](https://github.com/jath0/Proyecto-para-ASAX/blob/master/proyecto%20ASAX/bootcamp_script.ddl) es el script exportado del programa SQL Datamodeler y la carpeta TecnoBootcamp es el proyecto de Datamodeler.

![Modelado lógico: ](https://github.com/jath0/Proyecto-para-ASAX/blob/master/proyecto%20ASAX/Logical.png)

## Scripts
  * [Script de repaso primer año](https://github.com/jath0/Proyecto-para-ASAX/blob/master/Scripts%20SQL/Script_repaso_jathtestdb.sql)
  * [Filestream](https://github.com/jath0/Proyecto-para-ASAX/blob/master/Scripts%20SQL/script_filestream_modificado.sql)
  * [Particiones](https://github.com/jath0/Proyecto-para-ASAX/blob/master/Scripts%20SQL/Script_particiones_modificado.sql)
  * [Tablas Temporales](https://github.com/jath0/Proyecto-para-ASAX/blob/master/Scripts%20SQL/Tablas%20temporales%20del%20sistema.sql)
  * [Tablas en Memoria](https://github.com/jath0/Proyecto-para-ASAX/blob/master/Scripts%20SQL/Tablas%20en%20memoria.sql)

## Errores conocidos
  * En la tabla eval falta compartir la key del Alumno
  * Entre la tabla módulo y bootcamp, falta una tabla intermedia
