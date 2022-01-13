--#1: Write a SELECT statement that returns all columns from the Vendors table 
--inner-joined with the Invoices table

SELECT *
FROM Vendors JOIN Invoices ON
	Vendors.VendorID= Invoices.VendorID

--#2: Write a SELECT statement that returns four columns:

--VendorName       From the Vendors table
--InvoiceNumber    From the Invoices table
--InvoiceDate      From the Invoices table
--Balance          InvoiceTotal minus the sum of PaymentTotal and CreditTotal

--The result set should have one row for each invoice with a non-zero balance. 
--Sort the result set by VendorName in ascending order.

SELECT VendorName
	, InvoiceNumber
	, InvoiceDate
	, InvoiceTotal - (PaymentTotal + CreditTotal) AS Balance
FROM Vendors
	JOIN Invoices ON Invoices.VendorID = Vendors.VendorID
ORDER BY VendorName ASC

--#3: Write a SELECT statement that returns three columns:

--VendorName           From the Vendors table
--DefaultAccountNo     From the Vendors table
--AccountDescription   From the GLAccounts table

--The result set should have one row for each vendor, 
--with the account number and account description for that vendor's default account number. 
--Sort the result set by AccountDescription, then by VendorName.

SELECT VendorName
	, DefaultAccountNo
	, AccountDescription
FROM Vendors JOIN GLAccounts ON Vendors.DefaultAccountNo = GLAccounts.AccountNo 
ORDER BY AccountDescription
	, VendorName

--#4: Generate the same result set described in exercise 2, but with the implicit join syntax.
SELECT VendorName
	, DefaultAccountNo
	, AccountDescription
FROM Vendors, GLAccounts 
WHERE Vendors.DefaultAccountNo = GLAccounts.AccountNo
ORDER BY AccountDescription
	, VendorName

--#5: Write a SELECT statement that returns five columns from three tables, all using column aliases:

--Vendor       VendorName column
--Date         InvoiceDate column
--Number       InvoiceNumber column
--#            InvoiceSequence column
--LineItem     InvoiceLineItemAmount column

--Assign the following correlation names to the tables:

--v     Vendors table
--i     Invoices table
--li    InvoiceLineItems table
--Sort the final result set by Vendor, Date, Number, and #.

SELECT VendorName AS Vendor
	, InvoiceDate AS Date
	, InvoiceNumber AS Number
	, InvoiceSequence AS #
	, InvoiceLineItemAmount AS LineItem
FROM Vendors AS V JOIN Invoices AS I ON V.VendorID = I.VendorID
	JOIN InvoiceLineItems AS li ON li.InvoiceID = I.InvoiceID
ORDER BY Vendor
	, Date
	, Number
	, #

--#6:Write a SELECT statement that returns three columns:

--VendorID          From the Vendors table
--VendorName        From the Vendors table
--Name              A concatenation of VendorContactFName and VendorContactLName, 
--                  with a space in between

--The result set should have one row for each vendor whose contact has the 
--same first name as another vendors contact. Sort the final result set by Name.

--Hint: Use a self-join

SELECT V1.VendorID
	, V1.VendorName
	, CONCAT(V1.VendorContactFName, ' ', V1.VendorContactLName) AS Name
FROM Vendors AS V1 INNER JOIN Vendors AS V2
	ON V1.VendorContactFName = V2.VendorContactFName
ORDER BY Name


--#7: Write a SELECT statement that returns two columns from the 
--GLAccounts table: AccountNo and AccountDescription. 
--The result set should have one row for each account number that has never been used. 
--Sort the final result set by AccountNo.

--Hint: Use an outer join to the InvoiceLineItems table.

SELECT GLAccounts.AccountNo
	, GLAccounts.AccountDescription
FROM GLAccounts LEFT JOIN InvoiceLineItems 
	ON GLAccounts.AccountNo = InvoiceLineItems.AccountNo
WHERE InvoiceLineItems.AccountNo IS NULL
ORDER BY AccountNo

--#8: Use the UNION operator to generate a result set consisting of 
--two columns from the Vendors table: VendorName and VendorState. 
--If the vendor is in California, the VendorState value should be "CA" otherwise, 
--the VendorState value should be "Outside CA". Sort the final result set by VendorName

	SELECT VendorName
		, 'CA' AS VendorState 
	FROM Vendors
	WHERE VendorState = 'CA' 
UNION 
	SELECT VendorName
		, 'Outside CA' AS VendorState  
	FROM Vendors
	WHERE VendorState <> 'CA'
ORDER BY VendorName



