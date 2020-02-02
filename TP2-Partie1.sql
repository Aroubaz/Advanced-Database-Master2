/*TP2 PARTIE 1*/

/*PARTIE 1 implimentation of the table temps*/
INSERT INTO Temps(T_Date,T_Jours,T_Annees,T_Mois,T_Semains)
(SELECT CONVERT(datetime,V_Date) as [Date],
CONVERT(int,DAY(V_Date)) as [Day],
CONVERT(int,YEAR(V_Date)) as [Annees],
CONVERT(int,MONTH(V_Date)) as [Mois],
CONVERT(int,datepart(week,V_Date)) as [Semaine]
FROM Vente);




/*PARTIE 1 CREATE A JOB*/


/* INSERT IN CLIENT DW FROM CLIENT DW1/DWZ */
SET IDENTITY_INSERT DW.dbo.Client ON;
INSERT INTO DW.dbo.Client (C_ID,C_Mat,C_date_ajout,C_date_modification,C_Type)
( SELECT C1.C_ID,C1.C_Mat,C1.C_date_ajout,C1.C_date_modification,C1.C_Type FROM DW1.dbo.Client C1 
	WHERE C1.C_ID not in (SELECT C2.C_ID FROM DW.dbo.Client C2)
	);
	INSERT INTO DW.dbo.Client (C_ID,C_Mat,C_date_ajout,C_date_modification,C_Type)
( SELECT C1.C_ID,C1.C_Mat,C1.C_date_ajout,C1.C_date_modification,C1.C_Type FROM DW2.dbo.Client C1 
	WHERE C1.C_ID not in (SELECT C2.C_ID FROM DW.dbo.Client C2)
	);
SET IDENTITY_INSERT DW.dbo.Client OFF;
/* INSERT IN CLIENT DW FROM CLIENT DW1/DWZ */

/* INSERT IN PRODUIT DW FROM PRODUIT DW1/DWZ */
SET IDENTITY_INSERT DW.dbo.Produit ON;
INSERT INTO DW.dbo.Produit (P_ID,P_Montant_HT,P_TVA,P_QuantiteRestante)
( SELECT P1.P_ID,P1.P_Montant_HT,P1.P_TVA,P1.P_QuantiteRestante FROM DW1.dbo.Produit P1 
	WHERE P1.P_ID not in (SELECT P2.P_ID FROM DW.dbo.Produit P2)
	);
	INSERT INTO DW.dbo.Produit (P_ID,P_Montant_HT,P_TVA,P_QuantiteRestante)
( SELECT P1.P_ID,P1.P_Montant_HT,P1.P_TVA,P1.P_QuantiteRestante FROM DW2.dbo.Produit P1
	WHERE P1.P_ID not in (SELECT P2.P_ID FROM DW.dbo.Produit P2)
	);

SET IDENTITY_INSERT DW.dbo.Produit OFF;
/* INSERT IN PRODUIT DW FROM PRODUIT DW1/DWZ */

/* INSERT IN COMMERCIAL DW FROM COMMERCIAL DW1/DWZ */
SET IDENTITY_INSERT DW.dbo.Commercial ON;
INSERT INTO DW.dbo.Commercial (Com_ID,Com_prenom,Com_nom,Com_DateEntree)
( SELECT C1.Com_ID,C1.Com_prenom,C1.Com_nom,C1.Com_DateEntree FROM DW1.dbo.Commercial C1 
	WHERE C1.Com_ID not in (SELECT C2.Com_ID FROM DW.dbo.Commercial C2)
	);
	INSERT INTO DW.dbo.Commercial (Com_ID,Com_prenom,Com_nom,Com_DateEntree)
( SELECT C1.Com_ID,C1.Com_prenom,C1.Com_nom,C1.Com_DateEntree FROM DW2.dbo.Commercial C1 
	WHERE C1.Com_ID not in (SELECT C2.Com_ID FROM DW.dbo.Commercial C2)
	);

SET IDENTITY_INSERT DW.dbo.Commercial OFF;
/* INSERT IN COMMERCIAL DW FROM COMMERCIAL DW1/DWZ */
GO;




/* PARTIE 1 CREATE TRIGGER TO FILL VENTE TABLE IN DW FROM DW1 AND DW2 INSTANTLY */
use DW1;
GO;
CREATE TRIGGER insertInDWVENTEfromDW1VENTE ON DW1.dbo.Vente
AFTER INSERT
AS
BEGIN

	IF NOT EXISTS(
	SELECT * FROM DW.dbo.Client C WHERE C.C_ID in (select C_ID from inserted ) 
	)  AND NOT EXISTS(
	SELECT * FROM DW.dbo.Produit P WHERE P.P_ID in (select P_ID from inserted ) 

	) AND NOT EXISTS(
	SELECT * FROM DW.dbo.Commercial C WHERE C.Com_ID in (select Com_ID from inserted ) 

	)
	BEGIN
		RAISERROR('C_ID or P_ID or Com_ID dont exist in DW1 Table1',1,1);
		ROLLBACK TRANSACTION;
	END
	ELSE
		BEGIN
		SET IDENTITY_INSERT DW.dbo.Vente ON;
		insert into DW.dbo.Vente (V_ID,C_ID,P_ID,Com_ID,V_Quantite,V_TypeTransaction,V_Montant_HT,V_Date)
		(SELECT V_ID,C_ID,P_ID,Com_ID,V_Quantite,V_TypeTransaction,V_Montant_HT,V_Date from inserted t )
		SET IDENTITY_INSERT DW.dbo.Vente OFF;
		END
END

GO;

/* PARTIE 1 CREATE TRIGGER TO FILL VENTE TABLE IN DW FROM DW1 AND DW2 INSTANTLY */



CREATE TRIGGER insertInDWVENTEfromDW2VENTE ON DW2.dbo.Vente
AFTER INSERT
AS
BEGIN

IF NOT EXISTS(
SELECT * FROM DW.dbo.Client C WHERE C.C_ID in (select C_ID from inserted ) 

) AND NOT EXISTS(
SELECT * FROM DW.dbo.Produit P WHERE P.P_ID in (select P_ID from inserted ) 

) AND NOT EXISTS(
SELECT * FROM DW.dbo.Commercial C WHERE C.Com_ID in (select Com_ID from inserted ) 

)
BEGIN
RAISERROR('C_ID or P_ID or Com_ID dont exist in DW Table',1,1);
ROLLBACK TRANSACTION;
END
ELSE
BEGIN
SET IDENTITY_INSERT DW.dbo.Vente ON;
insert into DW.dbo.Vente (V_ID,C_ID,P_ID,Com_ID,V_Quantite,V_TypeTransaction,V_Montant_HT,V_Date)
(SELECT V_ID,C_ID,P_ID,Com_ID,V_Quantite,V_TypeTransaction,V_Montant_HT,V_Date from inserted t )
SET IDENTITY_INSERT DW.dbo.Vente OFF;
END

END
;
/* */
