-- =========================================
-- Project: Nashville Housing Data Cleaning
-- Description:
-- This project focuses on cleaning and transforming raw housing data using SQL.
-- Key operations include:
-- - Standardizing date formats
-- - Handling missing values
-- - Splitting address columns
-- - Removing duplicates
-- - Data normalization
--
-- Tools Used: MySQL
-- =========================================

-- =========================================
-- Create Table
-- =========================================
Create database Nashville;
use Nashville;

Create table Nashville_Housing (
UniqueId Varchar (50),
ParcelId Varchar (50),
LandUse Varchar (100),
PropertyAddress Varchar (255),
SalesDate Varchar (50),
SalesPrice Varchar (50),
LegalReference Varchar (100),
soldAsVacant Varchar (50),
OwnerName Varchar (250),
OwnerAddress Varchar (255),
Acreage Varchar (50),
TaxDistrict Varchar (100),
LandValue Varchar(50),
BuildingValue Varchar (50),
TotalValue Varchar (50),
YearBuilt Varchar (10),
Bedrooms Varchar (10),
FullBath Varchar (10),
HalfBath Varchar (10)
);

-- =========================================
-- Step 1 : DATA EXPLORATION
-- =========================================
Select count(*) as Total_rows from nashville_housing;

Select Distinct LandUse from nashville_housing;

select * from nashville_housing
limit 10;

-- =========================================
--  STEP 2: Standardize Date Format
-- =========================================

Alter table nashville_housing
add saleDateConverted Date;

Update nashville_housing
set saleDateconverted = str_to_date(SalesDate, '%M %e, %Y');

select saleDateconverted
from nashville_housing
limit 10;

-- =====================================================
-- Step 3 : HANDLE MISSING PROPERTY ADDRESS
-- =====================================================
Update Nashville_housing a
JOIN Nashville_housing b
on a.ParcelID = b.parcelID
and a.uniqueID <> b.uniqueID
Set a.PropertyAddress = b.PropertyAddress
Where a.PropertyAddress is NUll;

SELECT COUNT(*) 
FROM Nashville_Housing
WHERE PropertyAddress IS NULL;

-- =====================================================
-- Step 4 : SPLIT PROPERTY ADDRESS INTO COLUMNS
-- =====================================================

select * from nashville_housing;

ALTER TABLE nashville_housing
ADD Property_Address VARCHAR(255),
ADD Property_City VARCHAR(255);

UPDATE nashville_housing
SET 
    Property_Address = SUBSTRING_INDEX(PropertyAddress, ',', 1),
    Property_City = SUBSTRING_INDEX(PropertyAddress, ',', -1);
    
SELECT PropertyAddress, Property_Address, Property_City
FROM nashville_housing
LIMIT 10;


-- =====================================================
-- Step 5 : SPLIT OWNER ADDRESS INTO COLUMNS
-- =====================================================

Alter table nashville_housing
Add Owner_Address Varchar(225),
Add Owner_City Varchar (225),
Add Owner_State VArchar (225);

Update nashville_housing
SET
    Owner_Address = SUBSTRING_INDEX(OwnerAddress, ',', 1),
	Owner_City = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress,',',2) , ',' , -1),
	Owner_State = SUBSTRING_INDEX(OwnerAddress,',',-1);

SELECT OwnerAddress, Owner_Address, Owner_City, Owner_State
FROM nashville_housing
LIMIT 10;

-- =====================================================
-- Step 6 : STANDARDIZE SoldAsVacant VALUES
-- =====================================================

Update nashville_housing
Set soldAsVacant =
case
when soldAsVacant = 'Y' Then 'Yes'
when soldAsVacant = 'N' Then 'No'
Else soldAsVacant
end;

-- Validation
SELECT DISTINCT SoldAsVacant FROM Nashville_Housing;

-- =====================================================
-- Step 7: REMOVE DUPLICATES
-- =====================================================

DELETE FROM nashville_housing
Where UniqueID in (
Select UniqueId from (
  select uniqueID,
  Row_Number () over (
         partition by ParcelID, PropertyAddress, SalesPrice, LegalReference
         Order By UniqueID
         ) As row_num
         From nashville_housing
      )  temp
	where row_num > 1
    );
    
-- =========================================
-- STEP 8: DATA TYPE CONVERSION
-- =========================================
    
Alter table nashville_housing 
Modify SalesPrice Int;

SELECT Acreage
FROM Nashville_Housing
WHERE Acreage NOT REGEXP '^[0-9.]+$' ;

UPDATE Nashville_Housing
SET Acreage = NULL
WHERE Acreage NOT REGEXP '^[0-9.]+$';

Alter table nashville_housing
Modify acreage Decimal (10,2);

-- =========================================
-- STEP 9: DROP UNUSED COLUMNS
-- =========================================

Alter table nashville_housing
Drop Column PropertyAddress,
Drop Column SalesDate,
Drop Column OwnerAddress;

-- =========================================
-- STEP 10: FINAL CLEAN DATASET PREVIEW
-- =========================================

select * from nashville_housing
limit 10;

-- =========================================
-- STEP 11: ANALYTICAL QUERIES
-- =========================================

-- Average Sale Price by City
Select Property_City , Avg(SalesPrice) as Avg_price
from nashville_housing
Group by Property_City
Order by Avg_price Desc;

-- Total Sales by Year
Select Year(saleDateConverted) as Year, Count(*) as Total_sales
from nashville_housing 
Group by year
order by year;

-- Sales Distribution by Vacant Status
Select soldAsVacant , Count(*) as Total
from nashville_housing
group by soldAsVacant;

-- =========================================
-- STEP 12: CREATE VIEW FOR CLEAN DATA
-- =========================================
Create View Cleaned_Housing_Data as
Select * from nashville_housing;


-- =========================================
-- PROJECT SUMMARY
-- =========================================
-- ✔ Cleaned missing property addresses
-- ✔ Standardized date format
-- ✔ Split address columns into structured format
-- ✔ Normalized categorical values
-- ✔ Removed duplicate records
-- ✔ Converted data types for better performance
--
-- Final Result:
-- A clean, structured dataset ready for analysis or visualization
-- =========================================