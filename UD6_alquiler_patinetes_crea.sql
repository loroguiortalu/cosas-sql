-- --------------------------------------------------------------------------
-- Unidad 6 DCL - Alquiler patinetes. 
-- Script creación Alquiler patinetes  --------------------------------------
-- --------------------------------------------------------------------------
-- Creamos la base de datos
DROP DATABASE IF EXISTS ud6_alquiler_patinetes;
CREATE DATABASE ud6_alquiler_patinetes;
USE ud6_alquiler_patinetes;
-- --------------------------------------------------------------------------
-- Creamos la tabla patinete
CREATE TABLE patinete (
    codigo INT AUTO_INCREMENT PRIMARY KEY,
    fecha_compra DATE NOT NULL,
    km INT UNSIGNED NOT NULL DEFAULT 0,
    bateria VARCHAR(50)
);
-- --------------------------------------------------------------------------
-- Creamos la tabla cliente
CREATE TABLE cliente (
    DNI CHAR(10) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL
);
-- --------------------------------------------------------------------------
-- Creamos la tabla alquila
CREATE TABLE alquila (
    codigo_patinete INT,
    DNI_cliente CHAR(10),
    fecha DATE,
    km INT UNSIGNED NOT NULL DEFAULT 0,
    minutos INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (codigo_patinete, DNI_cliente, fecha),
    FOREIGN KEY(codigo_patinete) REFERENCES patinete(codigo),
	FOREIGN KEY(DNI_cliente) REFERENCES cliente(DNI)
);
-- --------------------------------------------------------------------------



