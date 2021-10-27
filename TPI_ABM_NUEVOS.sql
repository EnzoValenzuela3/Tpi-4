-- _____________________________________________________________________________________________________________________________________________
-- MYSQL; MAS ABM
-- _____________________________________________________________________________________________________________________________________________
CREATE PROCEDURE `altaVehiculo`(IN modeloId INT, IN PedidoDetalleId INT)-- no corregido
BEGIN

DECLARE IdAuto INT;
DECLARE ChasisParam VARCHAR(45);
DECLARE FechaInicio datetime;

SELECT LEFT(MD5(RAND()), 8) into ChasisParam;
Insert INTO automovil(Eliminado, pedido_detalle_Id, pedido_detalle_modelo_Id)
VALUES	(0, PedidoDetalleId, modeloId);
SELECT CONCAT(LAST_INSERT_ID(),'-', ChasisParam) into ChasisParam;
UPDATE automovil a SET Chasis = ChasisParam where a.Id = last_insert_id();

END;
-- _____________________________________________________________________________________________________________________________________________
CREATE PROCEDURE `delete_automovil` (IN Id_Automovil INT)-- no corregido
BEGIN

update automovil SET
Eliminado = 1,
FechaEliminado = now()
where Id = Id_Automovil;

END;
-- _____________________________________________________________________________________________________________________________________________
CREATE PROCEDURE `alta_consecionario`(IN nombre VARCHAR(45), out msg VARCHAR(45))-- corregido
BEGIN
if consecionariosRepetidos(nombre) = 0 THEN
	insert into consecionaria(Nombre, Eliminado) VALUES
    (nombre, 0);
    set @msg = 'insercion correcta';
    end if;
END;
-- _____________________________________________________________________________________________________________________________________________
CREATE PROCEDURE `inicioAutomovil`(IN Paramchasis VARCHAR(45),out cMensaje VARCHAR(45), out nResultado int)-- no corregido
BEGIN

DECLARE VarAutoId INT;
DECLARE VarIngreso DATETIME,VarEgreso DATETIME;
DECLARE VarFechaElim DATETIME,VarFechaInicio DATETIME;
DECLARE VarAutoEnEstacion INT, VarEliminado INT,VarAuEEliminado INT;

set cMensaje = "";
select Id, FechaInicio, Eliminado, FechaEliminado into VarAutoId, VarFechaInicio, VarEliminado, VarFechaElim
from automovil
where Chasis = Paramchasis;

IF VarAutoId IS NOT NULL AND IF VarEliminado = 0 AND IF VarFechaInicio IS NULL THEN
		set cMensaje = 'no esta iniciado, chequeo estacion';
			
#Se obtiene la primera estacion en la linea de montaje que corresponde al modelo del vehiculo
 select IdEstacion from (
 select min(e.OrdenEstacion) AS IdPrimeraEstacion, e.Id AS IdEstacion from estacion e 
 inner join linea_montaje li on e.linea_montaje_Id = li.Id
 inner join modelo mo on mo.linea_montaje_Id = li.Id
 inner join automovil au on mo.Id = au.pedido_detalle_modelo_Id
 where au.Id = VarAutoId) as t;
			 
  #Obtengo los valores del ultimo registro en la primer estacion de la linea
 select FechaIngresoEstacion, FechaEgresoEstacion, automovil_Id, Eliminado from automovil_estacion aue 
  where aue.estacion_Id = VarEstacionInicioId AND aue.FechaIngresoEstacion = 
  (SELECT max(FechaIngresoEstacion) from automovil_estacion where estacion_Id = VarEstacionInicioId)
 into VarIngreso, VarEgreso, VarAutoEnEstacion, VarAuEEliminado;
			 
  # Si no hay egreso, no hubo nunca un ingreso, o el registro corresponde a un auto eliminado se inserta el nuevo auto
 IF VarEgreso IS NOT NULL OR VarIngreso IS NULL OR VarAuEEliminado = 1 THEN
	
 START transaction;
 insert into automovil_estacion(FechaIngresoEstacion, Eliminado, estacion_Id, automovil_Id)
 VALUES(now(),0,VarEstacionInicioId,VarAutoId);
 update automovil set FechaInicio = now() where automovil.Id = VarAutoId;
 set nResultado = 0;
 set cMensaje = CONCAT('Se inicio correctamente el automovil en el momento ',now(),' Id: ',VarAutoId);
 COMMIT;
				
ELSE
 select Chasis from automovil a where a.Id = VarAutoEnEstacion into @chasis;
 set cMensaje = CONCAT('No se puede iniciar, estacion de automovil ocupada por auto con chasis: ',  @chasis);
 set nResultado = -1;
ELSE
 set cMensaje = CONCAT('No se puede iniciar, el automovil ya fue iniciado en ', VarFechaInicio);
 set nResultado = -2;
ELSE
 set cMensaje = CONCAT('No se puede iniciar, el automovil fue eliminado en ', VarFechaElim);
 set nResultado = -3;
ELSE
 set cMensaje = CONCAT('No se puede iniciar, no se encontro el auto con Chasis ',Paramchasis);
 set nResultado = -4;
END IF;
END IF;
END;
-- _____________________________________________________________________________________________________________________________________________
CREATE PROCEDURE `siguienteEstacionAutomovil`(IN Paramchasis VARCHAR(45),out cMensaje VARCHAR(125), out nResultado INT)-- no corregido
BEGIN

DECLARE VarAutoId INT;
DECLARE VarEliminado INT default 0;
DECLARE VarFechaElim DATETIME default NULL;
DECLARE VarEstacionId INT default 0;
DECLARE VarFechaIngreso DATETIME default NULL;
DECLARE VarFechaFinalizado DATETIME default NULL;
DECLARE VarOrden INT default 0;
DECLARE VarIdSiguiente INT default NULL;
DECLARE VarTarea VARCHAR(45) default NULL;
DECLARE VarLineaMontaje INT default 0;
DECLARE SiguienteEstaLibre INT default null;
DECLARE ChasisDeOcupado VARCHAR(45);

SELECT Id, Eliminado, FechaEliminado, FechaFin into VarAutoId, VarEliminado, VarFechaElim, VarFechaFinalizado
FROM automovil
WHERE Chasis = Paramchasis;

IF VarEliminado = 0 AND VarFechaFinalizado IS NULL THEN
 #Se obtiene la ultima fecha de ingreso del auto y la estacion a la que corresponde
 SELECT FechaIngresoEstacion, estacion_Id 
 FROM automovil_estacion aue 
 WHERE aue.automovil_Id = VarAutoId AND FechaIngresoEstacion = (select MAX(FechaIngresoEstacion) from automovil_estacion where automovil_Id = VarAutoId)
 INTO VarFechaIngreso, VarEstacionId;
    
 IF VarFechaIngreso IS NULL THEN
 call inicioAutomovil(Paramchasis,cMensaje, nResultado);
 ELSE
 #Se obtienen la informacion de la estacion actual, para obtener cual es la siguiente estacion
 SELECT OrdenEstacion, TareaDeterminada, linea_montaje_Id FROM estacion e 
 INNER JOIN automovil_estacion aue ON e.Id = aue.estacion_Id
 WHERE e.Id = VarEstacionId AND aue.automovil_Id = VarAutoId
 INTO VarOrden, VarTarea, VarLineaMontaje;
 SELECT Id AS IdSiguienteEstacion FROM estacion e
 WHERE OrdenEstacion = VarOrden+1 AND linea_montaje_Id = VarLineaMontaje
 INTO VarIdSiguiente;

IF VarIdSiguiente IS NULL THEN
 #No hay siguiente estacion, finaliza la produccion del auto
 Start transaction;
 UPDATE automovil_estacion 
 SET FechaEgresoEstacion = now()
 WHERE automovil_Id = VarAutoId
 AND estacion_Id = VarEstacionId;
 UPDATE automovil
 SET FechaFin = now()
 WHERE Id = VarAutoId;
 SET nResultado = 0;
 SET cMensaje = 'El automovil fue finalizado y salio de la linea de montaje';
 commit;
ELSE
 #Si el numero de egresos es igual al de ingresos en una estacion, entonces la estacion esta libre
 SELECT count(FechaEgresoEstacion) - count(FechaIngresoEstacion) FROM automovil_estacion aue WHERE Eliminado = 0 AND estacion_Id = VarIdSiguiente
 INTO SiguienteEstaLibre;
			
IF SiguienteEstaLibre = 0 THEN
 #siguiente estacion esta libre, se finaliza la actual
 start transaction;
 UPDATE automovil_estacion SET FechaEgresoEstacion = now()
 WHERE automovil_Id = VarAutoId AND estacion_Id = VarEstacionId;
				
#Se inserta automovil en siguiente estacion
INSERT INTO automovil_estacion(FechaIngresoEstacion, Eliminado, estacion_Id, automovil_Id)
 VALUES(now(),0,VarIdSiguiente,VarAutoId);
						
 SET nResultado = 0;
 SET cMensaje = CONCAT('Se paso el automovil a la siguiente estacion');
 commit;
			
 ELSE
#Siguiente estacion esta ocupada
 select a.Chasis from automovil_estacion aue
 inner join automovil a on a.Id = aue.automovil_Id
 where aue.estacion_Id = VarIdSiguiente
  AND FechaIngresoEstacion = (SELECT max(FechaIngresoEstacion) FROM automovil_estacion
    WHERE estacion_Id = VarIdSiguiente)
 into ChasisDeOcupado;
 set nResultado = -1;
 set cMensaje = CONCAT('El automovil no se pudo pasar de estacion, siguiente estacion ocupada por auto con chasis ', ChasisDeOcupado);

END IF;
END IF;
END IF;
ELSE
 IF VarFechaFinalizado IS NOT NULL THEN
 set nResultado = -2;
 set cMensaje = CONCAT('El automovil no se puede pasar de estacion, fue finalizado en: ',VarFechaFinalizado);
 ELSE
 set nResultado = -3;
 set cMensaje = CONCAT('El automovil no se puede pasar de estacion, fue eliminado en: ',VarFechaElim);
 END IF;
END IF;
END;
-- _____________________________________________________________________________________________________________________________________________