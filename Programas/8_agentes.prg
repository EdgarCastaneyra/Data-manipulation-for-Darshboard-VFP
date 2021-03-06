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

************************ Tabla maestra Agente **********************
		USE rutavsai + "ventas.dbf" IN 0
		
		SELECT fecha,hora,DAY(fecha) DIA,MONTH(fecha) MES,YEAR(fecha) ANIO,cve_prod,cve_age,cve_cte,vent_net ingreso,cant_surt,cant_dev,fac,space(1) documento,lugar FROM ventas INTO TABLE paso
		ALTER table paso ADD COLUMN cve_can n(10)
		ALTER table paso ADD COLUMN nom_can c(40)
		
		
				**********************Pega info canal de ventas*************************
				USE rutavsai + "clientes.dbf" IN 0 
				SELECT clientes
				INDEX on cve_cte TO a
				SELECT paso
				SET RELATION TO cve_cte INTO clientes
				replace ALL cve_can WITH clientes.cve_can
				
				SELECT clientes
				USE

				USE rutavsai + "canald.dbf" IN 0 SHARED
				SELECT canald
				INDEX on cve_can TO a
				SELECT paso
				SET RELATION TO cve_can INTO canald
				replace ALL nom_can WITH canald.nom_can
				replace ALL nom_can WITH "NA" FOR EMPTY(nom_can)

				SELECT canald
				USE
		
		
		SELECT paso
		
		replace ALL documento WITH RIGHT(fac,1)
		SELECT MES,ANIO,hora,documento,cve_age,cve_prod,fac,nom_can,lugar,SUM(ingreso) imp_tot,SUM(cant_surt) cant_ven,SUM(cant_dev) cant_dev FROM paso GROUP BY 1,2,3,4,5,6,7,8,9 INTO TABLE paso1
		DROP TABLE paso

		ALTER table paso1 ADD COLUMN nom_age c(40)
		


		**********************Pega info agentes*************************
		USE rutavsai + "agentes.dbf" IN 0 SHARED
		SELECT agentes
		INDEX on cve_age TO a
		SELECT paso1
		SET RELATION TO cve_age INTO agentes
		replace ALL nom_age WITH agentes.nom_age

		SELECT agentes
		USE
		
***********************Conteo de notas de venta Mostrador*************************
SELECT DATE(1999,1,1) fecha,MES,ANIO,documento,cve_age,nom_age,nom_can,lugar,COUNT(fac),SUM(imp_tot) imp_tot,SUM(cant_ven) cant_ven,SUM(cant_dev) cant_dev FROM paso1 WHERE anio<>0 OR mes<>0 GROUP BY 1,2,3,4,5,6,7,8 INTO TABLE paso2
SELECT paso2
replace ALL fecha WITH DATE(ANIO,mes,1)
replace ALL nom_age WITH "cve_age" + str(cve_age) FOR empty(nom_age)
COPY TO rutadata + "Agentes\" + "agevtahist"

DROP TABLE paso2


***********************Horario de notas de venta Mostrador*************************
SELECT DATE(1999,1,1) fecha,MES,ANIO,documento,cve_age,nom_age,nom_can,lugar,VAL(LEFT(hora,2)) hora,COUNT(fac),SUM(imp_tot) imp_tot,SUM(cant_ven) cant_ven,SUM(cant_dev) cant_dev FROM paso1 WHERE anio<>0 OR mes<>0 OR hora<>0 GROUP BY 1,2,3,4,5,6,7,8,9 INTO TABLE paso2
SELECT paso2
replace ALL fecha WITH DATE(ANIO,mes,1)
replace ALL nom_age WITH "cve_age" + str(cve_age) FOR empty(nom_age)
COPY TO rutadata + "Agentes\" + "agehora"


SELECT distinct lugar,nom_can tipo, (nom_age) nom_age FROM paso2 INTO table catage
SELECT distinct lugar,tipo, "Todos" nom_age FROM catage INTO TABLE paso4
SELECT catage
APPEND FROM paso4
SELECT distinct lugar,"Todos" tipo, "Todos" nom_age FROM catage INTO TABLE paso4
SELECT catage
APPEND FROM paso4
SELECT distinct "Todos" lugar, tipo, "Todos" nom_age FROM catage INTO TABLE paso4
SELECT catage
APPEND FROM paso4
SELECT distinct "Todos" lugar,"Todos" tipo, nom_age FROM catage INTO TABLE paso4
SELECT catage
APPEND FROM paso4

DROP TABLE paso4

APPEND BLANK
GO bottom
replace lugar WITH "Todos"
replace tipo WITH "Todos"
replace nom_age WITH "Todos"

COPY TO rutadata + "Agentes\" + "catage"

DROP TABLE paso2

***********************Ventas por producto*************************
SELECT DATE(1999,1,1) fecha,MES,ANIO,documento,cve_age,nom_age,cve_prod,nom_can,lugar,COUNT(fac),SUM(imp_tot) imp_tot,SUM(cant_ven) cant_ven,SUM(cant_dev) cant_dev FROM paso1 WHERE anio<>0 OR mes<>0 GROUP BY 1,2,3,4,5,6,7,8,9 INTO TABLE paso2
SELECT paso2
replace ALL fecha WITH DATE(ANIO,mes,1)
replace ALL nom_age WITH "cve_age" + str(cve_age) FOR empty(nom_age)

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

COPY TO rutadata + "Agentes\" + "ageprod"

DROP TABLE paso1
DROP TABLE paso2

DO 9_utilidad
