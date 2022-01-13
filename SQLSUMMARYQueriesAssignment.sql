--#1:Write a SELECT statement that returns two columns from the Invoices table: 
--VendorID and PaymentSum, where PaymentSum is the sum of the PaymentTotal column. 
--Group the result set by VendorID.

SELECT VendorId
	, SUM(PaymentTotal) AS PaymentSum
FROM Invoices
GROUP BY VendorID

--#2:Write a SELECT statement that returns two columns: VendorName and PaymentSum, 
--where PaymentSum is the sum of the PaymentTotal column. Group the result set 
--by VendorName. Return only 10 rows, corresponding to the 10 Vendors who’ve been paid the most.
--Hint: Use the TOP clause and join Vendors to Invoices.

SELECT TOP 10 VendorName
	, SUM(PaymentTotal) AS PaymentSum
FROM Vendors JOIN Invoices ON
	Vendors.VendorID = Invoices.VendorID
GROUP BY VendorName

--#3:Write a SELECT statement that returns three columns: VendorName, InvoiceCount, and InvoiceSum. 
--InvoiceCount is the count of the number of invoices, InvoiceSum is the sum of the InvoiceTotal column. 
--Group the result set by the vendor. Sort the result set so that the vendor with the 
--highest number of invoices appears first.

SELECT VendorName
	, COUNT(*) AS InvoiceCount
	, SUM(InvoiceTotal) AS InvoiceSum
FROM Vendors JOIN Invoices ON
	Vendors.VendorID = Invoices.VendorID
GROUP BY VendorName
ORDER BY InvoiceCount DESC

--#4:Write a SELECT statement that returns three columns: AccountDescription, LineItemCount, and LineItemSum. 
--LineItemCount is the number of entries in the InvoiceLineItems table that have that AccountNo. 
--LineItemSum is the sum of the InvoiceLineItemAmount column for that AccountNo. 
--Filter the result set to include only those rows with LineItemCount greater than 1. 
--Group the result set by account description, and sort it be descending LineItemCount.
--Hint: Join the GLAccounts table to the InvoiceLineItems table.

SELECT AccountDescription
	, COUNT(*) AS LineItemCount
	, SUM(InvoiceLineItemAmount) AS LineItemSum
FROM InvoiceLineItems JOIN GLAccounts ON
	InvoiceLineItems.AccountNo = GLAccounts.AccountNo
GROUP BY AccountDescription
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC

--#5: Modify the solution to exercise 4 to filter for invoices dated from 
--December 1, 2015 to February 29, 2016.
--Hint: Join to the Invoices table to code a search condition based on InvoiceDate.

SELECT AccountDescription
	, InvoiceDate
	, COUNT(*) AS LineItemCount
	, SUM(InvoiceLineItemAmount) AS LineItemSum
FROM InvoiceLineItems 
	JOIN GLAccounts ON
	InvoiceLineItems.AccountNo = GLAccounts.AccountNo
	JOIN Invoices ON
	InvoiceLineItems.InvoiceID = Invoices.InvoiceID
GROUP BY AccountDescription
	, InvoiceDate
HAVING InvoiceDate BETWEEN 'December 1, 2015' 
	AND 'February 29, 2016'
	AND COUNT(*) > 1
ORDER BY COUNT(*) DESC

--#6:Write a SELECT statement that answers the following question: 
--What is the total amount invoiced for each AccountNo? 
--Use the WITH ROLLUP operator to include a row that gives the grand total.
--Hint: Use the InvoiceLineItemAmount column of the InvoiceLineItems table.

SELECT COUNT(AccountNo) AS AccountNo
	,SUM(InvoiceLineItemAmount) AS GrandTotal
FROM InvoiceLineItems
GROUP BY ROLLUP (InvoiceLineItemAmount)

--#7:Write a SELECT statement that returns four columns: 
--VendorName, AccountDescription, LineItemCount, and LineItemSum. 
--LineItemCount is the row count, and LineItemSum is the sum of the InvoiceLineItemAmount column. 
--For each vendor and account, return the number and sum of line items, sorted first by vendor, 
--then by account description.
--Hint: Use a four-table join.

SELECT VendorName
	, AccountDescription
	, COUNT(*) AS LineItemCount
	, SUM(InvoiceLineItemAmount) AS LineItemSum
FROM Vendors JOIN GLAccounts ON
	Vendors.DefaultAccountNo = GLAccounts.AccountNo
	JOIN InvoiceLineItems ON 
	InvoiceLineItems.AccountNo = GLAccounts.AccountNo
	JOIN Invoices ON
	InvoiceLineItems.InvoiceID = Invoices.InvoiceID
GROUP BY VendorName
	,AccountDescription

--#8:Write a SELECT statement that answers this question: 
--Which vendors are being paid from more than one account? 
--Return two columns: the vendor name and the total number 
--of accounts that apply to that vendor’s invoices.
--Hint: Use the DISTINCT keyword to count InvoiceLineItems.AccountNo.

SELECT VendorName
	, COUNT(DISTINCT InvoiceLineItems.AccountNo) AS Account
FROM Vendors JOIN Invoices ON
	Vendors.VendorID = Invoices.VendorID
	JOIN InvoiceLineItems ON 
	InvoiceLineItems.InvoiceID = Invoices.InvoiceID
GROUP BY VendorName
HAVING COUNT(DISTINCT InvoiceLineItems.AccountNo) > 1
ORDER BY VendorName
	

