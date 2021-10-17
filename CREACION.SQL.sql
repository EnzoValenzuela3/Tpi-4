-- ______________________________________________________________________________________________________________________________________________
-- ESTUDIO DEL TPI;"CREACION.sql"
-- MySQL (orden de scripts sql)
-- 1) CREACION.SQL; ES EL SCRIPT QUE CONFORMA LA CREACION DE LAS DISTINTAS TABLAS Y SU RELACION
-- 2) INSERCION.SQL; ES SL SCRIPT DE INSERCION DE LOS VALORES A LA TABLA
-- 3) PROCED_ALTA_BAJA_MOD.SQL; ES EL SCRIPT DE PROCEDIMIENTOS DE ALTA BAJA Y MODIFICACION DE REGISTROS
-- 4) PROCED_TRA_NEGOCIO.SQL; ES EL SCRIPT DE TRABAJOS DE NEGOCIO
-- ESTUDIO DE LOS SCRIPT PRESENTADOS EN EL TRABAJO PRACTICO INTEGRADOR
-- ENZO MANUEL VALENZUELA, 2021
-- ______________________________________________________________________________________________________________________________________________
--  NOMBRE DEL ESQUEMA DE BASE DE DATOS; automotriz
-- ______________________________________________________________________________________________________________________________________________
create schema mysql2;-- ?
use mysql2;-- ?
CREATE DATABASE automotriz;-- crear base de datos
USE automotriz;-- ejecutar
-- ______________________________________________________________________________________________________________________________________________
-- CREACION DE TABLAS___
CREATE TABLE concesionaria(
id INT(11) NOT NULL AUTO_INCREMENT,
nombre VARCHAR(45)NOT NULL,
eliminado BIT(1),
fechaeliminado DATETIME,
PRIMARY KEY(id));
-- ---
CREATE TABLE pedido(
id INT(11)NOT NULL,
fechadeventa DATETIME,
fechadentrega DATETIME,
eliminado BIT(1),
fechaeliminado DATETIME,
concesionariaid INT(11)NOT NULL,
PRIMARY KEY(id),
FOREIGN KEY(concesionariaid) REFERENCES concesionaria(id));
-- ---
CREATE TABLE linea_montaje(
id INT(11)NOT NULL,
codigo VARCHAR(45),
eliminado BIT(1),
fechaeliminado DATETIME,
PRIMARY KEY(id));
-- ---
CREATE TABLE modelo(
id INT(11)NOT NULL,
nombre VARCHAR(45),
eliminado BIT(1),
fechaeliminado DATETIME,
lineamontajeid INT(11)NOT NULL,
PRIMARY KEY(id),
FOREIGN KEY(linramontajeid)REFERENCES linea_montaje(id));
-- ---
CREATE TABLE pedido_detalle(
id INT(11)NOT NULL,
modeloid INT(11) NOT NULL,
eliminado BIT(1),
fechaeliminado DATETIME,
pedidoid INT(11)NOT NULL,
modeloid1 INT(11)NOT NULL,
PRIMARY KEY(id,modeloid),
FOREIGN KEY(pedidoid)REFERENCES pedido(id),
FOREIGN KEY(modeloid)REFERENCES modelo(id),
FOREIGN KEY(modeloid1)REFERENCES modelo(id));
-- ---
CREATE TABLE automovil(
id INT(11)NOT NULL,
chasis VARCHAR(45),
fechainicio DATETIME,
fechafin DATETIME,
eliminado BIT(1),
fechaeliminado DATETIME,
pedidodetalleid INT(11)NOT NULL,
pedidodetallemodeloid INT(11)NOT NULL,
PRIMARY KEY(id),
FOREIGN KEY(pedidodetalleid,pedidodetallemodeloid)REFERENCES pedido_detalle(id,modeloid));
-- ---
CREATE TABLE estacion(
id INT(11)NOT NULL AUTO_INCREMENT,
ordenestacion INT(11),
tareaespecifica VARCHAR(45),
eliminado BIT(1),
fechaeliminado DATETIME,
lineamontajeid INT(11),
PRIMARY KEY (id),
FOREIGN KEY (lineamontajeid)REFERENCES linea_montaje(id));
-- ---
CREATE TABLE automovil_estacion(
fechaingresoestacion DATETIME,
fechaegresoestacion DATETIME,
eliminado BIT(1),
fechaeliminado DATETIME,
estacionid INT(11),
automovilid INT(11),
FOREIGN KEY(estacionid)REFERENCES estacion(id),
FOREIGN KEY(automovilid)REFERENCES automovil(id));
-- ---
CREATE TABLE unidad(
id INT(11)NOT NULL,
descripcion VARCHAR(45),
eliminado BIT(1),
fechaeliminado DATETIME,
PRIMARY KEY(id));
-- ---
CREATE TABLE insumos(
id INT(11)NOT NULL,
descripcion VARCHAR(45),
cantidad INT,
eliminado BIT(1),
fechaeliminado DATETIME,
unidadid INT(11)NOT NULL,
PRIMARY KEY(id),
FOREIGN KEY(unidadid)REFERENCES unidad(id));
-- ---
CREATE TABLE insumo_estacion(
cantidadconsumida INT(11),
unidadconsumida INT(11),
eliminado BIT(1),
fechaeliminado DATETIME,
estacionid INT(11),
insumosid INT(11),
PRIMARY KEY(estacionid,insumosid),
FOREIGN KEY(estacionid)REFERENCES estacion(id),
FOREIGN KEY(insumosid)REFERENCES insumos(id));
-- ---
CREATE TABLE proveedor(
id INT(11)NOT NULL,
nombre VARCHAR(45),
cuit VARCHAR(45),
eliminado BIT(1),
fechaeliminado DATETIME,
PRIMARY KEY(id));
-- ---
CREATE TABLE proveedor_insumos(
precio INT(11),
eliminado BIT(1),
fechaeliminado DATETIME,
insumosid INT(11),
proveedorid INT(11),
FOREIGN KEY(insumosid)REFERENCES insumos(id),
FOREIGN KEY(proveedorid)REFERENCES proveedor(id));
-- -------------------------------------------------------------------------------------------------------------------------------------------