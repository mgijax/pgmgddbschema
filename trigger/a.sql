CREATE OR REPLACE FUNCTION check_BIB_Refs_delete() RETURNS TRIGGER AS $$
BEGIN

DELETE FROM MGI_SetMember a
USING MGI_SetMember t
WHERE a._Object_key = OLD._Refs_key
AND a._MGIType_key = 1
AND a._Set_key = t._Set_key
;

DELETE FROM MGI_Translation a
USING MGI_TranslationType t
WHERE a._Object_key = OLD._Refs_key
AND a._MGIType_key = 1
and a._TranslationType_key = t._TranslationType_key
;

DELETE FROM VOC_Annot a
USING VOC_AnnotType t
WHERE a._Object_key = OLD._Refs_key
AND a._MGIType_key = 1
AND a._AnnotType_key = t._AnnotType_key
;

DELETE FROM MGI_AttributeHistory a
WHERE a._Object_key = OLD._Refs_key
AND a._MGIType_key = 1
;

DELETE FROM MGI_Note a
WHERE a._Object_key = OLD._Refs_key
AND a._MGIType_key = 1
;

DELETE FROM MGI_Reference_Assoc a
WHERE a._Object_key = OLD._Refs_key
AND a._MGIType_key = 1
;

DELETE FROM MGI_Synonym a
WHERE a._Object_key = OLD._Refs_key
AND a._MGIType_key = 1
;

DELETE FROM IMG_ImagePane_Assoc a
WHERE a._Object_key = OLD._Refs_key
AND a._MGIType_key = 1
;

DELETE FROM IMG_Cache a
WHERE a._Object_key = OLD._Refs_key
AND a._MGIType_key = 1
;

DELETE FROM ACC_AccessionReference ar
USING ACC_Accession a
WHERE a._Object_key = OLD._Refs_key
AND a._MGIType_key = 1
AND a._Accession_key = ar._Accession_key
;

DELETE FROM ACC_Accession a
WHERE a._Object_key = OLD._Refs_key
AND a._MGIType_key = 1
;

RETURN NEW;

END;
$$
LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION check_BIB_Refs_delete() TO public;

DROP TRIGGER check_BIB_Refs_delete_trigger ON BIB_Refs;

CREATE TRIGGER check_BIB_Refs_delete_trigger
AFTER DELETE on BIB_Refs
FOR EACH ROW
EXECUTE PROCEDURE check_BIB_Refs_delete();
