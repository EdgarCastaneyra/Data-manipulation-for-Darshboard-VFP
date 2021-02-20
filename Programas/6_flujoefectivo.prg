*application.Visible=.f.
CLOSE TABLES
SET safety OFF
SET TALK OFF
SET DATE FRENCH
SET CENTURY on
SET STATUS BAR OFF



****** configuración de variables publicas*****
PUBLIC rutavsai,rutadata


*STORE "C:\Users\edg19\Dashboard\Programa Fox\Tablas\" TO rutavsai &&tirden
*STORE "C:\Users\edg19\Dashboard\Data\" TO rutadata &&tirden

***********************Tabla maestra Flujo de efectivo*************************
USE cxcfin IN 0 
USE cxpfin IN 0 


SELECT "cxp" c_p_c,cve_prov cve_p_c,nom_prov nom_p_c,fac_comp fac,fecha,fech_venci f_venci,cant_surt,dias_venc,(vencida+siete+quince+treinta+cuatcinco+sesenta+mas) monto, (000000000000000.00) monto_acum,lugar,n_cred,n_carg FROM cxpfin INTO table paso

SELECT "cxc" c_p_c,cve_cte cve_p_c,nom_cte nom_p_c,fac,fecha,f_pago f_venci,cant_surt,dias_venc,(vencida+siete+quince+treinta+cuatcinco+sesenta+mas) monto, (000000000000000.00) monto_acum,lugar,n_cred,n_carg FROM cxcfin INTO TABLE paso2 

SELECT paso2 
APPEND FROM paso

DROP TABLE paso

ALTER table paso2 ADD COLUMN statusfac c(40)

replace ALL statusfac WITH "vencido" FOR dias_venc<0
replace ALL statusfac WITH "xvencer" FOR dias_venc>=0

SELECT * FROM paso2 ORDER BY f_venci ASC INTO TABLE flujoef 
c=0
p=0

		SELECT flujoef 

		GO top IN flujoef 
		DO WHILE !EOF('flujoef') 
			SELECT flujoef 
			cxcop=flujoef.c_p_c
			ven=flujoef.statusfac 
			
				IF ven="xvencer" then
					IF cxcop="cxc" then
						c=c + flujoef.monto
						REPLACE flujoef.monto_acum WITH c IN flujoef
						
					ELSE
						p= p + flujoef.monto
						REPLACE flujoef.monto_acum WITH p IN flujoef
						
					ENDIF
				ENDIF
				
			SKIP 1 IN flujoef
		ENDDO
		
SELECT flujoef
COPY TO rutadata + "flujo\" + "flujoef"

DROP TABLE cxpfin
DROP TABLE cxcfin




DO 7_producto