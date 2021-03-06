-- Query No: 1
CHANGES_HEADER =
SELECT
	V_ORDERS."_CASE_KEY" AS _CASE_KEY
	,CASE 
		WHEN CDPOS."FNAME" = 'CMGST' AND CDPOS."VALUE_NEW" IN ('A','D') THEN 'Akzeptiere Kreditprüfung'
		WHEN CDPOS."FNAME" = 'CMGST' AND CDPOS."VALUE_NEW" = 'B' THEN 'Lehne Kreditprüfung ab'   
		WHEN CDPOS."FNAME" = 'CMGST' AND CDPOS."VALUE_NEW" = 'C' THEN 'Akzeptiere Kreditprüfung teilweise'    
	    WHEN CDPOS."FNAME" = 'LIFSK' AND COALESCE(TRIM(CDPOS."VALUE_OLD"),'') = '' AND COALESCE(TRIM(CDPOS."VALUE_NEW"),'') <> '' THEN 'Setze Liefersperre'
	    WHEN CDPOS."FNAME" = 'LIFSK' AND COALESCE(TRIM(CDPOS."VALUE_OLD"),'') <> '' AND COALESCE(TRIM(CDPOS."VALUE_NEW"),'') <> '' THEN 'Ändere Liefersperre' 
	    WHEN CDPOS."FNAME" = 'LIFSK' AND COALESCE(TRIM(CDPOS."VALUE_OLD"),'') <> '' AND COALESCE(TRIM(CDPOS."VALUE_NEW"),'') = '' THEN 'Entferne Liefersperre'
        
        WHEN CDPOS."FNAME" = 'KOSTK' AND CDPOS."VALUE_NEW" IN ('B') THEN 'Teilweise kommissioniert'
        WHEN CDPOS."FNAME" = 'KOSTK' AND CDPOS."VALUE_NEW" IN ('C') THEN 'Vollständig kommissioniert'
        WHEN CDPOS."FNAME" = 'WBSTK' AND CDPOS."VALUE_NEW" IS NULL AND CDPOS."VALUE_OLD" IS NOT NULL THEN 'Irrelevant für Warenausgang'
        WHEN CDPOS."FNAME" = 'WBSTK' AND CDPOS."VALUE_NEW" IN ('C') THEN 'Warenausgang abgeschlossen'
        WHEN CDPOS."FNAME" = 'KOQUK' AND CDPOS."VALUE_NEW" IN ('B') THEN 'Kommisionierungsanfrage teilweise bestätigt'
        WHEN CDPOS."FNAME" = 'KOQUK' AND CDPOS."VALUE_NEW" IN ('C') THEN 'Kommisionierungsanfrage vollst. bestätigt'
		WHEN CDPOS."FNAME" = 'VSBED' THEN 'Ändere Versandbedingung'		
    END AS  "ACTIVITY_DE"
    ,CASE 
        WHEN CDPOS."FNAME" = 'CMGST' AND CDPOS."VALUE_NEW" IN ('A','D') THEN 'NAV: ' || 'Approve Credit Check'
        WHEN CDPOS."FNAME" = 'CMGST' AND CDPOS."VALUE_NEW" = 'B' THEN 'NAV: ' || 'Deny Credit Check'   
        WHEN CDPOS."FNAME" = 'CMGST' AND CDPOS."VALUE_NEW" = 'C' THEN 'NAV: ' || 'Partially approve Credit Check'    
        WHEN CDPOS."FNAME" = 'LIFSK' AND COALESCE(TRIM(CDPOS."VALUE_OLD"),'') = '' AND COALESCE(TRIM(CDPOS."VALUE_NEW"),'') <> '' THEN 'NAV: ' || 'Set Delivery Block'
        WHEN CDPOS."FNAME" = 'LIFSK' AND COALESCE(TRIM(CDPOS."VALUE_OLD"),'') <> '' AND COALESCE(TRIM(CDPOS."VALUE_NEW"),'') <> '' THEN 'NAV: ' || 'Change Delivery Block' 
	    WHEN CDPOS."FNAME" = 'LIFSK' AND COALESCE(TRIM(CDPOS."VALUE_OLD"),'') <> '' AND COALESCE(TRIM(CDPOS."VALUE_NEW"),'') = '' THEN 'NAV: ' || 'Remove Delivery Block'

        WHEN CDPOS."FNAME" = 'KOSTK' AND CDPOS."VALUE_NEW" IN ('B') THEN 'AV: ' || 'Partially picked'
        WHEN CDPOS."FNAME" = 'KOSTK' AND CDPOS."VALUE_NEW" IN ('C') THEN 'AV: ' || 'Fully picked'
        WHEN CDPOS."FNAME" = 'WBSTK' AND CDPOS."VALUE_NEW" IS NULL AND CDPOS."VALUE_OLD" IS NOT NULL THEN 'NAV: ' || 'Not relevant for Goods Issue'
        WHEN CDPOS."FNAME" = 'WBSTK' AND CDPOS."VALUE_NEW" IN ('C') THEN 'AV: ' || 'Goods Issue completed'
        WHEN CDPOS."FNAME" = 'KOQUK' AND CDPOS."VALUE_NEW" IN ('B') THEN 'AV: ' || 'Picking Request partially confirmed'
        WHEN CDPOS."FNAME" = 'KOQUK' AND CDPOS."VALUE_NEW" IN ('C') THEN 'AV: ' || 'Picking Request fully confirmed'
 		WHEN CDPOS."FNAME" = 'VSBED' THEN 'NAV: Change Shipping Condition'
    END AS  "ACTIVITY_EN"
	,CAST(CDHDR."UDATE" AS DATE) || ' ' || CAST(CDHDR."UTIME" AS TIME) AS "EVENTTIME"
	,50 +
	CASE 
		WHEN CDPOS."FNAME" = 'CMGST' AND CDPOS."VALUE_NEW" IN ('A','D') THEN 1
		WHEN CDPOS."FNAME" = 'CMGST' AND CDPOS."VALUE_NEW" = 'B' THEN 2 
		WHEN CDPOS."FNAME" = 'CMGST' AND CDPOS."VALUE_NEW" = 'C' THEN 3
	    WHEN CDPOS."FNAME" = 'LIFSK' AND COALESCE(TRIM(CDPOS."VALUE_OLD"),'') = '' AND COALESCE(TRIM(CDPOS."VALUE_NEW"),'') <> '' THEN 4
	    WHEN CDPOS."FNAME" = 'LIFSK' AND COALESCE(TRIM(CDPOS."VALUE_OLD"),'') <> '' AND COALESCE(TRIM(CDPOS."VALUE_NEW"),'') <> '' THEN 5
	    WHEN CDPOS."FNAME" = 'LIFSK' AND COALESCE(TRIM(CDPOS."VALUE_OLD"),'') <> '' AND COALESCE(TRIM(CDPOS."VALUE_NEW"),'') = '' THEN 6
        
        WHEN CDPOS."FNAME" = 'KOSTK' AND CDPOS."VALUE_NEW" IN ('B') THEN 7
        WHEN CDPOS."FNAME" = 'KOSTK' AND CDPOS."VALUE_NEW" IN ('C') THEN 8
        WHEN CDPOS."FNAME" = 'WBSTK' AND CDPOS."VALUE_NEW" IS NULL AND CDPOS."VALUE_OLD" IS NOT NULL THEN 9
        WHEN CDPOS."FNAME" = 'WBSTK' AND CDPOS."VALUE_NEW" IN ('C') THEN 10
        WHEN CDPOS."FNAME" = 'KOQUK' AND CDPOS."VALUE_NEW" IN ('B') THEN 11
        WHEN CDPOS."FNAME" = 'KOQUK' AND CDPOS."VALUE_NEW" IN ('C') THEN 12
 		WHEN CDPOS."FNAME" = 'VSBED' THEN 13
    END AS "_SORTING"
	--,CDHDR."USERNAME" AS "USER_NAME"
	,USR02."USTYP" AS "USER_TYPE"
	,CDPOS."TABNAME" AS "CHANGED_TABLE"
  	,NULL AS "CHANGED_TABLE_TEXT_DE"
  	,NULL AS "CHANGED_TABLE_TEXT_EN"
	,CDPOS."FNAME" AS "CHANGED_FIELD"
  	,NULL AS "CHANGED_FIELD_TEXT_DE"
  	,NULL AS "CHANGED_FIELD_TEXT_EN"
	,LTRIM(CDPOS."VALUE_OLD") AS "CHANGED_FROM"
	,LTRIM(CDPOS."VALUE_NEW") AS "CHANGED_TO"
  	,NULL AS "CHANGED_FROM_FLOAT"
  	,NULL AS "CHANGED_TO_FLOAT"
	,CDHDR."CHANGENR" AS "CHANGE_NUMBER"
	,CDHDR."TCODE" AS "TRANSACTION_CODE"
	,V_ORDERS."MANDT" AS "MANDT"
	,V_ORDERS."VBELN" AS "VBELN"
	,V_ORDERS."POSNR" AS "POSNR"
    ,NULL AS "_ORIGIN_SYS"
    ,NULL AS "LSLCODLSA"
    ,NULL AS "KOACDEABA"
    ,NULL AS "KOAERD"
    ,NULL AS "POACOD"
FROM 
	:TMP_O2C_VBAK_VBAP_ORDERS_VIEW AS V_ORDERS
	JOIN "LAKE"."CDPOS" AS CDPOS ON 1=1
		AND CDPOS."MANDANT" =  V_ORDERS."MANDT"
		AND LEFT(CDPOS."TABKEY", 13) = V_ORDERS."TABKEY_VBAK"
	JOIN "LAKE"."CDHDR" AS CDHDR ON 1=1
		AND CDPOS."MANDANT" = CDHDR."MANDANT"
		AND CDPOS."OBJECTCLAS" = CDHDR."OBJECTCLAS"
		AND CDPOS."OBJECTID" = CDHDR."OBJECTID"
		AND CDPOS."CHANGENR" = CDHDR."CHANGENR"
	LEFT JOIN "LAKE"."USR02" AS USR02 ON 1=1
		AND USR02."MANDT" = CDHDR."MANDANT"
		AND USR02."BNAME" = CDHDR."USERNAME"
WHERE 1=1
	AND CDPOS."CHNGIND" = 'U'
	AND (COALESCE(CDHDR."UDATE",'') <> '' AND CDHDR.UDATE <>'00000000')
	AND CDPOS."TABNAME" IN ('VBUK','VBAK')
	AND (
        (CDPOS."FNAME" = 'CMGST' AND COALESCE(TRIM(CDPOS."VALUE_NEW"),'') <> '')
	    OR CDPOS."FNAME" IN ('LIFSK', 'KOSTK', 'PKSTK', 'WBSTK', 'FKSTK', 'VLSTK', 'LVSTK', 'KOQUK','VSBED')
    )
;


CHANGES_HEADER_VBKD =
SELECT
	V_ORDERS."_CASE_KEY" AS _CASE_KEY
	,CASE 
		WHEN CDPOS."FNAME" = 'INCO1' THEN 'NAV: Ändere Incoterm'
		WHEN CDPOS."FNAME" = 'ZZINCO1' THEN 'NAV: Ändere Incoterm'
    END AS  "ACTIVITY_DE"
    ,CASE 
		WHEN CDPOS."FNAME" = 'INCO1' THEN 'NAV: Change Incoterm'
		WHEN CDPOS."FNAME" = 'ZZINCO1' THEN 'NAV: Change Incoterm'
    END AS  "ACTIVITY_EN"
	,CAST(CDHDR."UDATE" AS DATE) || ' ' || CAST(CDHDR."UTIME" AS TIME) AS "EVENTTIME"
	,70 AS "_SORTING"
	--,CDHDR."USERNAME" AS "USER_NAME"
	,USR02."USTYP" AS "USER_TYPE"
	,CDPOS."TABNAME" AS "CHANGED_TABLE"
  	,NULL AS "CHANGED_TABLE_TEXT_DE"
  	,NULL AS "CHANGED_TABLE_TEXT_EN"
	,CDPOS."FNAME" AS "CHANGED_FIELD"
  	,NULL AS "CHANGED_FIELD_TEXT_DE"
  	,NULL AS "CHANGED_FIELD_TEXT_EN"
	,LTRIM(CDPOS."VALUE_OLD") AS "CHANGED_FROM"
	,LTRIM(CDPOS."VALUE_NEW") AS "CHANGED_TO"
  	,NULL AS "CHANGED_FROM_FLOAT"
  	,NULL AS "CHANGED_TO_FLOAT"
	,CDHDR."CHANGENR" AS "CHANGE_NUMBER"
	,CDHDR."TCODE" AS "TRANSACTION_CODE"
	,V_ORDERS."MANDT" AS "MANDT"
	,V_ORDERS."VBELN" AS "VBELN"
	,V_ORDERS."POSNR" AS "POSNR"
    ,NULL AS "_ORIGIN_SYS"
    ,NULL AS "LSLCODLSA"
    ,NULL AS "KOACDEABA"
    ,NULL AS "KOAERD"
    ,NULL AS "POACOD"
FROM 
	:TMP_O2C_VBAK_VBAP_ORDERS_VIEW AS V_ORDERS
	JOIN "LAKE"."CDPOS" AS CDPOS ON 1=1
		AND CDPOS."MANDANT" =  V_ORDERS."MANDT"
		AND LEFT(CDPOS."TABKEY", 13) = V_ORDERS."TABKEY_VBAK"
		AND RIGHT(CDPOS."TABKEY", 6) = '000000'
	JOIN "LAKE"."CDHDR" AS CDHDR ON 1=1
		AND CDPOS."MANDANT" = CDHDR."MANDANT"
		AND CDPOS."OBJECTCLAS" = CDHDR."OBJECTCLAS"
		AND CDPOS."OBJECTID" = CDHDR."OBJECTID"
		AND CDPOS."CHANGENR" = CDHDR."CHANGENR"
	LEFT JOIN "LAKE"."USR02" AS USR02 ON 1=1
		AND USR02."MANDT" = CDHDR."MANDANT"
		AND USR02."BNAME" = CDHDR."USERNAME"
WHERE 1=1
	AND CDPOS."CHNGIND" = 'U'
	AND (COALESCE(CDHDR."UDATE",'') <> '' AND CDHDR.UDATE <>'00000000')
	AND CDPOS."TABNAME" = 'VBKD'
	AND CDPOS.FNAME IN ('INCO1', 'ZZINCO1')
;