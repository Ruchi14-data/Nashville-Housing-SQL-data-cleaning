# 🏠 Nashville Housing Data Cleaning Project (SQL)

## 📌 Project Overview
This project focuses on cleaning and transforming a raw housing dataset using SQL. The dataset contains inconsistencies such as missing values, unstructured address fields, inconsistent formats, and duplicate records.

The goal of this project is to prepare the dataset for analysis by applying structured data cleaning techniques.


## 🎯 Objectives
- Standardize date formats
- Handle missing property addresses
- Split combined address fields into structured columns
- Normalize categorical values
- Remove duplicate records
- Convert data types for accurate analysis

## 🛠️ Tools & Technologies
- SQL (MySQL)
- Data Cleaning Techniques
- Data Transformation
- Window Functions (ROW_NUMBER)

## 📂 Dataset
- **Dataset Name:** Nashville Housing Data
- Contains property sales data including:
  - Parcel ID
  - Property Address
  - Owner Address
  - Sale Price
  - Sale Date
  - Land Use
  - Acreage

## 🔍 Data Cleaning Steps

### 1. Data Exploration
- Checked total records
- Identified unique values
- Previewed dataset structure

### 2. Standardizing Date Format
- Converted text-based dates into SQL DATE format
- Created a new column `saleDateConverted`

### 3. Handling Missing Values
- Filled missing property addresses using ParcelID matching

### 4. Splitting Address Columns
- Extracted:
  - Property Street & City
  - Owner Street, City & State

### 5. Data Normalization
- Converted 'Y' and 'N' into 'Yes' and 'No' in `SoldAsVacant`

### 6. Removing Duplicates
- Used `ROW_NUMBER()` with CTE to identify and delete duplicate rows

### 7. Data Type Conversion
- Converted:
  - `SalePrice` → INT
  - `Acreage` → DECIMAL

### 8. Dropping Unused Columns
- Removed redundant columns after transformation


## 📊 Sample Analysis

- Average sale price by city
- Total sales per year
- Sales distribution by vacant status


## 📈 Key Learnings
- Handling inconsistent real-world datasets
- Writing optimized SQL queries for cleaning
- Using window functions for deduplication
- Data validation before transformation
- Importance of proper data types


## 👤 Author
Ruchi

