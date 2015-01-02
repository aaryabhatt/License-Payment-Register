
DROP TABLE IF EXISTS Roles CASCADE;
DROP TABLE IF EXISTS Privilege CASCADE;
DROP TABLE IF EXISTS Access CASCADE;
DROP TABLE IF EXISTS AppUser CASCADE;
DROP TABLE IF EXISTS License_Category CASCADE;
DROP TABLE IF EXISTS License_holder CASCADE;
DROP TABLE IF EXISTS License CASCADE;
DROP TABLE IF EXISTS Payment CASCADE;
DROP TABLE IF EXISTS Address CASCADE;
DROP TABLE IF EXISTS Cancel_Report CASCADE;

CREATE TABLE Roles
(
        Role            	CHAR(8) PRIMARY KEY,
        Description     	text
);

CREATE TABLE Privilege
(
        Privilege       	text    PRIMARY KEY,
        Description    	 	text
);

CREATE TABLE Access
(
        Role            	CHAR(8) references 
                			Roles ON DELETE CASCADE ON UPDATE CASCADE,
        Privilege       	text references 
                			Privilege  ON DELETE CASCADE ON UPDATE CASCADE,
       					PRIMARY KEY (role, privilege)
);

CREATE TABLE AppUser
(
        Userid          	text    PRIMARY KEY,
        Name            	text,
        Details         	text,
        Password        	text,
        Date_Joined     	date,
        Active          	smallint,
        Role            	CHAR(8) references 
			                Roles(role) ON DELETE CASCADE ON UPDATE CASCADE
);



CREATE TABLE License_Category
(
	Categoryid		SERIAL PRIMARY KEY,
        Categoryname            text,
	CategoryDescription	text
);




CREATE TABLE License 
(
	Licenseid		SERIAL,
	Categoryid		integer references License_Category ON DELETE CASCADE ON UPDATE CASCADE,
	License_no		text 	PRIMARY KEY,
	License_Type		text,
	Validity_Start		date,
	Validity_End		date,
	Entry_Date		timestamp
					
);

CREATE TABLE Payment
(
	Paymentid		SERIAL,
	License_no		text references License ON DELETE CASCADE ON UPDATE CASCADE,
	Amount			text,
	Payment_Date		timestamp,
	Payment_status		text,
	Receivedby		text,
					PRIMARY KEY(Paymentid)
);

CREATE TABLE License_holder
(
	Customerid      	SERIAL,
	License_no		text references License ON DELETE CASCADE ON UPDATE CASCADE,
	Title			text,
	Name			text,
	RelativeName		text,
					PRIMARY KEY(Customerid)
);

CREATE TABLE Address
(
	License_no		text references License ON DELETE CASCADE ON UPDATE CASCADE,
	Address         	text,   
        City            	text,
	District		text,
        State           	text,
        Country         	text,
        Phone           	text,
        Mobile          	text,
        Email           	text,
					PRIMARY KEY(License_no)
);

CREATE TABLE Cancel_Report
(
--	Paymentid		int references Payment ON DELETE CASCADE ON UPDATE CASCADE,
	Paymentid		int references Payment,
	Cancel_Date		timestamp,
	Userid			text references AppUser,
	Description		text,
					PRIMARY KEY(Paymentid)
);
	 	
	
