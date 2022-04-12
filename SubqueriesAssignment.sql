--#1: Write a SELECT statement that returns the same result set as this SELECT statement. 
--Substitute a subquery in a WHERE clause for the inner join.
--SELECT DISTINCT VendorName
--FROM Vendors JOIN Invoices ON
--Vendors.VendorID = Invoices.VendorID
--ORDER BY VendorName

SELECT DISTINCT VendorName
FROM Vendors
WHERE EXISTS
	(
		SELECT VendorID
		FROM Invoices
	)
ORDER BY VendorName


--#2: Write a SELECT statement that answers this question: Which invoices have a PaymentTotal 
--that's greater than the average PaymentTotal for all paid invoices? Return the InvoiceNumber 
--and InvoiceTotal for each invoice.

SELECT InvoiceNumber
	, InvoiceTotal
FROM Invoices
WHERE PaymentTotal >
	(
		SELECT AVG(PaymentTotal)
		FROM Invoices
		WHERE InvoiceTotal - PaymentTotal - CreditTotal = 0
	)

--#3: Write a SELECT statement that answers this question: 
--Which invoices have a PaymentTotal that's greater than the median PaymentTotal for all paid invoices? 
--(The median marks the midpoint in a set of values; an equal number of values lie above and below it.) 
--Return the InvoiceNumber and InvoiceTotal for each invoice.

--Hint: Begin with the solution to exercise 2, then use the ALL keyword in the WHERE clause 
--and code "TOP 50 PERCENT PaymentTotal" in the subquery.

SELECT InvoiceNumber
	, InvoiceTotal
FROM Invoices
WHERE PaymentTotal > ALL
	(
		SELECT TOP 50 PERCENT PaymentTotal
		FROM Invoices
		WHERE InvoiceTotal - PaymentTotal - CreditTotal = 0
	)

--#4: Write a SELECT statement that returns two columns from the GLAccounts table: AccountNo and AccountDescription. 
--The result set should have one row for each account number that has never been used. 
--Use a correlated subquery introduced with the NOT EXISTS operator. Sort the final result set by AccountNo. 
--An unused Account will not be present in the InvoiceLineItems table

SELECT AccountNo
	, AccountDescription
FROM GLAccounts
WHERE NOT EXISTS
	(
		SELECT *
		FROM InvoiceLineItems
		WHERE InvoiceLineItems.AccountNo = GLAccounts.AccountNo
	)
ORDER BY AccountNo

--#5: Write a SELECT statement that returns four columns: VendorName, InvoiceID, 
--InvoiceSequence, and InvoiceLineItemAmount for each invoice that has more than one 
--line item in the InvoiceLineItems table.

--Hint: Use a subquery that tests for InvoiceSequence > 1

SELECT VendorName
	, Invoices.InvoiceID
	, InvoiceSequence 
	, InvoiceLineItemAmount
FROM Vendors 
	JOIN Invoices ON Invoices.VendorID = Vendors.VendorID
	JOIN InvoiceLineItems ON InvoiceLineItems.InvoiceID = Invoices.InvoiceID
WHERE InvoiceSequence IN
	(
		SELECT InvoiceSequence
		FROM InvoiceLineItems
		WHERE InvoiceSequence > 1
	)



