/*
Cleaning Data using SQL Queries
*/

Select *
From NashvilleHousing

--Standardize Date Format

Select SaleDate2, CONVERT(Date,SaleDate)
From NashvilleHousing

ALTER TABLE NashvilleHousing
Add SaleDate2 Date;

Update NashvilleHousing
SET SaleDate2 = CONVERT(Date,SaleDate)

---------------------------------------------------------------------------------------
--Populate Property Address Data

Select *
From NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From From NashvilleHousing a
Join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

---------------------------------------------------------------------------------------
--Breaking Propert Address into Address and City

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as City
From NashvilleHousing

ALTER TABLE NashvilleHousing
Add StreetAddress Nvarchar(255);

Update NashvilleHousing
SET StreetAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add City Nvarchar(255);

Update NashvilleHousing
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

---------------------------------------------------------------------------------------
-- Breaking Owner Address into Address, City, and State
Select OwnerAddress
From NashvilleHousing

Select
PARSENAME(Replace(OwnerAddress,',', '.'), 3),
PARSENAME(Replace(OwnerAddress,',', '.'), 2),
PARSENAME(Replace(OwnerAddress,',', '.'), 1)
From NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerStreetAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerStreetAddress = PARSENAME(Replace(OwnerAddress,',', '.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerCity Nvarchar(255);

Update NashvilleHousing
SET OwnerCity = PARSENAME(Replace(OwnerAddress,',', '.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerState Nvarchar(255);

Update NashvilleHousing
SET OwnerState = PARSENAME(Replace(OwnerAddress,',', '.'), 1)

---------------------------------------------------------------------------------------
-- Change Y/N to Yes and No in "Sold as Vacant"
Select Distinct(SoldAsVacant), 
	Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
From NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END

---------------------------------------------------------------------------------------
-- Remove Duplicates
WITH RowNumCTE as (
	Select *,
		ROW_NUMBER() OVER (
		Partition by ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					Order by
						UniqueID
						) row_num
	From NashvilleHousing
)
Delete
From RowNumCTE
Where row_num > 1

WITH RowNumCTE as (
	Select *,
		ROW_NUMBER() OVER (
		Partition by ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					Order by
						UniqueID
						) row_num
	From NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

---------------------------------------------------------------------------------------
-- Delete Unused Columns
Alter Table NashvilleHousing
Drop Column
	PropertyAddress,
	OwnerAddress,
	SaleDate,
	SaleDateConverted

