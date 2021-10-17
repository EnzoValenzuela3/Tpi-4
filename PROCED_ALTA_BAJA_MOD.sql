-- ______________________________________________________________________________________________________________________________________________
-- ESTUDIO DEL TPI;"PROCED_ALTA_BAJA_MOD.sql"(revision de los sql)
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
use mysql2;-- usar esquema mysql2
USE automotriz;-- ejecutar database automotriz
-- ______________________________________________________________________________________________________________________________________________
-- ABM DE NEGOCIO________________________________________________________
CREATE PROCEDURE altaVehiculo(IN modeloId INT, IN PedidoDetalleId INT)
BEGIN
DECLARE IdAuto INT;
DECLARE ChasisParam VARCHAR(45);
DECLARE FechaInicio datetime;
SELECT LEFT(MD5(RAND()), 8) into ChasisParam;

START TRANSACTION;
Insert INTO automovil(Eliminado, pedido_detalle_Id, pedido_detalle_modelo_Id)
VALUES	(0, PedidoDetalleId, modeloId);
SELECT CONCAT(LAST_INSERT_ID(),'-', ChasisParam) into ChasisParam;
UPDATE automovil a SET Chasis = ChasisParam where a.Id = last_insert_id();
COMMIT;
END;
-- ___
CREATE PROCEDURE creacion_automoviles(IN ParamIdDetalle INT)
BEGIN

DECLARE idModeloParametro INT;
DECLARE nCantidadDetalle INT;
DECLARE finished INT DEFAULT 0;
DECLARE nInsertados INT;

DECLARE curDetallePedido CURSOR FOR 
 SELECT modelo_Id, Cantidad_modelo 
 FROM pedido_detalle
 WHERE pedido_detalle.Id = ParamIdDetalle;
    
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'  SET finished = 1;  
DECLARE CONTINUE HANDLER FOR SQLSTATE '23000'  SET finished = 1;  

OPEN curDetallePedido;
FETCH curDetallePedido INTO idModeloParametro, nCantidadDetalle;

SET nInsertados = 0;

WHILE nInsertados < nCantidadDetalle DO
 call altaVehiculo(idModeloParametro, ParamIdDetalle);
 SET nInsertados = nInsertados +1;
END WHILE;

CLOSE curDetallePedido;
END;
-- ___
CREATE PROCEDURE creacion_Automoviles_de_Pedido(IN ParamIdPedido INT)
BEGIN

DECLARE idDetallePedido INT;
DECLARE finished INT default 0;
DECLARE curDetallePedido CURSOR FOR
select Id FROM pedido_detalle WHERE pedido_Id = ParamIdPedido;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
OPEN curDetallePedido;
getModelo: LOOP
FETCH curDetallePedido INTO idDetallePedido;

IF finished = 1 THEN 
 LEAVE getModelo;
END IF;
call creacion_automoviles(idDetallePedido);

END LOOP getModelo;

CLOSE curDetallePedido;

END;
-- ______________________________________________________________________
-- ABM DE ALTA, BAJA, Y MODIFICACION
-- CONCESIONARIO_______________________________________________________________
CREATE PROCEDURE alta_consecionario(IN nombre VARCHAR(45))
BEGIN
if consecionariosRepetidos(nombre) = 0 THEN
	insert into consecionaria(Nombre, Eliminado) VALUES
    (nombre, 0);
end if;
END;
-- ___
CREATE PROCEDURE delete_consecionario(IN Id_Cons INT)
BEGIN

update consecionaria SET
Eliminado = 1,
FechaEliminado = now()
where Id = Id_Cons;

END;
-- ___
CREATE PROCEDURE update_consecionario(IN id INT ,IN nombreNuevo VARCHAR(45))
BEGIN
if consecionariosRepetidos(nombreNuevo) = 0 THEN
	update consecionaria c
    set Nombre = nombreNuevo where c.Id = id;
END IF;
END;
-- ___
CREATE PROCEDURE altaVehiculo(IN modeloId INT, IN PedidoDetalleId INT)
BEGIN

DECLARE ChasisParam VARCHAR(45);
DECLARE FechaInicio datetime;

SELECT LEFT(MD5(RAND()), 8) into ChasisParam;

Insert INTO automovil(Chasis, Eliminado, pedido_detalle_Id, pedido_detalle_modelo_Id)
VALUES	(ChasisParam,0, PedidoDetalleId, modeloId);

END;
-- __
CREATE PROCEDURE delete_automovil(IN Id_Automovil INT)
BEGIN

update automovil SET
Eliminado = 1,
FechaEliminado = now()
where Id = Id_Automovil;

END;
-- ___
CREATE PROCEDURE alta_pedido_detalle(IN id_pedido INT , IN Cantidad INT, IN modelo_Id INT)
BEGIN
insert into pedido_detalle(modelo_Id, modelo_Id1, Cantidad_modelo, pedido_Id, Eliminado)
VALUES(modelo_Id, modelo_Id, Cantidad, id_pedido, 0);
END;
-- ___
CREATE PROCEDURE delete_PedidoDetalle(IN ParamPedido_detalle INT)
BEGIN

DECLARE finished int default 0;
DECLARE Id_Automovil INT;
DECLARE C cursor for
select Id from automovil where pedido_detalle_Id = ParamPedido_detalle;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

update pedido_detalle
SET Eliminado = 1,
FechaEliminado = now()
WHERE Id = ParamPedido_detalle;

OPEN C;
delAuto: LOOP
FETCH C into Id_Automovil;
IF finished = 1 THEN 
	LEAVE delAuto;
END IF;
call delete_automovil(Id_Automovil);

END LOOP delAuto;
CLOSE C;

END;
-- ___
CREATE PROCEDURE altapedido(IN Id_Cons INT)
BEGIN
insert into pedido(consecionaria_Id,FechaDeVenta,  Eliminado )
values (Id_Cons,now(),0);
END;
-- ___
CREATE PROCEDURE delete_Pedido(IN ParamPedido INT)
BEGIN

DECLARE finished int default 0;
DECLARE Id_PedidoDetalle INT;
DECLARE C cursor for
select Id from pedido_detalle where pedido_Id = ParamPedido;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

update pedido
SET Eliminado = 1,
FechaEliminado = now()
WHERE Id = ParamPedido;

OPEN C;
delDetalle: LOOP
FETCH C into Id_PedidoDetalle;
IF finished = 1 THEN 
	LEAVE delDetalle;
END IF;
call delete_PedidoDetalle(Id_PedidoDetalle);

END LOOP delDetalle;
CLOSE C;
END;
-- ____________________________________________________________________________________