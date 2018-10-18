CREATE OR REPLACE TRIGGER suc_abuela
BEFORE DELETE ON sucursal
FOR EACH ROW
DECLARE
	sucp sucursal.codsuc%TYPE;
	PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	sucp := :OLD.sucpadre;
	IF sucp IS NULL THEN
		DBMS_OUTPUT.PUT_LINE('intentaste borrar la raiz');
		RAISE_APPLICATION_ERROR(-20505,'¡No puedes eliminar la sucursal raiz!');
	ELSE
		DBMS_OUTPUT.PUT_LINE(sucp || ' la suc padre es esa');
		FOR suc IN (SELECT * FROM sucursal WHERE sucpadre = :OLD.codsuc) LOOP
			UPDATE sucursal
			SET sucpadre = :OLD.sucpadre
			WHERE codsuc = suc.codsuc;
			commit;
		END LOOP;
		COMMIT;
	END IF;
END;
/

--Este bloque es para probar--
BEGIN
DELETE FROM sucursal WHERE codsuc = 1;
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(SQLCODE || SQLERRM);
END;
/
