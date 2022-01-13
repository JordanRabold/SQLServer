--#1: Write SELECT INTO statements to create two test tables named VendorCopy and InvoiceCopy 
--that are complete copies of the Vendors and Invoices tables. If VendorCopy and InvoiceCopy already exist, 
--first code two DROP TABLE statements to delete them.
DROP TABLE VendorCopy
DROP TABLE InvoiceCopy

SELECT *
INTO VendorCopy
FROM Vendors

SELECT *
INTO InvoiceCopy
FROM Invoices

--#2: Write an INSERT statement that adds a row to the InvoiceCopy table with the following values:
--VendorID:32
--InvoiceTotal:$434.58
--TermsID:2
--InvoiceNumber:AX-014-027
--PaymentTotal:$0.00
--InvoiceDueDate:07/8/16
--InvoiceDate:06/21/16
--CreditTotal:$0.00
--PaymentDate:null

INSERT INTO InvoiceCopy (VendorID, InvoiceTotal, TermsID,
	InvoiceNumber, PaymentTotal, InvoiceDueDate,
	InvoiceDate, CreditTotal, PaymentDate)
	VALUES (32, 434.58, 2, 'AX-014-027', 0.00, '07/8/16',
	'06/21/16', 0.00, NULL)

--#3: Write an INSERT statement that adds a row to the VendorCopy table for each 
--non-California vendor in the Vendors table. 
--(This will result in duplicate vendors in the VendorCopy table.)
SELECT * FROM Vendors

INSERT INTO VendorCopy(VendorName, VendorAddress1, VendorAddress2 
	, VendorCity, VendorState,VendorZipCode, VendorPhone 
	, VendorContactLName, VendorContactFName, DefaultTermsID, DefaultAccountNo)
SELECT VendorName, VendorAddress1, VendorAddress2 
	, VendorCity, VendorState,VendorZipCode, VendorPhone 
	, VendorContactLName, VendorContactFName, DefaultTermsID, DefaultAccountNo
FROM Vendors
WHERE (VendorState <> 'CA')

--#4: Write an UPDATE statement that modifies the VendorCopy table. Change the default account number to 
--403 for each vendor that has a default account number of 400.

UPDATE VendorCopy
SET DefaultAccountNo = 403
WHERE DefaultAccountNo = 400

--#5: Write an UPDATE statement that modifies the InvoiceCopy table. 
--Change the PaymentDate to today's date and the PaymentTotal to the 
--balance due for each invoice with a balance due. Set today's date 
--with a literal date string, or use the GETDATE() function.
SELECT * FROM InvoiceCopy

UPDATE InvoiceCopy
SET PaymentDate = '11/17/2021',
	PaymentTotal = InvoiceTotal - PaymentTotal - CreditTotal
WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0

--#6: Write an UPDATE statement that modifies the InvoiceCopy table. 
--Change TermsID to 2 for each invoice that's from a vendor with a DefaultTermsID of 2. Use a subquery.

UPDATE InvoiceCopy
SET TermsID = 2
WHERE VendorID IN
	(
		SELECT VendorID
		FROM Vendors
		WHERE DefaultTermsID = 2
	)

--#7: Solve exercise 6 using a join rather than a subquery.
UPDATE InvoiceCopy
SET TermsID = 2
FROM InvoiceCopy JOIN VendorCopy ON
	InvoiceCopy.VendorID = VendorCopy.VendorID
WHERE DefaultTermsID = 2

--#8: Write a DELETE statement that deletes all vendors in the 
--state of Minnesota from the VendorCopy table.
 
--SELECT * FROM VendorCopy WHERE VendorState = 'MN'
--BEGIN TRAN
DELETE FROM VendorCopy
WHERE VendorState = 'MN'
--ROLLBACK TRAN

--#9:Write a DELETE statement for the VendorCopy table. 
--Delete the vendors that are located in states from which no vendor has ever sent an invoice.
--Hint: Use a subquery coded with "SELECT DISTINCT VendorState" introduced with the NOT IN operator.
--BEGIN TRAN
DELETE FROM VendorCopy
WHERE VendorState NOT IN
	(
		SELECT DISTINCT VendorState
		FROM VendorCopy JOIN InvoiceCopy ON
		VendorCopy.VendorID = InvoiceCopy.VendorID
	)
--ROLLBACK TRAN

