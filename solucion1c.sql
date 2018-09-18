CREATE OR REPLACE TRIGGER suc_abuela
BEFORE DELETE ON sucursal
FOR EACH ROW
<<<<<<< HEAD
declare
pragma autonomous_transaction;
=======
DECLARE
	PRAGMA AUTONOMOUS_TRANSACTION;
>>>>>>> 062bacaf0655545d2f7ce73df8adaba27bc46065
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
