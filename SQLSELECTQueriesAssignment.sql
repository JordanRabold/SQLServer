--#1 Write a SELECT statement that returns three columns from the Vendors table: VendorContactFName, VendorContactLName, and VendorName.
--Sort the result set by last name, then by first name. (This should be answered in a single quesry)

SELECT VendorContactFName
	, VendorContactLName
	, VendorName
FROM Vendors
ORDER BY VendorContactLName

--#2 Write a SELECT statement that returns four columns from the Invoices table named: number, total, credits, and Balance.

SELECT InvoiceNumber AS Number
	, InvoiceTotal AS Total
	, PaymentTotal + CreditTotal AS Credits
	, InvoiceTotal - PaymentTotal - CreditTotal AS Balance
FROM Invoices 

--#3 Write a SELECT statement that returns one column from the Vendors table named: Full name. Create this column
--from the VendorContactFName and VendorContactLName columns. Format is as follows: Last name, comma, first name 
--For example: "Doe, John". Sort the result set by last name, then by first name

SELECT VendorContactFName + ', ' + VendorContactLName AS VendorName
FROM Vendors
ORDER BY VendorContactLName, VendorContactFName;

--#4 Write a SELECT statement that returns three columns: 
-- InvoiceTotal - from the invoices table
-- 10% - 10% of the value of InvoiceTotal
-- Plus 10% - The value of InvoiceTotal plus 10%

SELECT InvoiceTotal
	, (InvoiceTotal * .10) AS '10%'
	, (InvoiceTotal * .10) + InvoiceTotal  AS 'Plus 10%'
FROM Invoices
WHERE InvoiceTotal > 1000
ORDER BY InvoiceTotal DESC

--#5 Modify the solution to exercise 2 to filter for invoices with an InvoiceTotal 
--that’s greater than or equal to $500 but less than or equal to $10,000.

SELECT InvoiceNumber AS Number
	, InvoiceTotal AS Total
	, PaymentTotal + CreditTotal AS Credits
	, InvoiceTotal - PaymentTotal - CreditTotal AS Balance
FROM Invoices 
WHERE InvoiceTotal >= $500 AND InvoiceTotal <= $10000

-- #6 Modify the solution to exercise 3 to filter for contacts 
--whose last name begins with the letter A, B, C, or E.

SELECT VendorContactFName + ',' + VendorContactLName AS VendorName
FROM Vendors
WHERE VendorContactLName LIKE '[A-C,E]%'
ORDER BY VendorContactLName, VendorContactFName;

--#7 Write a SELECT statement that determines whether the PaymentDate column 
--of the Invoices table has any invalid values. To be valid, PaymentDate must 
--be a null value if there’s a balance due and a non-null value if there’s no 
--balance due. Code a compound condition in the WHERE clause that tests for these conditions.

SELECT*
FROM Invoices
WHERE InvoiceTotal - PaymentTotal - CreditTotal <=0 AND PaymentDate IS NULL
OR InvoiceTotal - PaymentTotal - CreditTotal >=0 AND PaymentDate IS NOT NULL