application.Visible=.t.
SET EXACT ON
CLOSE TABLES
*CLOSE DATABASES
SET safety OFF
SET TALK OFF
SET DATE FRENCH
SET CENTURY on
SET STATUS BAR OFF
SET DEFAULT TO SYS(5) + LEFT(SYS(2003),LEN(SYS(2003)))


****** configuración de variables publicas*****
PUBLIC rutavsai, rutadata

*STORE "C:\VSAI\afficent\Tablas\" TO rutavsai &&tirden
*STORE "C:\VSAI\afficent\Dashboard\Data\" TO rutadata &&tirden

*STORE "C:\VSAI\Afficent\Dashboard_COMER19\Tablas\" TO rutavsai &&tirden
*STORE "C:\VSAI\Afficent\Dashboard_COMER19\Data\" TO rutadata &&tirden

STORE "D:\AFFICENT\Clientes SAI\Dimefet\Dashboard\Data\" TO rutadata
STORE "D:\AFFICENT\Clientes SAI\Dimefet\Tablas\" TO rutavsai



SET EXACT ON


******Notas de Venta********
USE rutavsai + "nventasc" IN 0 EXCLUSIVE
SELECT ALLTRIM((ALLTRIM(cve_factu)+ " " + ALLTRIM(factura))) No_FAC,cve_suc,cve_cte,cve_age,usuario,cve_factu,;
No_FAC nvta, falta_fac falta_nvta,Status_fac Status_nvt,cve_mon,tip_cam TC_NVTA,descuento descue,hravta hora_nvta,lugar;
FROM nventasc INTO TABLE nvtapaso

SELECT nventasc
USE

USE rutavsai + "nventasd" IN 0 EXCLUSIVE
SELECT ALLTRIM((SPACE(3)+ " " + SPACE(10))) No_FAC, no_ped,cve_suc,SPACE(3) cve_factu,lote, ;
No_FAC nvta,cve_prod,cant_surt cant_surtn,valor_prod valor_pron,descu_prod descu_pron,subt_prod subt_prodn,Iva_prod Iva_prodn,cost_prom cost_promn,cost_repo cost_repon, new_med,;
00000.0000 descuen,SPACE(8) hora_nvta,DATE(1999,01,01) falta_nvta,SPACE(10) Status_nvt,SPACE(10) Status_fin,00 cve_mon,0000000000.0000 TC_NVTA,SPACE(10) lugar, "N" rem_fac,00000 cve_cte,00000 cve_age,DATE(1999,01,01) f_pago,0000000000 usuario ;
FROM nventasd INTO TABLE nvtadpaso

SELECT nventasd
USE

*SET STEP ON

SELECT nvtapaso
INDEX on ALLTRIM(STR(nvta)) + ALLTRIM(cve_suc) TO a  &&Preguntar si usa el campo sucursal
*INDEX on nvta TO a
SELECT nvtadpaso
SET RELATION TO ALLTRIM(STR(nvta)) + ALLTRIM(cve_suc) inTO nvtapaso
*SET RELATION TO nvta inTO nvtapaso
replace ALL Status_nvt WITH nvtapaso.Status_nvt
DELETE FOR Status_nvt="Cancelada" &&Elimina las canceladas
PACK


SELECT nvtapaso
INDEX on ALLTRIM(STR(nvta)) + ALLTRIM(cve_suc) TO a  &&Preguntar si usa el campo sucursal
*INDEX on nvta TO a
SELECT nvtadpaso
SET RELATION TO ALLTRIM(STR(nvta)) + ALLTRIM(cve_suc) inTO nvtapaso
*SET RELATION TO nvta inTO nvtapaso


replace ALL hora_nvta WITH nvtapaso.hora_nvta
replace ALL falta_nvta WITH nvtapaso.falta_nvta
replace ALL cve_mon WITH nvtapaso.cve_mon
replace ALL TC_NVTA WITH nvtapaso.TC_NVTA
replace ALL lugar WITH nvtapaso.lugar
replace ALL cve_cte WITH nvtapaso.cve_cte 
replace ALL cve_age WITH nvtapaso.cve_age 
replace ALL usuario WITH nvtapaso.usuario 
replace ALL descuen WITH (descu_pron/subt_prodn)*100 FOR descu_pron<>0
replace ALL rem_fac WITH "N" &&Pone una N para diferenciar las que son por nota de venta
replace ALL no_fac WITH nvtapaso.no_fac &&Esta es la llave para reelacionar con las facturas
replace ALL cve_factu WITH nvtapaso.cve_factu &&Esta es la llave para reelacionar con las facturas

ALTER table nvtadpaso ADD COLUMN status_rem c(10)
ALTER table nvtadpaso ADD COLUMN TC_rem n(10,4)
ALTER table nvtadpaso ADD COLUMN no_rem n(10)
ALTER table nvtadpaso ADD COLUMN falta_rem d(8)
ALTER table nvtadpaso ADD COLUMN hora_rem c(8)
ALTER table nvtadpaso ADD COLUMN cant_surtr n(20,8)
ALTER table nvtadpaso ADD COLUMN valor_pror n(20,8)
ALTER table nvtadpaso ADD COLUMN descu_pror n(20,6)
ALTER table nvtadpaso ADD COLUMN subt_prodr n(20,6)
ALTER table nvtadpaso ADD COLUMN Iva_prodr n(7,2)
ALTER table nvtadpaso ADD COLUMN cost_promr n(20,8)
ALTER table nvtadpaso ADD COLUMN cost_repor n(20,8)
ALTER table nvtadpaso ADD COLUMN descuer n(20,8)

ALTER table nvtadpaso ADD COLUMN status_fac c(10)
ALTER table nvtadpaso ADD COLUMN TC_fac n(10,4)
ALTER table nvtadpaso ADD COLUMN falta_fac d(8)
ALTER table nvtadpaso ADD COLUMN hora_fac c(8)
ALTER table nvtadpaso ADD COLUMN cant_surtf n(20,8)
ALTER table nvtadpaso ADD COLUMN valor_prof n(20,8)
ALTER table nvtadpaso ADD COLUMN descu_prof n(20,6)
ALTER table nvtadpaso ADD COLUMN subt_prodf n(20,6)
ALTER table nvtadpaso ADD COLUMN Iva_prodf n(7,2)
ALTER table nvtadpaso ADD COLUMN cost_promf n(20,8)
ALTER table nvtadpaso ADD COLUMN cost_repof n(20,8)
ALTER table nvtadpaso ADD COLUMN descuef n(20,8)
ALTER table nvtadpaso ADD COLUMN part_fac n(6)


ALTER table nvtadpaso ADD COLUMN cant_surt n(20,8)
ALTER table nvtadpaso ADD COLUMN valor_prod n(20,8)
ALTER table nvtadpaso ADD COLUMN descu_prod n(20,6)
ALTER table nvtadpaso ADD COLUMN subt_prod n(20,6)
ALTER table nvtadpaso ADD COLUMN Iva_prod n(7,2)
ALTER table nvtadpaso ADD COLUMN cost_prom n(20,8)
ALTER table nvtadpaso ADD COLUMN cost_repo n(20,8)
ALTER table nvtadpaso ADD COLUMN descue n(20,8)

ALTER table nvtadpaso ADD COLUMN status_ped c(10)
ALTER table nvtadpaso ADD COLUMN hora_ped c(8)
ALTER table nvtadpaso ADD COLUMN f_alta_ped d(8)
ALTER table nvtadpaso ADD COLUMN TC_ped n(10,4)

ALTER table nvtadpaso ADD COLUMN cant_dev n(20,8)

DELETE FOR Status_nvt="Cancelada" &&Elimina las canceladas
PACK

DROP TABLE nvtapaso

 
******Facturas********
USE rutavsai + "Facturac" IN 0 EXCLUSIVE
SELECT ALLTRIM((ALLTRIM(cve_factu)+ " " + ALLTRIM(No_FAC))) No_FAC,cve_suc,cve_cte,cve_age,usuario,cve_factu,;
 falta_fac,Status_fac,cve_mon,tip_cam TC_fac,descue,hora_fac,lugar,f_pago FROM facturac INTO TABLE faccpaso
SELECT facturac
USE

USE rutavsai + "Facturad" IN 0 EXCLUSIVE
SELECT ALLTRIM((ALLTRIM(cve_factu)+ " " + ALLTRIM(No_FAC))) No_FAC,no_rem,no_ped,cve_suc,cve_factu,lote,part_fac,;
cve_prod,cant_surt cant_surtf,valor_prod valor_prof,descu_prod descu_prof,subt_prod subt_prodf,Iva_prod Iva_prodf,cost_prom cost_promf,cost_repo cost_repof, new_med,;
00000.0000 descuef,SPACE(8) hora_fac,DATE(1999,01,01) falta_fac,SPACE(10) Status_fac,00 cve_mon,0000000000.0000 TC_fac,SPACE(10) lugar, "F" rem_fac,00000 cve_cte,00000 cve_age,DATE(1999,01,01) f_pago,0000000000 usuario;
 FROM facturad INTO TABLE facdpaso
SELECT facturad
USE



*SELECT faccpaso
*INDEX on no_fac TO a
*SELECT facdpaso
*SET RELATION TO no_fac inTO faccpaso

*replace ALL cve_suc WITH faccpaso.cve_suc &&FOR EMPTY(facdpaso.cve_suc)

*SET RELATION TO


SELECT faccpaso
INDEX on ALLTRIM(no_fac) TO a
*INDEX on no_fac TO a
SELECT facdpaso
SET RELATION TO ALLTRIM(no_fac) inTO faccpaso
*SET RELATION TO no_fac inTO faccpaso
replace ALL status_fac WITH faccpaso.status_fac

DELETE FOR status_fac="Cancelada"
PACK



SELECT faccpaso
*INDEX on ALLTRIM(no_fac) + ALLTRIM(cve_suc) TO a
INDEX on no_fac TO a
SELECT facdpaso
*SET RELATION TO ALLTRIM(no_fac) + ALLTRIM(cve_suc) inTO faccpaso
SET RELATION TO no_fac inTO faccpaso


replace ALL hora_fac WITH faccpaso.hora_fac 
replace ALL falta_fac WITH faccpaso.falta_fac
replace ALL cve_mon WITH faccpaso.cve_mon
replace ALL TC_fac WITH faccpaso.TC_fac 
replace ALL lugar WITH faccpaso.lugar
replace ALL cve_cte WITH faccpaso.cve_cte 
replace ALL cve_age WITH faccpaso.cve_age 
replace ALL f_pago WITH faccpaso.f_pago 
replace ALL usuario WITH faccpaso.usuario 
replace ALL descuef WITH (descu_prof/subt_prodf)*100 FOR descu_prof<>0

DELETE FOR status_fac="Cancelada"
PACK

DROP TABLE faccpaso

		**********Notas de Ventas Facturadas*********
		SELECT facdpaso
		*INDEX on ALLTRIM(no_fac) TO a
		INDEX on ALLTRIM(no_fac) + ALLTRIM(cve_suc) TO a
		SELECT nvtadpaso
		*SET RELATION TO ALLTRIM(no_fac) inTO facdpaso
		SET RELATION TO ALLTRIM(no_fac) + ALLTRIM(cve_suc) inTO facdpaso
		
		replace ALL status_fac with facdpaso.status_fac
		replace ALL TC_fac with facdpaso.TC_fac
		replace ALL falta_fac with facdpaso.falta_fac 
		replace ALL hora_fac with facdpaso.hora_fac
		replace ALL no_rem with facdpaso.no_rem
		replace ALL part_fac with facdpaso.part_fac 
		SET RELATION to
		
		SELECT facdpaso
		*INDEX on ALLTRIM(no_fac) + ALLTRIM(cve_prod)+ ALLTRIM(new_med) TO a
		INDEX on ALLTRIM(no_fac) + ALLTRIM(cve_suc) + ALLTRIM(cve_prod)+ ALLTRIM(new_med) + ALLTRIM(lote) TO a
		SELECT nvtadpaso
		*SET RELATION TO ALLTRIM(no_fac) + ALLTRIM(cve_prod)+ ALLTRIM(new_med) inTO facdpaso
		SET RELATION TO ALLTRIM(no_fac) + ALLTRIM(cve_suc) + ALLTRIM(cve_prod)+ ALLTRIM(new_med) + ALLTRIM(lote) inTO facdpaso
		
		replace ALL cant_surtf with facdpaso.cant_surtf
		replace ALL valor_prof with facdpaso.valor_prof
		replace ALL descu_prof with facdpaso.descu_prof
		replace ALL subt_prodf with facdpaso.subt_prodf
		replace ALL Iva_prodf with facdpaso.Iva_prodf
		replace ALL cost_promf with facdpaso.cost_promf
		replace ALL cost_repof with facdpaso.cost_repof
		replace ALL descuef with facdpaso.descuef 
		replace ALL part_fac with facdpaso.part_fac 
		
		SET RELATION to
		
		**********Notas de Ventas NO Facturadas*********
		SELECT nvtadpaso
		*INDEX on ALLTRIM(no_fac) TO b
		INDEX on ALLTRIM(no_fac) + ALLTRIM(cve_suc) TO b
		SELECT facdpaso
		*SET RELATION TO ALLTRIM(no_fac) INTO nvtadpaso
		SET RELATION TO ALLTRIM(no_fac) + ALLTRIM(cve_suc) INTO nvtadpaso
		DELETE FOR  nvtadpaso.no_fac==facdpaso.no_fac
		SELECT * FROM facdpaso where NOT DELETED() INTO TABLE paso
		SELECT nvtadpaso
		APPEND FROM paso
		
		DROP TABLE paso
		

******Remisiones********
USE rutavsai + "Remc" IN 0 EXCLUSIVE
SELECT No_rem,suc_rem cve_suc,cve_cte,cve_age,usuario,;
falta_rem,Status_rem ,cve_mon,tip_cam TC_rem,descue,hora_rem,lugar FROM remc INTO TABLE remcpaso
SELECT remc
USE

USE rutavsai + "remd" IN 0 EXCLUSIVE
SELECT No_rem,suc_rem cve_suc,no_ped,lote,;
cve_prod,cant_surt cant_surtr,valor_prod valor_pror,descu_prod descu_pror,subt_prod subt_prodr,Iva_prod Iva_prodr,cost_prom cost_promr,cost_repo cost_repor, new_med,;
00000.000 descuer,SPACE(8) hora_rem,DATE() falta_rem,SPACE(10) lugar,SPACE(10) Status_rem,00 cve_mon,0000000000.0000 TC_rem, "R" rem_fac,00000 cve_cte,00000 cve_age,DATE(1999,01,01) f_pago,0000000000 usuario ;
FROM remd INTO TABLE remdpaso

SELECT remd
USE

SELECT remcpaso
INDEX on ALLTRIM(STR(no_rem)) + ALLTRIM(cve_suc) TO c
*INDEX on no_rem TO c
SELECT remdpaso
SET RELATION TO ALLTRIM(STR(no_rem)) + ALLTRIM(cve_suc) inTO remcpaso
*SET RELATION TO no_rem inTO remcpaso
replace ALL status_rem WITH remcpaso.status_rem
DELETE FOR status_rem="Cancelada"
PACK


SELECT remcpaso
INDEX on ALLTRIM(STR(no_rem)) + ALLTRIM(cve_suc) TO c
*INDEX on no_rem TO c
SELECT remdpaso
SET RELATION TO ALLTRIM(STR(no_rem)) + ALLTRIM(cve_suc) inTO remcpaso
*SET RELATION TO no_rem inTO remcpaso


replace ALL hora_rem WITH remcpaso.hora_rem
replace ALL falta_rem WITH remcpaso.falta_rem
replace ALL cve_mon WITH remcpaso.cve_mon
replace ALL TC_rem WITH remcpaso.TC_rem
replace ALL lugar WITH remcpaso.lugar
replace ALL cve_cte WITH remcpaso.cve_cte 
replace ALL cve_age WITH remcpaso.cve_age 
replace ALL usuario WITH remcpaso.usuario 
replace ALL descuer WITH (descu_pror/subt_prodr)*100 FOR descu_pror<>0
replace ALL rem_fac WITH "R"


DROP TABLE remcpaso

		**********Remisiones Facturadas*********
		SELECT remdpaso
		*INDEX on ALLTRIM(STR(no_rem)) TO c
		INDEX on ALLTRIM(STR(no_rem)) + ALLTRIM(cve_suc) TO c
		SELECT nvtadpaso
		*SET RELATION TO ALLTRIM(STR(no_rem)) INTO remdpaso
		SET RELATION TO ALLTRIM(STR(no_rem)) + ALLTRIM(cve_suc) INTO remdpaso
		
		replace ALL status_rem with remdpaso.status_rem
		replace ALL TC_rem with remdpaso.TC_rem
		replace ALL falta_rem with remdpaso.falta_rem 
		replace ALL hora_rem with remdpaso.hora_rem
		replace ALL rem_fac with "R" FOR nvtadpaso.no_rem==remdpaso.no_rem AND nvtadpaso.no_rem<>0
		SET RELATION to

		SELECT remdpaso
		*INDEX on ALLTRIM(STR(no_rem)) + ALLTRIM(cve_prod) + ALLTRIM(new_med) TO c
		INDEX on ALLTRIM(STR(no_rem)) + ALLTRIM(cve_suc) + ALLTRIM(cve_prod) + ALLTRIM(new_med) + ALLTRIM(lote) TO c
		SELECT nvtadpaso
		*SET RELATION TO ALLTRIM(STR(no_rem)) + ALLTRIM(cve_prod) + ALLTRIM(new_med) INTO remdpaso
		SET RELATION TO ALLTRIM(STR(no_rem)) + ALLTRIM(cve_suc) + ALLTRIM(cve_prod) + ALLTRIM(new_med) + ALLTRIM(lote) INTO remdpaso
		
		replace ALL cant_surtr with remdpaso.cant_surtr
		replace ALL valor_pror with remdpaso.valor_pror
		replace ALL descu_pror with remdpaso.descu_pror
		replace ALL subt_prodr with remdpaso.subt_prodr
		replace ALL Iva_prodr with remdpaso.Iva_prodr
		replace ALL cost_promr with remdpaso.cost_promr
		replace ALL cost_repor with remdpaso.cost_repor
		replace ALL descuer with remdpaso.descuer 

		SET RELATION to

		
		**********Remisiones NO Facturadas*********
		SELECT nvtadpaso
		*INDEX on ALLTRIM(STR(no_rem)) TO b
		INDEX on ALLTRIM(STR(no_rem)) + ALLTRIM(cve_suc) TO b
		SELECT remdpaso
		*SET RELATION TO ALLTRIM(STR(no_rem)) INTO nvtadpaso
		SET RELATION TO ALLTRIM(STR(no_rem)) + ALLTRIM(cve_suc) INTO nvtadpaso
		DELETE FOR  nvtadpaso.No_rem==remdpaso.No_rem
		SELECT * FROM remdpaso where NOT DELETED() INTO TABLE paso
		SELECT nvtadpaso
		APPEND FROM paso
		
		DROP TABLE paso
		DROP TABLE remdpaso
		DROP TABLE facdpaso

****************PEDIDOS*********************************

USE rutavsai + "pedidoc" IN 0 EXCLUSIVE
SELECT No_ped,;
f_alta_ped,hora_ped,tip_cam,status status_ped FROM pedidoc INTO TABLE pedcpaso
SELECT pedidoc
USE

		**********Datos de Pedidos*********
		SELECT pedcpaso
		INDEX on No_ped TO c
		SELECT nvtadpaso
		SET RELATION TO No_ped INTO pedcpaso
		replace ALL status_ped with pedcpaso.status_ped
		replace ALL f_alta_ped with pedcpaso.f_alta_ped
		replace ALL hora_ped with pedcpaso.hora_ped 
		replace ALL TC_ped with pedcpaso.tip_cam 
		SET RELATION to

DROP TABLE pedcpaso


********Devoluciones***************

USE rutavsai + "creditos" IN 0 EXCLUSIVE
SELECT No_nota, fecha,(ALLTRIM(cve_factu)+ " " + ALLTRIM(No_FAC)) No_FAC,cve_suc,;
tip_not,no_estado FROM creditos INTO TABLE credpaso
SELECT creditos
USE

USE rutavsai + "creditod" IN 0 EXCLUSIVE
SELECT No_nota,;
cve_prod,newmed, cantidad,costo_prom cost_prom,;
SPACE(10) No_fac, space(100) llave, space(40) tip_not,space(40) no_estado,SPACE(10) Cve_suc,lote,part_fac ;
FROM creditod INTO TABLE creddpaso
SELECT creditod
USE

SELECT credpaso
INDEX on ALLTRIM(no_nota) TO a
SELECT creddpaso 
SET RELATION TO ALLTRIM(no_nota) INTO credpaso
replace ALL no_fac WITH credpaso.no_fac
replace ALL llave WITH ALLTRIM(cve_prod) + "_" +ALLTRIM(no_fac)+ "_" +ALLTRIM(cve_suc) +ALLTRIM(newmed)+ ALLTRIM(lote)
replace ALL no_estado WITH credpaso.no_estado
replace ALL tip_not WITH credpaso.tip_not
replace ALL Cve_suc WITH credpaso.Cve_suc 

REPLACE ALL cost_prom WITH 0 FOR STR(cost_prom)="**********"

SELECT creddpaso 
DELETE FOR tip_not="Dev. Just.  " AND no_estado="Cancelada"
PACK

DROP TABLE credpaso
SELECT creddpaso
INDEX on ALLTRIM(cve_prod) + ALLTRIM(no_fac)+ ALLTRIM(newmed)+ALLTRIM(lote)+ALLTRIM(STR(part_fac)) TO a
*INDEX on ALLTRIM(cve_prod) + ALLTRIM(no_fac)+ ALLTRIM(cve_suc) + ALLTRIM(newmed) TO a
SELECT nvtadpaso
SET RELATION TO ALLTRIM(cve_prod) + ALLTRIM(no_fac)+ ALLTRIM(new_med)+ALLTRIM(lote)+ ALLTRIM(STR(part_fac)) INTO creddpaso
*SET RELATION TO ALLTRIM(cve_prod) + ALLTRIM(no_fac)+ ALLTRIM(cve_suc) + ALLTRIM(new_med) INTO creddpaso

replace ALL cant_dev WITH -creddpaso.cantidad FOR creddpaso.tip_not="Dev. Just.   "
replace ALL cost_promf WITH cost_promf - creddpaso.cost_prom FOR cost_promf>0 AND creddpaso.cost_prom>0
replace ALL cost_repof WITH cost_repof - creddpaso.cost_prom FOR cost_repof>0

DROP TABLE creddpaso

*!*	**************Moneda del Productos****************

ALTER table nvtadpaso ADD COLUMN mon_prod n(1)

USE rutavsai + "Producto" IN 0 EXCLUSIVE
SELECT Producto
INDEX on cve_prod TO a
SELECT nvtadpaso
SET RELATION TO cve_prod inTO Producto
replace ALL mon_Prod WITH Producto.cve_monc
SELECT producto
USE


**********Tabla de Ventas************

SELECT nvtadpaso

SELECT *,;
00000.00 TC,00000000000000000000.0000 VENT_NET,00000000000000000000.0000 VENT_TOT,00000000000000000000.0000 VENT_DEV,no_fac fac,SPACE(8) hora, DATE(1999,1,1) fecha;
 FROM nvtadpaso INTO TABLE paso
 
 SELECT paso
 

 replace ALL status_fin WITH "PED" FOR status_ped="SURTIDO"
 replace ALL status_fin WITH "NV" FOR status_nvt="PAGADA"
 replace ALL status_fin WITH "REM" FOR status_rem="FACTURADA" 
 replace ALL status_fin WITH "FAC" FOR status_fac="PAGADA"
 
 
 replace ALL fac WITH ALLTRIM(STR(no_ped))+"_"+ALLTRIM(rem_fac) FOR no_ped<>0
 replace ALL fac WITH ALLTRIM(STR(nvta))+"_"+ALLTRIM(rem_fac) FOR nvta<>0
 replace ALL fac WITH ALLTRIM(STR(no_rem))+"_"+ALLTRIM(rem_fac) FOR no_rem<>0 AND no_ped==0 
 replace ALL fac WITH ALLTRIM(no_fac)+"_"+ALLTRIM(rem_fac) FOR rem_fac=="F" AND no_rem==0
 
 
 replace ALL fecha WITH f_alta_ped FOR no_ped<>0
 replace ALL fecha WITH falta_nvta FOR nvta<>0
 replace ALL fecha WITH falta_rem FOR no_rem<>0 AND no_ped==0 
 replace ALL fecha WITH falta_fac FOR rem_fac=="F" AND no_rem==0
 
 replace ALL hora WITH hora_ped FOR no_ped<>0
 replace ALL hora WITH hora_nvta FOR nvta<>0
 replace ALL hora WITH hora_rem FOR no_rem<>0 AND no_ped==0 
 replace ALL hora WITH hora_fac FOR rem_fac=="F" AND no_rem==0

 replace ALL TC WITH TC_ped FOR no_ped<>0
 replace ALL TC WITH TC_nvta FOR nvta<>0
 replace ALL TC WITH TC_rem FOR no_rem<>0 AND no_ped==0 
 replace ALL TC WITH TC_fac FOR rem_fac=="F" AND no_rem==0
 
 replace ALL cant_surt WITH cant_surtn FOR nvta<>0
 replace ALL cant_surt WITH cant_surtr FOR no_rem<>0 
 replace ALL cant_surt WITH cant_surtf FOR rem_fac=="F" AND no_rem==0

 replace ALL valor_prod WITH valor_pron FOR nvta<>0
 replace ALL valor_prod WITH valor_pror FOR no_rem<>0
 replace ALL valor_prod WITH valor_prof FOR rem_fac=="F" AND no_rem==0

 replace ALL descu_prod WITH descu_pron FOR nvta<>0
 replace ALL descu_prod WITH descu_pror FOR no_rem<>0
 replace ALL descu_prod WITH descu_prof FOR rem_fac=="F" AND no_rem==0

 replace ALL subt_prod WITH subt_prodn FOR nvta<>0
 replace ALL subt_prod WITH subt_prodr FOR no_rem<>0
 replace ALL subt_prod WITH subt_prodf FOR rem_fac=="F" AND no_rem==0

 replace ALL Iva_prod WITH Iva_prodn FOR nvta<>0
 replace ALL Iva_prod WITH Iva_prodr FOR no_rem<>0
 replace ALL Iva_prod WITH Iva_prodf FOR rem_fac=="F" AND no_rem==0

 REPLACE ALL cost_prom WITH 0 FOR STR(cost_prom)="**********"
 REPLACE ALL cost_promr WITH 0 FOR STR(cost_promr)="**********"
 REPLACE ALL cost_promf WITH 0 FOR STR(cost_promf)="**********"

 replace ALL cost_prom WITH cost_promn FOR nvta<>0
 replace ALL cost_prom WITH cost_promr FOR no_rem<>0
 replace ALL cost_prom WITH cost_promf FOR rem_fac=="F" AND no_rem==0

 replace ALL cost_repo WITH cost_repon FOR nvta<>0
 replace ALL cost_repo WITH cost_repor FOR no_rem<>0
 replace ALL cost_repo WITH cost_repof FOR rem_fac=="F" AND no_rem==0

 replace ALL descue WITH descuen FOR nvta<>0
 replace ALL descue WITH descuer FOR no_rem<>0
 replace ALL descue WITH descuef FOR rem_fac=="F" AND no_rem==0



 replace ALL VENT_NET  WITH ((((cant_surt+cant_dev)*valor_prod)*(1-descue/100))*(1+iva_prod/100)) *IIF(cve_mon=1,1,TC)

 replace ALL VENT_TOT WITH (((cant_surt*valor_prod)*(1-descuen/100))*(1+iva_prod/100)) *IIF(cve_mon=1,1,TC)

 replace ALL VENT_DEV WITH ((((-cant_dev)*valor_prod)*(1-descue/100))*(1+iva_prod/100)) FOR cant_dev<0 *IIF(cve_mon=1,1,TC)


DELETE FOR year(FECHA)=0
PACK


COPY TO rutavsai + "ventas"
COPY TO rutadata + "ventas\" + "ventas"
DROP TABLE nvtadpaso
DROP TABLE paso


DO 2_compras

