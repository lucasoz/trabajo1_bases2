--PARA QUE ESTO FUNCIONE DEBEN ESTAR LAS TABLAS CREADAS Y LOS XML AGREGADOS  OSEA LO SIGUIENTE
CREATE TABLE red(
id_red NUMBER(8) PRIMARY KEY,
nombre_red VARCHAR2(40) NOT NULL,
grafo_rutas XMLTYPE
);

insert into red values(333,'Red 2',
'<GrafoRuta>
	<Paso>
		<Origen>1</Origen>
		<Destino>2</Destino>
		<Costo>100</Costo>
	</Paso>
	<Paso>
		<Origen>1</Origen>
		<Destino>4</Destino>
		<Costo>90</Costo>
	</Paso>
	<Paso>
		<Origen>1</Origen>
		<Destino>3</Destino>
		<Costo>50</Costo>
	</Paso>
	<Paso>
		<Origen>2</Origen>
		<Destino>4</Destino>
		<Costo>20</Costo>
	</Paso>
	<Paso>
		<Origen>3</Origen>
		<Destino>4</Destino>
		<Costo>30</Costo>
	</Paso>
	<Paso>
		<Origen>4</Origen>
		<Destino>5</Destino>
		<Costo>90</Costo>
	</Paso>
	<Paso>
		<Origen>5</Origen>
		<Destino>1</Destino>
		<Costo>50</Costo>
	</Paso>
</GrafoRuta>');

insert into red values(335,'Red 2',
'<GrafoRuta>
	<Paso>
		<Origen>1</Origen>
		<Destino>2</Destino>
		<Costo>1000</Costo>
	</Paso>
	<Paso>
		<Origen>2</Origen>
		<Destino>3</Destino>
		<Costo>900</Costo>
	</Paso>
	<Paso>
		<Origen>3</Origen>
		<Destino>4</Destino>
		<Costo>500</Costo>
	</Paso>
	<Paso>
		<Origen>4</Origen>
		<Destino>1</Destino>
		<Costo>200</Costo>
	</Paso>
</GrafoRuta>');

-- ESTA ES LA FUNCION recursiva. CREO QUE ESTO TIENE ERRORES
-- CREATE OR REPLACE FUNCTION recursiva(red IN NUMBER, origen IN NUMBER, actual IN NUMBER, destino IN NUMBER, suma_costo IN NUMBER, contador IN NUMBER)
-- RETURN VARCHAR IS
-- tam NUMBER:=0;
-- suma_f NUMBER:=0;
-- contador_f NUMBER;
-- BEGIN
-- SELECT count(DISTINCT origen) INTO tam FROM red,
-- XMLTABLE
-- (
--   '/GrafoRuta/Paso'
--   PASSING grafo_rutas
--   COLUMNS
--   origen NUMBER(38) PATH 'Origen',
--   destino NUMBER(38) PATH 'Destino',
--   costo NUMBER(38) PATH 'Costo'
-- ) WHERE id_red = red;
-- IF actual = destino THEN
-- 	RETURN ' total '||suma_costo;
-- ELSE
--   contador_f:=contador+1;
--   FOR i IN (SELECT origen, destino, costo FROM red,
--   XMLTABLE
--   (
--     '/GrafoRuta/Paso'
--     PASSING grafo_rutas
--     COLUMNS
--     origen NUMBER(38) PATH 'Origen',
--     destino NUMBER(38) PATH 'Destino',
--     costo NUMBER(38) PATH 'Costo'
--   ) WHERE id_red = red and origen = actual) LOOP
--     suma_f:=suma_costo+i.costo;
--     IF contador = tam THEN
--       RETURN 'x';
--     ELSIF i.destino = origen THEN
--       RETURN 'x';
--     ELSE
--       RETURN '-'||i.destino||recursiva(red,origen,i.destino,destino,suma_f,contador);
--     END IF;
--   END LOOP;
-- END IF;
-- END;
-- /


--ESTE ES UN CODIGO DE ENSAYO ESTOY TOMANDO VALORES GENERICOS DE ORIGEN 1 Y DESTINO 4 HAY QUE HACER UN PROCEDIMIENTO QUE RECIVA LOS PARAMETROS
-- DECLARE
-- cadena VARCHAR(250);
-- origen_t NUMBER:=1;
-- destino NUMBER:=4;
-- BEGIN
-- FOR i IN (SELECT origen, destino, costo FROM red,
-- XMLTABLE
-- (
--   '/GrafoRuta/Paso'
--   PASSING grafo_rutas
--   COLUMNS
--   origen NUMBER(3) PATH 'Origen',
--   destino NUMBER(3) PATH 'Destino',
--   costo NUMBER(3) PATH 'Costo'
-- ) WHERE id_red = 330 and origen = origen_t) LOOP
--   cadena:=origen_t||'-'||i.destino||recursiva(origen_t,i.destino,destino,i.costo,1);
-- 	IF length(cadena) != instr(cadena,'x') THEN
-- 	  DBMS_OUTPUT.PUT_LINE(cadena);
-- 	END IF;
-- END LOOP;
-- END;
-- /



-- CREATE OR REPLACE PROCEDURE posibles_rutas
-- (codigo_red IN NUMBER, origen_t IN NUMBER, destino IN NUMBER)
-- IS
-- cadena VARCHAR(250);
-- BEGIN
-- FOR i IN (SELECT origen, destino, costo FROM red,
-- XMLTABLE
-- (
--   '/GrafoRuta/Paso'
--   PASSING grafo_rutas
--   COLUMNS
--   origen NUMBER(38) PATH 'Origen',
--   destino NUMBER(38) PATH 'Destino',
--   costo NUMBER(38) PATH 'Costo'
-- ) WHERE id_red = codigo_red and origen = origen_t) LOOP
--   cadena:=origen_t||'-'||i.destino||recursiva(codigo_red,origen_t,i.destino,destino,i.costo,1);
-- 	IF length(cadena) != instr(cadena,'x') THEN
-- 	  DBMS_OUTPUT.PUT_LINE(cadena);
-- 	END IF;
-- END LOOP;
-- END;
-- /
--
-- execute posibles_rutas(333,1,4);


CREATE OR REPLACE PROCEDURE recursiva(
cadena IN VARCHAR, red IN NUMBER, origen IN NUMBER, actual IN NUMBER, destino IN NUMBER, suma_costo IN NUMBER, contador IN NUMBER, tam IN NUMBER)
IS
cadena1 VARCHAR(250);
suma_f NUMBER:=0;
contador_f NUMBER;
BEGIN
IF actual = destino THEN
	DBMS_OUTPUT.PUT_LINE(cadena||' total '||suma_costo);
ELSE
  contador_f:=contador+1;
  FOR i IN (SELECT origen, destino, costo FROM red,
  XMLTABLE
  (
    '/GrafoRuta/Paso'
    PASSING grafo_rutas
    COLUMNS
    origen NUMBER(38) PATH 'Origen',
    destino NUMBER(38) PATH 'Destino',
    costo NUMBER(38) PATH 'Costo'
  ) WHERE id_red = red and origen = actual) LOOP
    suma_f:=suma_costo+i.costo;
    IF contador = tam THEN
      CONTINUE;
    ELSIF i.destino = origen THEN
      CONTINUE;
    ELSE
      cadena1:=cadena||'-'||i.destino;
      recursiva(cadena1,red,origen,i.destino,destino,suma_f,contador,tam);
    END IF;
  END LOOP;
END IF;
END;
/
