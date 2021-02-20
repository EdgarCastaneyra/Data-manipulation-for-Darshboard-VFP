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


*STORE "C:\Users\Edgar\Documents\Visual FoxPro Projects\Merced\Tablero de Control\Dashboard\Programa Fox\Tablas\" TO rutavsai
*STORE "C:\Users\Edgar\Documents\Visual FoxPro Projects\Merced\Tablero de Control\Dashboard\Data\" TO rutadata

*STORE "C:\Users\Edgar\Documents\1.- Afficent\Dashboard\Dashboard\Data\" TO rutadata
*STORE "C:\Users\Edgar\Documents\1.- Afficent\Dashboard\Dashboard\Programa Fox\Tablas\" TO rutavsai



************************ Tabla maestra Productos **********************
		USE rutavsai + "ventas.dbf" IN 0
		USE rutavsai + "producto.dbf" IN 0
		
		SELECT fecha,DAY(fecha) DIA,MONTH(fecha) MES,YEAR(fecha) ANIO,cve_prod,vent_net ingreso,cost_prom,cant_surt,cant_dev,fac,space(1) documento FROM ventas INTO TABLE paso
		
		replace ALL documento WITH RIGHT(fac,1)
		SELECT MONTH(fecha) MES,YEAR(fecha) ANIO,documento,cve_prod,SUM(ingreso) imp_tot,SUM(cost_prom) cost_prom,SUM(cant_surt) cant_ven,SUM(cant_dev) cant_dev FROM paso GROUP BY 1,2,3,4 INTO TABLE paso1
		DROP TABLE paso
		
		ALTER table paso1 ADD COLUMN fecha d(8)
		replace ALL fecha WITH DATE(anio,mes,1)

		************ cruce con catalogo de productos **************
		ALTER table paso1 ADD COLUMN cse_prod c(10)
		ALTER table paso1 ADD COLUMN sub_cse c(10)
		ALTER table paso1 ADD COLUMN sub_subcse c(10)
		ALTER table paso1 ADD COLUMN desc_prod c(40)
		ALTER table paso1 ADD COLUMN des_tial c(40)
		ALTER table paso1 ADD COLUMN cve_tial n(10)
		ALTER table paso1 ADD COLUMN uni_med c(5)

		SELECT producto
		INDEX on cve_prod TO a
		SELECT paso1
		SET RELATION TO cve_prod INTO producto
		replace ALL uni_med WITH producto.uni_med 
		replace ALL cse_prod WITH producto.cse_prod
		replace ALL sub_cse WITH producto.sub_cse 
		replace ALL sub_subcse WITH producto.sub_subcse 
		replace ALL desc_prod WITH producto.desc_prod 
		replace ALL cve_tial WITH producto.cve_tial 
		select producto
		USE
		
		
		**************Tipo Producto****************

		USE rutavsai + "tipoalma" IN 0 EXCLUSIVE
		SELECT tipoalma
		INDEX on cve_tial TO a
		SELECT paso1
		SET RELATION TO cve_tial inTO tipoalma
		replace ALL des_tial WITH tipoalma.des_tial
		SELECT tipoalma
		USE
		
		ALTER table paso1 ADD COLUMN ult_mes c(7)
		ALTER table paso1 ADD COLUMN utilidad n(20)
		ALTER table paso1 ADD COLUMN ut_prom n(20)
				
	
		
		******************************************Pega la última fecha de compra******************************

		SELECT distinct(cve_prod) cve_prod, ult_mes FROM paso1 INTO TABLE ult_mes_vta

		SELECT cve_prod,YEAR(fecha) ANIO,MONTH(fecha) MES FROM ventas ORDER BY falta_rem DESC INTO CURSOR producto
		SELECT producto
		INDEX on cve_prod TO producto


		SELECT ult_mes_vta
		GO top IN ult_mes_vta
		DO WHILE !EOF('ult_mes_vta') 

			IF SEEK(ult_mes_vta.cve_prod, 'producto') THEN
				REPLACE ult_mes_vta.ult_mes WITH ALLTRIM(PADL(producto.ANIO,4,"0") + "_" + PADL(producto.MES,2,"0")) IN ult_mes_vta
			ENDIF

			SKIP 1 IN ult_mes_vta
		ENDDO 


		SELECT ult_mes_vta
		INDEX on cve_prod TO a
		SELECT paso1
		SET RELATION TO cve_prod INTO ult_mes_vta
		replace ALL ult_mes WITH ult_mes_vta.ult_mes 
		DROP TABLE ult_mes_vta

		*SELECT ventas 
		*USE

		SELECT paso1
		replace ALL utilidad WITH imp_tot-cost_prom
		replace ALL ut_prom WITH utilidad/cant_ven
				
COPY TO rutadata + "Producto\" + "Producto"

		
		
		
		
***********************CAtalogo de Productos  ****************
		SELECT distinct cse_prod,sub_cse,sub_subcse,desc_prod FROM paso1 INTO table catprod
		SELECT catprod
		DELETE ALL
		SELECT distinct cse_prod, sub_cse,sub_subcse, "Todos" desc_prod FROM catprod where DELETED() INTO TABLE paso
		SELECT catprod
		APPEND FROM paso
		SELECT distinct cse_prod,sub_cse,"Todos" sub_subcse, "Todos" desc_prod from catprod  where DELETED() INTO TABLE paso
		SELECT catprod
		APPEND FROM paso
		SELECT distinct cse_prod,"Todos" sub_cse,"Todos" sub_subcse, "Todos" desc_prod from catprod where DELETED() INTO TABLE paso
		SELECT catprod
		APPEND FROM paso
		SELECT distinct sub_subcse, "Todos" desc_prod FROM  catprod where DELETED() INTO TABLE paso
		SELECT catprod
		APPEND FROM paso
		SELECT distinct sub_cse, "Todos" sub_subcse, "Todos" desc_prod FROM  catprod where DELETED() INTO TABLE paso
		SELECT catprod
		APPEND FROM paso

		DROP TABLE paso

		SELECT catprod

		replace ALL cse_prod WITH "Todos" FOR EMPTY(cse_prod) AND NOT DELETED()
		replace ALL sub_cse WITH "Todos" FOR EMPTY(sub_cse) AND NOT DELETED()
		replace ALL sub_subcse WITH "Todos" FOR EMPTY(sub_subcse) AND NOT DELETED()

		ALTER table catprod ADD COLUMN llave c(70)
		Replace ALL llave WITH cse_prod + sub_cse + sub_subcse + desc_prod

		SELECT distinct(llave) llave FROM catprod INTO TABLE catprodok
		ALTER table catprodok ADD COLUMN cse_prod c(10)
		ALTER table catprodok ADD COLUMN sub_cse c(10)
		ALTER table catprodok ADD COLUMN sub_subcse c(10)
		ALTER table catprodok ADD COLUMN desc_prod c(40)

		SELECT catprod
		INDEX on llave TO a
		SELECT catprodok
		SET RELATION TO llave INTO catprod
		replace ALL cse_prod WITH catprod.cse_prod
		replace ALL sub_cse WITH catprod.sub_cse 
		replace ALL sub_subcse WITH catprod.sub_subcse 
		replace ALL desc_prod WITH catprod.desc_prod 
		DROP TABLE catprod 


		SELECT catprodok

		COPY TO rutadata + "producto\catprod"
		DROP TABLE catprodok
		DROP TABLE paso1


*********************** Existencias  ****************

USE rutadata + "Cliente\cteprod.dbf" IN 0

SELECT fecha,mes,anio,cve_prod,desc_prod,lugar,new_med,cse_prod,SUM(cant_ven) cant_ven FROM cteprod GROUP BY 1,2,3,4,5,6,7,8 INTO TABLE existepaso

SELECT cteprod
USE

ALTER table existepaso ADD COLUMN existencia n(20,8)

SELECT existepaso
		replace ALL lugar WITH "Tirden" for ALLTRIM(lugar)<>"A1ISO"
		replace ALL lugar WITH "ISO" for ALLTRIM(lugar)=="A1ISO"


**************atributo****************

SELECT existepaso
USE
ALTER table existepaso ADD COLUMN desc_med c(40)

USE rutavsai + "atributo" IN 0 EXCLUSIVE
SELECT atributo
INDEX on new_med TO a
SELECT existepaso
SET RELATION TO new_med inTO atributo
replace ALL desc_med WITH atributo.desc_med 
SELECT atributo
USE

SELECT existepaso

COPY TO rutadata + "producto\prodalma"

USE rutavsai + "existe.dbf" IN 0

SELECT cve_prod,lugar,SUM(existencia) existencia,new_med FROM existe GROUP BY 1,2,4 INTO TABLE existencia


SELECT existencia
		replace ALL lugar WITH "Tirden" for ALLTRIM(lugar)<>"A1ISO"
		replace ALL lugar WITH "ISO" for ALLTRIM(lugar)=="A1ISO"
		
ALTER table existencia ADD COLUMN cse_prod c(10)

**************Productos****************

SELECT producto 
USE


USE rutavsai + "Producto" IN 0 EXCLUSIVE
SELECT Producto
INDEX on cve_prod TO a
SELECT existencia
SET RELATION TO cve_prod inTO Producto
replace ALL cse_prod WITH Producto.cse_prod 
SELECT producto
USE

SELECT existencia
COPY TO rutadata + "producto\existencia"

SELECT existe
USE


DO 8_agentes