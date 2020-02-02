/*TP2 PARTIE 0*/

/*Le champ V_Date doit être ajouté à la table vente. Donner une date aléatoire, pour chaque vente, durant les années 2019 & 2020. */
update Vente set V_Date = DATEADD(DAY,ABS(CHECKSUM(NEWID())) %730, '2019-01-01');

/*FRACTION DW en DW1 et DW2*/

/*REMPLIRE DW1 2020*/
SET IDENTITY_INSERT  DW1.dbo.Client ON
insert into DW1.dbo.Client (C_ID,C_Mat,C_date_ajout,C_date_modification,C_Type)(
select C_ID,C_Mat,C_date_ajout,C_date_modification,C_Type from ERP_BDD.dbo.Client C
where C.C_ID in (select V.C_ID from ERP_BDD.dbo.Vente V where year(V.V_Date)=2020) ) ;
SET IDENTITY_INSERT  DW1.dbo.Client OFF




SET IDENTITY_INSERT  DW1.dbo.Commercial ON
insert into DW1.dbo.Commercial(Com_ID,Com_prenom,Com_nom,Com_DateEntree)(
select Com_ID,Com_prenom,Com_nom,Com_DateEntree from ERP_BDD.dbo.Commercial C
where C.Com_ID in (select V.Com_ID from ERP_BDD.dbo.Vente V where year(V.V_Date)=2020) ) ;
SET IDENTITY_INSERT  DW1.dbo.Commercial OFF



SET IDENTITY_INSERT  DW1.dbo.Historique_Client ON
insert into DW1.dbo.Historique_Client(HC_ID,C_ID,C_Mat_ancien,C_Type_ancien)(
select H.HC_ID,H.C_ID,C_Mat_ancien,C_Type_ancien from ERP_BDD.dbo.Historique_Client H
where H.HC_ID in (select V.Com_ID from ERP_BDD.dbo.Vente V where year(V.V_Date)=2020) ) ;
SET IDENTITY_INSERT  DW1.dbo.Historique_Client OFF


SET IDENTITY_INSERT  DW1.dbo.Produit ON
insert into DW1.dbo.Produit(P_ID,P_Montant_HT,P_TVA,P_QuantiteRestante)(
select  P_ID,P_Montant_HT, P_TVA, P_QuantiteRestante from ERP_BDD.dbo.Produit H
where H.P_ID in (select V.P_ID from ERP_BDD.dbo.Vente V where year(V.V_Date)=2020) ) ;
SET IDENTITY_INSERT  DW1.dbo.Produit OFF

insert into DW1.dbo.Vente (C_ID,P_ID,Com_ID,V_Quantite,V_TypeTransaction,V_Montant_HT,V_Date)(
select H.C_ID,H.P_ID,H.Com_ID,H.V_Quantite,H.V_TypeTransaction,H.V_Montant_HT,H.V_Date from ERP_BDD.dbo.Vente H
where YEAR(V_Date) = 2020);

/*REMPLIRE DW1 2020*/

/*REMPLIRE DW2 2019*/

SET IDENTITY_INSERT  DW2.dbo.Client ON
insert into DW2.dbo.Client (C_ID,C_Mat,C_date_ajout,C_date_modification,C_Type)(
select C_ID,C_Mat,C_date_ajout,C_date_modification,C_Type from ERP_BDD.dbo.Client C
where C.C_ID in (select V.C_ID from ERP_BDD.dbo.Vente V where year(V.V_Date)=2019) ) ;
SET IDENTITY_INSERT  DW2.dbo.Client OFF

SET IDENTITY_INSERT  DW2.dbo.Commercial ON
insert into DW2.dbo.Commercial(Com_ID,Com_prenom,Com_nom,Com_DateEntree)(
select Com_ID,Com_prenom,Com_nom,Com_DateEntree from ERP_BDD.dbo.Commercial C
where C.Com_ID in (select V.Com_ID from ERP_BDD.dbo.Vente V where year(V.V_Date)=2019) ) ;
SET IDENTITY_INSERT  DW2.dbo.Commercial OFF


SET IDENTITY_INSERT  DW2.dbo.Historique_Client ON
insert into DW2.dbo.Historique_Client(HC_ID,C_ID,C_Mat_ancien,C_Type_ancien)(
select H.HC_ID,H.C_ID,C_Mat_ancien,C_Type_ancien from ERP_BDD.dbo.Historique_Client H
where H.HC_ID in (select V.Com_ID from ERP_BDD.dbo.Vente V where year(V.V_Date)=2019) ) ;
SET IDENTITY_INSERT  DW2.dbo.Historique_Client OFF


SET IDENTITY_INSERT  DW2.dbo.Produit ON
insert into DW2.dbo.Produit(P_ID,P_Montant_HT,P_TVA,P_QuantiteRestante)(
select  P_ID,P_Montant_HT, P_TVA, P_QuantiteRestante from ERP_BDD.dbo.Produit H
where H.P_ID in (select V.P_ID from ERP_BDD.dbo.Vente V where year(V.V_Date)=2019) ) ;
SET IDENTITY_INSERT  DW2.dbo.Produit OFF


insert into DW2.dbo.Vente (C_ID,P_ID,Com_ID,V_Quantite,V_TypeTransaction,V_Montant_HT,V_Date)(
select H.C_ID,H.P_ID,H.Com_ID,H.V_Quantite,H.V_TypeTransaction,H.V_Montant_HT,H.V_Date from ERP_BDD.dbo.Vente H
where YEAR(V_Date) = 2019);
/*REMPLIRE DW2 2019*/
