-- -----------------------------------------------------
-- TPI;ESTUDIO DE SCRIPT DE "CREACION DE TABLAS"(copipasteo)
-- -----------------------------------------------------
CREATE SCHEMA `mydb` ;
USE `mydb` ;
-- -----------------------------------------------------
-- Table `mydb`.`consecionaria`
-- -----------------------------------------------------
CREATE TABLE `mydb`.`consecionaria` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NULL DEFAULT NULL,
  `Eliminado` BIT(1) NULL DEFAULT NULL,
  `FechaEliminado` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`Id`));
-- -----------------------------------------------------
-- Table `mydb`.`pedido`
-- -----------------------------------------------------
CREATE TABLE `mydb`.`pedido` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `FechaDeVenta` DATETIME NULL DEFAULT NULL,
  `FechaDeEntrega` DATETIME NULL DEFAULT NULL,
  `Eliminado` BIT(1) NULL DEFAULT NULL,
  `FechaEliminado` DATETIME NULL DEFAULT NULL,
  `consecionaria_Id` INT(11) NOT NULL,
  PRIMARY KEY (`Id`),
    FOREIGN KEY (`consecionaria_Id`)
    REFERENCES `mydb`.`consecionaria` (`Id`));
-- -----------------------------------------------------
-- Table `mydb`.`linea_montaje`
-- -----------------------------------------------------
CREATE TABLE `mydb`.`linea_montaje` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `Codigo` VARCHAR(45) NULL DEFAULT NULL,
  `Eliminado` BIT(1) NULL DEFAULT NULL,
  `FechaEliminado` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`Id`));
-- -----------------------------------------------------
-- Table `mydb`.`modelo`
-- -----------------------------------------------------
CREATE TABLE `mydb`.`modelo` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NULL DEFAULT NULL,
  `Eliminado` BIT(1) NULL DEFAULT NULL,
  `FechaEliminado` DATETIME NULL DEFAULT NULL,
  `linea_montaje_Id` INT(11) NOT NULL,
  PRIMARY KEY (`Id`),
    FOREIGN KEY (`linea_montaje_Id`)
    REFERENCES `mydb`.`linea_montaje` (`Id`));
-- -----------------------------------------------------
-- Table `mydb`.`pedido_detalle`
-- -----------------------------------------------------
CREATE TABLE `mydb`.`pedido_detalle` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `modelo_Id` INT(11) NOT NULL,
  `Eliminado` BIT(1) NULL DEFAULT NULL,
  `FechaEliminado` DATETIME NULL DEFAULT NULL,
  `pedido_Id` INT(11) NOT NULL,
  `modelo_Id1` INT(11) NOT NULL,
  `Cantidad_modelo` INT(11) NOT NULL,
  PRIMARY KEY (`Id`, `modelo_Id`),
    FOREIGN KEY (`pedido_Id`)
    REFERENCES `mydb`.`pedido` (`Id`),
    FOREIGN KEY (`modelo_Id1`)
    REFERENCES `mydb`.`modelo` (`Id`));
-- -----------------------------------------------------
-- Table `mydb`.`automovil`
-- -----------------------------------------------------
CREATE TABLE `mydb`.`automovil` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `Chasis` VARCHAR(45) NULL DEFAULT NULL,
  `FechaInicio` DATETIME NULL DEFAULT NULL,
  `FechaFin` DATETIME NULL DEFAULT NULL,
  `Eliminado` BIT(1) NULL DEFAULT NULL,
  `FechaEliminado` DATETIME NULL DEFAULT NULL,
  `pedido_detalle_Id` INT(11) NOT NULL,
  `pedido_detalle_modelo_Id` INT(11) NOT NULL,
  PRIMARY KEY (`Id`),
    FOREIGN KEY (`pedido_detalle_Id` , `pedido_detalle_modelo_Id`)
    REFERENCES `mydb`.`pedido_detalle` (`Id` , `modelo_Id`));
-- -----------------------------------------------------
-- Table `mydb`.`estacion`
-- -----------------------------------------------------
CREATE TABLE `mydb`.`estacion` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `OrdenEstacion` INT(11) NULL DEFAULT NULL,
  `TareaDeterminada` VARCHAR(45) NULL DEFAULT NULL,
  `Eliminado` BIT(1) NULL DEFAULT NULL,
  `FechaEliminado` DATETIME NULL DEFAULT NULL,
  `linea_montaje_Id` INT(11) NOT NULL,
  PRIMARY KEY (`Id`),
    FOREIGN KEY (`linea_montaje_Id`)
    REFERENCES `mydb`.`linea_montaje` (`Id`));
-- -----------------------------------------------------
-- Table `mydb`.`automovil_estacion`
-- -----------------------------------------------------
CREATE TABLE `mydb`.`automovil_estacion` (
  `FechaIngresoEstacion` DATETIME NULL DEFAULT NULL,
  `FechaEgresoEstacion` DATETIME NULL DEFAULT NULL,
  `Eliminado` BIT(1) NULL DEFAULT NULL,
  `FechaEliminado` DATETIME NULL DEFAULT NULL,
  `estacion_Id` INT(11) NOT NULL,
  `automovil_Id` INT(11) NOT NULL,
    FOREIGN KEY (`estacion_Id`)
    REFERENCES `mydb`.`estacion` (`Id`),
    FOREIGN KEY (`automovil_Id`)
    REFERENCES `mydb`.`automovil` (`Id`));
-- -----------------------------------------------------
-- Table `mydb`.`unidad`
-- -----------------------------------------------------
CREATE TABLE `mydb`.`unidad` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `Descripcion` VARCHAR(45) NULL DEFAULT NULL,
  `Eliminar` BIT(1) NULL DEFAULT NULL,
  `FechaEliminado` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`Id`));
-- -----------------------------------------------------
-- Table `mydb`.`insumos`
-- -----------------------------------------------------
CREATE TABLE `mydb`.`insumos` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `Descripcion` VARCHAR(45) NULL DEFAULT NULL,
  `Cantidad` INT(11) NULL DEFAULT NULL,
  `Eliminado` BIT(1) NULL DEFAULT NULL,
  `FechaEliminado` VARCHAR(45) NULL DEFAULT NULL,
  `unidad_Id` INT(11) NOT NULL,
  PRIMARY KEY (`Id`),
    FOREIGN KEY (`unidad_Id`)
    REFERENCES `mydb`.`unidad` (`Id`));
-- -----------------------------------------------------
-- Table `mydb`.`insumo_estacion`
-- -----------------------------------------------------
CREATE TABLE `mydb`.`insumo_estacion` (
  `CantidadConsumida` INT(11) NULL DEFAULT NULL,
  `UnidadConsumida` INT(11) NULL DEFAULT NULL,
  `Eliminado` BIT(1) NULL DEFAULT NULL,
  `FechaEliminado` DATETIME NULL DEFAULT NULL,
  `estacion_Id` INT(11) NOT NULL,
  `insumos_Id` INT(11) NOT NULL,
  PRIMARY KEY (`insumos_Id`, `estacion_Id`),
    FOREIGN KEY (`estacion_Id`)
    REFERENCES `mydb`.`estacion` (`Id`),
    FOREIGN KEY (`insumos_Id`)
    REFERENCES `mydb`.`insumos` (`Id`));
-- -----------------------------------------------------
-- Table `mydb`.`proveedor`
-- -----------------------------------------------------
CREATE TABLE `mydb`.`proveedor` (
  `Id` INT(11) NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NULL DEFAULT NULL,
  `CUIT` VARCHAR(45) NULL DEFAULT NULL,
  `Eliminado` BIT(1) NULL DEFAULT NULL,
  `FechaEliminado` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`Id`));
-- -----------------------------------------------------
-- Table `mydb`.`proveedor_insumos`
-- -----------------------------------------------------
CREATE TABLE `mydb`.`proveedor_insumos` (
  `Precio` INT(11) NULL DEFAULT NULL,
  `Eliminado` BIT(1) NULL DEFAULT NULL,
  `FechaEliminado` DATETIME NULL DEFAULT NULL,
  `insumos_Id` INT(11) NOT NULL,
  `proveedor_Id` INT(11) NOT NULL,
    FOREIGN KEY (`insumos_Id`)
    REFERENCES `mydb`.`insumos` (`Id`),
    FOREIGN KEY (`proveedor_Id`)
    REFERENCES `mydb`.`proveedor` (`Id`));
-- -----------------------------------------------------