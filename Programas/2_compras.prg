CLOSE TABLES
SET safety OFF
SET TALK OFF
SET DATE FRENCH
SET CENTURY on
SET STATUS BAR OFF
SET DEFAULT TO SYS(5) + LEFT(SYS(2003),LEN(SYS(2003)))


****** configuración de variables publicas*****
PUBLIC rutavsai, rutadata


*STORE "C:\Users\edg19\Dashboard\Data\" TO rutadata
*STORE "C:\Users\edg19\Dashboard\Programa Fox\Tablas\" TO rutavsai


SET EXACT ON


******Facturas de Compra********
USE rutavsai + "comprafc" IN 0 EXCLUSIVE
SELECT no_fcomp, ALLTRIM(ALLTRIM(No_facc)+ " " + ALLTRIM(STR(cve_prov))) No_FAC,cve_suc,cve_prov,usuario,no_pedc,no_orda,;
no_facc fac_comp, falta_fac, Status_fac, lugar, cve_mon,tip_cam,descuento descue,u_tip_cam,fech_revi,fech_venci,fech_auto;
FROM comprafc INTO TABLE faccpaso

SELECT comprafc
USE

USE rutavsai + "comprafd" IN 0 EXCLUSIVE
SELECT ALLTRIM(ALLTRIM(No_facc)+ " " + ALLTRIM(STR(cve_prov))) No_FAC,cve_prov, no_pedc,no_req,cve_suc, ;
cve_prod,cant_surt,valor_prod,descu_prod,subt_prod,Iva_prod, new_med,;
SPACE(10) fac_comp,0000000000 no_fcomp,00000.0000 descue,DATE(1999,01,01) falta_fac,SPACE(10) Status_fac,00 cve_mon,0000000000.0000 tip_cam,0000000000.0000 u_tip_cam,SPACE(10) lugar, "C" rem_fac,DATE(1999,01,01) fech_revi,DATE(1999,01,01) fech_venci,DATE(1999,01,01) fech_auto,0000000000 usuario ;
FROM comprafd INTO TABLE faccdpaso

SELECT comprafd
USE

SELECT faccpaso
INDEX on ALLTRIM(No_FAC) + ALLTRIM(cve_suc) TO a
*INDEX on No_FAC TO a
SELECT faccdpaso
SET RELATION TO ALLTRIM(No_FAC) + ALLTRIM(cve_suc) inTO faccpaso
*SET RELATION TO No_FAC inTO faccpaso
replace ALL Status_fac WITH faccpaso.Status_fac
DELETE FOR Status_fac="Cancelada" &&Elimina las canceladas
PACK

SELECT faccpaso
INDEX on ALLTRIM(No_FAC) + ALLTRIM(cve_suc) TO a
SELECT faccdpaso
SET RELATION TO ALLTRIM(No_FAC) + ALLTRIM(cve_suc) inTO faccpaso

replace ALL falta_fac WITH faccpaso.falta_fac
replace ALL cve_mon WITH faccpaso.cve_mon
replace ALL tip_cam WITH faccpaso.tip_cam
replace ALL u_tip_cam WITH faccpaso.u_tip_cam
replace ALL lugar WITH faccpaso.lugar
replace ALL cve_prov WITH faccpaso.cve_prov 
replace ALL no_fcomp WITH faccpaso.no_fcomp 
replace ALL usuario WITH faccpaso.usuario 
replace ALL fech_revi WITH faccpaso.fech_revi 
replace ALL fech_venci WITH faccpaso.fech_venci 
replace ALL fech_auto WITH faccpaso.fech_auto 
replace ALL fac_comp WITH faccpaso.fac_comp 
replace ALL descue WITH (descu_prod/subt_prod)*100 FOR descu_prod<>0


DROP TABLE faccpaso


**************Moneda del Productos****************

ALTER table faccdpaso ADD COLUMN mon_prod n(1)

USE rutavsai + "Producto" IN 0 EXCLUSIVE
SELECT Producto
INDEX on ALLTRIM(cve_prod) TO a
SELECT faccdpaso 
SET RELATION TO ALLTRIM(cve_prod) inTO Producto
replace ALL mon_Prod WITH Producto.cve_monc
SELECT producto
USE


**********Tabla de Compras************

SELECT faccdpaso

alter TABLE faccdpaso add column TC n(5,2)
alter TABLE faccdpaso add column COMP_NET n(20,4)
alter TABLE faccdpaso add column FAC c(20)
alter TABLE faccdpaso add column fecha d(8)
 
replace ALL fac WITH no_fac
replace ALL fecha WITH falta_fac
replace ALL TC WITH tip_cam
 
replace ALL COMP_NET WITH ((((cant_surt)*valor_prod)*(1-descue/100))*(1+iva_prod/100))*TC FOR cve_mon=2 &&Moneda del documento 
replace ALL COMP_NET WITH ((((cant_surt)*valor_prod)*(1-descue/100))*(1+iva_prod/100)) FOR cve_mon=1  &&Moneda del documento  

COPY TO rutavsai + "compras"
DROP TABLE faccdpaso

DO 3_clientes