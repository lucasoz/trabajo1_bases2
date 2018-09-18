CREATE OR REPLACE TRIGGER suc_abuela
BEFORE DELETE ON sucursal
FOR EACH ROW
DECLARE
	PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	FOR suc IN (SELECT * FROM sucursal WHERE sucpadre = :OLD.codsuc) LOOP
		UPDATE sucursal
		SET sucpadre = :OLD.sucpadre
		WHERE codsuc = suc.codsuc;
		commit;
	END LOOP;
	COMMIT;
END;
/
