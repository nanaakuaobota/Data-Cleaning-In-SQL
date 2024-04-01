select * from DataCleaningPortfolio.dbo.nashvillehousing

-- standardizing date format

alter table nashvillehousing
add SaleDate2 Date;

Update nashvillehousing
set SaleDate2 =Convert(Date,SaleDate)

select SaleDate2, CONVERT(Date,SaleDate)
from nashvillehousing

-- ----------------------------------------------------------------------------------------------------------------

-- Populating Property Address data

Select *
From nashvilleHousing
Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From nashvillehousing a
JOIN nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From nashvillehousing a
JOIN nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

---------------------------------------------------------------------------------------------------------

-- Breaking out PropertyAddress column into Individual Columns (Address, City, State)

Select PropertyAddress
From nashvillehousing


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From nashvillehousing


ALTER TABLE nashvillehousing
Add PropertySplitAddress Nvarchar(255);

Update nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE nashvillehousing
Add PropertySplitCity Nvarchar(255);

Update nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Select *
From nashvillehousing

----------------------------------------------------------------------

-- Breaking out ownerAddress column into Individual Columns (Address, City, State)

Select OwnerAddress
From nashvillehousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From nashvillehousing

ALTER TABLE nashvillehousing
Add OwnerSplitAddress Nvarchar(255);

Update nashvillehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE nashvillehousing
Add OwnerSplitCity Nvarchar(255);

Update nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE nashvillehousing
Add OwnerSplitState Nvarchar(255);

Update nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select *
From nashvillehousing

--------------------------------------------------------------------------------------------------------------------------

-- Changing Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From nashvillehousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From nashvillehousing

Update nashvillehousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

------------------------------------------------------------------------------------------------------------------------------

-- Removing Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From nashvillehousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
-- Order by PropertyAddress


--------------------------------------------------------

-- Deleting Unused Columns

Select *
From nashvillehousing


ALTER TABLE nashvillehousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
