--
-- Seed Data
--
\! echo ---Insert Roles--- 
INSERT INTO roles Values ('ADMIN', 'Admin Have All the Access');
INSERT INTO roles Values ('ACCOUNT', 'to add enteries in license');
INSERT INTO roles Values ('CASHIER', 'for cashier');
INSERT INTO roles Values ('GUEST' , 'Prospective Customer, Not Logged In.');


\! echo ---Insert Privileges ---
INSERT INTO privilege Values ('/index','Root Page');
INSERT INTO privilege Values ('/default','Default Page');
INSERT INTO privilege Values ('/login/index','Login');
INSERT INTO privilege Values ('/logout/index', 'Logout');
INSERT INTO privilege Values ('/user/list','Logs Index page');
INSERT INTO privilege Values ('/user/modify','User Modify');
INSERT INTO privilege Values ('/user/add','User Add');


-- Admin must have all thes access
\! echo ---Insert Admin Access ---  
INSERT INTO access Values ('ADMIN','/index');
INSERT INTO access Values ('ADMIN','/logout/index');
INSERT INTO access Values ('ADMIN','/user/add');
INSERT INTO access Values ('ADMIN','/user/list');
INSERT INTO access Values ('ADMIN','/user/modify');

-- Account  must have read,write,list of License section only 
\! echo ---Insert Manager Access ---  
INSERT INTO access Values ('ACCOUNT','/index');
INSERT INTO access Values ('ACCOUNT','/logout/index');

-- Cashier  must have read,write,list of License section only 
\! echo ---Insert Manager Access ---  
INSERT INTO access Values ('CASHIER','/index');
INSERT INTO access Values ('CASHIER','/logout/index');

-- Guest must have only read permissions and comment permissions
\! echo ---Insert  Guest Access ---  
INSERT INTO access Values ('GUEST' ,    '/index');
INSERT INTO access Values ('GUEST' ,    '/login/index');
INSERT INTO access Values ('GUEST' ,    '/default');

-- Users
\! echo ---Insert  User Access ---  
INSERT INTO appuser VALUES( 'UNKN','Unknown','DETAILS UNKNOWN','PWD','2015-01-01','1','GUEST');
INSERT INTO appuser VALUES( 'admin','Software Admin','Handle Software Administration','admin','2015-01-01','1','ADMIN');
INSERT into appuser VALUES ('tirveni','Tirveni Yadav', 'ME as a SU', 'tirveni', '2015-01-01','1','ADMIN');
INSERT into appuser VALUES ('amit','Amit Bondwal', 'ME as a SU', 'amit', '2015-01-01','1','ADMIN');

-- Login amit and tirveni, pw: eloor
update appuser set password='E5Heps6EgklcViMsGX7wEu1K9Kc' where userid='tirveni';
update appuser set password='E5Heps6EgklcViMsGX7wEu1K9Kc' where userid='amit';
