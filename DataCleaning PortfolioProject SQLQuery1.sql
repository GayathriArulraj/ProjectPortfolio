/*
Cleaning Data in SQL Query
*/
Select * 
from PortfolioProject.dbo.Housing
----------------------------------------------
--- Standardize Date Format
Select SaleDateConverted , convert(Date,SaleDate)
from PortfolioProject.dbo.Housing

Update Housing
SET SaleDate = convert(Date,SaleDate)


Alter Table Housing
Add SaleDateConverted date;

Update Housing
Set SaleDateConverted = convert(Date,SaleDate)

-------------------------------------
--Populate Property Address data

Select *
from PortfolioProject.dbo.Housing
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress ,ISnull(a.PropertyAddress , b.PropertyAddress)
from PortfolioProject.dbo.Housing a
Join PortfolioProject.dbo.Housing b
on a.ParcelID = b.ParcelID
AND  a.[UniqueID]<> b.[UniqueID]
Where a.PropertyAddress is Null


Update a
SET PropertyAddress = ISnull(a.PropertyAddress , b.PropertyAddress)
from PortfolioProject.dbo.Housing a
Join PortfolioProject.dbo.Housing b
on a.ParcelID = b.ParcelID
AND  a.[UniqueID]<> b.[UniqueID]
Where a.PropertyAddress is Null



----------------------------------------------------
--Breaking OUT Address INTO INdivdual Columns (Address, City,State)
Select PropertyAddress 
From PortfolioProject.dbo.Housing

Select 
SUBSTRING (PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.Housing

Alter Table Housing
Add PropertySplitAddress Nvarchar(255);

Update Housing
Set PropertySplitAddress = SUBSTRING (PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

Alter Table Housing
Add PropertySplitCity Nvarchar(255);

Update Housing
Set PropertySplitCity = SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

Select * 
from PortfolioProject.dbo.Housing

Select OwnerAddress
from PortfolioProject.dbo.housing

Select 
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
FROM 
PortfolioProject.dbo.Housing

Alter Table Housing
Add OwnerSplitAddress Nvarchar(255);

Update Housing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter Table Housing
Add OwnerSplitCity Nvarchar(255);

Update Housing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter Table Housing
Add OwnerSplitState Nvarchar(255);

Update Housing
Set OwnerSplitState= PARSENAME(Replace(OwnerAddress,',','.'),1)

Select * 
From PortfolioProject.dbo.Housing



-----------------------------
---Change Y and N into Yes /No  in Sold as Vacant field
Select Distinct (SoldAsVacant),Count(SoldAsVacant)
From PortfolioProject.dbo.Housing
Group By SoldAsVacant
Order by  2

Select SoldAsVacant ,
CASE When SoldAsVacant ='Y'Then 'Yes'
When SoldAsVacant='N'Then 'No'
Else SoldASVacant
END
From PortfolioProject.dbo.Housing

Update Housing
SET SoldAsVacant = CASE When SoldAsVacant ='Y'Then 'Yes'
When SoldAsVacant='N'Then 'No'
Else SoldASVacant
END
--------------------------------------------------------------------------
---Remove Duplicate
Select * from
PortfolioProject.dbo.Housing


With RownumCTE AS(
Select * ,
ROW_NUMBER() Over(Partition by ParcelID,
PropertyAddress,SalePrice,SaleDate,LegalReference
Order By UniqueID)row_num
From PortfolioProject.dbo.Housing
--Order By ParcelID
)
Select *
From RownumCTE
Where row_num > 1 
Order By PropertyAddress



-------------------------------------------
--Delete Unused Column
Select *
From  PortfolioProject.dbo.Housing

Alter Table  PortfolioProject.dbo.Housing 
Drop Column OwnerAddress, TaxDistrict,PropertyAddress

Alter Table  PortfolioProject.dbo.Housing 
Drop Column SaleDate
