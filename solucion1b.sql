CREATE OR REPLACE PACKAGE sucursales IS
 TYPE lista IS TABLE OF NUMBER(3);
 PROCEDURE suma_niveles(niveles IN lista, suma OUT NUMBER);
 FUNCTION nivel(id IN NUMBER) RETURN NUMBER;
END;
/
CREATE OR REPLACE PACKAGE BODY sucursales IS
PROCEDURE suma_niveles(niveles IN lista, suma OUT NUMBER) IS
nivel_obtenido number;
BEGIN
  suma:=0;
  FOR elemento IN (SELECT * FROM sucursal) LOOP
    nivel_obtenido:=nivel(elemento.codsuc);
    FOR i in 1..niveles.count LOOP
      if nivel_obtenido = niveles(i) then
        suma:=suma+elemento.ganancia;
      end if;
    end loop;
  END LOOP;
END;

FUNCTION nivel(id IN NUMBER)
RETURN NUMBER IS
cont NUMBER(3):=0;
id_padre sucursal.sucpadre%TYPE;
id_actual sucursal.codsuc%TYPE;
BEGIN
id_actual:=id;
LOOP
  SELECT sucpadre INTO id_padre from sucursal where codsuc = id_actual;
  id_actual:=id_padre;
  cont:=cont+1;
  EXIT WHEN id_padre IS NULL;
END LOOP;
return cont;
END;
END; --Fin del cuerpo del paquete
/

DECLARE
suma NUMBER;
BEGIN
  sucursales.suma_niveles(sucursales.lista((2),(4)),suma);
  DBMS_OUTPUT.PUT_LINE(suma);
END;
/
