CREATE TABLE sucursal(
codsuc NUMBER(8) PRIMARY KEY,
ganancia NUMBER(8) NOT NULL CHECK (ganancia > 0),
sucpadre NUMBER(8) REFERENCES sucursal
);

INSERT INTO sucursal VALUES(1,5000,NULL);
commit;
INSERT INTO sucursal VALUES(2,200,1);
commit;
INSERT INTO sucursal VALUES(9,300,1);
commit;
INSERT INTO sucursal VALUES(11,500,1);
commit;
INSERT INTO sucursal VALUES(15,800,2);
commit;
INSERT INTO sucursal VALUES(16,900,2);
commit;
INSERT INTO sucursal VALUES(22,50,11);
commit;
INSERT INTO sucursal VALUES(29,80,16);
commit;

create or replace FUNCTION ganancias_anteriores(id IN NUMBER)
RETURN NUMBER IS PRAGMA AUTONOMOUS_TRANSACTION;
    ganancia sucursal.ganancia%TYPE;
    padre sucursal.sucpadre%TYPE;
BEGIN
    IF id IS NULL THEN
        return 0;
    ELSE
        SELECT sucpadre, ganancia INTO padre, ganancia FROM sucursal WHERE codsuc = id;
        return ganancia + ganancias_anteriores(padre);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER control_ganancias
BEFORE INSERT OR UPDATE ON sucursal
FOR EACH ROW
DECLARE
cantidad number;
BEGIN
  SELECT count(*) INTO cantidad FROM sucursal;
  IF cantidad > 0 then
    IF :NEW.ganancia > ganancias_anteriores(:NEW.sucpadre) THEN
      RAISE_APPLICATION_ERROR(-20506,'¡La ganancias de la sucursal padre excede la esperada!');
    END IF;
  end if;
END;
/

BEGIN
INSERT INTO sucursal values(43,5600,22);
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(SQLCODE || SQLERRM);
END;
/

BEGIN
INSERT INTO sucursal values(43,5250,22);
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(SQLCODE || SQLERRM);
END;
/

BEGIN
UPDATE sucursal
SET ganancia = 5600
WHERE codsuc = 43;
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(SQLCODE || SQLERRM);
END;
/
