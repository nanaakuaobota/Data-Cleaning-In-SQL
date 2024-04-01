# Data-Cleaning-In-SQL
 
1. Standardize Date Format:

- Used the ALTER TABLE statement to add a new column SaleDate2.
- Utilized the UPDATE statement with CONVERT function to standardize the SaleDate column to a consistent date format.

2. Populate Property Address Data:

- Employed UPDATE statement with a self-join to fill missing values in the PropertyAddress column by matching rows with the same ParcelID.

3. Breaking out Property Address Column:

-Added new columns PropertySplitAddress and PropertySplitCity using ALTER TABLE.
-Utilized UPDATE statement with SUBSTRING function to split the PropertyAddress column into separate columns for Address and City.

4. Breaking out Owner Address Column:

- Added new columns OwnerSplitAddress, OwnerSplitCity, and OwnerSplitState using ALTER TABLE.
- Used UPDATE statement with PARSENAME and REPLACE functions to split the OwnerAddress column into separate columns for Address, City, and State.

6. Change Y and N to Yes and No in "Sold as Vacant" Field:

-Updated the SoldAsVacant column using the UPDATE statement with CASE expression to change 'Y' and 'N' values to 'Yes' and 'No' respectively.

7. Remove Duplicates:

- Employed a WITH clause and DELETE statement to remove duplicate records based on certain columns (ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference).

8. Delete Unused Columns:

- Used the ALTER TABLE statement with DROP COLUMN to remove unnecessary columns (OwnerAddress, TaxDistrict, PropertyAddress, SaleDate).

Find sql query script [here](housing_queries.sql)



