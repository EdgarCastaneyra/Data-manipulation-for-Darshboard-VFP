*application.Visible=.f.
CLOSE TABLES
SET safety OFF
SET TALK OFF
SET DATE FRENCH
SET CENTURY on
SET STATUS BAR OFF
SET DEFAULT TO SYS(5) + LEFT(SYS(2003),LEN(SYS(2003)))


****** configuración de variables publicas*****
PUBLIC rutavsai,rutadata

*STORE "C:\Users\edg19\Dashboard\Programa Fox\Tablas\" TO rutavsai &&tirden
*STORE "C:\Users\edg19\Dashboard\Data\" TO rutadata &&tirden


***********************Tabla maestra cliente*************************
USE rutavsai + "ventas.dbf" IN 0 

SELECT * from ventas INTO TABLE vtas
SELECT ventas 
USE

SELECT vtas

 replace ALL fac WITH ALLTRIM(STR(no_ped))+"_"+ALLTRIM(rem_fac) FOR no_ped<>0
 replace ALL fac WITH ALLTRIM(STR(nvta))+"_"+ALLTRIM(rem_fac) FOR nvta<>0
 replace ALL fac WITH ALLTRIM(STR(no_rem))+"_R" FOR NOT EMPTY(no_rem)
 replace ALL fac WITH ALLTRIM(no_fac)+"_F" FOR NOT EMPTY(no_fac)
 
 
 replace ALL fecha WITH f_alta_ped FOR no_ped<>0
 replace ALL fecha WITH falta_nvta FOR nvta<>0
 replace ALL fecha WITH falta_rem FOR NOT EMPTY(no_rem)
 replace ALL fecha WITH falta_fac FOR NOT EMPTY(no_fac)

SELECT fac, cve_cte,cve_mon,fecha,f_pago,lugar,cve_age,;
SUM(vent_net) vent_net, SUM(cant_surt) cant_surt,f_pago-DATE() dias_venc FROM vtas GROUP BY 1,2,3,4,5,6,7 where status_fac<>"Pagada" AND NOT EMPTY(no_fac) INTO TABLE cxc

ALTER table cxc ADD COLUMN Vencida n(20,2)
ALTER table cxc ADD COLUMN siete n(20,2)
ALTER table cxc ADD COLUMN quince n(20,2)
ALTER table cxc ADD COLUMN treinta n(20,2)
ALTER table cxc ADD COLUMN cuatcinco n(20,2)
ALTER table cxc ADD COLUMN sesenta n(20,2)
ALTER table cxc ADD COLUMN mas n(20,2)
ALTER table cxc ADD COLUMN nom_cte c(60)
ALTER table cxc ADD COLUMN dia_cre n(3)
ALTER table cxc ADD COLUMN lim_cre n(20,2)


		**********************Pega info clientes*************************
		USE rutavsai + "clientes.dbf" IN 0 
		SELECT clientes
		INDEX on cve_cte TO a
		SELECT cxc
		SET RELATION TO cve_cte INTO clientes
		replace ALL nom_cte WITH clientes.nom_cte
		replace ALL dia_cre WITH clientes.dia_cre 
		replace ALL lim_cre WITH clientes.lim_cre 

		SELECT clientes
		USE
		
		SELECT cxc
		replace ALL dias_venc WITH -999 FOR EMPTY(f_pago)

**************Resta los pagos que ya se hicieron*****************************************

		USE rutavsai + "facturac.dbf" IN 0 
		
		SELECT ALLTRIM(cve_factu) + " " + ALLTRIM(no_fac) + "_F" as llave, saldo_fac FROM facturac INTO TABLE paso
		SELECT facturac
		USE

		SELECT paso
		INDEX on llave  TO a
		SELECT cxc
		SET RELATION TO fac INTO paso
	
		replace ALL vent_net WITH ABS(paso.saldo_fac) 

		DROP TABLE paso
		
**************Pega el importe segun la fecha de vencimiento******************************

		SELECT cxc

		GO top IN cxc
		DO WHILE !EOF('cxc') 
			SELECT cxc
			monto=cxc.VENT_NET
			diasven=cxc.Dias_venc
			
					DO case
					CASE dias_venc<0
					REPLACE cxc.Vencida WITH monto IN cxc
					
					CASE dias_venc>=0 AND dias_venc<=7
					REPLACE cxc.siete WITH monto IN cxc

					CASE dias_venc>7 AND dias_venc<=15
					REPLACE cxc.quince WITH monto IN cxc

					CASE dias_venc>15 AND dias_venc<=30
					REPLACE cxc.treinta WITH monto IN cxc
					
					CASE dias_venc>30 AND dias_venc<=45
					REPLACE cxc.cuatcinco WITH monto IN cxc

					CASE dias_venc>45 AND dias_venc<=60
					REPLACE cxc.sesenta WITH monto IN cxc

					CASE dias_venc>60
					REPLACE cxc.mas WITH monto IN cxc

					ENDCASE			

			SKIP 1 IN cxc
		ENDDo


SELECT cxc
RECALL all


SELECT cve_cte,nom_cte,fac,fecha,f_pago,cant_surt,dias_venc,vencida,siete,quince,treinta,cuatcinco,sesenta,mas,lugar,cve_age,SPACE(20) nom_age FROM cxc INTO table cxcfin
SELECT cxcfin

&&DELETE FOR EMPTY(f_pago)
&&PACK

DROP TABLE cxc
DROP TABLE vtas


ALTER table cxcfin ADD COLUMN n_cred n(20,2)
ALTER table cxcfin ADD COLUMN n_carg n(20,2)


**********************Pega info notas de crédito*************************
USE rutavsai + "creditos.dbf" IN 0 SHARED
SELECT creditos

SELECT no_cliente cve_cte,SPACE(50) nom_cte,ALLTRIM(no_nota)+IIF(ALLTRIM(tip_not)="Dev. Just.","   Dev","   Desc") fac,fecha,saldo n_cred,lugar,no_agente cve_age,SPACE(50) nom_age,tip_not FROM creditos WHERE no_estado=="Emitida" OR no_estado=="Parcial" INTO TABLE ncred
SELECT cxcfin
APPEND FROM ncred
SELECT creditos
USE

DROP TABLE ncred

**********************Pega info notas de cargo*************************
USE rutavsai + "ncargv.dbf" IN 0 SHARED

SELECT cve_cte,SPACE(50) nom_cte,(ALLTRIM(no_ncargv)+"   N_cargo") fac,fech_ncv fecha,(saldo_ncv*-1) n_carg,lugar,cve_age,SPACE(50) nom_age FROM ncargv WHERE estado_ncv=="Emitida" OR estado_ncv=="Parcial" INTO TABLE ncarg
SELECT cxcfin
APPEND FROM ncarg
SELECT ncargv
USE

DROP TABLE ncarg

		**********************Pega info clientes*************************
		USE rutavsai + "clientes.dbf" IN 0 
		SELECT clientes
		INDEX on cve_cte TO a
		SELECT cxcfin
		SET RELATION TO cve_cte INTO clientes
		replace ALL nom_cte WITH clientes.nom_cte

		SELECT clientes
		USE
		
		 		**********************Pega info agentes*************************
		USE rutavsai + "agentes.dbf" IN 0 SHARED
		SELECT agentes
		INDEX on cve_age TO a
		SELECT cxcfin
		SET RELATION TO cve_age INTO agentes
		replace ALL nom_age WITH agentes.nom_age

		SELECT agentes
		USE


SELECT cxcfin
COPY TO rutadata + "flujo\" + "cxc"

DO 5_cxp

