# Data Cleaning Procedure

## Overview
This project focuses on cleaning a dataset containing **2,500 layoff records** from **2,000 companies across 60 countries**. The dataset includes key columns such as:

- `company`
- `location`
- `industry`
- `total_laid_off`
- `percentage_laid_off`
- `date`
- `stage`
- `country`
- `funds_raised_millions`

The objective is to **transform raw, messy data into a clean, structured format** for accurate and reliable analysis.

## Data Cleaning Process
The cleaning process follows a **4-step approach**:

1. **Remove Duplicates**  
   - Create a duplicate table for safe deletion.
   - Use `ROW_NUMBER()` to identify duplicate records.
   - Delete duplicates while preserving original data integrity.

2. **Standardize Data**  
   - Trim spaces using `TRIM()`.
   - Merge similar industry names (e.g., `'crypto'`, `'crypto currency'`, `'crypto-currency'`).
   - Normalize country names using `DISTINCT()`.
   - Convert date formats using `STR_TO_DATE()`.

3. **Handle NULL/Blank Values**  
   - Convert blanks into NULLs for consistency.
   - Fill missing industries using available company data.

4. **Delete Unnecessary Data**  
   - Remove records that don’t add value to the analysis.
   - Drop helper columns like `row_num` after deduplication.

## Technologies Used
- **SQL** (for data transformation)
- **Excel** *(for initial data exploration)*

