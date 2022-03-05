-- Generado por Oracle SQL Developer Data Modeler 21.2.0.183.1957
--   en:        2022-03-05 13:49:52 CET
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE bootcamp (
    id_bootcamp  VARCHAR2(2) NOT NULL,
    nombre       VARCHAR2(64) NOT NULL,
    duración     VARCHAR2(64) NOT NULL,
    horario      VARCHAR2(64) NOT NULL,
    fecha_inicio DATE NOT NULL,
    descripcion  VARCHAR2(300) NOT NULL,
    tipo         VARCHAR2(12) NOT NULL
);

ALTER TABLE bootcamp ADD CONSTRAINT bootcamp_pk PRIMARY KEY ( id_bootcamp );

CREATE TABLE bootcamp_campus (
    bootcamp_id_bootcamp VARCHAR2(2) NOT NULL,
    campus_id_campus     VARCHAR2(2) NOT NULL
);

CREATE TABLE bootcamp_estudiante (
    bootcamp_id_bootcamp     VARCHAR2(2) NOT NULL,
    estudiante_id_estudiante VARCHAR2(16) NOT NULL
);

CREATE TABLE campus (
    id_campus VARCHAR2(2) NOT NULL,
    nombre    VARCHAR2(64) NOT NULL,
    ciudad    VARCHAR2(64) NOT NULL,
    direccion VARCHAR2(128) NOT NULL
);

ALTER TABLE campus ADD CONSTRAINT campus_pk PRIMARY KEY ( id_campus );

CREATE TABLE estudiante (
    id_estudiante    VARCHAR2(16) NOT NULL,
    nombre           VARCHAR2(32) NOT NULL,
    apellidos        VARCHAR2(64) NOT NULL,
    genero           VARCHAR2(32) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    telefono         INTEGER NOT NULL,
    email            VARCHAR2(128) NOT NULL,
    otros_detalles   VARCHAR2(300) NOT NULL
);

ALTER TABLE estudiante ADD CONSTRAINT estudiante_pk PRIMARY KEY ( id_estudiante );

CREATE TABLE evaluable (
    id_eval          VARCHAR2(4) NOT NULL,
    enunciado        VARCHAR2(1200) NOT NULL,
    respuesta        VARCHAR2(1200) NOT NULL,
    comentario       VARCHAR2(1200) NOT NULL,
    estado           VARCHAR2(32) NOT NULL,
    nota             VARCHAR2(2) NOT NULL,
    modulo_id_módulo VARCHAR2(4) NOT NULL
);

ALTER TABLE evaluable ADD CONSTRAINT evaluable_pk PRIMARY KEY ( id_eval );

CREATE TABLE matriculado (
    id                       VARCHAR2(2),
    numeroplaza              VARCHAR2(3),
    añomatricula             VARCHAR2(4),
    bootcamp_id_bootcamp     VARCHAR2(2) NOT NULL,
    estudiante_id_estudiante VARCHAR2(16) NOT NULL,
    pago_id_pago             VARCHAR2(256) NOT NULL
);

CREATE TABLE metodo_pago (
    id_metodopago            VARCHAR2(256) NOT NULL,
    estudiante_id_estudiante VARCHAR2(16) NOT NULL,
    tarjeta_id_tarjeta       VARCHAR2(256) NOT NULL,
    paypal_login_paypal      VARCHAR2(256) NOT NULL
);

ALTER TABLE metodo_pago ADD CONSTRAINT metodo_pago_pk PRIMARY KEY ( id_metodopago );

CREATE TABLE modulo (
    id_módulo            VARCHAR2(4) NOT NULL,
    nombre               VARCHAR2(32) NOT NULL,
    descripcion          VARCHAR2(300) NOT NULL,
    estado               VARCHAR2(32) NOT NULL,
    bootcamp_id_bootcamp VARCHAR2(2) NOT NULL
);

ALTER TABLE modulo ADD CONSTRAINT modulo_pk PRIMARY KEY ( id_módulo );

CREATE TABLE no_evaluable (
    id_noeval        VARCHAR2(4) NOT NULL,
    enunciado        VARCHAR2(1200) NOT NULL,
    respuesta        VARCHAR2(1200) NOT NULL,
    comentario       VARCHAR2(1200) NOT NULL,
    estado           VARCHAR2(32) NOT NULL,
    modulo_id_módulo VARCHAR2(4) NOT NULL
);

ALTER TABLE no_evaluable ADD CONSTRAINT no_evaluable_pk PRIMARY KEY ( id_noeval );

CREATE TABLE pago (
    id_pago                  VARCHAR2(256) NOT NULL,
    estado                   VARCHAR2(10) NOT NULL,
    fecha__pago              DATE NOT NULL,
    precio_bootcamp          VARCHAR2(6) NOT NULL,
    otros_detalles           VARCHAR2(300) NOT NULL,
    moneda                   VARCHAR2(16) NOT NULL,
    estudiante_id_estudiante VARCHAR2(16) NOT NULL,
    bootcamp_id_bootcamp     VARCHAR2(2) NOT NULL
);

ALTER TABLE pago ADD CONSTRAINT pago_pk PRIMARY KEY ( id_pago );

CREATE TABLE paypal (
    login_paypal VARCHAR2(256) NOT NULL
);

ALTER TABLE paypal ADD CONSTRAINT paypal_pk PRIMARY KEY ( login_paypal );

CREATE TABLE profesor (
    id_profe             VARCHAR2(4) NOT NULL,
    nombre               VARCHAR2(32) NOT NULL,
    apellidos            VARCHAR2(64) NOT NULL,
    email                VARCHAR2(128) NOT NULL,
    otros_detalles       VARCHAR2(300) NOT NULL,
    bootcamp_id_bootcamp VARCHAR2(2) NOT NULL
);

ALTER TABLE profesor ADD CONSTRAINT profesor_pk PRIMARY KEY ( id_profe );

CREATE TABLE tarjeta (
    id_tarjeta   VARCHAR2(256) NOT NULL,
    numero       INTEGER NOT NULL,
    cvv          NUMBER NOT NULL,
    titular      VARCHAR2(128) NOT NULL,
    banco        VARCHAR2(128) NOT NULL,
    fecha_expira DATE NOT NULL
);

ALTER TABLE tarjeta ADD CONSTRAINT tarjeta_pk PRIMARY KEY ( id_tarjeta );

ALTER TABLE bootcamp_campus
    ADD CONSTRAINT bootcamp_campus_bootcamp_fk FOREIGN KEY ( bootcamp_id_bootcamp )
        REFERENCES bootcamp ( id_bootcamp );

ALTER TABLE bootcamp_campus
    ADD CONSTRAINT bootcamp_campus_campus_fk FOREIGN KEY ( campus_id_campus )
        REFERENCES campus ( id_campus );

ALTER TABLE bootcamp_estudiante
    ADD CONSTRAINT bootcamp_estudiante_bootc_fk FOREIGN KEY ( bootcamp_id_bootcamp )
        REFERENCES bootcamp ( id_bootcamp );

ALTER TABLE bootcamp_estudiante
    ADD CONSTRAINT bootcamp_estudiante_estud_fk FOREIGN KEY ( estudiante_id_estudiante )
        REFERENCES estudiante ( id_estudiante );

ALTER TABLE evaluable
    ADD CONSTRAINT evaluable_modulo_fk FOREIGN KEY ( modulo_id_módulo )
        REFERENCES modulo ( id_módulo );

ALTER TABLE matriculado
    ADD CONSTRAINT matriculado_bootcamp_fk FOREIGN KEY ( bootcamp_id_bootcamp )
        REFERENCES bootcamp ( id_bootcamp );

ALTER TABLE matriculado
    ADD CONSTRAINT matriculado_estudiante_fk FOREIGN KEY ( estudiante_id_estudiante )
        REFERENCES estudiante ( id_estudiante );

ALTER TABLE matriculado
    ADD CONSTRAINT matriculado_pago_fk FOREIGN KEY ( pago_id_pago )
        REFERENCES pago ( id_pago );

ALTER TABLE metodo_pago
    ADD CONSTRAINT metodo_pago_estudiante_fk FOREIGN KEY ( estudiante_id_estudiante )
        REFERENCES estudiante ( id_estudiante );

ALTER TABLE metodo_pago
    ADD CONSTRAINT metodo_pago_paypal_fk FOREIGN KEY ( paypal_login_paypal )
        REFERENCES paypal ( login_paypal );

ALTER TABLE metodo_pago
    ADD CONSTRAINT metodo_pago_tarjeta_fk FOREIGN KEY ( tarjeta_id_tarjeta )
        REFERENCES tarjeta ( id_tarjeta );

ALTER TABLE modulo
    ADD CONSTRAINT modulo_bootcamp_fk FOREIGN KEY ( bootcamp_id_bootcamp )
        REFERENCES bootcamp ( id_bootcamp );

ALTER TABLE no_evaluable
    ADD CONSTRAINT no_evaluable_modulo_fk FOREIGN KEY ( modulo_id_módulo )
        REFERENCES modulo ( id_módulo );

ALTER TABLE pago
    ADD CONSTRAINT pago_bootcamp_fk FOREIGN KEY ( bootcamp_id_bootcamp )
        REFERENCES bootcamp ( id_bootcamp );

ALTER TABLE pago
    ADD CONSTRAINT pago_estudiante_fk FOREIGN KEY ( estudiante_id_estudiante )
        REFERENCES estudiante ( id_estudiante );

ALTER TABLE profesor
    ADD CONSTRAINT profesor_bootcamp_fk FOREIGN KEY ( bootcamp_id_bootcamp )
        REFERENCES bootcamp ( id_bootcamp );



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            14
-- CREATE INDEX                             0
-- ALTER TABLE                             27
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
