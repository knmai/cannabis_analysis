/*Analyzing the effects stains raitings, effects, and flavors*/

--Opening the database
USE cannabis_analysis

--Viewing table
SELECT * 
FROM dbo.strain_rating_effects_flavors;

--Finding average ratings by strain type
SELECT  type, AVG(rating) AS Average_rating  
FROM dbo.strain_rating_effects_flavors
GROUP BY type;

/* Testing creating tables through loops. (Not doable unless using dynamic SQL)
DECLARE @counter INT
SET @counter =0
DECLARE @effects varchar(10)
SET @effects = 'effects_' + @counter
DECLARE @effects_temp varchar(10)
SET @effects_temp = 'effects' + @counter
WHILE (@counter <=1)
BEGIN 
	SELECT DISTINCT @effects
	INTO effects_temp 
	FROM dbo.strain_rating_effects_flavors
	SET @counter = @counter + 1 
END
*/


SELECT DISTINCT effects_1
INTO effects1
FROM dbo.strain_rating_effects_flavors

SELECT DISTINCT effects_2
INTO effects2
FROM dbo.strain_rating_effects_flavors

SELECT DISTINCT effects_3
INTO effects3
FROM dbo.strain_rating_effects_flavors

SELECT DISTINCT effects_4
INTO effects4
FROM dbo.strain_rating_effects_flavors

SELECT DISTINCT effects_5
INTO effects5
FROM dbo.strain_rating_effects_flavors


SELECT *
FROM effects1

--Checking all effects to make sure all unique variables are accounted for and creating tabke for all unique effects
SELECT effects_1, effects2.effects_2, effects3.effects_3, effects4.effects_4, effects5.effects_5
INTO all_effects
FROM effects1
FULL OUTER JOIN effects2 ON effects2.effects_2 = effects_1
FULL OUTER JOIN effects3 ON effects3.effects_3 = effects_1
FULL OUTER JOIN effects4 ON effects4.effects_4 = effects_1
FULL OUTER JOIN effects5 ON effects5.effects_5 = effects_1

SELECT*
FROM all_effects
ORDER BY effects_1 ASC

/*SELECT effects_1, effects2.effects_2, effects3.effects_3, effects4.effects_4, effects5.effects_5
FROM effects1
LEFT JOIN effects2 ON effects2.effects_2 = effects_1
LEFT JOIN effects3 ON effects3.effects_3 = effects_1
LEFT JOIN effects4 ON effects4.effects_4 = effects_1
LEFT JOIN effects5 ON effects5.effects_5 = effects_1
*/

--Adding unique effects to 1 column
INSERT INTO all_effects(effects_1)
VALUES ('Mouth')

--Creating master table of unique effects
CREATE TABLE master_effects
(
	effects_list VARCHAR(10))
INSERT INTO master_effects
SELECT DISTINCT effects_1 AS effects_list
FROM all_effects 

SELECT *
FROM all_effects

--Count how many strains fall under each effect
SELECT (SELECT * FROM master_effects) AS effects_list, AVG(rating)
FROM dbo.strain_rating_effects_flavors
WHERE effects_1 = effects_list
GROUP BY effects_list

WITH master_effects (effects_list) AS
	(SELECT DISTINCT effects_1 FROM all_effects)
	SELECT effects_list AS all_effects/*, COUNT(strain) AS number_of_strains*/, COUNT(CASE WHEN effects_1 IN (SELECT DISTINCT effects_1
FROM all_effects) then 1 else null),  AVG(rating) AS average_associated_rating
	FROM dbo.strain_rating_effects_flavors, master_effects
	WHERE effects_list IS NOT NULL
	GROUP BY effects_list

SELECT DISTINCT effects_1
FROM all_effects


--Analyzing strain medical benefits

--Average THC content by strain type
SELECT type, AVG(thc_level) AS Average_THC
FROM dbo.strain_medical_benefits
WHERE type IS NOT NULL
GROUP BY type

SELECT DISTINCT most_common_terpene
FROM dbo.strain_medical_benefits

SELECT most_common_terpene, COUNT(name) AS number_of_strains
FROM dbo.strain_medical_benefits
WHERE most_common_terpene IS NOT NULL
GROUP BY most_common_terpene


SELECT name AS strains_medical
INTO temp_strains_list 
FROM dbo.strain_medical_benefits

SELECT *
FROM temp_strains_list
ORDER BY strains_medical ASC

INSERT INTO temp_strains_list(strains_medical)
SELECT strain
FROM dbo.strain_rating_effects_flavors

--Creating temp distinct table of all the strain names, while removing delimiters that affect disctinct results
SELECT DISTINCT REPLACE(strains_medical, '-',' ') AS strains_medical
INTO temp_master_strain_list
FROM temp_strains_list
ORDER BY strains_medical ASC

SELECT *
FROM temp_master_strain_list

