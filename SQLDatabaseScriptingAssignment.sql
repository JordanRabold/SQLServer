CREATE DATABASE Membership
GO

USE Membership
GO

CREATE TABLE Individuals
(
	IndividualID	smallint		PRIMARY KEY IDENTITY
	,FirstName		varchar(40)		NOT NULL--should always put first name
	,LastName		varchar(40)		NOT NULL--last name is usually required as well
	,Address		varchar(100)	NULL--address is important, but you dont need it to find an individual
	,Phone			varchar(40)		NOT NULL--important to find an individual
)


CREATE TABLE Groups
(
	GroupID		tinyint			NOT NULL PRIMARY KEY IDENTITY--referenced above..is this a redundant NOT NULL?
	,GroupName	varchar(100)	NOT NULL -- required to find how much dues the group owes
	,Dues		money			NOT NULL DEFAULT '0' CHECK(Dues > 0)--required to bill the group
)

CREATE TABLE GroupMembership
(
	GroupID			tinyint		NOT NULL--Groupid required to find in system
								REFERENCES Groups(GroupID)
	,IndividualID	smallint	NOT NULL --same as groupid, should be required
								REFERENCES Individuals(IndividualID)
)
CREATE NONCLUSTERED INDEX IX_GroupMembership_IndividualID
	ON GroupMembership(IndividualID)

CREATE CLUSTERED INDEX IX_GroupMembership_GroupID
	ON GroupMembership(GroupID)


ALTER TABLE Individuals
ADD DuesPaid	bit		NOT NULL;

ALTER TABLE Invoices
ADD CHECK (PaymentDate = 'Null' AND PaymentTotal = 0 
	AND PaymentDate = 'Not Null' AND PaymentTotal > 0)

ALTER TABLE Invoices
ADD CHECK (PaymentTotal + CreditTotal != InvoiceTotal)

DROP TABLE GroupMembership;

CREATE TABLE GroupMembership
(
	GroupID			tinyint		NOT NULL
								REFERENCES Groups(GroupID)
	,IndividualID	smallint	NOT NULL
								REFERENCES Individuals(IndividualID)
								UNIQUE(GroupID, IndividualID)
)




