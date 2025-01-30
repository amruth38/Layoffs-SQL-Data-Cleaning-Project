/*------------------------ DATA CLEANING PROJECT ----------------------------*/

SELECT * FROM layoffs;

/*
    1. Remove Duplicates
    2. Standardize the Data (spell-checking, etc)
    3. NULL/Blank Values
    4. Remove Unnecessary Columns (very risky to delete columns)
*/

/* 1. -------REMOVING DUPLICATES ------- */

CREATE TABLE layoffs_dup
LIKE layoffs;
    
INSERT layoffs_dup
SELECT * FROM layoffs;

SELECT * FROM layoffs_dup;

SELECT *,
ROW_NUMBER() OVER (
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, funds_raised_millions
    ) AS row_num
FROM layoffs_dup;

WITH dup_data AS (
	SELECT *,
	ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
	FROM layoffs_dup
    ) 
SELECT * FROM dup_data 
WHERE row_num > 1;

/* Creating second duplicate table*/

CREATE TABLE `layoffs_dup2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_dup2
	SELECT *,
	ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
	FROM layoffs_dup;
    
SELECT * FROM layoffs_dup2
WHERE row_num > 1;

DELETE FROM layoffs_dup2
WHERE row_num > 1;

----------------------------------------------------------------------------------

/* 2. ------- STANDARDISING THE DATA -------- */

/* Removing spaces in the company name */

SELECT company, TRIM(company) FROM layoffs_dup2
WHERE TRIM(company) != company;

SELECT * FROM layoffs_dup2;

UPDATE layoffs_dup2
SET company = TRIM(company);

/* Merge similarly named industries like ' crypto', 'crypto currency', 'crypto-currency' */ 

SELECT DISTINCT industry FROM layoffs_dup2
ORDER BY 1;

SELECT * FROM layoffs_dup2
WHERE industry LIKE '%Crypto%';

UPDATE layoffs_dup2
SET industry = 'Crypto'
WHERE industry LIKE '%Crypto%';

/* Search for similar named companies */

SELECT DISTINCT country
FROM layoffs_dup2
ORDER BY 1;
 
UPDATE layoffs_dup2
SET country = 'United States'
WHERE country = 'United States.';

/* Change 'date' column's datatype to date*/

SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_dup2;

UPDATE layoffs_dup2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_dup2
MODIFY COLUMN `date` DATE;

-------------------------------------------------------------------------------------------

/* 3. --------DEALING WITH THE NULL DATA --------------- */

SELECT * FROM layoffs_dup2
WHERE industry IS NULL OR industry = '';

UPDATE layoffs_dup2
SET industry = NULL WHERE industry = '';

SELECT t1.industry, t2.industry FROM layoffs_dup2 t1
JOIN layoffs_dup2 t2 ON t1.company = t2.company
WHERE t1.industry IS NULL OR t1.industry = '';

UPDATE layoffs_dup2 t1 
JOIN layoffs_dup2 t2 ON t1.company = t2.company
SET t1.industry = t2.industry 
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

-----------------------------------------------------------------------------------------

/* 4. ---------- DELETING UNECESSARY DATA ----------- */

DELETE FROM layoffs_dup2
WHERE percentage_laid_off IS NULL AND total_laid_off IS NULL; 

ALTER TABLE layoffs_dup2
DROP COLUMN row_num;

------------------------------------------------------------------------------------------










 
