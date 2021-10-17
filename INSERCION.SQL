-- ______________________________________________________________________________________________________________________________________________
-- ESTUDIO DEL TPI;"INSERCION.sql"(COPIPASTEO DEL DOCUMENTO ORIGINAL)
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
use mysql2;-- utilizar esquema mysql2
USE automotriz;-- ejecutar database ,automotriz	
-- ______________________________________________________________________________________________________________________________________________
-- PROVEEDOR ___
INSERT INTO proveedor(Nombre, CUIT,Eliminado)
VALUES
('Proveedor1','10-2030-40',0),
('Proveedor2','10-3040-40',0),
('Proveedor3','10-4050-40',0);
-- UNIDAD___
insert into unidad(Descripcion, Eliminar)
VALUES
('Lts',0),
('Kg',0),
('g',0),
('m2',0);
-- INSUMOS___
insert into insumos(Descripcion, Cantidad, Eliminado, unidad_Id)
VALUES				
('pintura',10,0,1),
('aluminio',500,0,2),
('hierro',100,0,2),
('alfombra',10,0,4);
-- PROVEEDOR_INSUMOS ___
insert into proveedor_insumos(Precio,insumos_Id, proveedor_Id)
VALUES
(100,1, (select min(Id)  from proveedor)),
(200,1, (select min(Id)+1  from proveedor)),
(150,2, (select min(Id)+2  from proveedor));
-- LINEA_MONTAJE ___
insert into linea_montaje(Codigo, Eliminado)
VALUES					
('001A',0),
('002B',0),
('003C',0),
('004D',0);
-- ESTACION ___
insert into estacion(OrdenEstacion, TareaDeterminada,Eliminado, linea_montaje_Id) 
VALUES				
(1,'Ensamblaje',0,1),
(2,'Pintura',0,1),
(3,'Tapizado',0,1),
(1,'Ensamblaje',0,2),
(2,'Pintura',0,2),
(3,'Tapizado',0,2),            
(1,'Ensamblaje',0,3),
(2,'Pintura',0,3),
(3,'Tapizado',0,3);
-- MODELO___
insert into modelo(Nombre, Eliminado, linea_montaje_Id)
VALUES				
('Mustang',0,1),
('Topolino',0,2),
('Countach',0,3);
-- INSUMO_ESTACION ___
insert into insumo_estacion(CantidadConsumida, Eliminado, estacion_Id, insumos_Id)
VALUES					    
(200,0,1,2),
(30,0,2,1),
(20,0,3,4),                            
(250,0,4,3),
(15,0,5,1),
(25,0,6,4),                            
(400,0,7,2),
(45,0,8,1),
(32,0,9,4);
-- ________________________________________________________________________________________________________________________________________
-- SELECCIONES DE PRUEVA
-- ___
select * from estacion e inner join insumo_estacion ine on e.Id = ine.estacion_Id inner join insumos ins on ine.insumos_Id = ins.Id 
 where e.linea_montaje_Id = 1; 
-- ___
select * from insumo_estacion; select * from modelo;
-- ___
select ins.Descripcion, Cantidad, un.Descripcion from insumos ins inner join unidad un on ins.unidad_id = un.Id;
-- ___
select ins.Descripcion, Cantidad, un.Descripcion , Nombre , Precio from insumos ins inner join unidad un on ins.unidad_id = un.Id 
 inner join proveedor_insumos on insumos_Id = ins.Id inner join proveedor p on p.Id = proveedor_Id;