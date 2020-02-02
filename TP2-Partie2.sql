/*QUESTION1 */
/*
GO 
update DW2.dbo.Client 
set C_Type ='potentiel' 
where  C_ID = 6;


*/
/* QUESTION a */
GO;
create view Question_a_section2  as
	select C.C_ID , DATEDIFF(DAY, C_date_ajout , C_date_modification)as Jours
	from Client C , Historique_Client H 
	WHERE C.C_Type LIKE 'confirme' AND H.C_Type_ancien LIKE 'potentiel';

/*QUESTION b*/
/*WE WILL NEED 4 VIEW  */
/* FIRST VIEW CALCULATE THE AVERAGE OF VENTE WITHE CONFIRMED YEARS FOR CLIENT*/
CREATE VIEW MoyenneVENTE 
as 
SELECT AVG(V_Montant_HT) as MoyenneVente , ABS(DATEDIFF(YEAR,v.V_Date,c.C_date_ajout)) as Ancienneté
FROM DW1.dbo.Vente V , DW1.dbo.Client C 
WHERE V.V_Date >='2020-06-01' AND V.C_ID = C.C_ID
GROUP BY (DATEDIFF(YEAR,v.V_Date,c.C_date_ajout))

/*SECOND VIEW TO CALCULATE TO AVG OF VENTE FOR ONE YEAR OR MORE CLIENT*/
CREATE VIEW MoyenneVentePlusOneYear 
AS
SELECT AVG(MoyenneVente) as MoyenneVente,'ancien' as Experience
FROM MoyenneVENTE 
WHERE Ancienneté > 0

/*THINRD VIEW TO CALCULATE TO AVG OF VENTE FOR ONE YEAR OR LESS CLIENT*/
CREATE VIEW MoyenneVenteLessOneYear 
AS
SELECT AVG(MoyenneVente) as MoyenneVente,'nouveau' as Experience
FROM MoyenneVENTE 
WHERE Ancienneté = 0

/*FOURTH VIEW TO COMPARE THE SECOND AND THE THIRD VIEW RESULTS*/
CREATE VIEW COMPARE 
AS 
SELECT * FROM MoyenneVentePlusOneYear
UNION ALL
SELECT * FROM MoyenneVenteLessOneYear