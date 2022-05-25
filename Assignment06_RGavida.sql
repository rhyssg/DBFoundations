--*************************************************************************--
-- Title: Assignment06
-- Author: RGarvida
-- Desc: This file demonstrates how to use Views
-- Change Log: When,Who,What
-- 2022-05-23,RGarvida,Created File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment06DB_RGarvida')
	 Begin 
	  Alter Database [Assignment06DB_RGarvida] set Single_user With Rollback Immediate;
	  Drop Database Assignment06DB_RGarvida;
	 End
	Create Database Assignment06DB_RGarvida;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment06DB_RGarvida;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [mOney] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, UnitsInStock
From Northwind.dbo.Products
UNIOn
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, UnitsInStock + 10 -- Using this is to create a made up value
From Northwind.dbo.Products
UNIOn
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, UnitsInStock + 20 -- Using this is to create a made up value
From Northwind.dbo.Products
Order By 1, 2
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From Categories;
go
Select * From Products;
go
Select * From Employees;
go
Select * From Inventories;
go

/********************************* Questions and Answers *********************************/
print 
'NOTES------------------------------------------------------------------------------------ 
 1) You can use any name you like for you views, but be descriptive and consistent
 2) You can use your working code from assignment 5 for much of this assignment
 3) You must use the BASIC views for each table after they are created in Question 1
------------------------------------------------------------------------------------------'

-- Question 1 (5% pts): How can you create BACIC views to show data from each table in the database.
-- NOTES: 1) Do not use a *, list out each column!
--        2) Create one view per table!
--		  3) Use SchemaBinding to protect the views from being orphaned!
go
/*
-- Select all data
Select * From Categories;
Select * From Products;
Select * From Employees;
Select * From Inventories;
go

--Select columns from table
Select CategoryID, CategoryName From Categories;
go

Select ProductID, ProductName, CategoryID, UnitPrice From Products;
go

Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID From Employees;
go

Select InventoryID, InventoryDate, EmployeeID, ProductID, Count From Inventories;
go

--Create View
Create View vCategories As
Select CategoryID, CategoryName From Categories;
go

Create View vProducts As
Select ProductID, ProductName, CategoryID, UnitPrice From Products;
go

Create View vEmployees As
Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID From Employees;
go

Create View vInventories As 
Select InventoryID, InventoryDate, EmployeeID, ProductID, Count From Inventories;
go

--Protect with Schema Binding
Create View vCategories WITH SCHEMABINDING As
Select CategoryID, CategoryName From Categories;
go

Create View vProducts WITH SCHEMABINDING As
Select ProductID, ProductName, CategoryID, UnitPrice From Products;
go

Create View vEmployees WITH SCHEMABINDING As
Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID From Employees;
go

Create View vInventories WITH SCHEMABINDING As 
Select InventoryID, InventoryDate, EmployeeID, ProductID, Count From Inventories;
go
*/

--Q1 Final Version 
Create View vCategories WITH SCHEMABINDING As
Select 
 CategoryID
,CategoryName 
From dbo.Categories;
go

Create View vProducts WITH SCHEMABINDING As
Select 
 ProductID
,ProductName
,CategoryID
,UnitPrice 
From dbo.Products;
go

Create View vEmployees WITH SCHEMABINDING As
Select 
 EmployeeID
,EmployeeFirstName
,EmployeeLastName
,ManagerID 
From dbo.Employees;
go

Create View vInventories WITH SCHEMABINDING As 
Select 
 InventoryID
,InventoryDate
,EmployeeID
,ProductID
,Count 
From dbo.Inventories;
go


-- Question 2 (5% pts): How can you set permissions, so that the public group CANNOT select data 
-- from each table, but can select data from each view?

Deny Select On Categories to Public;
Deny Select On Products to Public;
Deny Select On Employees to Public;
Deny Select On Inventories to Public;

Grant Select On vCategories to Public;
Grant Select On vProducts to Public;
Grant Select On vEmployees to Public;
Grant Select On vInventories to Public;

-- Question 3 (10% pts): How can you create a view to show a list of Category and Product names, 
-- and the price of each product?
-- Order the result by the Category and Product!

-- Here is an example of some rows selected from the view:
-- CategoryName ProductName       UnitPrice
-- Beverages    Chai              18.00
-- Beverages    Chang             19.00
-- Beverages    Chartreuse verte  18.00

/*
--Select all data
Select * From vCategories;
Select * From vProducts;
go

--Selected columns from table
Select CategoryName From vCategories;
Select ProductName, UnitPrice From vProducts;
go

--Join tables
Select CategoryName, ProductName, UnitPrice From vCategories As vc INNER JOIN vProducts As vp ON vc.CategoryID = vp.CategoryID;
go

--Order By
Select CategoryName, ProductName, UnitPrice From vCategories As vc INNER JOIN vProducts As vp ON vc.CategoryID = vp.CategoryID
Order By CategoryName, ProductName;
go

--Create view
Create View vProductsbyCategories WITH SCHEMABINDING As
Select TOP 1000000 CategoryName, ProductName, UnitPrice From vCategories As vc INNER JOIN vProducts As vp ON vc.CategoryID = vp.CategoryID
Order By CategoryName, ProductName;
go
*/

--Q3 Final Version
Create View vProductsbyCategories WITH SCHEMABINDING As
Select TOP 1000000 
 CategoryName
,ProductName
,UnitPrice 
From dbo.vCategories As vc 
INNER JOIN dbo.vProducts As vp ON vc.CategoryID = vp.CategoryID
Order By 
 CategoryName
,ProductName;
go

-- Question 4 (10% pts): How can you create a view to show a list of Product names 
-- and Inventory Counts on each Inventory Date?
-- Order the results by the Product, Date, and Count!

-- Here is an example of some rows selected from the view:
-- ProductName	  InventoryDate	Count
-- Alice Mutton	  2017-01-01	  0
-- Alice Mutton	  2017-02-01	  10
-- Alice Mutton	  2017-03-01	  20
-- Aniseed Syrup	2017-01-01	  13
-- Aniseed Syrup	2017-02-01	  23
-- Aniseed Syrup	2017-03-01	  33

/*
--Select all data
Select * From vProducts;
Select * From vInventories;
go

--Selected columns from table 
Select ProductName From vProducts;
Select InventoryDate, Count From vInventories;
go

--Combine tables 
Select ProductName, InventoryDate, Count From vProducts as vp INNER JOIN vInventories As vi ON vp.ProductID = vi.ProductID;
go

--Order By
Select ProductName, InventoryDate, Count From vProducts as vp INNER JOIN vInventories As vi ON vp.ProductID = vi.ProductID
Order By ProductName, InventoryDate, Count;
go

--Create View 
Create View vInventoriesByProductsByDates WITH SCHEMABINDING As
Select TOP 1000000 ProductName, InventoryDate, Count From vProducts as vp INNER JOIN vInventories As vi ON vp.ProductID = vi.ProductID
Order By ProductName, InventoryDate, Count;
go
*/

--Q4 Final Version
Create View vInventoriesByProductsByDates WITH SCHEMABINDING As
Select TOP 1000000
 ProductName
,InventoryDate
,Count 
From dbo.vProducts as vp 
INNER JOIN dbo.vInventories As vi ON vp.ProductID = vi.ProductID
Order By 
 ProductName
,InventoryDate
,Count;
go


-- Question 5 (10% pts): How can you create a view to show a list of Inventory Dates 
-- and the Employee that took the count?
-- Order the results by the Date and return only one row per date!

-- Here is are the rows selected from the view:

-- InventoryDate	EmployeeName
-- 2017-01-01	    Steven Buchanan
-- 2017-02-01	    Robert King
-- 2017-03-01	    Anne Dodsworth

/*
--Select All data;
Select * From vInventories;
Select * From vEmployees;
go

--Selected columns from table 
Select InventoryDate From vInventories;
Select [EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName From vEmployees; 
go

--Join tables and DISTINCT only one per row
Select DISTINCT InventoryDate, [EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName From vInventories As vi INNER JOIN vEmployees as ve ON vi.EmployeeID = ve.EmployeeID;
go

--Order By
Select DISTINCT InventoryDate, [EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName From vInventories As vi INNER JOIN vEmployees as ve ON vi.EmployeeID = ve.EmployeeID
Order By InventoryDate;
go

--Create View
Create View vInventoriesByEmployeesByDates WITH SCHEMABINDING As
Select DISTINCT TOP 1000000 InventoryDate, [EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName From vInventories As vi INNER JOIN vEmployees as ve ON vi.EmployeeID = ve.EmployeeID
Order By InventoryDate;
go
*/

--Q5 Final Version
Create View vInventoriesByEmployeesByDates WITH SCHEMABINDING As
Select DISTINCT TOP 1000000 
 InventoryDate
,[EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName 
From dbo.vInventories As vi 
INNER JOIN dbo.vEmployees As ve ON vi.EmployeeID = ve.EmployeeID
Order By 
InventoryDate;
go


-- Question 6 (10% pts): How can you create a view show a list of Categories, Products, 
-- and the Inventory Date and Count of each product?
-- Order the results by the Category, Product, Date, and Count!

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count
-- CategoryName	ProductName	InventoryDate	Count
-- Beverages	  Chai	      2017-01-01	  39
-- Beverages	  Chai	      2017-02-01	  49
-- Beverages	  Chai	      2017-03-01	  59
-- Beverages	  Chang	      2017-01-01	  17
-- Beverages	  Chang	      2017-02-01	  27
-- Beverages	  Chang	      2017-03-01	  37

/*
--Select all data
Select * From vCategories;
Select * From vProducts;
Select * From vInventories;
go

--Selected columns from tables
Select CategoryName From vCategories;
Select ProductName From vProducts;
Select InventoryDate, Count From vInventories;
go

--Join tables 
Select CategoryName, ProductName, InventoryDate, Count From vCategories As vc INNER JOIN vProducts As vp ON vc.CategoryID = vp.CategoryID
INNER JOIN vInventories As vi ON vp.ProductID = vi.ProductID;
go

--Order By 
Select CategoryName, ProductName From vCategories As vc INNER JOIN vProducts As vp ON vc.CategoryID = vp.CategoryID
INNER JOIN vInventories As vi ON vp.ProductID = vi.ProductID Order By CategoryName, ProductName, InventoryDate, Count;
go

--Create View
Create View vInventoriesByProductsByCategories WITH SCHEMABINDING As
Select TOP 1000000 CategoryName, ProductName, InventoryDate, Count From vCategories As vc INNER JOIN vProducts As vp ON vc.CategoryID = vp.CategoryID
INNER JOIN vInventories As vi ON vp.ProductID = vi.ProductID Order By CategoryName, ProductName, InventoryDate, Count;
go
*/

--Q6 Final Version
Create View vInventoriesByProductsByCategories WITH SCHEMABINDING As
Select TOP 1000000 
 CategoryName
,ProductName 
,InventoryDate
,Count
From dbo.vCategories As vc 
INNER JOIN dbo.vProducts As vp ON vc.CategoryID = vp.CategoryID
INNER JOIN dbo.vInventories As vi ON vp.ProductID = vi.ProductID 
Order By 
 CategoryName
,ProductName
,InventoryDate
,Count;
go

-- Question 7 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the EMPLOYEE who took the count?
-- Order the results by the Inventory Date, Category, Product and Employee!

-- Here is an example of some rows selected from the view:
-- CategoryName	ProductName	        InventoryDate	Count	EmployeeName
-- Beverages	  Chai	              2017-01-01	  39	  Steven Buchanan
-- Beverages	  Chang	              2017-01-01	  17	  Steven Buchanan
-- Beverages	  Chartreuse verte	  2017-01-01	  69	  Steven Buchanan
-- Beverages	  Côte de Blaye	      2017-01-01	  17	  Steven Buchanan
-- Beverages	  Guaraná Fantástica	2017-01-01	  20	  Steven Buchanan
-- Beverages	  Ipoh Coffee	        2017-01-01	  17	  Steven Buchanan
-- Beverages	  Lakkalikööri	      2017-01-01	  57	  Steven Buchanan

/*
--Select all data
Select * From vCategories;
Select * From vProducts;
Select * From vInventories;
Select *From vEmployees;
go 

--Selected columns from tables
Select CategoryName From vCategories;
Select ProductName From vProducts;
Select InventoryDate, Count From vInventories; 
Select [EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName From vEmployees;
go

--Join Tables 
Select CategoryName, ProductName, InventoryDate, Count, [EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
From vCategories As vc INNER JOIN vProducts As vp ON vc.CategoryID = vp.CategoryID 
INNER JOIN vInventories As vi ON vp.ProductID = vi.ProductID
INNER JOIN vEmployees As ve ON vi.EmployeeID = ve.EmployeeID;
go

--Order By
Select CategoryName, ProductName, InventoryDate, Count, [EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
From vCategories As vc INNER JOIN vProducts As vp ON vc.CategoryID = vp.CategoryID 
INNER JOIN vInventories As vi ON vp.ProductID = vi.ProductID
INNER JOIN vEmployees As ve ON vi.EmployeeID = ve.EmployeeID
Order By InventoryDate, CategoryName, ProductName, EmployeeName; 
go

--Create View
Create View vInventoriesByProductsByEmployees WITH SCHEMABINDING As 
Select TOP 1000000 CategoryName, ProductName, InventoryDate, Count, [EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
From vCategories As vc INNER JOIN vProducts As vp ON vc.CategoryID = vp.CategoryID 
INNER JOIN vInventories As vi ON vp.ProductID = vi.ProductID
INNER JOIN vEmployees As ve ON vi.EmployeeID = ve.EmployeeID
Order By InventoryDate, CategoryName, ProductName, EmployeeName; 
go
*/

--Q7 Final Version
Create View vInventoriesByProductsByEmployees WITH SCHEMABINDING As 
Select TOP 1000000 
 CategoryName
,ProductName
,InventoryDate
,Count
,[EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
From dbo.vCategories As vc 
INNER JOIN dbo.vProducts As vp ON vc.CategoryID = vp.CategoryID 
INNER JOIN dbo.vInventories As vi ON vp.ProductID = vi.ProductID
INNER JOIN dbo.vEmployees As ve ON vi.EmployeeID = ve.EmployeeID
Order By 
 InventoryDate
,CategoryName
,ProductName
,EmployeeName; 
go


-- Question 8 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the Employee who took the count
-- for the Products 'Chai' and 'Chang'? 

-- Here are the rows selected from the view:

-- CategoryName	ProductName	InventoryDate	Count	EmployeeName
-- Beverages	  Chai	      2017-01-01	  39	  Steven Buchanan
-- Beverages	  Chang	      2017-01-01	  17	  Steven Buchanan
-- Beverages	  Chai	      2017-02-01	  49	  Robert King
-- Beverages	  Chang	      2017-02-01	  27	  Robert King
-- Beverages	  Chai	      2017-03-01	  59	  Anne Dodsworth
-- Beverages	  Chang	      2017-03-01	  37	  Anne Dodsworth

/*
--Select all data
Select * From vCategories;
Select * From vProducts;
Select * From vInventories;
Select * From vEmployees;
go

--Selected columns from from tables 
Select CategoryName From vCategories;
Select ProductName From vProducts;
Select InventoryDate, Count From vInventories;
Select [EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName From vEmployees;
go

--Join tables 
Select CategoryName, ProductName, InventoryDate, Count, [EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
From vCategories As vc INNER JOIN vProducts As vp ON vc.CategoryID = vp.CategoryID 
INNER JOIN vInventories As vi ON vp.ProductID = vi.ProductID
INNER JOIN vEmployees As ve ON vi.EmployeeID = ve.EmployeeID;
go

--Subquery for Chai and Chang
Select CategoryName, ProductName, InventoryDate, Count, [EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
From vCategories As vc INNER JOIN vProducts As vp ON vc.CategoryID = vp.CategoryID 
INNER JOIN vInventories As vi ON vp.ProductID = vi.ProductID
INNER JOIN vEmployees As ve ON vi.EmployeeID = ve.EmployeeID
Where vp.ProductID In (Select ProductID From vProducts Where ProductName In ('Chai', 'Chang'));
go

--Order By
Select CategoryName, ProductName, InventoryDate, Count, [EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
From vCategories As vc INNER JOIN vProducts As vp ON vc.CategoryID = vp.CategoryID 
INNER JOIN vInventories As vi ON vp.ProductID = vi.ProductID
INNER JOIN vEmployees As ve ON vi.EmployeeID = ve.EmployeeID
Where vp.ProductID In (Select ProductID From vProducts Where ProductName In ('Chai', 'Chang'))
Order By InventoryDate, CategoryName, ProductName; -- As seen on order of sample rows
go

--Create View
Create View vInventoriesForChaiAndChangByEmployees WITH SCHEMABINDING As
Select TOP 1000000 CategoryName, ProductName, InventoryDate, Count, [EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
From vCategories As vc INNER JOIN vProducts As vp ON vc.CategoryID = vp.CategoryID 
INNER JOIN vInventories As vi ON vp.ProductID = vi.ProductID
INNER JOIN vEmployees As ve ON vi.EmployeeID = ve.EmployeeID
Where vp.ProductID In (Select ProductID From vProducts Where ProductName In ('Chai', 'Chang'))
Order By InventoryDate, CategoryName, ProductName;
go
*/

--Q8 Final Version
Create View vInventoriesForChaiAndChangByEmployees WITH SCHEMABINDING As
Select TOP 1000000
 CategoryName
,ProductName
,InventoryDate
,Count
,[EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
From dbo.vCategories As vc 
INNER JOIN dbo.vProducts As vp ON vc.CategoryID = vp.CategoryID 
INNER JOIN dbo.vInventories As vi ON vp.ProductID = vi.ProductID
INNER JOIN dbo.vEmployees As ve ON vi.EmployeeID = ve.EmployeeID
Where vp.ProductID In (Select ProductID From dbo.vProducts 
						Where ProductName In ('Chai', 'Chang'))
Order By 
 InventoryDate
,CategoryName
,ProductName;
go

-- Question 9 (10% pts): How can you create a view to show a list of Employees and the Manager who manages them?
-- Order the results by the Manager's name!

-- Here are teh rows selected from the view:
-- Manager	        Employee
-- Andrew Fuller	  Andrew Fuller
-- Andrew Fuller	  Janet Leverling
-- Andrew Fuller	  Laura Callahan
-- Andrew Fuller	  Margaret Peacock
-- Andrew Fuller	  Nancy Davolio
-- Andrew Fuller	  Steven Buchanan
-- Steven Buchanan	Anne Dodsworth
-- Steven Buchanan	Michael Suyama
-- Steven Buchanan	Robert King

/*
--Look all data
Select * From vEmployees;
go

--Look at selected columns
Select [Manager] = EmployeeFirstName + ' ' + EmployeeLastName, [Employee] = EmployeeFirstName + ' ' + EmployeeLastName From vEmployees;
go

--Combine via self join
Select [Manager] = vmgr.EmployeeFirstName + ' ' + vmgr.EmployeeLastName, [Employee] = vemp.EmployeeFirstName + ' ' + vemp.EmployeeLastName 
From vEmployees As vemp INNER JOIN vEmployees As vmgr On vemp.ManagerID = vmgr.EmployeeID;
go

--Order Results
Select [Manager] = vmgr.EmployeeFirstName + ' ' + vmgr.EmployeeLastName, [Employee] = vemp.EmployeeFirstName + ' ' + vemp.EmployeeLastName 
From vEmployees As vemp INNER JOIN vEmployees As vmgr On vemp.ManagerID = vmgr.EmployeeID
Order By [Manager], [Employee];
go

--Create View
Create View vEmployeesByManager WITH SCHEMABINDING As
Select TOP 1000000 [Manager] = vmgr.EmployeeFirstName + ' ' + vmgr.EmployeeLastName, [Employee] = vemp.EmployeeFirstName + ' ' + vemp.EmployeeLastName 
From vEmployees As vemp INNER JOIN vEmployees As vmgr On vemp.ManagerID = vmgr.EmployeeID
Order By [Manager], [Employee];
go
*/

--Q9 Final Version
Create View vEmployeesByManager WITH SCHEMABINDING As
Select TOP 1000000 
 [Manager] = vmgr.EmployeeFirstName + ' ' + vmgr.EmployeeLastName
,[Employee] = vemp.EmployeeFirstName + ' ' + vemp.EmployeeLastName 
From dbo.vEmployees As vemp 
INNER JOIN dbo.vEmployees As vmgr ON vemp.ManagerID = vmgr.EmployeeID
Order By [Manager], [Employee];
go

-- Question 10 (20% pts): How can you create one view to show all the data from all four 
-- BASIC Views? Also show the Employee's Manager Name and order the data by 
-- Category, Product, InventoryID, and Employee.

-- Here is an example of some rows selected from the view:
-- CategoryID	  CategoryName	ProductID	ProductName	        UnitPrice	InventoryID	InventoryDate	Count	EmployeeID	Employee
-- 1	          Beverages	    1	        Chai	              18.00	    1	          2017-01-01	  39	  5	          Steven Buchanan
-- 1	          Beverages	    1	        Chai	              18.00	    78	        2017-02-01	  49	  7	          Robert King
-- 1	          Beverages	    1	        Chai	              18.00	    155	        2017-03-01	  59	  9	          Anne Dodsworth
-- 1	          Beverages	    2	        Chang	              19.00	    2	          2017-01-01	  17	  5	          Steven Buchanan
-- 1	          Beverages	    2	        Chang	              19.00	    79	        2017-02-01	  27	  7	          Robert King
-- 1	          Beverages	    2	        Chang	              19.00	    156	        2017-03-01	  37	  9	          Anne Dodsworth
-- 1	          Beverages	    24	      Guaraná Fantástica	4.50	    24	        2017-01-01	  20	  5	          Steven Buchanan
-- 1	          Beverages	    24	      Guaraná Fantástica	4.50	    101	        2017-02-01	  30	  7	          Robert King
-- 1	          Beverages	    24	      Guaraná Fantástica	4.50	    178	        2017-03-01	  40	  9	          Anne Dodsworth
-- 1	          Beverages	    34	      Sasquatch Ale	      14.00	    34	        2017-01-01	  111	  5	          Steven Buchanan
-- 1	          Beverages	    34	      Sasquatch Ale	      14.00	    111	        2017-02-01	  121	  7	          Robert King
-- 1	          Beverages	    34	      Sasquatch Ale	      14.00	    188	        2017-03-01	  131	  9	          Anne Dodsworth


-- Test your Views (NOTE: You must change the names to match yours as needed!)

/*
--Select all data
Select * From vCategories;
Select * From vProducts;
Select * From vInventories;
Select * From vEmployees;
go

--Selected columns from table
Select CategoryID, CategoryName From vCategories;
Select ProductID, ProductName, UnitPrice From vProducts;
Select InventoryID, InventoryDate, Count From vInventories;
Select EmployeeID, [Manager] = EmployeeFirstName + ' ' + EmployeeLastName, [Employee] = EmployeeFirstName + ' ' + EmployeeLastName From vEmployees;
go


--Join tables 
Select vc.CategoryID, CategoryName, vp.ProductID, ProductName, UnitPrice, InventoryID, InventoryDate, Count, vemp.EmployeeID, [Manager] = vmgr.EmployeeFirstName + ' ' + vmgr.EmployeeLastName, [Employee] = vemp.EmployeeFirstName + ' ' + vemp.EmployeeLastName
From vCategories As vc INNER JOIN vProducts As vp ON vc.CategoryID = vp.CategoryID
INNER JOIN vInventories As vi ON vp.ProductID = vi.ProductID
INNER JOIN vEmployees As vemp ON vi.EmployeeID = vemp.EmployeeID
INNER JOIN vEmployees As vmgr ON vemp.ManagerID = vmgr.EmployeeID;
go

--Order By
Select vc.CategoryID, CategoryName, vp.ProductID, ProductName, UnitPrice, InventoryID, InventoryDate, Count, vemp.EmployeeID, [Manager] = vmgr.EmployeeFirstName + ' ' + vmgr.EmployeeLastName, [Employee] = vemp.EmployeeFirstName + ' ' + vemp.EmployeeLastName 
From vCategories As vc INNER JOIN vProducts As vp ON vc.CategoryID = vp.CategoryID
INNER JOIN vInventories As vi ON vp.ProductID = vi.ProductID
INNER JOIN vEmployees As vemp ON vi.EmployeeID = vemp.EmployeeID
INNER JOIN vEmployees As vmgr ON vemp.ManagerID = vmgr.EmployeeID
Order By CategoryName, ProductName, InventoryID, [Employee];

--Create View
Create View vInventoriesByProductsByCategoriesByEmployees WITH SCHEMABINDING As
Select TOP 1000000 vc.CategoryID, CategoryName, vp.ProductID, ProductName, UnitPrice, InventoryID, InventoryDate, Count, vemp.EmployeeID, [Manager] = vmgr.EmployeeFirstName + ' ' + vmgr.EmployeeLastName, [Employee] = vemp.EmployeeFirstName + ' ' + vemp.EmployeeLastName
From vCategories As vc INNER JOIN vProducts As vp ON vc.CategoryID = vp.CategoryID
INNER JOIN vInventories As vi ON vp.ProductID = vi.ProductID
INNER JOIN vEmployees As vemp ON vi.EmployeeID = vemp.EmployeeID
INNER JOIN vEmployees As vmgr ON vemp.ManagerID = vmgr.EmployeeID
Order By CategoryName, ProductName, InventoryID, [Employee];
*/

--Q10 Final Version
Create View vInventoriesByProductsByCategoriesByEmployees WITH SCHEMABINDING As
Select TOP 1000000 
 vc.CategoryID
,CategoryName
,vp.ProductID
,ProductName
,UnitPrice
,InventoryID
,InventoryDate
,Count
,vemp.EmployeeID
,[Manager] = vmgr.EmployeeFirstName + ' ' + vmgr.EmployeeLastName
,[Employee] = vemp.EmployeeFirstName + ' ' + vemp.EmployeeLastName
From dbo.vCategories As vc 
INNER JOIN dbo.vProducts As vp ON vc.CategoryID = vp.CategoryID
INNER JOIN dbo.vInventories As vi ON vp.ProductID = vi.ProductID
INNER JOIN dbo.vEmployees As vemp ON vi.EmployeeID = vemp.EmployeeID
INNER JOIN dbo.vEmployees As vmgr ON vemp.ManagerID = vmgr.EmployeeID
Order By 
 CategoryName
,ProductName
,InventoryID
,[Employee];
go

Print 'Note: You will get an error until the views are created!'
Select * From [dbo].[vCategories]
Select * From [dbo].[vProducts]
Select * From [dbo].[vInventories]
Select * From [dbo].[vEmployees]

Select * From [dbo].[vProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByDates]
Select * From [dbo].[vInventoriesByEmployeesByDates]
Select * From [dbo].[vInventoriesByProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByEmployees]
Select * From [dbo].[vInventoriesForChaiAndChangByEmployees]
Select * From [dbo].[vEmployeesByManager]
Select * From [dbo].[vInventoriesByProductsByCategoriesByEmployees]

/***************************************************************************************/