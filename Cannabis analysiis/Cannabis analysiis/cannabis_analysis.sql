/*Analyzing the effects stains raitings, effects, and flavors*/

--Opening the database
USE cannabis_analysis

--Viewing table
SELECT * 
FROM dbo.strain_rating_effects_flavors;

--Finding average ratings by strain type
SELECT  type, AVG(rating) AS Average_rating  
INTO average_strain_type_rating
FROM dbo.strain_rating_effects_flavors
GROUP BY type;

SELECT * 
FROM average_strain_type_rating
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

/*Creating table with all effects accounted for
--Creating table with all 
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
*/

--Creating master effects list more efficiently
SELECT effects_1 AS unique_effects
INTO all_effects_accounted
FROM dbo.strain_rating_effects_flavors

SELECT *
FROM all_effects_accounted

INSERT INTO all_effects_accounted
SELECT effects_2
FROM dbo.strain_rating_effects_flavors

INSERT INTO all_effects_accounted
SELECT effects_3
FROM dbo.strain_rating_effects_flavors

INSERT INTO all_effects_accounted
SELECT effects_4
FROM dbo.strain_rating_effects_flavors

INSERT INTO all_effects_accounted
SELECT effects_5
FROM dbo.strain_rating_effects_flavors

SELECT DISTINCT *
INTO master_effects_list
FROM all_effects_accounted
WHERE unique_effects IS NOT NULL

SELECT *
FROM master_effects_list

--Count how many strains fall under each effect -to review
	SELECT strain, (SELECT * FROM master_effects_list) AS effects_list, AVG(rating)
	FROM dbo.strain_rating_effects_flavors, master_effects_list
	WHERE effects_1 IN (unique_effects)
	GROUP BY strain

WITH master_effects_list (unique_effects) AS
	(SELECT DISTINCT effects_1 FROM all_effects)
	SELECT unique_effects AS all_effects/*, COUNT(strain) AS number_of_strains*/, COUNT(CASE WHEN effects_1 IN (SELECT DISTINCT effects_1
FROM all_effects) then 1 else null),  AVG(rating) AS average_associated_rating
	FROM dbo.strain_rating_effects_flavors, master_effects
	WHERE effects_list IS NOT NULL
	GROUP BY effects_list

SELECT * 
FROM master_effects_list


/*Tables created for analysis and visualizing: average_strain_type_rating
											   master_effects_list
											   */

/*Analyzing strain medical benefits*/

--Average THC content by strain type
SELECT type, AVG(thc_level) AS Average_THC
INTO average_thc_by_type
FROM dbo.strain_medical_benefits_leafly
WHERE type IS NOT NULL
GROUP BY type

SELECT *
FROM average_thc_by_type

  

--Count number of occurances of most common terpenes in strains, the average thc level and the strain type
SELECT 
	most_common_terpene, 
	AVG(thc_level) AS average_thc,
	COUNT(name) AS number_of_strains, 
	COUNT(CASE WHEN type = 'Hybrid' then 1 else NULL end) AS occurances_in_hybrid, 
	COUNT(CASE WHEN type = 'Sativa' then 1 else NULL end) AS occurances_in_sativa,
	COUNT(CASE WHEN type = 'Indica' then 1 else NULL end) AS occurances_in_indica,
	COUNT(CASE WHEN type IS NULL then 1 else NULL end) AS null_types
INTO terpenes_avergae_thc_effects_count
FROM dbo.strain_medical_benefits_leafly
WHERE most_common_terpene IS NOT NULL
GROUP BY most_common_terpene

SELECT *
FROM terpenes_avergae_thc_effects_count

--Creating table with unique strains from all tables
SELECT name AS strains_medical
INTO temp_strains_list_leafly
FROM dbo.strain_medical_benefits_leafly

INSERT INTO temp_strains_list(strains_medical)
SELECT strain
FROM dbo.strain_rating_effects_flavors

SELECT DISTINCT REPLACE(strains_medical, '-',' ') AS strains_medical
INTO temp_master_strain_list
FROM temp_strains_list
ORDER BY strains_medical ASC

SELECT *
FROM temp_master_strain_list

/*To be used later on
--Creating table of effects and benefits
CREATE TABLE 
	leafly_effects_list (positive_effects VARCHAR(50), negative_effect VARCHAR(50), ambiguous_effects VARCHAR(50), helps_with VARCHAR(50))
INSERT INTO leafly_effects_list(positive_effects)
VALUES ('relaxed'),('happy'), ('euphoric'),( 'uplifted'), 
		('aroused'),('creative'), ('energetic'), 
		('focused'),('giggly'),('hungry'), ('sleepy'), 
		('talkative'),('tingly')
INSERT INTO leafly_effects_list(negative_effect)
VALUES ('anxious'), ('dizzy'), ('energetic'), 
		('dry_eyes'),('dry_mouth'),('headache'),
		('paranoid')
INSERT INTO leafly_effects_list(ambiguous_effects)
VALUES ('hungy'),('talkative'), ('tingly'),( 'sleepy')
INSERT INTO leafly_effects_list(helps_with)
VALUES ('ptsd'),('fatigue'), ('lack_of_appetite'),( 'nausea'),( 'headaches'),
		('stress'), ('pain'), ('depression'),('anxiety'),('insomnia'), 
		('cramps'), ('bipolar_disorder'),('cancer'), ('gastrointestinal_disorder'),('inflammation'), 
		('muscle_spasms'), ('eye_pressure'), ('migraines'),('asthma'), 
		('anorexia'), ('arthritis'),('add/adhd'),('muscular_dystrophy'), ('hypertension'),
		('glaucoma'),('pms'), 
		('seizures'), ('spasticity'),('spinal_cord_injury'), ('fibromyalgia'),('crohn''s_disease'), 
		('phantom_limb_pain'), ('epilepsy'), ('multiple_sclerosis'),('parkinson''s'), 
		('tourette''s_syndrome'), ('alzheimer''s'),('hiv/aids'),('tinnitus') 

SELECT *
FROM leafly_effects_list
*/

/*Counting strain benefits and effects*/

/*
--Using case method
SELECT name,   
	  relaxed,
		 happy,
		 euphoric,
         uplifted,
         CASE WHEN relaxed > 0 THEN 1 ELSE 0 END + 
         CASE WHEN happy  > 0  THEN 1 ELSE 0 END + 
         CASE WHEN euphoric > 0 THEN 1 ELSE 0 END + 
         CASE WHEN uplifted > 0  THEN 1 ELSE 0 END AS number_of_effects
FROM     dbo.strain_medical_benefits_leafly
*/

--Counting the total mumber of benefits and negatives per strains and the thc level
SELECT 
		name,
		thc_level,
		most_common_terpene,
       (SELECT count(*)
        FROM (VALUES (relaxed),(happy), (euphoric),(uplifted), 
		(aroused),(creative), (energetic), 
		(focused),(giggly),(hungry), (sleepy), 
		(talkative),(tingly)) as positives(col)
        where positives.col > 0) as number_of_positive_effects, 
		(SELECT count(*)
        FROM (VALUES (anxious), (dizzy), (energetic), 
		(dry_eyes),(dry_mouth),(headache),
		(paranoid)) as negatives(col)
        where negatives.col > 0) as number_of_negatives_effects, 
		(SELECT count(*)
        FROM (VALUES (ptsd),(fatigue), (lack_of_appetite),( nausea),( headaches),
		(stress), (pain), (depression),(anxiety),(insomnia), 
		(cramps), (bipolar_disorder),(cancer), (gastrointestinal_disorder),(inflammation), 
		(muscle_spasms), (eye_pressure), (migraines),(asthma), 
		(anorexia), (arthritis),(add_adhd),(muscular_dystrophy), (hypertension),
		(glaucoma),(pms), 
		(seizures), (spasticity),(spinal_cord_injury), (fibromyalgia),(crohns_disease), 
		(phantom_limb_pain), (epilepsy), (multiple_sclerosis),(parkinsons), 
		(tourettes_syndrome), (alzheimers),(hiv_aids),(tinnitus)) as medical(col)
        where medical.col > 0) as number_of_medical_effects,
		(SELECT count(*)
        FROM (VALUES (hungry),(talkative), (tingly),( sleepy))
		as ambiguous(col)
        where ambiguous.col > 0) as number_of_ambiguous_effects
INTO list_of_strains_with_number_of_effects
from dbo.strain_medical_benefits_leafly

SELECT *
FROM list_of_strains_with_number_of_effects

SELECT  name as strain,
		ISNULL(most_common_terpene,'none') AS most_common_terpene, 
		thc_level, 
		(number_of_positive_effects + number_of_medical_effects) as number_of_beneficial_effects, 
		number_of_negatives_effects, 
		number_of_ambiguous_effects
INTO strain_thc_level_terpene_and_accounted_effects
FROM list_of_strains_with_number_of_effects
WHERE thc_level IS NOT NULL 
ORDER BY number_of_negatives_effects DESC

SELECT *
FROM strain_thc_level_terpene_and_accounted_effects

--Tabe with unique terpenes, their avergae thc level, and their total accounted effects in all strains
SELECT ISNULL(most_common_terpene,'none') AS most_common_terpene, 
	   AVG(thc_level) AS average_thc_level,
	   SUM(number_of_positive_effects + number_of_medical_effects) as accounted_beneficial_effects, 
	   SUM(number_of_negatives_effects) as accounted_negative_effects, 
	   SUM(number_of_ambiguous_effects) as accounted_ambiguous_effects
INTO terpene_average_thc_and_accounted_effects
FROM list_of_strains_with_number_of_effects
WHERE thc_level IS NOT NULL 
GROUP BY most_common_terpene


SELECT *
FROM terpene_average_thc_and_accounted_effects


