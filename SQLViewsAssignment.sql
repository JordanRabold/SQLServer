--#1: Write a Create View statement that defines a view named InvoiceBasic
--that returns three columns: VendorName, InvoiceNumber, and InvoiceTotal.
--Then, write a SELECT statement that returns all of the columns in the view, 
--sorted by VendorName, where the first letter of the vendor name is N, O, or P.
GO
CREATE VIEW vw_InvoiceBasic
AS 
	SELECT VendorName
		, InvoiceNumber
		, InvoiceTotal
	FROM Vendors JOIN Invoices
		ON Vendors.VendorID = Invoices.VendorID
GO

SELECT VendorName
	, InvoiceNumber
	, InvoiceTotal
FROM vw_InvoiceBasic
WHERE LEFT(VendorName, 1) = 'N'
	OR LEFT(VendorName, 1) = 'O'
	OR LEFT(VendorName, 1) = 'P'

--#2:  Create a view named Top10PaidInvoices that returns three columns 
--for each vendor: VendorName, LastInvoice (the most recent invoice date), 
--and SumOfInvoices (the sum of the InvoiceTotal column). Return only the 10 
--vendors with the largest SumOfInvoices and include only paid invoices. 
--*Paid invoices do not have a balance due.

GO
CREATE VIEW vw_Top10PaidInvoices
AS
	SELECT TOP 10 
		  VendorName
		, MAX(InvoiceDate) AS LastInvoice
		, SUM(InvoiceTotal) AS SumOfInvoices
	FROM Vendors JOIN Invoices
		ON Vendors.VendorID = Invoices.VendorID
GO	

--#3: Create an updatable view named VendorAddress that returns the VendorID, 
--both address columns, and the city, state, and zip code columns for each vendor. 
--Then, write a SELECT query to examine the result set where VendorID = 4. 
--Next, write an UPDATE statement that changes the address so that the suite 
--number (Ste 260) is stored in the VendorAddress2 rather than in the VendorAddress1.
--To verify the change, rerun your SELECT query.

SELECT *
FROM Vendors

GO
CREATE VIEW vw_VendorAddress
AS
	SELECT VendorAddress1
		, VendorAddress2
		, VendorCity
		, VendorState
		, VendorZipCode
		, VendorID
	FROM Vendors 
GO

SELECT VendorAddress1
	, VendorAddress2
	, VendorCity
	, VendorState
	, VendorZipCode
	, VendorID
FROM vw_VendorAddress
WHERE VendorID = 4

BEGIN TRAN
UPDATE vw_VendorAddress
SET VendorAddress1 = '1990 Westwood blvd'
WHERE VendorID = 4
ROLLBACK TRAN

BEGIN TRAN
UPDATE vw_VendorAddress
SET VendorAddress2 = 'Ste 260'
WHERE VendorID = 4
ROLLBACK TRAN

--#4: Modify (using ALTER VIEW) the InvoiceBasic view created in exercise 
--to get the first 10 vendors sorted by VendorName in ascending order.

GO
ALTER VIEW vw_InvoiceBasic
AS
	SELECT TOP 10 
		  VendorName
		, InvoiceNumber
		, InvoiceTotal
	FROM Vendors JOIN Invoices
		ON Vendors.VendorID = Invoices.VendorID
	ORDER BY VendorName ASC
GO
--SELECT * 
--FROM vw_InvoiceBasic

--#5: Given the following view, add column alias's for each column WITHOUT 
--modifying the SELECT clause. (You will need to refer to the textbook for 
--this one, or the official docs)
GO
CREATE VIEW vw_InvoiceInfo
	(VendorName, VendorAddress, BalanceDue)
AS
	SELECT VendorName
	,VendorCity + ', ' + VendorState
	,InvoiceTotal - PaymentTotal - CreditTotal
	FROM Vendors JOIN Invoices 
		ON Vendors.VendorID = Invoices.VendorID
GO

--SELECT *
--FROM vw_InvoiceInfo