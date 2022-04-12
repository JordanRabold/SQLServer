USE master
DROP DATABASE IF EXISTS Rhino

CREATE DATABASE Rhino;
GO

USE Rhino;
GO

--CREATING TABLES--

CREATE TABLE dbo.Customer
(
	CustomerID		int				IDENTITY(1, 1)		PRIMARY KEY
	,FullName		varchar(80)		NOT NULL
	,Email			varchar(100)	NOT NULL
	,Phone			varchar(30)		NOT NULL
	,Address		varchar(100)	NOT NULL
	,City			varchar(50)		NOT NULL
	,State			varchar(50)		NOT NULL
	,Zipcode		varchar(20)		NOT NULL
	,Country		varchar(50)		NOT NULL
)

SET IDENTITY_INSERT Customer ON

INSERT INTO Customer(CustomerID, FullName, Email, Phone, Address, City, State, Zipcode, Country)
	VALUES(1, 'Annie Ferguson', 'A.Ferguson@email.com', '(253)555-5555', '123 EZ St.', 'Puyallup', 'WA', '98373', 'United States')
		,(2, 'Nick Lowtan', 'N.Lowtan@email.com', '(253)555-5554', '123 E Sumner Rd.', 'Sumner', 'WA', '98374', 'United States')
		,(3, 'Yuki Tsuji', 'Y.Tsuji@email.com', '(555)555-5553', '3-4-30-2F', 'Shiba', 'Tokyo', '163-8001', 'Japan')
		,(4, 'Concierge Marie', 'C.Marie@email.com', '(204)986-5971', '510 MAIN ST', 'Winnipeg', 'MB', 'R2C 0A4', 'Canada')
		,(5, 'Michael Scott', 'M.Scott@email.com', '(308)856-9826', '1725 Slough Avenue', 'Scranton', 'PA', '18503', 'United States') 

SET IDENTITY_INSERT Customer OFF

CREATE TABLE CustomerLogin
(
	CustomerID		int				REFERENCES Customer(CustomerID)
	,Username		varchar(100)	NOT NULL
	,Password		varchar(100)	NOT NULL
)

INSERT INTO CustomerLogin(CustomerID, Username, Password)
	VALUES(1, 'A.Ferguson', HASHBYTES('SHA1', 'password01'))
		,(2, 'N.Lowtan', HASHBYTES('SHA1', 'password02'))
		,(3, 'Y.Tsuji', HASHBYTES('SHA1', 'password03'))
		,(4, 'C.Marie', HASHBYTES('SHA1', 'OhCanada'))
		,(5, 'M.Scott', HASHBYTES('SHA1', 'WorldsBestBoss'))

CREATE TABLE Employees
(
	EmployeeID			int				IDENTITY(5000, 100)		PRIMARY KEY
	,FullName			varchar(50)		NOT NULL
	,JobTitle			varchar(50)		NOT NULL
	,HireDate			smalldatetime	NOT NULL
	,LeaveDate			smalldatetime	NULL
	,Address			varchar(50)		NOT NULL
	,City				varchar(50)		NOT NULL
	,State				varchar(50)		NOT NULL
	,VacationHours		tinyint			NOT NULL
	,SickLeaveHours		tinyint			NOT NULL
	,BenefitsStatus		varchar(20)		CHECK (BenefitsStatus IN('Enrolled', 'Opted Out')) NOT NULL 
)

SET IDENTITY_INSERT Employees ON

INSERT INTO Employees(EmployeeID, FullName, JobTitle, HireDate, LeaveDate, Address, City, State,
						VacationHours , SickLeaveHours, BenefitsStatus)
	Values(5000, 'Jordan Rabold', 'RMA Technician', '2015-12-15', NULL, '12101 98th st.', 'Puyallup', 'WA',
			40, 20, 'Opted Out')
		  ,(5100, 'Jeremy Lamoy', 'Chief Production Officer', '2012-09-27', NULL, '123 E St.', 'Puyallup', 'WA',
			120, 40, 'Enrolled')
		  ,(5200, 'Jenna Johnson', 'Warehouse Manager', '2015-05-15', NULL, '125 N St.', 'Tacoma', 'WA',
			40, 20, 'Opted Out')
		  ,(5300, 'Nathen Dusenbery', 'Shipping Specialist', '2020-03-11', NULL, '126 W St.', 'Tacoma', 'WA',
			40, 20, 'Enrolled')
		  ,(5400, 'Joey Touch', 'Assembly Technician', '2019-05-28', NULL, '127 S St.', 'Spanaway', 'WA',
			40, 20, 'Opted Out')

SET IDENTITY_INSERT Employees OFF

CREATE TABLE EmployeePay
(
	EmployeeID		int				REFERENCES Employees(EmployeeID)
	,PayRate		float			NOT NULL
	,PayFrequency	varchar(10)		CHECK (PayFrequency IN('Hourly', 'Salary'))	
	,ModifiedDate	smalldatetime	NOT NULL
)

INSERT INTO EmployeePay(EmployeeID, PayRate, PayFrequency, ModifiedDate)
	VALUES(5000, 21.00, 'Hourly', GETDATE())
		,(5100, 50000.00, 'Salary', GETDATE())
		,(5200, 23.00, 'Hourly', GETDATE())
		,(5300, 20.00, 'Hourly', GETDATE())
		,(5400, 21.00, 'Hourly', GETDATE())


CREATE TABLE ProductCategory
(
	ProductCategoryID				int				IDENTITY(1, 1) PRIMARY KEY
	,ProductCategoryName			varchar(50)		NOT NULL
	,ProductCategoryDescription		varchar(100)	NOT NULL	
)

SET IDENTITY_INSERT ProductCategory ON

INSERT INTO ProductCategory(ProductCategoryID, ProductCategoryName, ProductCategoryDescription)
	VALUES(1, '4 Axis Motion Control', 'Capture more with the most versatile motorized camera slider')
		,(2, '4 Axis Motion Control Bundles', 'Essential, Time-Lapse, and Ultimate slider bundles')
		,(3, 'ROV Motorized Sliders', 'Portable sliders for you phone')
		,(4, 'B-stock Products', '20% off our popular products!')
SET IDENTITY_INSERT ProductCategory OFF


CREATE TABLE Product
(
	ProductID			int				IDENTITY(100, 1)	PRIMARY KEY
	,Title				varchar(50)		NOT NULL
	,Description		varchar(100)	NOT NULL
	,RetailPrice		float			NOT NULL
	,ProductCategoryID	int				REFERENCES ProductCategory(ProductCategoryID)
)
SET IDENTITY_INSERT Product ON
INSERT INTO Product(ProductID, Title, Description, RetailPrice, ProductCategoryID)
	VALUES(100, 'Rhino Arc II', '4 axis motorized pan head', 14000.00, 1)
		,(101, 'Rhino Focus V2', 'Motorized camera focus', 300.00, 1)
		,(102, 'Rhino Slider Motor', 'High speed motor designed for Rhino slider', 250.00, 1)
		,(103, 'Rhino Slider', 'Carbon or steel rail sliders for stop motion filming', 600.00, 1)
SET IDENTITY_INSERT Product OFF


CREATE TABLE ProductImages
(
	ImageID			int				IDENTITY(1, 1)	PRIMARY KEY
	,ProductID		int				REFERENCES	Product(ProductID)
	,ImageUrl		varchar(400)	NOT NULL
)


SET IDENTITY_INSERT ProductImages ON
INSERT INTO ProductImages(ImageID, ProductID, ImageUrl)
	VALUES(1, 100, 'https://via.placeholder.com/150')
		,(2, 101, 'https://via.placeholder.com/150')
		,(3, 102, 'https://via.placeholder.com/150')
		,(4, 103, 'https://via.placeholder.com/150')
SET IDENTITY_INSERT ProductImages OFF


CREATE TABLE ProductParts
(
	ProductPartsID			int				IDENTITY(1, 1)	PRIMARY KEY
	,ProductID				int				REFERENCES Product(ProductID)
	,ProductPartsName		varchar(50)		NOT NULL
	,ProductPartsQty		int				NOT NULL
	,ProductPartsVendor		varchar(50)		NOT NULL
)
SET IDENTITY_INSERT ProductParts ON
INSERT INTO ProductParts(ProductPartsID, ProductID, ProductPartsName, ProductPartsQty, ProductPartsVendor)
	VALUES(1, 100, 'Front Housing', 1, 'Midwest Mold')
		,(2, 100, 'Back Housing', 1, 'Midwest Mold')
		,(3, 100, 'Baseplate', 1, 'Alljack')
		,(4, 100, 'Tilt Arm', 1, 'Alljack')
		,(5, 100, 'Upper PCB', 1, 'Schippers & Crew')
SET IDENTITY_INSERT ProductParts OFF


CREATE TABLE ProductTroubleshooting
(
	ProductIssueID			int				IDENTITY(1, 1) PRIMARY KEY
	,ProductID				int				REFERENCES Product(ProductID)
	,ProductIssue			varchar(200)	NOT NULL
	,TroubleshootingSteps	varchar(5000)	NOT NULL
)
SET IDENTITY_INSERT ProductTroubleshooting ON
INSERT INTO ProductTroubleshooting(ProductIssueID, ProductID, ProductIssue, TroubleshootingSteps)
	VALUES(1, 100, '4 Axis Fail', 'Send in for repair')
		,(2, 100, 'Quick release plate loose', 'Use a 3mm hex driver to tighten the Tilt Arm bolt')
		,(3, 100, 'Blank Screen', 'Send in for repair')
		,(4, 101, 'Too much backlash/slipping', 'Use a 1.5mm hex driver to tighten the 2 set screws on the side')
		,(5, 102, 'Will not calibrate', 'Send in for repair')
SET IDENTITY_INSERT ProductTroubleshooting OFF


CREATE TABLE CustomerRepairs
(
	RepairNumber				int				IDENTITY(1, 1) PRIMARY KEY
	,CustomerID					int				REFERENCES Customer(CustomerID)
	,ProductID					int				REFERENCES Product(ProductID)
	,ProductPartsID				int				REFERENCES ProductParts(ProductPartsID)
	,WarrantyStatus				bit				NOT NULL DEFAULT 'False'
	,ProductIssueDescription	varchar(100)	NOT NULL
	,RepairCost					float			NOT NULL
	,RepairNotes				varchar(1000)	NOT NULL
)
SET IDENTITY_INSERT CustomerRepairs ON

INSERT INTO CustomerRepairs(RepairNumber, CustomerID, ProductID, ProductPartsID, WarrantyStatus
	, ProductIssueDescription, RepairCost, RepairNotes)
	VALUES(1, 1, 100, 1, DEFAULT, 'Front housing damaged', 20.00, 'Replaced front housing')
		,(2, 2, 100, 2, 'True', 'Back housing damaged', 15.00, 'Replaced back housing') 
		,(3, 3, 100, 5, 'True', '4 axis fail', 160.00, 'Replaced upper PCB')

SET IDENTITY_INSERT CustomerRepairs OFF


CREATE TABLE Orders
(
	OrderNumber			int					IDENTITY(1, 1) PRIMARY KEY
	,CustomerID			int					REFERENCES Customer(CustomerID)
	,OrderDate			smalldatetime		NOT NULL
	,OrderTotal			float				NOT NULL
	,Status				varchar(20)			CHECK (Status IN('Completed', 'Cancelled', 'Pending')) NOT NULL
	,OrderShipDate		smalldatetime		NOT NULL
	,ShippingMethod		varchar(50)			NOT NULL
)
SET IDENTITY_INSERT Orders ON

INSERT INTO Orders(OrderNumber, CustomerID, OrderDate, OrderTotal, Status, OrderShipDate, ShippingMethod)
	VALUES(1, 1, GETDATE(), 500.00, 'Completed', GETDATE(), 'FedEx')
		,(2, 2, 2/22/2022, 150.00, 'Cancelled', GETDATE(), 'DHL')
		,(3, 3, 1/05/2020, 1500.00, 'Completed', GETDATE(), 'UPS')
		,(4, 4, GETDATE(), 300.00, 'Pending', GETDATE(), 'USPS')

SET IDENTITY_INSERT Orders OFF


CREATE TABLE OrderItems
(
	OrderNumber		int				REFERENCES Orders(OrderNumber)
	,ProductID		int				REFERENCES Product(ProductID)
	,Qty			smallint		NOT NULL
)

INSERT INTO OrderItems(OrderNumber, ProductID, Qty)
	VALUES(1, 100, 2)
		,(2, 101, 1)
		,(3, 102, 5)
		,(4, 103, 3)

----------SELECT STATEMENTS-------------

-- #1: Get customers who live in the United States
SELECT FullName
	, Country
FROM Customer
WHERE Country = 'United States'


--#2: Get customers who have completed orders
SELECT FullName
	, OrderNumber
	, Status
FROM Customer JOIN Orders ON Customer.CustomerID = Orders.CustomerID
WHERE Status = 'Completed'


--#3: Get employees who are payed over 20.00 hourly and sort by highest payrate first
SELECT FullName
	, PayRate
	, PayFrequency
FROM Employees JOIN EmployeePay ON EmployeePay.EmployeeID = Employees.EmployeeID
WHERE PayRate >= 20.00
	AND PayFrequency = 'Hourly'
ORDER BY PayRate DESC


--#4: Get a list of all customer repairs
SELECT *
FROM CustomerRepairs
-- This one is simple but its something I would look at every single day on a spreadsheet. 


--#5: Get product troubleshooting steps for Arc II
SELECT ProductID
	, ProductIssue
	,TroubleshootingSteps
FROM ProductTroubleshooting
WHERE ProductID = 100

--#6: Get list of customers who ordered more than 1 qty of products. Sort by highest qty last
SELECT Customer.CustomerID
	, ProductID
	, Qty
FROM Customer JOIN Orders ON Orders.CustomerID = Customer.CustomerID
	JOIN OrderItems ON OrderItems.OrderNumber = Orders.OrderNumber
WHERE Qty > 1
ORDER BY Qty ASC

--#7: Get list of all customers and their login info
SELECT FullName
	, Username
	, Password
FROM Customer JOIN CustomerLogin ON CustomerLogin.CustomerID = Customer.CustomerID

