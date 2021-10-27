-- -----------------------------------------------------
-- TPI;ESTUDIO DE SCRIPT DE "ABM DE PUNTO 3"
-- -----------------------------------------------------
USE SCHEMA `mydb` ;-- ELEGIR ESQUEMA 
-- -----------------------------------------------------
CREATE DEFINER=`root`@`localhost` PROCEDURE `altaVehiculo`(IN modeloId INT, IN PedidoDetalleId INT)
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
-- -----------------------------------------------------
CREATE DEFINER=`root`@`localhost` PROCEDURE `creacion_automoviles`(IN ParamIdDetalle INT)
BEGIN

DECLARE idModeloParametro INT;
DECLARE nCantidadDetalle INT;
DECLARE finished INT DEFAULT 0;
DECLARE nInsertados INT;

DECLARE curDetallePedido CURSOR FOR 
SELECT modelo_Id, Cantidad_modelo FROM pedido_detalle 
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
-- -----------------------------------------------------
CREATE DEFINER=`root`@`localhost` PROCEDURE `creacion_Automoviles_de_Pedido`(IN ParamIdPedido INT)
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
-- ------------------------------------------------------------------------------------------------------------