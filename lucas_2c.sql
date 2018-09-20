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

create table rutas_posibles(texo VARCHAR(250) PRIMARY KEY,total NUMBER(38));

CREATE OR REPLACE PROCEDURE recursiva(
cadena IN VARCHAR, red IN NUMBER, origen IN NUMBER, actual IN NUMBER, destino IN NUMBER, suma_costo IN NUMBER, contador IN NUMBER, tam IN NUMBER)
IS
cadena1 VARCHAR(250);
suma_f NUMBER:=0;
contador_f NUMBER;
BEGIN
IF actual = destino THEN
	INSERT INTO rutas_posibles values(cadena,suma_costo);
	--DBMS_OUTPUT.PUT_LINE(cadena||' total '||suma_costo);
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

create or replace PROCEDURE posibles_rutas
(codigo_red IN NUMBER, origen_t IN NUMBER, destino IN NUMBER)
IS
cadena VARCHAR(250);
tam NUMBER:=0;
BEGIN
delete rutas_posibles;
SELECT count(DISTINCT origen) INTO tam FROM red,
XMLTABLE
(
  '/GrafoRuta/Paso'
  PASSING grafo_rutas
  COLUMNS
  origen NUMBER(38) PATH 'Origen',
  destino NUMBER(38) PATH 'Destino',
  costo NUMBER(38) PATH 'Costo'
) WHERE id_red = codigo_red;

FOR i IN (SELECT origen, destino, costo FROM red,
XMLTABLE
(
  '/GrafoRuta/Paso'
  PASSING grafo_rutas
  COLUMNS
  origen NUMBER(38) PATH 'Origen',
  destino NUMBER(38) PATH 'Destino',
  costo NUMBER(38) PATH 'Costo'
) WHERE id_red = codigo_red and origen = origen_t) LOOP
  cadena:=origen_t||'-'||i.destino;
  recursiva(cadena,codigo_red,origen_t,i.destino,destino,i.costo,1,tam);
END LOOP;

FOR elemento IN (select * from rutas_posibles order by total desc) LOOP
	DBMS_OUTPUT.PUT_LINE(elemento.texo||' total '||elemento.total);
END LOOP;
END;
/
