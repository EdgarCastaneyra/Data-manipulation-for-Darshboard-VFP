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


*STORE "D:\AFFICENT\Dashboard\Dashboard\Data\" TO rutadata
*STORE "D:\AFFICENT\Dashboard\Dashboard\Programa Fox\Tablas\" TO rutavsai

*STORE "C:\Users\edg19\Dashboard\Data\" TO rutadata
*STORE "C:\Users\edg19\Dashboard\Programa Fox\Tablas\" TO rutavsai


***********************Tabla maestra cliente*************************
USE rutavsai + "ventas.dbf" IN 0 

SELECT no_fac,no_rem,nvta,fac,cve_prod, new_med, cve_cte, cant_surt,cant_dev,cost_prom,cost_repo,mon_prod,hora,fecha,TC,vent_net,vent_tot,vent_dev,lugar FROM Ventas INTO TABLE vtascte

ALTER table vtascte ADD COLUMN cve_can n(10)
ALTER table vtascte ADD COLUMN falta_cte d(8)
ALTER table vtascte ADD COLUMN etiqueta c(40)
ALTER table vtascte ADD COLUMN nom_cte c(40)
ALTER table vtascte ADD COLUMN nom_can c(40)


		**********************Pega info clientes*************************
		USE rutavsai + "clientes.dbf" IN 0 
		SELECT clientes
		INDEX on cve_cte TO a
		SELECT vtascte
		SET RELATION TO cve_cte INTO clientes
		replace ALL cve_can WITH clientes.cve_can
		replace ALL falta_cte WITH clientes.falta_cte  
		replace ALL nom_cte WITH clientes.nom_cte 
		replace ALL cve_can WITH clientes.cve_can

		SELECT clientes
		USE

		USE rutavsai + "canald.dbf" IN 0 SHARED
		SELECT canald
		INDEX on cve_can TO a
		SELECT vtascte
		SET RELATION TO cve_can INTO canald
		replace ALL nom_can WITH canald.nom_can
		replace ALL nom_cte WITH "NA" FOR EMPTY(nom_cte)
		replace ALL nom_can WITH "NA" FOR EMPTY(nom_can)

		SELECT canald
		USE
		
*********************** Resumen general de clientes ***************************************
SELECT cve_cte,DATE(1999,1,1) fecha, MONTH(fecha) mes, YEAR(fecha) anio, vent_net,cve_can,nom_cte,nom_can, lugar FROM vtascte INTO TABLE paso1
SELECT cve_cte,fecha,mes,anio,cve_can,nom_cte,nom_can, SUM(vent_net) mtovta,lugar FROM paso1 GROUP BY 1,2,3,4,5,6,7,9 INTO TABLE paso2
SELECT paso2

replace ALL fecha WITH DATE(ANIO,mes,1)
replace ALL lugar WITH "Tirden" for ALLTRIM(lugar)<>"A1ISO"
replace ALL lugar WITH "ISO" for ALLTRIM(lugar)=="A1ISO"

COPY TO rutadata + "Cliente\" + "vtascte"
DROP TABLE paso1


***********************Catalogo de Clientes **********************************************
SELECT distinct nom_can tipo, (nom_cte) nomcte,lugar FROM paso2 INTO table catcliente
DROP TABLE paso2
SELECT distinct lugar,tipo, "Todos" nomcte FROM catcliente INTO TABLE paso
SELECT catcliente
APPEND FROM paso
SELECT distinct lugar,"Todos" tipo, "Todos" nomcte FROM catcliente INTO TABLE paso
SELECT catcliente
APPEND FROM paso
SELECT distinct "Todos" lugar,"Todos" tipo, nomcte FROM catcliente INTO TABLE paso
SELECT catcliente
APPEND FROM paso
SELECT distinct "Todos" lugar,tipo, "Todos" nomcte FROM catcliente INTO TABLE paso
SELECT catcliente
APPEND FROM paso

DROP TABLE paso

APPEND BLANK
GO bottom
replace tipo WITH "Todos"
replace nomcte WITH "Todos"
replace lugar WITH "Todos"

SELECT catcliente
COPY TO rutadata + "\cliente\catcte"


***********************Conteo de notas de venta Mostrador*************************
SELECT distinct(nvta) nvta,falta_nvta,YEAR(falta_nvta) ANIO, MONTH(falta_nvta) Mes FROM ventas INTO table paso
SELECT DATE(1999,1,1) fecha,ANIO, Mes, COUNT(nvta) venta FROM paso WHERE anio<>0 OR mes<>0 GROUP BY 1,2,3 INTO table paso2
SELECT paso2
replace ALL fecha WITH DATE(ANIO,mes,1)
COPY TO rutadata + "Cliente\" + "nvtamost"

DROP TABLE paso2
SELECT paso


***********************Horario de notas de venta Mostrador*************************
SELECT distinct(nvta) nvta,falta_nvta,YEAR(falta_nvta) ANIO, MONTH(falta_nvta) Mes, VAL(LEFT(hora_nvta,2)) hora FROM ventas INTO table paso
SELECT DATE(1999,1,1) fecha,ANIO, Mes, hora, COUNT(nvta) venta FROM paso WHERE anio<>0 OR mes<>0 OR hora<>0 GROUP BY 1,2,3,4 INTO table paso2
SELECT paso2
replace ALL fecha WITH DATE(ANIO,mes,1)
COPY TO rutadata + "Cliente\" + "horamost"

DROP TABLE paso
DROP TABLE paso2


***********************Gráfica clientes nuevos*************************
SELECT fac,cve_cte,nom_can,nom_cte,DATE(1999,1,1) fecha,YEAR(falta_cte) ANIO_CTE,month(falta_cte) MES_CTE, YEAR(fecha) ANIO,month(fecha) MES,;
SPACE(10) nuev_ret, SUM(vent_net) vent_net  FROM vtascte where vent_net<>0 group BY 1,2,3,4,5,6,7,8,9 INTO table ctesnvospaso
SELECT ctesnvospaso
replace ALL fecha WITH DATE(ANIO,MES,1) FOR anio<>0 OR mes<>0

replace ALL nuev_ret WITH "Nuevo" FOR Anio_cte=anio AND mes_cte=mes
replace ALL nuev_ret WITH "Retenidos" FOR EMPTY(nuev_ret)


SELECT nom_can,cve_cte, nom_cte, anio_cte,mes_cte,fecha, anio,mes,nuev_ret,;
SUM(vent_net) vent_net, COUNT(fac) CNT_FAC,SPACE(8) ult_mes, SPACE(20) etiqueta,00000 etiq FROM ctesnvospaso GROUP BY 1,2,3,4,5,6,7,8,9 ORDER BY 6 desc INTO TABLE ctesnvos


DROP TABLE ctesnvospaso

		******************************************Pega la última fecha de compra******************************

		SELECT distinct(cve_cte) cve_cte,ult_mes FROM ctesnvos INTO TABLE ult_mes_vta

		SELECT ctesnvos
		INDEX on cve_cte TO clien


		SELECT ult_mes_vta
		GO top IN ult_mes_vta
		DO WHILE !EOF('ult_mes_vta') 

			IF SEEK(ult_mes_vta.cve_cte, 'ctesnvos') THEN
				REPLACE ult_mes_vta.ult_mes WITH ALLTRIM(PADL(ctesnvos.ANIO,4,"0") + "_" + PADL(ctesnvos.MES,2,"0")) IN ult_mes_vta				
			ENDIF

			SKIP 1 IN ult_mes_vta
		ENDDO
		
		SELECT ult_mes_vta
		INDEX on cve_cte TO b
		SELECT ctesnvos
		SET RELATION TO cve_cte INTO ult_mes_vta
		replace ALL ult_mes WITH ult_mes_vta.ult_mes 
		DROP TABLE ult_mes_vta


		************************************* Etiquetas **********************************************
		
			************************** Frecuente y Recurrente ******************	
			replace ALL etiq WITH 1 FOR anio=YEAR(DATE()) AND mes>=MONTH(DATE())-2
			SELECT distinct(cve_cte) cve_cte, etiqueta, SUM(etiq) etiq FROM ctesnvos GROUP BY 1,2 INTO TABLE paso

			SELECT paso
			replace ALL etiqueta WITH "Frecuente" FOR etiq==3		
			replace ALL etiqueta WITH "Recurrente" FOR etiq==2
			replace ALL etiqueta WITH "Por_Recuperar" FOR etiq==1
			replace ALL etiqueta WITH "Olvidados" FOR etiq==0
			
			SELECT paso
			INDEX on cve_cte TO c
			SELECT ctesnvos
			SET RELATION TO cve_cte INTO paso
			replace ALL etiqueta WITH paso.etiqueta
			
		
		DROP TABLE paso
		
		replace ALL etiqueta WITH "Nuevo" FOR nuev_ret="Nuevo" AND anio==YEAR(DATE()) AND mes==MONTH(DATE())
		
SELECT ctesnvos
COPY TO rutadata + "Cliente\" + "ctesnvos"

***************************** Tabla segmentación de clientes ******************

SELECT distinct(cve_cte) cve_cte,nom_can, nom_cte,etiqueta,ult_mes, ALLTRIM(STR(anio_cte))+"_"+ALLTRIM(STR(mes_cte)) altacte,;
 sum(vent_net)/COUNT(vent_net) avg_vta,SUM(cnt_fac)/COUNT(vent_net) avg_fac,COUNT(vent_net) meses_vta,SPACE(50) contacto,SPACE(15) tel1_cte,SPACE(120) email_cte;
  FROM ctesnvos GROUP BY 1,2,3,4,5,6 INTO TABLE segfreccte
 
		**********************Pega info clientes*************************
		USE rutavsai + "clientes.dbf" IN 0 
		SELECT clientes
		INDEX on cve_cte TO a
		SELECT segfreccte
		SET RELATION TO cve_cte INTO clientes
		replace ALL email_cte WITH clientes.email_cte
		replace ALL contacto WITH clientes.contacto
		replace ALL tel1_cte WITH clientes.tel1_cte
		
SELECT clientes
USE 
 
SELECT nom_can, cve_cte, nom_cte,etiqueta,ult_mes, altacte,avg_vta,ROUND(avg_fac,0) avg_fac,meses_vta,contacto,tel1_cte,email_cte;
  FROM segfreccte INTO cursor fin

SELECT fin
COPY TO rutadata + "Cliente\" + "segfreccte"

SELECT nom_can,cve_cte,nom_cte,fecha,mon_prod,SUM(vent_net),no_fac,no_rem,nvta FROM vtascte GROUP BY 1,2,3,4,5,7,8,9 INTO cursor paso
SELECT paso
COPY TO rutadata + "Cliente\" + "detctesfac"


***********************Ventas por producto*************************
SELECT DATE(1999,1,1) fecha,MONTH(fecha) as MES, YEAR(fecha) as ANIO,fac,cve_cte,nom_cte,cve_prod,nom_can,Lugar,new_med ,COUNT(fac),SUM(vent_net) imp_tot,SUM(cant_surt) cant_ven,SUM(cant_dev) cant_dev FROM vtascte WHERE not EMPTY(fecha) GROUP BY 1,2,3,4,5,6,7,8,9,10 INTO TABLE paso2
SELECT paso2
replace ALL fecha WITH DATE(ANIO,mes,1)
replace ALL nom_cte WITH "cve_cte" + str(cve_cte) FOR empty(nom_cte)

ALTER table paso2 ADD COLUMN cse_prod c(10)
ALTER table paso2 ADD COLUMN sub_cse c(10)
ALTER table paso2 ADD COLUMN sub_subcse c(10)
ALTER table paso2 ADD COLUMN desc_prod c(40)
ALTER table paso2 ADD COLUMN mon_prod n(1)
ALTER table paso2 ADD COLUMN uni_med c(5)


**************Productos****************

USE rutavsai + "Producto" IN 0 EXCLUSIVE
SELECT Producto
INDEX on cve_prod TO a
SELECT paso2
SET RELATION TO cve_prod inTO Producto
replace ALL cse_prod WITH Producto.cse_prod 
replace ALL sub_cse WITH Producto.sub_cse
replace ALL sub_subcse WITH Producto.sub_subcse 
replace ALL desc_prod WITH Producto.desc_prod
replace ALL mon_Prod WITH Producto.cve_monc
replace ALL uni_med WITH Producto.uni_med
SELECT producto
USE

SELECT paso2

COPY TO rutadata + "Cliente\" + "cteprod"

*DROP TABLE paso
DROP TABLE paso2


DO 4_cxc
