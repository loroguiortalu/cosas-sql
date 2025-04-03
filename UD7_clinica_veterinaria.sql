-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------
-- Unidad 7 Programación SQL

-- Creación BD --------------------------------------------------------------
DROP DATABASE IF EXISTS ud7_clinica_veterinaria;
CREATE DATABASE ud7_clinica_veterinaria;
USE ud7_clinica_veterinaria;
-- --------------------------------------------------------------------------
-- Creación tablas
-- CLIENTE
DROP TABLE IF EXISTS cliente;
CREATE TABLE cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    direccion VARCHAR(100),    
    telefono VARCHAR(50),
    email VARCHAR(50) NOT NULL
);
INSERT INTO cliente (nombre, direccion, telefono, email) VALUES ('Pedro García', 'Cuesta 34', '652898887', 'pedrogarcia@gmail.com');
INSERT INTO cliente (nombre, direccion, telefono, email) VALUES ('Luis Llorca', 'Mayor 105', '655898752', 'luisllorca@gmail.com');
INSERT INTO cliente (nombre, direccion, telefono, email) VALUES ('Ana Matute', 'Pedro Lorca 56', '789524574', 'anamatute@gmail.com');
INSERT INTO cliente (nombre, direccion, telefono, email) VALUES ('Amadeo García', 'Sol 56', '658557887', 'amadeogar@hotmail.com');
INSERT INTO cliente (nombre, direccion, telefono, email) VALUES ('Petronila Cuesta', 'Luna 250', '655338752', 'petronilacue@micorreo.com');
INSERT INTO cliente (nombre, direccion, telefono, email) VALUES ('Ana María Sacos', 'Amapola 54', '659524574', 'anasac@arrakis.com');
INSERT INTO cliente (nombre, direccion, telefono, email) VALUES ('Pablo Sánchez', 'Aceituna 34', '629624574', 'pablosan@ionos.com');
INSERT INTO cliente (nombre, direccion, telefono, email) VALUES ('Jesús García', 'Lunero 99', '658136667', 'jesusgar@hotmail.com');
INSERT INTO cliente (nombre, direccion, telefono, email) VALUES ('Petra Santos', 'Estrellas 124', '855311752', 'petrasan@micorreo.com');
INSERT INTO cliente (nombre, direccion, telefono, email) VALUES ('Azucena Grande', 'Margaritas 99', '759522574', 'azucenagran@arrakis.com');
-- --------------------------------------------------------------------------
-- VETERINARIO
DROP TABLE IF EXISTS veterinario;
CREATE TABLE veterinario (
	id INT AUTO_INCREMENT PRIMARY KEY,
    DNI VARCHAR(10),
    nombre VARCHAR(50) NOT NULL,
    telefono VARCHAR(50),
    autonomo TINYINT,
    fecha_incorporacion DATE,
    CONSTRAINT uk_DNI UNIQUE (DNI)
);
INSERT INTO veterinario (DNI, nombre, telefono, autonomo, fecha_incorporacion) VALUES('00000A', 'Luis Sánchez', '655899581', 0, '2025-01-01');
INSERT INTO veterinario (DNI, nombre, telefono, autonomo, fecha_incorporacion) VALUES('11111B', 'Mario Casas', '623897521', 0, '2025-01-10');
INSERT INTO veterinario (DNI, nombre, telefono, autonomo, fecha_incorporacion) VALUES('22222C', 'Rosa San Pedro', NULL, 1, '2025-01-20');
INSERT INTO veterinario (DNI, nombre, telefono, autonomo, fecha_incorporacion) VALUES('33333D', 'Alfredo Puentes', '755399581', 0, '2025-02-01');
INSERT INTO veterinario (DNI, nombre, telefono, autonomo, fecha_incorporacion) VALUES('44444E', 'Mario Casas', '623897521', 0, '2025-02-01');
INSERT INTO veterinario (DNI, nombre, telefono, autonomo, fecha_incorporacion) VALUES('55555F', 'Rosa Millán', NULL, 1, '2024-01-23');
INSERT INTO veterinario (DNI, nombre, telefono, autonomo, fecha_incorporacion) VALUES('66666G', 'Rosa San Pedro', NULL, 1, '2024-01-24');
INSERT INTO veterinario (DNI, nombre, telefono, autonomo, fecha_incorporacion) VALUES('77777H', 'Marcelo Fan', '655329581', 1, '2024-02-05');
INSERT INTO veterinario (DNI, nombre, telefono, autonomo, fecha_incorporacion) VALUES('88888I', 'Gustavo De Básica', '623897111', 0, '2024-02-04');
INSERT INTO veterinario (DNI, nombre, telefono, autonomo, fecha_incorporacion) VALUES('99999J', 'Josefina Altos', NULL, 1, '2024-01-06');
-- --------------------------------------------------------------------------
-- SALA
DROP TABLE IF EXISTS sala;
CREATE TABLE sala (
    numero INT PRIMARY KEY,
    descripcion VARCHAR(100)
);
INSERT INTO sala VALUES (1, 'Sala 1');
INSERT INTO sala VALUES (2, 'Sala 2');
INSERT INTO sala VALUES (3, 'Sala 3');
INSERT INTO sala VALUES (4, 'Sala 4');
-- --------------------------------------------------------------------------
-- MASCOTA
DROP TABLE IF EXISTS mascota;
CREATE TABLE mascota (
	id_cliente INT,	
    numero INT,
    nombre VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    PRIMARY KEY(id_cliente, numero),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id)
);
INSERT INTO mascota (id_cliente, numero, nombre, fecha_nacimiento) VALUES (1, 1, 'Toby', '2020-01-01');
INSERT INTO mascota (id_cliente, numero, nombre, fecha_nacimiento) VALUES (1, 2, 'Luna', '2021-01-10');
INSERT INTO mascota (id_cliente, numero, nombre, fecha_nacimiento) VALUES (2, 1, 'Lano', '2021-04-01');
INSERT INTO mascota (id_cliente, numero, nombre, fecha_nacimiento) VALUES (3, 1, 'Pancho', '2019-03-05');
INSERT INTO mascota (id_cliente, numero, nombre, fecha_nacimiento) VALUES (3, 2, 'Como tu', '2019-03-05');
INSERT INTO mascota (id_cliente, numero, nombre, fecha_nacimiento) VALUES (3, 3, 'Niki', '2020-05-01');
INSERT INTO mascota (id_cliente, numero, nombre, fecha_nacimiento) VALUES (4, 1, 'Pedrito', '2021-04-01');
INSERT INTO mascota (id_cliente, numero, nombre, fecha_nacimiento) VALUES (5, 1, 'Sole', '2019-03-01');
INSERT INTO mascota (id_cliente, numero, nombre, fecha_nacimiento) VALUES (6, 1, 'Calo', '2019-02-05');
INSERT INTO mascota (id_cliente, numero, nombre, fecha_nacimiento) VALUES (7, 1, 'Repe', '2020-02-01');
INSERT INTO mascota (id_cliente, numero, nombre, fecha_nacimiento) VALUES (8, 1, 'Niki', '2019-03-11');
INSERT INTO mascota (id_cliente, numero, nombre, fecha_nacimiento) VALUES (9, 1, 'Pancho', '2020-02-05');
INSERT INTO mascota (id_cliente, numero, nombre, fecha_nacimiento) VALUES (10, 1, 'Luna', '2021-02-01');
-- --------------------------------------------------------------------------
-- ATIENDE
DROP TABLE IF EXISTS atiende;
CREATE TABLE atiende (
    id_veterinario INT,
    numero_sala INT,
    id_cliente INT,
    numero_mascota INT,    
    fecha_cita DATE NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    PRIMARY KEY(id_veterinario, numero_sala, id_cliente, numero_mascota, fecha_cita),
    FOREIGN KEY (id_veterinario) REFERENCES veterinario(id),
    FOREIGN KEY (numero_sala) REFERENCES sala(numero),
    FOREIGN KEY (id_cliente, numero_mascota) REFERENCES mascota(id_cliente, numero)
);
INSERT INTO atiende VALUES (1, 1, 1, 1, '2025-12-01', 40);
INSERT INTO atiende VALUES (1, 1, 1, 1, '2025-12-15', 40);
INSERT INTO atiende VALUES (1, 1, 1, 1, '2025-02-01', 35);
INSERT INTO atiende VALUES (2, 2, 1, 1, '2025-02-02', 40);
INSERT INTO atiende VALUES (3, 3, 2, 1, '2025-02-03', 40);
INSERT INTO atiende VALUES (4, 4, 8, 1, '2025-02-06', 35);
INSERT INTO atiende VALUES (5, 4, 9, 1, '2025-02-06', 100);
INSERT INTO atiende VALUES (6, 3, 7, 1, '2025-02-06', 100);
INSERT INTO atiende VALUES (7, 2, 10, 1, '2025-02-07', 50);
INSERT INTO atiende VALUES (7, 2, 9, 1, '2025-02-07', 75);
INSERT INTO atiende VALUES (8, 1, 7, 1, '2025-03-06', 50);
INSERT INTO atiende VALUES (8, 2, 7, 1, '2025-03-06', 35);

-- Comprobamos
SELECT * FROM
	(SELECT COUNT(*) AS 'filas en cliente' FROM cliente) cliente, 
    (SELECT COUNT(*) AS 'filas en veterinario' FROM veterinario) veterinario,
    (SELECT COUNT(*) AS 'filas en sala' FROM sala) sala,
    (SELECT COUNT(*) AS 'filas en mascota' FROM mascota) mascota,
	(SELECT COUNT(*) AS 'filas en atiende' FROM atiende) atiende;
-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------




