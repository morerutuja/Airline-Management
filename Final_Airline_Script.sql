CREATE database dmddAirline;

use dmddAirline;
-------------------------- Creating Tables -------------------------------


/***************** Employee Table ********************/
 

IF NOT EXISTS(SELECT * FROM sys.objects  WHERE name='Employee')
CREATE TABLE Employee(
   EmployeeID INT NOT NULL IDENTITY(604000,1),
   EmployeeFirstName VARCHAR(20),
   EmployeeLastName VARCHAR(20),
   EmployeeGender CHAR (10),
   EmployeeDOB DATE,
   EmployeePhone BIGINT,
   EmployeeEmail VARCHAR(50),
   EmployeeAge INT
   CONSTRAINT Employee_PK PRIMARY KEY(EmployeeID),
   CONSTRAINT CheckEmployeeAge CHECK ( EmployeeAge > 18 ),
   CONSTRAINT CheckPhone CHECK (  EmployeePhone not like '%[^0-9]%' )
);



/***************** CabinCrew Table ********************/



IF NOT EXISTS(SELECT * FROM sys.objects  WHERE name='CabinCrew')
CREATE TABLE CabinCrew(
   EmployeeID INT NOT NULL,
   Designation CHAR(30),
   Experience INT
   CONSTRAINT CabinCrew_PK PRIMARY KEY(EmployeeID),
   CONSTRAINT CabinCrew_FK FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID)
);



/***************** Flight Table ********************/



IF NOT EXISTS(SELECT * FROM sys.objects  WHERE name='Flight')
CREATE TABLE Flight(
   FlightID INT NOT NULL IDENTITY(208000,1),
   FlightName CHAR(40),
  
 
   CONSTRAINT Flight_PK PRIMARY KEY(FlightID),
);
 
 

/***************** LinkCabinCrewFlight Table ********************/


IF NOT EXISTS(SELECT * FROM sys.objects  WHERE name='LinkCabinCrewFlight')
CREATE TABLE LinkCabinCrewFlight(
   EmployeeID INT NOT NULL,
   FlightID INT NOT NULL,
   JoiningDate DATE
   CONSTRAINT LinkCabinCrewFlight_PK PRIMARY KEY(EmployeeID, FlightID),
   CONSTRAINT LinkCabinCrewFlight_FK FOREIGN KEY(EmployeeID) REFERENCES CabinCrew(EmployeeID),
   CONSTRAINT LinkCabinCrewFlight_FK1 FOREIGN KEY(FlightID) REFERENCES Flight(FlightID)
);
 


/***************** Pilot Table ********************/



IF NOT EXISTS(SELECT * FROM sys.objects  WHERE name='Pilot')
CREATE TABLE Pilot(
   EmployeeID INT NOT NULL,
   PilotLicense VARBINARY(250),
   Experience INT
   CONSTRAINT Pilot_PK PRIMARY KEY(EmployeeID),
   CONSTRAINT UniqueLicense Unique(PilotLicense),
   CONSTRAINT Pilot_FK FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID)
);
 

 
/***************** LinkPilotFlight Table ********************/



IF NOT EXISTS(SELECT * FROM sys.objects  WHERE name='LinkPilotFlight')
CREATE TABLE LinkPilotFlight(
   EmployeeID INT NOT NULL,
   FlightID INT NOT NULL,
   AssignmentDate DATE
   CONSTRAINT LinkPilotFlight_PK PRIMARY KEY(EmployeeID, FlightID),
   CONSTRAINT LinkPilotFlight_FK FOREIGN KEY(EmployeeID) REFERENCES Pilot(EmployeeID),
   CONSTRAINT LinkPilotFlight_FK1 FOREIGN KEY(FlightID) REFERENCES Flight(FlightID)
);


 
/***************** Airport Table ********************/



IF NOT EXISTS(SELECT * FROM sys.objects  WHERE name='Airport')
CREATE TABLE Airport(
   AirportID INT NOT NULL IDENTITY(500,1) ,
   AirportName CHAR(50),
   Terminal varchar(15),
   City varchar(20),
   State varchar(20)
   CONSTRAINT Airport_PK PRIMARY KEY(AirportID),
);
 

 
/***************** AirTrafficModerator Table ********************/



IF NOT EXISTS(SELECT * FROM sys.objects  WHERE name='AirTrafficModerator')
CREATE TABLE AirTrafficModerator(
   EmployeeID INT,
   ModeratorLicense INT,
   AirportID INT
   CONSTRAINT AirTrafficModerator_PK PRIMARY KEY(EmployeeID),
   CONSTRAINT AirTrafficModerator_FK FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID),
   CONSTRAINT AirTrafficModerator_FK1 FOREIGN KEY(AirportID) REFERENCES Airport(AirportID)
);


 
/***************** FlightSchedule Table ********************/



IF NOT EXISTS(SELECT * FROM sys.objects  WHERE name='FlightSchedule')
CREATE TABLE FlightSchedule(
   FlightScheduleID INT NOT NULL IDENTITY(9100,1),
   ScheduleDate DATE,
   DepartureTime DATETIME,
   ArrivalTime DATETIME,
   OriginalAirportID INT,
   DestinationAirportID INT,
   FlightID INT,
   FlightDuration DATETIME
 
   CONSTRAINT FlightSchedule_PK PRIMARY KEY(FlightScheduleID),
   CONSTRAINT FlightSchedule_FK FOREIGN KEY(OriginalAirportID) REFERENCES Airport(AirportID),
   CONSTRAINT FlightSchedule_FK1 FOREIGN KEY(DestinationAirportID) REFERENCES Airport(AirportID),
   CONSTRAINT FlightSchedule_FK2 FOREIGN KEY(FlightID) REFERENCES Flight(FlightID)
);
 

 
/***************** CustomerAddress Table ********************/

 

IF NOT EXISTS(SELECT * FROM sys.objects  WHERE name='CustomerAddress')
CREATE TABLE CustomerAddress(
   CustomerAddressID INT NOT NULL IDENTITY(7020,1),
   CustomerAddressLine VARCHAR(30),
   CustomerCity CHAR(20),
   CustomerState CHAR(20),
   CustomerCountry CHAR(20),
   CustomerZip INT
 
   CONSTRAINT CustomerAddress_PK PRIMARY KEY(CustomerAddressID)
);
 


/***************** Customer Table ********************/



IF NOT EXISTS(SELECT * FROM sys.objects  WHERE name='Customer')
CREATE TABLE Customer(
   CustomerID INT NOT NULL IDENTITY(400100,1),
   CustomerFirstName VARCHAR(25),
   CustomerLastName VARCHAR(25),
   CustomerGender CHAR(10),
   CustomerDOB DATE,
   CustomerPhone BIGINT,
   CustomerEmail VARCHAR(50),
   CustomerAddressID INT ,
   CustomerAge INT
   CONSTRAINT Customer_PK PRIMARY KEY(CustomerID)
   CONSTRAINT Customer_FK FOREIGN KEY(CustomerAddressID) REFERENCES CustomerAddress(CustomerAddressID)
);
 

 
/***************** TicketBooking Table ********************/
 


IF NOT EXISTS(SELECT * FROM sys.objects  WHERE name='TicketBooking')
CREATE TABLE TicketBooking(
   TicketBookingID INT NOT NULL IDENTITY(80272700,1),
   FlightID INT,
   TicketBookingDate DATE,
   TicketPromoCode CHAR(10),
   TicketBookingAmount INT,
   DiscountedPrice FLOAT
   CONSTRAINT TicketBooking_PK PRIMARY KEY(TicketBookingID),
   CONSTRAINT TicketBooking_FK FOREIGN KEY(FlightID) REFERENCES Flight(FlightID),
);
 


/***************** Receipt Table ********************/



IF NOT EXISTS(SELECT * FROM sys.objects  WHERE name='Receipt')
CREATE TABLE Receipt(
   ReceiptID INT NOT NULL IDENTITY(310200,1),
   TicketBookingID INT,
   CustomerID INT
   CONSTRAINT Receipt_PK PRIMARY KEY(ReceiptID),
   CONSTRAINT Receipt_FK1 FOREIGN KEY(TicketBookingID) REFERENCES TicketBooking(TicketBookingID),
   CONSTRAINT Receipt_FK2 FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID)
);
 


/***************** Seat Table ********************/



IF NOT EXISTS(SELECT * FROM sys.objects  WHERE name='Seat')
CREATE TABLE Seat(
   SeatNo VARCHAR(10) NOT NULL ,
   Class CHAR(20),
   FlightID INT
   CONSTRAINT Seat_PK PRIMARY KEY(SeatNo, FlightID),
   CONSTRAINT Seat_FK FOREIGN KEY(FlightID) REFERENCES Flight(FlightID),  
);
 select * from seat



/***************** LinkSeatCustomer Table ********************/



IF NOT EXISTS(SELECT * FROM sys.objects  WHERE name='LinkSeatCustomer')
CREATE TABLE LinkSeatCustomer(
   SeatNo VARCHAR(10) NOT NULL,
   CustomerID INT NOT NULL,
   SeatBookingDate DATE,
   FlightID int
   CONSTRAINT LinkSeatCustomer_PK PRIMARY KEY(SeatNo, CustomerID),
   CONSTRAINT LinkSeatCustomer_FK FOREIGN KEY(SeatNo,FlightID) REFERENCES Seat(SeatNo,FlightID),
   CONSTRAINT LinkSeatCustomer_FK1 FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID)
);
 



-------------------------------- UDF ----------------------------------

------- /******************** UDF 1:  to check booking date ********************/ --------
use dmddAirline

CREATE OR ALTER FUNCTION CheckBookingDate(@TicketBookingID int)
RETURNS int
AS
BEGIN
   DECLARE @Result smallint;
   SET @Result = 0;
	SELECT @Result = IIF(tb.TicketBookingDate > fs.ScheduleDate, 1, 0) 
	from FlightSchedule fs 
	join TicketBooking tb  on tb.FlightID = fs.FlightID
	where TicketBookingID  = @TicketBookingID 
   RETURN @Result;
END;



/************************* UDF2 : Discounted Price after applying Promo Code ****************/

CREATE or ALTER FUNCTION getNumericValue (@TicketPromoCode VARCHAR(256), @TicketBookingAmount INT )
RETURNS VARCHAR(256)
AS
BEGIN
  DECLARE @integerPart INT
  DECLARE @result FLOAT
  SET @integerPart = PATINDEX('%[^0-9]%', @TicketPromoCode)
  BEGIN
    WHILE @integerPart > 0
		BEGIN
			SET @TicketPromoCode = STUFF(@TicketPromoCode, @integerPart, 1, '' )
			SET @integerPart = PATINDEX('%[^0-9]%', @TicketPromoCode )
		END
     SET @result = ((100 - @TicketPromoCode) * @TicketBookingAmount) / 100
  END
  RETURN  ISNULL(@result,0)
END



 
---- /******************** UDF3: Flight Duration ********************/ --------

CREATE OR ALTER FUNCTION calculateFlightDuration(@FlightID int)
RETURNS int
AS
BEGIN
  DECLARE @Result int;
  SET @Result = 0;
   SELECT @Result = DateDiff(HOUR, ArrivalTime, DepartureTime)
   FROM FlightSchedule
   WHERE FlightID = @FlightID
   
  RETURN @Result;
END;

---- /******************** Column Data Encryption ******************** / -------------------

CREATE MASTER KEY
ENCRYPTION BY PASSWORD = 'DMDDPROJ@7';
 
-- create certificate to protect symmetric key
CREATE CERTIFICATE TestCertificate
WITH SUBJECT = 'Protect my data';
 
-- create symmetric key to encrypt data
CREATE SYMMETRIC KEY TestSymmetricKey
WITH ALGORITHM = AES_128
ENCRYPTION BY CERTIFICATE TestCertificate;
 
--open symmetric key
OPEN SYMMETRIC KEY TestSymmetricKey
DECRYPTION BY CERTIFICATE TestCertificate;








-------------------------------------- Constraints ---------------------------------------

------- /******************** Check Constraint 1: Check Booking date ********************/ --------
 
ALTER TABLE TicketBooking 
ADD CONSTRAINT CheckTicketDate CHECK (dbo.CheckBookingDate(TicketBookingID) = 0);




------- /******************** Check Constraint 3:Check Flight Time ********************/ --------

ALTER TABLE FlightSchedule 
ADD CONSTRAINT CheckFlightTime CHECK (ArrivalTime > DepartureTime);





------------------------------------------ Triggers ------------------------------------------

 ------- /******************** Trigger 1 :Employee Age ********************/ --------

CREATE OR ALTER TRIGGER calculateAge ON Employee
AFTER INSERT
AS  
BEGIN
    Update Employee set [EmployeeAge] = DateDiff(year,EmployeeDOB,getdate())
 
END;

------- /******************** Trigger 2 :Customer Age ********************/ --------

CREATE OR ALTER TRIGGER calculateCustomerAge ON Customer
AFTER INSERT

AS  
BEGIN
    Update Customer set [CustomerAge] = DateDiff(year,CustomerDOB,getdate())
 
END;

---- /********************  Trigger 3: Update pilot license column with encrypted value ********************/ --------
 
CREATE OR ALTER TRIGGER EncryptLicense_Pilot
ON Pilot
AFTER INSERT,UPDATE 
AS  
BEGIN

	OPEN SYMMETRIC KEY TestSymmetricKey
	DECRYPTION BY CERTIFICATE TestCertificate;
	Update Pilot set [PilotLicense] = ENCRYPTByKey(Key_GUID(N'TestSymmetricKey'),Convert(varbinary,pilotlicense))
 	CLOSE SYMMETRIC KEY TestSymmetricKey;
	
END;
 
 ---- /********************  Trigger 4 :  Update moderator license column with encrypted value ********************/ --------

CREATE OR ALTER TRIGGER EncryptLicense_ATM
ON AirTrafficModerator
AFTER INSERT, UPDATE
AS  
BEGIN
	Update AirTrafficModerator set [ModeratorLicense] = ENCRYPTByKey(Key_GUID(N'TestSymmetricKey'),Convert(varbinary,ModeratorLicense))
  
END;




---- /********************  Trigger 5 :  Flight Duration ********************/ --------

CREATE OR ALTER TRIGGER FlightDurationTrigger ON FlightSchedule
AFTER INSERT
AS  
BEGIN
        Update FlightSchedule set [FlightDuration] = dbo.calculateFlightDuration(FlightID)
 
END;


------- /******************** Trigger 6 :Pilot Experience ********************/ --------

CREATE OR ALTER TRIGGER calculateExperience ON LinkPilotFlight
AFTER INSERT
AS  
BEGIN

        DECLARE @EmployeeID INT
        DECLARE @AssignmentDate DATE
        
        SELECT @EmployeeID = INSERTED.employeeId FROM INSERTED

        SELECT @AssignmentDate = INSERTED.AssignmentDate FROM INSERTED


        Update Pilot 
        set [Experience] = DateDiff(year,@AssignmentDate,getdate())
        WHERE EmployeeID = @EmployeeID
        
END;

------- /******************** Trigger 7: Cabin crew Experience ********************/ --------

CREATE OR ALTER TRIGGER calculateCabinCrewExperience ON LinkCabinCrewFlight
AFTER INSERT
AS  
BEGIN

        DECLARE @EmployeeID INT
        DECLARE @JoiningDate DATE

        SELECT @EmployeeID = INSERTED.employeeId FROM INSERTED

        SELECT @JoiningDate = INSERTED.JoiningDate FROM INSERTED


        Update CabinCrew
        set Experience = DateDiff(year,@JoiningDate,getdate())
        WHERE EmployeeID = @EmployeeID
        
END;



------- /******************** Trigger 8: Promo code ********************/ --------


CREATE OR ALTER TRIGGER getNumericValueTrigger ON TicketBooking
AFTER INSERT
AS  
BEGIN
        Update TicketBooking set [DiscountedPrice] = dbo.getNumericValue(TicketPromoCode, TicketBookingAmount)
 
END;




--------------------------- INSERT -------------------------

/*****************Employee********************/


INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Wanda','Patterson','F','1992-04-12',9345772216,'wanpetterson@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Bonnie','Huges','F','1992-03-20',8877612355,'bonnie.h@yahoo.in',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Annee','Powel','F','1990-04-28',6152236791,'anne@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Julia','Flores','F','1989-12-12',9812231186,'julia.f@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Dana','White','M','2000-12-26',9920979994,'dana@hotmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Robert','Olson','M','2001-08-06',7773132875,'robert@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Willian','Snyder','M','1997-01-22',8080861153,'willian@hotmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Joe','Heart','M','1996-03-22',9820211776,'joe@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Stacy','Williams','F','1996-08-01',7812266453,'stacy@yahoo.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Brenda','Matthews','F','1990-11-11',7775652359,'Brenda@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Jean','Austin','F','1999-02-07',9877761256,'Jean@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Timotee','Elliot','M','1992-12-10',8573134887,'timotee.e@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Mark','Wahlberg','M','1996-10-10',8573435657,'Mark07@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Rio','Peters','M','1990-11-28',8574447621,'rio10@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Alessia','Cara','F','1989-01-10',7899876781,'aleCara81@yahoo.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Eric','Nam','M','1973-08-03',9090101110,'ericname32@outlook.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Chan','Bahng','M','1996-03-11',8325235123,'bangchan325@mail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Jake','Scott','M','1997-01-22',7812231186,'Scotty12@outlook.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Willy','Jay','F','1982-05-05',7905652359,'Jaywilly0505@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Peter','Pan','M','1971-09-01',9000211776,'PeterPan1@yahoo.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Carlie','Hanson','F','1997-01-04',9820219090,'carlie22@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Jast','Izabella','F','1992-04-12',9345772211,'JastIzabella@yahoo.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Farrell','Frederik','F','1992-03-20',8877612350,'Farrell.Frederik@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Bruen','Antonetta','M','1990-04-28',6152212341,'Bruen.Antonetta@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Crist','Ezra','M','1989-12-12',9812231181,'Crist.Ezra@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Corwin','Margarete','M','2000-12-26',9920979992,'Corwin.Margarete@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Murphy','Delaney','M','2001-08-06',7773132872,'Murphy.Delaney@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Grant','Leopoldo','F','1997-01-22',8080861154,'Grant.Leopoldo@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Stoltenberg','Priscilla','F','1996-03-22',9820211770,'Stoltenberg.Priscilla@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Marvin','Jeromy','F','1996-08-01',7812266421,'Marvin.Jeromy@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Casper','Ada','M','1990-01-11',7775652312,'Casper.Ada@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Schaefer','Arlie','M','1999-02-07',9877761223,'Schaefer.Arlie@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Lowe','Alyce','M','1991-12-14',8573134832,'Lowe.Alyce@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Brakus','Johathan','F','1996-10-29',8573435623,'Brakus.Johathan@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Corkery','Jackeline','M','1990-11-28',8574447665,'Corkery.Jackeline@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Streich','Shayna','M','1989-01-15',7899876756,'Streich.Shayna@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('OKeefe','Magnus','M','1973-08-03',9090101165,'OKeefe.Magnus@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Carter','Madelyn','F','1996-07-17',8325235190,'Carter.Madelyn@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Lang','Monique','M','1997-01-22',7812231654,'Lang.Monique@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Stoltenberg','Cleveland','M','1990-05-05',7905652133,'Stoltenberg.Cleveland@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Witting','Retha','M','1971-09-01',9000211098,'Witting.Retha@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Jacob','Lee','M','1997-10-04',9820210981,'Jacoblee89@yahoo.au',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Han','Jisung','F','1996-03-22',9876235190,'Han321@mail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Hyunjin','Hwang','M','1989-08-01',7432231654,'artsyHyunjin1@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Eddie','Nam','M','1992-12-10',8765652133,'eddie21@hotmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Donald','OConnell','M','1986-04-08',987456321,'donald.o@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Douglas','Grant','M','1988-06-04',2224904100,'Grant.d@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Jennifer','Whalen','F','1990-04-13',917485236,'whalen.jen@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Michael','Hartstein','F','1990-07-30',963258741,'hartstein.m@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Pat','Fay','M','1990-11-06',987321654,'fay.pat@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Susan','Mavris','F','1990-11-17',852147963,'marvis.su@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Hermann','Baer','M','1992-09-14',874125963,'baer.her@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Shelley','Higgins','F','1994-02-06',654789321,'higgins.sh@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('William','Gietz','M','1997-09-06',698745213,'gietz.william@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Steven','King','M','1998-04-24',789654123,'king.ste@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Bruce','Ernst','M','1998-05-18',741852963,'ernst.br@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Diana','Lorentz','F','1999-05-16',784512369,'lorentz.d@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Nancy','Greenberg','F','2000-03-01',9517534862,'greenberg.nancy@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Daniel','Faviet','M','2000-08-28',963741852,'faviet.d@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Hannah','Banh','M','1996-03-21',781223190,'hanban@hotmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Steve','Hawkings','F','1996-08-10',7905652909,'Hawkings@imail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Stefan','Curry','F','1989-11-11',9000211098,'stefcurry@outlook.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Daniel','Peters','M','1999-02-07',9820210981,'Danpet@hotmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Ross','Geller','F','1992-12-10',9875535190,'gellerross@gmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Monica','Greenberg','M','1996-10-10',7432231611,'MonicaBerg@hotmail.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Joey','Trib','F','1990-11-28',8761233111,'TrIBJ12@outlook.com',NULL);
INSERT INTO Employee(EmployeeFirstName,EmployeeLastName,EmployeeGender,EmployeeDOB,EmployeePhone,EmployeeEmail,EmployeeAge) VALUES ('Hellen','Keller','M','1989-01-10',987456311,'Hk23@gmail.com',NULL);



/***************** CabinCrew ********************/


INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604015,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604016,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604017,'Purser',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604018,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604019,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604020,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604021,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604022,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604023,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604024,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604025,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604026,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604027,'Purser',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604028,'Purser',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604029,'Purser',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604045,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604046,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604047,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604048,'Purser',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604049,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604050,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604051,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604052,'Purser',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604053,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604054,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604055,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604056,'Purser',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604057,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604058,'FlightAttendant',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604059,'Purser',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604060,'Purser',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604061,'Purser',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604062,'Purser',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604063,'Purser',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604064,'Purser',NULL);
INSERT INTO CabinCrew(EmployeeID,Designation,Experience) VALUES (604065,'Purser',NULL);



/***************** Flight ********************/


INSERT INTO Flight(FlightName) VALUES ('MA01');
INSERT INTO Flight(FlightName) VALUES ('NY02');
INSERT INTO Flight(FlightName) VALUES ('AZ03');
INSERT INTO Flight(FlightName) VALUES ('UT04');
INSERT INTO Flight(FlightName) VALUES ('OR14');
INSERT INTO Flight(FlightName) VALUES ('NJ12');
INSERT INTO Flight(FlightName) VALUES ('NY01');
INSERT INTO Flight(FlightName) VALUES ('NY06');
INSERT INTO Flight(FlightName) VALUES ('MA02');
INSERT INTO Flight(FlightName) VALUES ('NJ10');
INSERT INTO Flight(FlightName) VALUES ('UT99');
INSERT INTO Flight(FlightName) VALUES ('NC12');
INSERT INTO Flight(FlightName) VALUES ('SC13');
INSERT INTO Flight(FlightName) VALUES ('MA03');
INSERT INTO Flight(FlightName) VALUES ('UT05');



/***************** LinkCabinCrewFlight ********************/


INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604017,208000,'2015/01/01');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604016,208000,'2015/01/12');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604019,208000,'2016/03/16');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604027,208001,'2016/03/08');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604015,208001,'2016/03/16');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604018,208001,'2016/04/21');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604028,208002,'2016/04/21');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604020,208002,'2021/03/08');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604050,208002,'2015/01/14');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604029,208003,'2018/10/12');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604021,208003,'2019/05/06');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604025,208003,'2019/04/04');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604049,208004,'2020/01/13');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604058,208004,'2018/11/15');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604052,208005,'2022/02/02');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604045,208005,'2015/01/01');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604022,208005,'2015/01/12');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604056,208006,'2016/03/16');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604023,208006,'2016/03/08');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604024,208006,'2016/03/16');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604059,208007,'2016/04/21');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604053,208007,'2016/04/21');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604054,208007,'2021/03/08');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604060,208008,'2015/01/14');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604057,208008,'2018/10/12');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604046,208008,'2019/05/06');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604061,208009,'2019/04/04');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604026,208009,'2020/12/12');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604051,208009,'2020/01/13');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604062,208010,'2018/11/15');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604055,208010,'2022/02/02');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604023,208010,'2015/01/01');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604062,208011,'2015/01/12');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604063,208011,'2016/03/16');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604054,208011,'2016/03/08');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604064,208012,'2016/03/16');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604016,208012,'2016/04/21');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604055,208012,'2016/04/21');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604065,208013,'2021/03/08');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604019,208013,'2015/01/14');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604046,208013,'2018/10/12');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604027,208014,'2019/05/06');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604023,208014,'2019/04/04');
INSERT INTO LinkCabinCrewFlight(EmployeeID,FlightID,JoiningDate) VALUES (604020,208014,'2020/12/12');



/***************** Pilot ********************/


INSERT INTO Pilot(EmployeeID,PilotLicense,Experience) VALUES (604000,345345,NULL);
INSERT INTO Pilot(EmployeeID,PilotLicense,Experience) VALUES (604001,443421,NULL);
INSERT INTO Pilot(EmployeeID,PilotLicense,Experience) VALUES (604002,882635,NULL);
INSERT INTO Pilot(EmployeeID,PilotLicense,Experience) VALUES (604003,763521,NULL);
INSERT INTO Pilot(EmployeeID,PilotLicense,Experience) VALUES (604004,882751,NULL);
INSERT INTO Pilot(EmployeeID,PilotLicense,Experience) VALUES (604005,773642,NULL);
INSERT INTO Pilot(EmployeeID,PilotLicense,Experience) VALUES (604006,773628,NULL);
INSERT INTO Pilot(EmployeeID,PilotLicense,Experience) VALUES (604007,881615,NULL);
INSERT INTO Pilot(EmployeeID,PilotLicense,Experience) VALUES (604008,761422,NULL);
INSERT INTO Pilot(EmployeeID,PilotLicense,Experience) VALUES (604009,336251,NULL);
INSERT INTO Pilot(EmployeeID,PilotLicense,Experience) VALUES (604010,999222,NULL);
INSERT INTO Pilot(EmployeeID,PilotLicense,Experience) VALUES (604011,902216,NULL);
INSERT INTO Pilot(EmployeeID,PilotLicense,Experience) VALUES (604012,356612,NULL);
INSERT INTO Pilot(EmployeeID,PilotLicense,Experience) VALUES (604013,773245,NULL);
INSERT INTO Pilot(EmployeeID,PilotLicense,Experience) VALUES (604014,219900,NULL);
INSERT INTO Pilot(EmployeeID,PilotLicense,Experience) VALUES (604066,902219,NULL);



/***************** LinkPilotFlight ********************/


INSERT INTO LinkPilotFlight(EmployeeID,FlightID,AssignmentDate) VALUES (604000,208000,'2022/01/20');
INSERT INTO LinkPilotFlight(EmployeeID,FlightID,AssignmentDate) VALUES (604001,208001,'2022/05/05');
INSERT INTO LinkPilotFlight(EmployeeID,FlightID,AssignmentDate) VALUES (604002,208014,'2022/05/31');
INSERT INTO LinkPilotFlight(EmployeeID,FlightID,AssignmentDate) VALUES (604003,208013,'2021/06/12');
INSERT INTO LinkPilotFlight(EmployeeID,FlightID,AssignmentDate) VALUES (604004,208002,'2021/12/15');
INSERT INTO LinkPilotFlight(EmployeeID,FlightID,AssignmentDate) VALUES (604005,208010,'2020/04/18');
INSERT INTO LinkPilotFlight(EmployeeID,FlightID,AssignmentDate) VALUES (604006,208003,'2020/08/15');
INSERT INTO LinkPilotFlight(EmployeeID,FlightID,AssignmentDate) VALUES (604007,208004,'2020/09/02');
INSERT INTO LinkPilotFlight(EmployeeID,FlightID,AssignmentDate) VALUES (604008,208005,'2019/02/24');
INSERT INTO LinkPilotFlight(EmployeeID,FlightID,AssignmentDate) VALUES (604009,208003,'2019/02/24');
INSERT INTO LinkPilotFlight(EmployeeID,FlightID,AssignmentDate) VALUES (604010,208009,'2018/03/08');
INSERT INTO LinkPilotFlight(EmployeeID,FlightID,AssignmentDate) VALUES (604011,208011,'2018/07/17');
INSERT INTO LinkPilotFlight(EmployeeID,FlightID,AssignmentDate) VALUES (604012,208006,'2017/08/08');
INSERT INTO LinkPilotFlight(EmployeeID,FlightID,AssignmentDate) VALUES (604013,208007,'2017/12/18');
INSERT INTO LinkPilotFlight(EmployeeID,FlightID,AssignmentDate) VALUES (604014,208008,'2017/12/03');
INSERT INTO LinkPilotFlight(EmployeeID,FlightID,AssignmentDate) VALUES (604066,208012,'2020/04/18');



/***************** Airport ********************/


INSERT INTO Airport(AirportName,Terminal,city,state) VALUES ('Hartsfield-Jackson Atlanta International Airport','T1','atlanta','georgia');
INSERT INTO Airport(AirportName,Terminal,city,state) VALUES ('Los Angeles International Airport','T2','Los angeles','california');
INSERT INTO Airport(AirportName,Terminal,city,state) VALUES ('Denver International Airport','T2','Denver','colorado');
INSERT INTO Airport(AirportName,Terminal,city,state) VALUES ('John F.Kennedy International Airport','T3','new york','new york');
INSERT INTO Airport(AirportName,Terminal,city,state) VALUES ('San Francisco International Airport','T4','San francisco','california');
INSERT INTO Airport(AirportName,Terminal,city,state) VALUES ('George Bush International Airport','T2','houston','texas');
INSERT INTO Airport(AirportName,Terminal,city,state) VALUES ('McCarran International Airport','T4','las vegas','nevada');
INSERT INTO Airport(AirportName,Terminal,city,state) VALUES ('Phoenix Sky Harbour International Airport','T5','phoenix','arizona');
INSERT INTO Airport(AirportName,Terminal,city,state) VALUES ('Dallas International Aiport','T2','dallas','texas');
INSERT INTO Airport(AirportName,Terminal,city,state) VALUES ('Maimi International Airport','T1','miami','florida');
INSERT INTO Airport(AirportName,Terminal,city,state) VALUES ('Logan International Airport','T2','logan','boston');
INSERT INTO Airport(AirportName,Terminal,city,state) VALUES ('Tampa International Airport','T4','tampa','florida');
INSERT INTO Airport(AirportName,Terminal,city,state) VALUES ('Nashville International Airport','T3','nashville','tennessee');
INSERT INTO Airport(AirportName,Terminal,city,state) VALUES ('Midway International Airport','T1','chicago','illinois');



/***************** AirTrafficModerator ********************/


INSERT INTO AirTrafficModerator(EmployeeID,ModeratorLicense,AirportID) VALUES (604030,123456,500);
INSERT INTO AirTrafficModerator(EmployeeID,ModeratorLicense,AirportID) VALUES (604031,654321,501);
INSERT INTO AirTrafficModerator(EmployeeID,ModeratorLicense,AirportID) VALUES (604032,741852,502);
INSERT INTO AirTrafficModerator(EmployeeID,ModeratorLicense,AirportID) VALUES (604033,258741,503);
INSERT INTO AirTrafficModerator(EmployeeID,ModeratorLicense,AirportID) VALUES (604034,369852,504);
INSERT INTO AirTrafficModerator(EmployeeID,ModeratorLicense,AirportID) VALUES (604035,258963,505);
INSERT INTO AirTrafficModerator(EmployeeID,ModeratorLicense,AirportID) VALUES (604036,789456,506);
INSERT INTO AirTrafficModerator(EmployeeID,ModeratorLicense,AirportID) VALUES (604037,654987,507);
INSERT INTO AirTrafficModerator(EmployeeID,ModeratorLicense,AirportID) VALUES (604038,159357,508);
INSERT INTO AirTrafficModerator(EmployeeID,ModeratorLicense,AirportID) VALUES (604039,753951,509);
INSERT INTO AirTrafficModerator(EmployeeID,ModeratorLicense,AirportID) VALUES (604040,852456,510);
INSERT INTO AirTrafficModerator(EmployeeID,ModeratorLicense,AirportID) VALUES (604041,654258,511);
INSERT INTO AirTrafficModerator(EmployeeID,ModeratorLicense,AirportID) VALUES (604042,325665,512);
INSERT INTO AirTrafficModerator(EmployeeID,ModeratorLicense,AirportID) VALUES (604043,452141,513);
INSERT INTO AirTrafficModerator(EmployeeID,ModeratorLicense,AirportID) VALUES (604044,985647,504);



/***************** FlightSchedule ********************/


INSERT INTO FlightSchedule(ScheduleDate,DepartureTime,ArrivalTime,OriginalAirportID,DestinationAirportID,FlightID,FlightDuration) VALUES ('12/12/2022','2022/12/12 5:10:00','2022/12/12 7:04:00',504,503,208007,NULL);
INSERT INTO FlightSchedule(ScheduleDate,DepartureTime,ArrivalTime,OriginalAirportID,DestinationAirportID,FlightID,FlightDuration) VALUES ('12/18/2022','2022/12/18 9:10:30','2022/12/18 12:12:00',502,504,208000,NULL);
INSERT INTO FlightSchedule(ScheduleDate,DepartureTime,ArrivalTime,OriginalAirportID,DestinationAirportID,FlightID,FlightDuration) VALUES ('3/8/2022','2022/03/08 4:15:00','2022/03/08 7:21',508,512,208001,NULL);
INSERT INTO FlightSchedule(ScheduleDate,DepartureTime,ArrivalTime,OriginalAirportID,DestinationAirportID,FlightID,FlightDuration) VALUES ('1/23/2022','2022/01/23 6:31:00','2022/01/23 8:31:00',500,505,208009,NULL);
INSERT INTO FlightSchedule(ScheduleDate,DepartureTime,ArrivalTime,OriginalAirportID,DestinationAirportID,FlightID,FlightDuration) VALUES ('5/22/2021','2021/05/22 8:25:00','2021/05/22 11:25:00',501,507,208010,NULL);
INSERT INTO FlightSchedule(ScheduleDate,DepartureTime,ArrivalTime,OriginalAirportID,DestinationAirportID,FlightID,FlightDuration) VALUES ('5/31/2021','2021/05/31 10:00:00','2021/05/31 11:25:00',502,508,208002,NULL);
INSERT INTO FlightSchedule(ScheduleDate,DepartureTime,ArrivalTime,OriginalAirportID,DestinationAirportID,FlightID,FlightDuration) VALUES ('9/2/2019','2019/09/02 2:45:00','2019/09/02 5:50:00',511,506,208003,NULL);
INSERT INTO FlightSchedule(ScheduleDate,DepartureTime,ArrivalTime,OriginalAirportID,DestinationAirportID,FlightID,FlightDuration) VALUES ('9/17/2019','2019/09/17 0:05:00','2019/09/17 3:05:00',505,509,208004,NULL);
INSERT INTO FlightSchedule(ScheduleDate,DepartureTime,ArrivalTime,OriginalAirportID,DestinationAirportID,FlightID,FlightDuration) VALUES ('4/1/2019','2019/04/01 9:45:10','2019/04/01 11:45:10',512,510,208011,NULL);
INSERT INTO FlightSchedule(ScheduleDate,DepartureTime,ArrivalTime,OriginalAirportID,DestinationAirportID,FlightID,FlightDuration) VALUES ('2/14/2018','2018/02/14 3:15:15','2018/02/14 7:15:15',506,511,208012,NULL);
INSERT INTO FlightSchedule(ScheduleDate,DepartureTime,ArrivalTime,OriginalAirportID,DestinationAirportID,FlightID,FlightDuration) VALUES ('6/6/2018','2018/06/06 7:35:00','2018/06/06 10:15:15',510,505,208008,NULL);
INSERT INTO FlightSchedule(ScheduleDate,DepartureTime,ArrivalTime,OriginalAirportID,DestinationAirportID,FlightID,FlightDuration) VALUES ('8/15/2018','2018/08/15 8:00:00','2018/08/15 12:00:00',503,511,208005,NULL);
INSERT INTO FlightSchedule(ScheduleDate,DepartureTime,ArrivalTime,OriginalAirportID,DestinationAirportID,FlightID,FlightDuration) VALUES ('10/16/2017','2017/10/16 7:31:00','2017/10/16 10:31:00',513,501,208006,NULL);
INSERT INTO FlightSchedule(ScheduleDate,DepartureTime,ArrivalTime,OriginalAirportID,DestinationAirportID,FlightID,FlightDuration) VALUES ('11/23/2017','2017/11/23 1:45:00','2017/11/23 5:45:00',501,502,208000,NULL);
INSERT INTO FlightSchedule(ScheduleDate,DepartureTime,ArrivalTime,OriginalAirportID,DestinationAirportID,FlightID,FlightDuration) VALUES ('12/12/2016','2016/12/12 5:10:00','2016/12/12 7:10:00',507,501,208014,NULL);
INSERT INTO FlightSchedule(ScheduleDate,DepartureTime,ArrivalTime,OriginalAirportID,DestinationAirportID,FlightID,FlightDuration) VALUES ('5/5/2020','2020/05/05 6:56:00','2020/05/05 9:15:00',504,511,208013,NULL);



/***************** CustomerAddress ********************/


INSERT INTO CustomerAddress(CustomerAddressLine,CustomerCity,CustomerState,CustomerZip,CustomerCountry) VALUES ('75 St Alphonsus St','Boston','MA',2108,'USA');
INSERT INTO CustomerAddress(CustomerAddressLine,CustomerCity,CustomerState,CustomerZip,CustomerCountry) VALUES ('82 Walnut Ave','Buffalo','NY',14201,'USA');
INSERT INTO CustomerAddress(CustomerAddressLine,CustomerCity,CustomerState,CustomerZip,CustomerCountry) VALUES ('47 Burroughs St','Newark','NJ',7105,'USA');
INSERT INTO CustomerAddress(CustomerAddressLine,CustomerCity,CustomerState,CustomerZip,CustomerCountry) VALUES ('47 Chapel St','Wocester','MA',1601,'USA');
INSERT INTO CustomerAddress(CustomerAddressLine,CustomerCity,CustomerState,CustomerZip,CustomerCountry) VALUES ('47 Bradford Dr','Quincy','MA',2169,'USA');
INSERT INTO CustomerAddress(CustomerAddressLine,CustomerCity,CustomerState,CustomerZip,CustomerCountry) VALUES ('47 Arcadia Ave','Sycracuse','NY',13207,'USA');
INSERT INTO CustomerAddress(CustomerAddressLine,CustomerCity,CustomerState,CustomerZip,CustomerCountry) VALUES ('63 Crapo St','Jersy City','NJ',7030,'USA');
INSERT INTO CustomerAddress(CustomerAddressLine,CustomerCity,CustomerState,CustomerZip,CustomerCountry) VALUES ('1094 Main St','Cambridge','MA',2238,'USA');
INSERT INTO CustomerAddress(CustomerAddressLine,CustomerCity,CustomerState,CustomerZip,CustomerCountry) VALUES ('864 Hixville Rd','Buffalo','NY',14205,'USA');
INSERT INTO CustomerAddress(CustomerAddressLine,CustomerCity,CustomerState,CustomerZip,CustomerCountry) VALUES ('725 Pleasant St','Amherst','NY',1004,'USA');
INSERT INTO CustomerAddress(CustomerAddressLine,CustomerCity,CustomerState,CustomerZip,CustomerCountry) VALUES ('363 Great Rd','Newark','NJ',7108,'USA');
INSERT INTO CustomerAddress(CustomerAddressLine,CustomerCity,CustomerState,CustomerZip,CustomerCountry) VALUES ('56 June St','Boston','MA',2116,'USA');



/***************** Customer ********************/


INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Steve','Smith','M','2002-12-17',8104531842,'steve@gmail.com',7023,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Nick','Shaw','M','1999-11-10',9930786745,'nick@yahoo.com',7028,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Rick','boss','M','1977-06-15',7773467812,'rickb@gmail.com',7024,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Emma','Stone','F','1998-07-12',9723451128,'Emma@gmail.com',7025,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Jill','Beckham','M','2000-11-01',8080675112,'Jill.b@gmail.com',7027,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Adam','Johnson','M','2004-04-09',7775634900,'johnson@gmail.com',7023,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Jared','Ely','M','1999-05-13',9000346721,'jared.ely@gmail.com',7020,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Mary','Smith','F','2001-6-20',8765552314,'marry.smith@gmail.com',7021,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Patrica','Johnson','F','1990-06-23',9920970006,'patrica@gmail.com',7024,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Linda','Willams','F','1998-04-28',9821169871,'linda.williams@gmail.com',7028,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Barbara','Jones','F','1980-09-22',9669877515,'Barbrajones@gmail.com',7030,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Mick','Martin','M','2007-02-10',7390886518,'mick@gmail.com',7031,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Rohan','Nair','M','2016-12-09',8573134674,'rohan@gmail.com',7027,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Carol','Spencer','F','1992-07-11',7272666986,'carol@yahoo.com',7030,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Jackson','Wang','M','1991-02-02',8674329000,'jackwang@yahoo.com',7026,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Rachel','Green','F','1976-06-04',9665551821,'rach.green@hotmail.com',7031,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Amber','Lui','F','1992-09-09',7020122132,'amber99@outlook.com',7024,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Felix','Adams','M','1989-02-01',7687989012,'adamsfelix@hotmail.com',7028,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Sarah','Barrios','F','1985-09-03',9080124378,'barisara0903@yahoo.com',7022,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Zeb','Bangash','M','1993-01-12',9876543210,'zebban.10@hotmail.com',7029,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Bessie','morrison','F','1996-05-02',9497277991,'bessie@gmail.com',7031,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Alison','Stanley','F','1991-11-08',8027262453,'Alison@gmail.com',7023,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Vickie','Brewer','M','1984-09-24',6765847952,'Vicke@gmail.com',7020,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Terry','Carlson','M','1988-11-04',4748661512,'t@hotmail.com',7021,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Lena','Jeason','F','1971-04-26',2105321422,'Lenna@gmail.com',7023,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Konner','Ibarra','M','1995-05-05',9209437919,'k@gmail.com',7028,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Aaden','Price','M','2006-02-09',9173896089,'a@hotmail.com',7023,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Prince','Durham','F','2006-01-05',9532170467,'prince@gmail.com',7024,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Darien','Alvarez','F','1991-03-18',4262289142,'darien@gmail.com',7025,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Leo','James','F','1977-07-21',6583875822,'wilsonpm@yahoo.ca',7027,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Felipe','Conner','M','1987-09-15',6916663172,'scarlet@outlook.com',7023,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Jamar','Huber','M','1982-10-15',9052213485,'ozawa@yahoo.com',7020,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Dillon','Roberson','F','1986-04-22',6754212886,'quinn@att.net',7021,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Cody','Herrera','M','1999-06-01',8045737944,'dburrows@me.com',7023,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Isiah','Morrow','F','1981-02-10',9363337198,'jshearer@sbcglobal.net',7028,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('James','Joyce','F','1991-04-02',6412702257,'mcsporran@verizon.net',7024,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Efrain','Lynn','M','1972-03-04',2359832578,'kewley@gmail.com',7025,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Konnor','Keller','F','1995-05-30',2359832579,'jaarnial@outlook.com',7027,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Frankie','Williamson','M','1970-11-05',2359832580,'violinhi@mac.com',7023,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Brady','Randolph','M','1988-02-15',2359832581,'portele@me.com',7020,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Isaac','Pratt','M','1990-03-02',2359832582,'errxn@comcast.net',7021,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Ryder','Mason','M','1970-02-21',2359832583,'chaikin@me.com',7024,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Jeremiah','Michael','F','1974-01-30',2359832584,'jaffe@icloud.com',7028,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Landin','Bush','M','1997-07-28',2359832585,'wenzlaff@verizon.net',7030,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Jamarion','Francis','M','2001-07-19',2359832586,'tlinden@live.com',7031,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Freddy','Copeland','M','1982-02-27',2359832587,'haddawy@outlook.com',7027,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Philip','Middleton','F','1978-01-17',2359832588,'hellfire@mac.com',7030,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Diego','Avila','F','1976-03-09',2359832589,'mbalazin@hotmail.com',7023,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Jamison','Wheeler','F','2006-03-31',2359832590,'roesch@me.com',7028,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Dorian','Douglas','F','1994-05-07',2359832591,'aibrahim@msn.com',7024,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Cory','Beard','M','1972-05-22',2359832592,'isaacson@me.com',7025,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Immanuel','Vasquez','M','1998-06-10',2359832593,'openldap@live.com',7027,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Kamron','Casey','F','2006-12-26',2359832594,'microfab@me.com',7023,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Seth','Weiss','M','1993-07-31',2359832595,'carreras@comcast.net',7020,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Deangelo','Farrell','F','1987-05-03',2359832596,'rbarreira@me.com',7021,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Yosef','Larson','F','1994-01-06',2359832597,'pontipak@verizon.net',7024,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Jaydin','Gallegos','M','1982-09-25',2359832598,'imightb@aol.com',7028,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Adam','Strickland','F','1971-01-19',2359832599,'ianbuck@yahoo.ca',7030,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Ronnie','Murray','M','1985-03-27',2359832600,'iapetus@att.net',7031,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Hamza','Osborn','M','1971-10-27',2359832601,'matthijs@msn.com',7027,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Jean','Haynes','M','1970-10-07',2359832602,'samavati@msn.com',7030,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Yadiel','Chen','M','2007-03-23',7390886518,'hellfire@sbcglobal.net',7026,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Bailey','Mullins','F','1999-07-26',7390886519,'odlyzko@optonline.net',7031,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Brady','Bell','M','2009-02-12',7390886520,'lushe@live.com',7024,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Nikolai','Fields','M','2008-10-13',7390886521,'djupedal@yahoo.ca',7028,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Trent','Gentry','M','1976-06-28',7390886522,'jfreedma@aol.com',7022,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Ali','Burton','F','2008-08-08',7390886523,'fudrucker@gmail.com',7029,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Adriel','Cross','F','1987-09-23',7390886524,'mbswan@aol.com',7025,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Jonathon','Duarte','F','1972-05-01',7390886525,'samavati@sbcglobal.net',7027,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Yurem','Hodge','F','2004-12-03',7390886526,'boein@msn.com',7023,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Sidney','Davenport','M','1981-07-15',7390886527,'carreras@mac.com',7020,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Santos','Baird','M','1970-05-29',7390886528,'lpalmer@comcast.net',7021,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Blaine','Mcknight','F','1990-05-13',7390886529,'johndo@comcast.net',7024,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Jeremiah','Cain','M','1996-08-27',7390886530,'gospodin@me.com',7028,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Koen','Buckley','F','1989-10-01',7390886531,'ilikered@comcast.net',7030,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Terry','Wiley','F','1975-09-09',7390886532,'tmccarth@att.net',7031,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Giovani','Baker','M','1998-06-09',7390886533,'stecoop@aol.com',7027,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Stephen','Gardner','F','2004-09-27',7390886534,'sopwith@msn.com',7030,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Baron','Rollins','M','1977-11-22',7390886535,'aprakash@outlook.com',7026,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Jasper','Mcpherson','M','1975-10-27',7390886536,'rsteiner@yahoo.ca',7031,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Elvis','Ware','M','1988-06-29',7390886537,'ullman@yahoo.ca',7024,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Brenden','Watts','F','1985-08-07',7390886538,'kiddailey@aol.com',7023,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Rafael','Hudson','F','1996-04-27',7390886539,'wenzlaff@sbcglobal.net',7028,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Prince','Chandler','F','1978-08-18',7390886540,'eurohack@gmail.com',7023,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Lincoln','Mcmahon','F','1979-01-18',7390886541,'metzzo@comcast.net',7028,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Marco','Moyer','M','1986-10-06',7390886542,'lahvak@sbcglobal.net',7024,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Mekhi','Hanna','M','1991-11-20',7390886543,'konst@hotmail.com',7025,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Nico','Wolf','F','1991-10-10',7390886544,'chaikin@icloud.com',7027,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Odin','Benson','M','2000-02-07',7390886545,'matsn@mac.com',7023,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Brendon','Curry','F','1999-12-18',7390886546,'skajan@comcast.net',7020,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Cody','Hayes','F','1987-11-30',7390886547,'jramio@hotmail.com',7021,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Rayan','Stout','M','1987-02-04',7390886548,'arachne@me.com',7024,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Emery','Joyce','F','1972-07-03',7390886549,'cgarcia@aol.com',7028,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Rigoberto','Mays','M','1983-05-31',7390886550,'rsteiner@verizon.net',7030,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Samuel','Briggs','M','1998-05-11',7390886551,'pkplex@hotmail.com',7031,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Erik','Rangel','M','1988-01-15',7390886552,'schwaang@icloud.com',7027,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Santiago','Palmer','M','1972-05-03',9000346721,'dexter@mac.com',7030,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Tristen','Harding','F','2005-11-16',9000346722,'gfxguy@comcast.net',7026,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Gordon','Andrews','F','2009-11-02',9000346723,'bjoern@me.com',7031,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Cannon','Aguilar','M','1991-02-24',9000346724,'barlow@aol.com',7024,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('River','Abbott','F','1975-01-15',9000346725,'telbij@yahoo.ca',7023,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Stanley','Woodard','F','1983-06-05',9000346726,'sjava@hotmail.com',7028,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Branson','Ramirez','F','1991-07-08',9000346727,'hahiss@outlook.com',7024,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Kobe','Blankenship','F','1999-12-22',9000346728,'mlewan@icloud.com',7025,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Mario','Murillo','M','1981-02-12',9000346729,'krueger@yahoo.ca',7027,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Brooks','Frey','M','1988-04-28',9000346730,'smartfart@icloud.com',7023,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Neil','Thompson','F','2002-01-18',9000346731,'gfody@comcast.net',7020,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Zion','Herman','M','1995-10-19',9000346732,'epeeist@hotmail.com',7021,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Davis','Manning','F','1974-11-04',9000346733,'salesgeek@mac.com',7024,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Enrique','Tran','F','1998-10-10',9000346734,'gtaylor@yahoo.com',7028,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Phillip','Gomez','M','2006-12-16',9000346735,'ngedmond@me.com',7030,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Kadyn','Ross','F','2000-01-04',9000346736,'doormat@outlook.com',7031,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Terrence','Orozco','M','2008-08-30',9000346737,'kempsonc@me.com',7027,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Johnathan','Lloyd','M','1982-10-05',9000346738,'scitext@att.net',7030,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Rocco','Dudley','M','1978-06-13',9000346739,'skoch@msn.com',7026,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Damian','Lynn','F','2007-03-27',9000346740,'tellis@outlook.com',7031,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Max','Sherman','F','2002-04-22',9000346741,'joglo@icloud.com',7024,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Landon','Boyd','F','1986-01-24',9000346742,'petersen@optonline.net',7028,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Ryan','Downs','F','1977-01-14',9000346743,'adillon@optonline.net',7022,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Rhys','Gilmore','M','1973-10-07',9000346744,'harryh@me.com',7029,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Francis','Davis','M','1991-09-27',9000346745,'munge@hotmail.com',7031,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Keith','Collier','F','1976-08-04',9000346746,'panolex@icloud.com',7023,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Clark','Guerrero','M','2009-07-11',9000346747,'brbarret@sbcglobal.net',7020,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Jadyn','Aguirre','F','2001-04-25',9000346748,'bowmanbs@att.net',7027,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Mohammad','Zhang','F','1983-10-10',9000346749,'bahwi@gmail.com',7030,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Carmelo','Hudson','F','1976-07-27',9000346750,'spadkins@me.com',7026,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Dustin','Mcmahon','F','1988-02-25',9000346751,'parkes@yahoo.com',7031,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Cade','Juarez','F','1997-02-27',9000346752,'pgottsch@live.com',7024,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Gilberto','Gregory','F','1987-11-27',9000346753,'ryanshaw@gmail.com',7028,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Brandon','Ferguson','M','1986-01-17',9000346754,'nasor@att.net',7022,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Leon','Holder','M','1998-12-18',9000346755,'fwitness@msn.com',7029,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Marshall','Hester','F','1993-04-24',9000346756,'temmink@mac.com',7031,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Kylan','Knapp','M','1991-02-26',9000346757,'louise@aol.com',7023,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Garrett','Boyd','F','1980-02-21',9000346758,'itstatus@icloud.com',7020,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Jermaine','Booker','F','1977-03-30',9000346759,'daveed@hotmail.com',7027,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Camden','Melendez','M','1986-02-13',9000346760,'mwitte@yahoo.com',7030,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Christopher','Lynn','F','1976-07-07',9000346761,'pakaste@me.com',7026,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Marley','York','M','1983-04-16',9000346762,'rsteiner@yahoo.com',7031,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Alvin','Galvan','M','1980-05-21',9000346763,'mjewell@icloud.com',7024,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Skylar','Aguilar','M','1974-09-01',9000346764,'aracne@verizon.net',7028,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Ashton','Mcguire','F','1991-08-14',9000346765,'rsteiner@icloud.com',7022,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Gavyn','Moss','F','1998-11-14',9000346766,'danny@verizon.net',7029,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Elvis','Barry','F','2002-07-19',9000346767,'intlprog@sbcglobal.net',7031,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Abdullah','Neal','F','1987-12-27',9000346768,'dbindel@gmail.com',7023,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Jayce','Harding','M','1987-10-28',9000346769,'bescoto@yahoo.com',7020,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Jaden','Krueger','M','1982-07-16',9000346770,'jginspace@yahoo.ca',7031,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Sawyer','Crawford','F','1990-03-12',9000346771,'mlewan@live.com',7024,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Talon','Kline','M','1974-05-05',9000346772,'danneng@verizon.net',7028,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Ramiro','Matthews','F','1996-08-13',9000346773,'chrwin@yahoo.com',7022,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Marcel','Meza','F','1990-02-18',9000346774,'irving@aol.com',7022,NULL);
INSERT INTO Customer(CustomerFirstName,CustomerLastName,CustomerGender,CustomerDOB,CustomerPhone,CustomerEmail,CustomerAddressID,CustomerAge) VALUES ('Bree','Handon','M','1976-01-01',8989898989,'bree.h@mail.com',7021,NULL);



/***************** TicketBooking ********************/

DBCC CHECKIDENT('Ticketbooking', RESEED, 80272699);

SELECT  * FROM TICKETBOOKING;
DELETE FROM TICKETBOOKING

INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208009,'1/19/2022','PWY10QL',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208007,'6/6/2022','PWY20QU',67,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208001,'1/7/2022','PQWYM30',95,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208004,'6/10/2019','PWY10QL',95,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PWY10QL',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208002,'4/20/2021','PWY10QL',90,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208012,'1/12/2018','PWY10QL',130,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208001,'1/7/2022','WY25WPQ',180,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208011,'3/1/2019','PWY10QL',150,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PQWYM30',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','PWY10QL',420,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208005,'5/5/2018','WY25WPQ',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','PWY20QU',125,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208006,'8/8/2017','PQWY34U',234,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208011,'3/1/2019','WYPQ15Q',90,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PWY20QU',420,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PQWYM30',233,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208004,'6/10/2019','PQWY34U',361,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208002,'4/20/2021','PWY10QL',278,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208008,'5/5/2018','PWY10QL',310,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PWY10QL',130,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PWY20QU',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','PWY20QU',324,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208007,'6/6/2022','PWY10QL',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208001,'1/7/2022','PWY10QL',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PWY10QL',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PWY10QL',67,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','WY25WPQ',95,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208006,'8/8/2017','PWY10QL',95,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208011,'3/1/2019','PQWYM30',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','PWY10QL',90,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208007,'6/6/2022','WY25WPQ',130,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208001,'1/7/2022','PWY20QU',180,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PQWY34U',150,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','WYPQ15Q',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','PWY20QU',420,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208006,'8/8/2017','PQWYM30',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208011,'3/1/2019','PQWY34U',125,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PWY10QL',234,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PWY10QL',90,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','PWY10QL',420,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208001,'1/7/2022','PWY20QU',233,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PQWYM30',361,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PWY10QL',278,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','PWY10QL',310,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208006,'8/8/2017','PWY10QL',130,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208011,'3/1/2019','PWY10QL',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','WY25WPQ',324,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PWY10QL',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','PQWYM30',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208009,'1/19/2002','PWY10QL',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208001,'1/7/2022','WY25WPQ',67,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208011,'3/1/2019','PWY20QU',95,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208012,'1/12/2018','PQWY34U',95,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208008,'5/5/2018','WYPQ15Q',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208002,'4/20/2021','PWY20QU',90,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208004,'6/10/2019','PQWYM30',130,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208002,'4/20/2021','PQWY34U',180,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208004,'6/10/2019','PWY10QL',150,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208005,'5/5/2018','PWY10QL',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PWY10QL',420,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PWY20QU',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','PQWYM30',125,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208007,'6/6/2022','PWY10QL',234,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PWY10QL',90,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PWY10QL',420,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','PWY10QL',233,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208006,'8/8/2017','WY25WPQ',361,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208011,'3/1/2019','PWY10QL',278,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PQWYM30',310,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PWY10QL',130,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','WY25WPQ',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208007,'6/6/2022','PWY20QU',324,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208001,'1/7/2022','PQWY34U',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','WYPQ15Q',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PWY20QU',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','PQWYM30',67,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208006,'8/8/2017','PQWY34U',95,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208011,'3/1/2019','PWY10QL',95,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','PWY10QL',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208007,'6/6/2022','PWY10QL',90,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208001,'1/7/2022','PWY20QU',130,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PWY20QU',180,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PWY10QL',150,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208002,'4/20/2021','PWY10QL',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208004,'6/10/2019','PWY10QL',420,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208002,'4/20/2021','PWY10QL',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208004,'6/10/2019','WY25WPQ',125,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208005,'5/5/2018','PWY10QL',234,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PQWYM30',90,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PWY10QL',420,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','WY25WPQ',233,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208007,'6/6/2022','PWY20QU',361,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208001,'1/7/2022','PQWY34U',278,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','WYPQ15Q',310,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PWY20QU',130,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','PQWYM30',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208006,'8/8/2017','PQWY34U',324,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208011,'3/1/2019','PWY10QL',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PWY10QL',200,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PQWY34U',310,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208004,'6/10/2019','PWY20QU',331,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208002,'4/20/2021','PWY10QL',487,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208004,'6/10/2019','PQWYM30',312,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208005,'5/5/2018','PWY20QU',311,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PQWYM30',314,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PWY10QL',226,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','PWY20QU',314,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208007,'6/6/2022','WY25WPQ',126,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208001,'1/7/2022','WY25WPQ',220,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PWY10QL',500,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PQWYM30',485,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208001,'1/7/2022','PWY20QU',352,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PWY10QL',140,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PWY10QL',376,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208002,'4/20/2021','PQWYM30',292,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208004,'6/10/2019','PWY10QL',120,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208002,'4/20/2021','PQWYM30',357,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208004,'6/10/2019','PWY10QL',432,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208005,'5/5/2018','WY25WPQ',343,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PWY10QL',425,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PWY20QU',150,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','PWY10QL',435,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208007,'6/6/2022','PWY10QL',214,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208001,'1/7/2022','PWY10QL',185,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PQWYM30',325,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PWY20QU',218,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','PWY20QU',495,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208006,'8/8/2017','PWY10QL',162,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PQWYM30',283,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','PWY10QL',173,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208007,'6/6/2022','WY25WPQ',172,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208001,'1/7/2022','PWY10QL',383,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PWY20QU',368,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PWY20QU',481,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','PWY20QU',223,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208006,'8/8/2017','PQWYM30',291,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208011,'3/1/2019','PQWYM30',223,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PWY10QL',282,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','WY25WPQ',242,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','PWY10QL',384,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208007,'6/6/2022','PWY20QU',416,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208001,'1/7/2022','PWY10QL',315,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PWY10QL',116,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PWY10QL',457,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','PWY10QL',417,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208007,'6/6/2022','PWY10QL',255,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208001,'1/7/2022','PQWYM30',156,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208003,'7/1/2019','PWY20QU',380,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208000,'9/20/2017','PQWYM30',376,NULL);
INSERT INTO TicketBooking(FlightID,TicketBookingDate,TicketPromoCode,TicketBookingAmount,DiscountedPrice) VALUES (208010,'4/19/2021','PWY10QL',335,NULL);

/******************* Receipt **************/

INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272700,400100);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272707,400101);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272708,400102);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272706,400103);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272719,400104);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272705,400105);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272717,400106);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272718,400107);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272703,400108);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272711,400109);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272704,400110);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272709,400111);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272712,400112);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272701,400113);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272702,400114);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272715,400115);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272716,400116);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272710,400117);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272713,400118);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272714,400119);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272720,400120);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272721,400121);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272722,400122);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272723,400123);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272724,400124);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272725,400125);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272726,400126);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272727,400127);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272728,400128);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272729,400129);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272730,400130);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272731,400131);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272732,400132);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272733,400133);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272734,400134);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272735,400135);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272736,400136);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272737,400137);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272738,400138);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272739,400139);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272740,400140);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272741,400141);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272742,400142);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272743,400143);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272744,400144);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272745,400145);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272746,400146);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272747,400147);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272748,400148);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272749,400149);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272750,400150);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272751,400151);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272752,400152);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272753,400153);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272754,400154);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272755,400155);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272756,400156);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272757,400157);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272758,400158);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272759,400159);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272760,400160);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272761,400161);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272762,400162);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272763,400163);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272764,400164);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272765,400165);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272766,400166);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272767,400167);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272768,400168);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272769,400169);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272770,400170);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272771,400171);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272772,400172);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272773,400173);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272774,400174);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272775,400175);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272776,400176);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272777,400177);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272778,400178);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272779,400179);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272780,400180);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272781,400181);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272782,400182);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272783,400183);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272784,400184);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272785,400185);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272786,400186);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272787,400187);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272788,400188);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272789,400189);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272790,400190);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272791,400191);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272792,400192);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272793,400193);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272794,400194);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272795,400195);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272796,400196);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272797,400197);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272798,400198);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272799,400199);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272800,400200);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272801,400201);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272802,400202);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272803,400203);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272804,400204);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272805,400205);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272806,400206);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272807,400207);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272808,400208);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272809,400209);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272810,400210);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272811,400211);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272812,400212);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272813,400213);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272814,400214);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272815,400215);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272816,400216);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272817,400217);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272818,400218);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272819,400219);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272820,400220);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272821,400221);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272822,400222);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272823,400223);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272824,400224);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272825,400225);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272826,400226);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272827,400227);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272828,400228);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272829,400229);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272830,400230);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272831,400231);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272832,400232);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272833,400233);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272834,400234);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272835,400235);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272836,400236);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272837,400237);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272838,400238);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272839,400239);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272840,400240);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272841,400241);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272842,400242);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272843,400243);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272844,400244);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272845,400245);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272846,400246);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272847,400247);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272848,400248);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272849,400249);
INSERT INTO Receipt(TicketBookingId,CustomerId) VALUES (80272850,400250);


/***************** Seat ********************/


INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1A','Business',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1B','Business',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1D','Business',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1K','Business',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1L','Business',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2A','Business',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2B','Business',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2D','Business',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2K','Business',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2L','Business',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3A','Business',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3B','Business',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3D','Business',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3K','Business',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3L','Business',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4A','First',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4B','First',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4D','First',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4K','First',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4L','First',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5A','First',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5B','First',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5D','First',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5K','First',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5L','First',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6A','First',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6B','First',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6D','First',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6K','First',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6L','First',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7A','Economy',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7B','Economy',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7D','Economy',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7K','Economy',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7L','Economy',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8A','Economy',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8B','Economy',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8D','Economy',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8K','Economy',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8L','Economy',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9A','Economy',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9B','Economy',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9D','Economy',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9K','Economy',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9L','Economy',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10A','Economy',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10B','Economy',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10D','Economy',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10K','Economy',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10L','Economy',208000);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1A','Business',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1B','Business',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1D','Business',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1K','Business',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1L','Business',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2A','Business',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2B','Business',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2D','Business',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2K','Business',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2L','Business',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3A','Business',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3B','Business',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3D','Business',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3K','Business',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3L','Business',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4A','First',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4B','First',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4D','First',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4K','First',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4L','First',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5A','First',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5B','First',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5D','First',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5K','First',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5L','First',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6A','First',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6B','First',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6D','First',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6K','First',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6L','First',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7A','Economy',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7B','Economy',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7D','Economy',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7K','Economy',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7L','Economy',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8A','Economy',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8B','Economy',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8D','Economy',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8K','Economy',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8L','Economy',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9A','Economy',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9B','Economy',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9D','Economy',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9K','Economy',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9L','Economy',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10A','Economy',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10B','Economy',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10D','Economy',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10K','Economy',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10L','Economy',208001);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1A','Business',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1B','Business',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1D','Business',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1K','Business',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1L','Business',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2A','Business',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2B','Business',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2D','Business',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2K','Business',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2L','Business',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3A','Business',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3B','Business',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3D','Business',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3K','Business',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3L','Business',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4A','First',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4B','First',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4D','First',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4K','First',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4L','First',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5A','First',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5B','First',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5D','First',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5K','First',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5L','First',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6A','First',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6B','First',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6D','First',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6K','First',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6L','First',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7A','Economy',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7B','Economy',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7D','Economy',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7K','Economy',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7L','Economy',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8A','Economy',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8B','Economy',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8D','Economy',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8K','Economy',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8L','Economy',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9A','Economy',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9B','Economy',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9D','Economy',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9K','Economy',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9L','Economy',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10A','Economy',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10B','Economy',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10D','Economy',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10K','Economy',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10L','Economy',208002);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1A','Business',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1B','Business',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1D','Business',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1K','Business',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1L','Business',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2A','Business',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2B','Business',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2D','Business',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2K','Business',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2L','Business',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3A','Business',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3B','Business',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3D','Business',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3K','Business',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3L','Business',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4A','First',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4B','First',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4D','First',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4K','First',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4L','First',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5A','First',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5B','First',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5D','First',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5K','First',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5L','First',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6A','First',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6B','First',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6D','First',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6K','First',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6L','First',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7A','Economy',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7B','Economy',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7D','Economy',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7K','Economy',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7L','Economy',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8A','Economy',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8B','Economy',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8D','Economy',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8K','Economy',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8L','Economy',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9A','Economy',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9B','Economy',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9D','Economy',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9K','Economy',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9L','Economy',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10A','Economy',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10B','Economy',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10D','Economy',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10K','Economy',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10L','Economy',208003);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1A','Business',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1B','Business',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1D','Business',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1K','Business',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1L','Business',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2A','Business',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2B','Business',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2D','Business',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2K','Business',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2L','Business',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3A','Business',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3B','Business',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3D','Business',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3K','Business',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3L','Business',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4A','First',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4B','First',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4D','First',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4K','First',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4L','First',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5A','First',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5B','First',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5D','First',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5K','First',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5L','First',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6A','First',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6B','First',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6D','First',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6K','First',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6L','First',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7A','Economy',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7B','Economy',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7D','Economy',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7K','Economy',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7L','Economy',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8A','Economy',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8B','Economy',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8D','Economy',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8K','Economy',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8L','Economy',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9A','Economy',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9B','Economy',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9D','Economy',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9K','Economy',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9L','Economy',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10A','Economy',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10B','Economy',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10D','Economy',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10K','Economy',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10L','Economy',208004);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1A','Business',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1B','Business',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1D','Business',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1K','Business',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1L','Business',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2A','Business',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2B','Business',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2D','Business',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2K','Business',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2L','Business',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3A','Business',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3B','Business',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3D','Business',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3K','Business',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3L','Business',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4A','First',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4B','First',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4D','First',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4K','First',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4L','First',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5A','First',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5B','First',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5D','First',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5K','First',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5L','First',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6A','First',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6B','First',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6D','First',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6K','First',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6L','First',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7A','Economy',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7B','Economy',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7D','Economy',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7K','Economy',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7L','Economy',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8A','Economy',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8B','Economy',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8D','Economy',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8K','Economy',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8L','Economy',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9A','Economy',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9B','Economy',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9D','Economy',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9K','Economy',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9L','Economy',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10A','Economy',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10B','Economy',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10D','Economy',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10K','Economy',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10L','Economy',208005);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1A','Business',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1B','Business',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1D','Business',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1K','Business',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1L','Business',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2A','Business',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2B','Business',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2D','Business',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2K','Business',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2L','Business',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3A','Business',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3B','Business',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3D','Business',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3K','Business',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3L','Business',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4A','First',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4B','First',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4D','First',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4K','First',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4L','First',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5A','First',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5B','First',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5D','First',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5K','First',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5L','First',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6A','First',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6B','First',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6D','First',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6K','First',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6L','First',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7A','Economy',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7B','Economy',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7D','Economy',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7K','Economy',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7L','Economy',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8A','Economy',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8B','Economy',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8D','Economy',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8K','Economy',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8L','Economy',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9A','Economy',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9B','Economy',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9D','Economy',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9K','Economy',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9L','Economy',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10A','Economy',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10B','Economy',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10D','Economy',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10K','Economy',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10L','Economy',208006);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1A','Business',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1B','Business',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1D','Business',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1K','Business',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1L','Business',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2A','Business',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2B','Business',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2D','Business',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2K','Business',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2L','Business',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3A','Business',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3B','Business',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3D','Business',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3K','Business',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3L','Business',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4A','First',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4B','First',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4D','First',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4K','First',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4L','First',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5A','First',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5B','First',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5D','First',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5K','First',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5L','First',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6A','First',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6B','First',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6D','First',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6K','First',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6L','First',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7A','Economy',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7B','Economy',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7D','Economy',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7K','Economy',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7L','Economy',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8A','Economy',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8B','Economy',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8D','Economy',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8K','Economy',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8L','Economy',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9A','Economy',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9B','Economy',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9D','Economy',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9K','Economy',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9L','Economy',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10A','Economy',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10B','Economy',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10D','Economy',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10K','Economy',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10L','Economy',208007);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1A','Business',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1B','Business',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1D','Business',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1K','Business',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1L','Business',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2A','Business',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2B','Business',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2D','Business',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2K','Business',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2L','Business',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3A','Business',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3B','Business',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3D','Business',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3K','Business',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3L','Business',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4A','First',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4B','First',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4D','First',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4K','First',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4L','First',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5A','First',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5B','First',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5D','First',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5K','First',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5L','First',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6A','First',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6B','First',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6D','First',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6K','First',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6L','First',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7A','Economy',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7B','Economy',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7D','Economy',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7K','Economy',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7L','Economy',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8A','Economy',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8B','Economy',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8D','Economy',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8K','Economy',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8L','Economy',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9A','Economy',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9B','Economy',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9D','Economy',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9K','Economy',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9L','Economy',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10A','Economy',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10B','Economy',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10D','Economy',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10K','Economy',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10L','Economy',208008);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1A','Business',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1B','Business',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1D','Business',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1K','Business',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1L','Business',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2A','Business',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2B','Business',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2D','Business',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2K','Business',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2L','Business',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3A','Business',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3B','Business',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3D','Business',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3K','Business',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3L','Business',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4A','First',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4B','First',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4D','First',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4K','First',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4L','First',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5A','First',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5B','First',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5D','First',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5K','First',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5L','First',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6A','First',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6B','First',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6D','First',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6K','First',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6L','First',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7A','Economy',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7B','Economy',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7D','Economy',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7K','Economy',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7L','Economy',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8A','Economy',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8B','Economy',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8D','Economy',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8K','Economy',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8L','Economy',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9A','Economy',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9B','Economy',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9D','Economy',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9K','Economy',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9L','Economy',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10A','Economy',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10B','Economy',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10D','Economy',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10K','Economy',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10L','Economy',208009);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1A','Business',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1B','Business',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1D','Business',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1K','Business',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1L','Business',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2A','Business',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2B','Business',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2D','Business',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2K','Business',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2L','Business',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3A','Business',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3B','Business',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3D','Business',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3K','Business',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3L','Business',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4A','First',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4B','First',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4D','First',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4K','First',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4L','First',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5A','First',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5B','First',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5D','First',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5K','First',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5L','First',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6A','First',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6B','First',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6D','First',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6K','First',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6L','First',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7A','Economy',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7B','Economy',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7D','Economy',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7K','Economy',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7L','Economy',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8A','Economy',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8B','Economy',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8D','Economy',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8K','Economy',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8L','Economy',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9A','Economy',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9B','Economy',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9D','Economy',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9K','Economy',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9L','Economy',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10A','Economy',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10B','Economy',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10D','Economy',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10K','Economy',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10L','Economy',208010);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1A','Business',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1B','Business',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1D','Business',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1K','Business',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1L','Business',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2A','Business',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2B','Business',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2D','Business',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2K','Business',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2L','Business',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3A','Business',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3B','Business',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3D','Business',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3K','Business',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3L','Business',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4A','First',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4B','First',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4D','First',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4K','First',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4L','First',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5A','First',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5B','First',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5D','First',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5K','First',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5L','First',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6A','First',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6B','First',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6D','First',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6K','First',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6L','First',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7A','Economy',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7B','Economy',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7D','Economy',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7K','Economy',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7L','Economy',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8A','Economy',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8B','Economy',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8D','Economy',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8K','Economy',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8L','Economy',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9A','Economy',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9B','Economy',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9D','Economy',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9K','Economy',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9L','Economy',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10A','Economy',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10B','Economy',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10D','Economy',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10K','Economy',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10L','Economy',208011);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1A','Business',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1B','Business',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1D','Business',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1K','Business',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1L','Business',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2A','Business',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2B','Business',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2D','Business',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2K','Business',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2L','Business',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3A','Business',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3B','Business',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3D','Business',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3K','Business',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3L','Business',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4A','First',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4B','First',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4D','First',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4K','First',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4L','First',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5A','First',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5B','First',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5D','First',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5K','First',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5L','First',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6A','First',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6B','First',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6D','First',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6K','First',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6L','First',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7A','Economy',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7B','Economy',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7D','Economy',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7K','Economy',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7L','Economy',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8A','Economy',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8B','Economy',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8D','Economy',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8K','Economy',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8L','Economy',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9A','Economy',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9B','Economy',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9D','Economy',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9K','Economy',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9L','Economy',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10A','Economy',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10B','Economy',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10D','Economy',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10K','Economy',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10L','Economy',208012);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1A','Business',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1B','Business',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1D','Business',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1K','Business',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1L','Business',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2A','Business',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2B','Business',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2D','Business',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2K','Business',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2L','Business',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3A','Business',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3B','Business',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3D','Business',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3K','Business',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3L','Business',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4A','First',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4B','First',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4D','First',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4K','First',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4L','First',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5A','First',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5B','First',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5D','First',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5K','First',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5L','First',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6A','First',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6B','First',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6D','First',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6K','First',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6L','First',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7A','Economy',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7B','Economy',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7D','Economy',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7K','Economy',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7L','Economy',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8A','Economy',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8B','Economy',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8D','Economy',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8K','Economy',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8L','Economy',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9A','Economy',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9B','Economy',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9D','Economy',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9K','Economy',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9L','Economy',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10A','Economy',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10B','Economy',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10D','Economy',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10K','Economy',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10L','Economy',208013);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1A','Business',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1B','Business',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1D','Business',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1K','Business',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('1L','Business',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2A','Business',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2B','Business',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2D','Business',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2K','Business',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('2L','Business',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3A','Business',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3B','Business',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3D','Business',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3K','Business',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('3L','Business',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4A','First',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4B','First',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4D','First',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4K','First',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('4L','First',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5A','First',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5B','First',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5D','First',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5K','First',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('5L','First',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6A','First',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6B','First',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6D','First',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6K','First',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('6L','First',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7A','Economy',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7B','Economy',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7D','Economy',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7K','Economy',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('7L','Economy',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8A','Economy',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8B','Economy',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8D','Economy',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8K','Economy',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('8L','Economy',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9A','Economy',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9B','Economy',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9D','Economy',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9K','Economy',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('9L','Economy',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10A','Economy',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10B','Economy',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10D','Economy',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10K','Economy',208014);
INSERT INTO Seat(SeatNo,Class,FlightID) VALUES ('10L','Economy',208014);



/***************** LinkSeatCustomer ********************/


INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('2K',400100,'1/19/2022',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('10B',400101,'4/7/2022',208001);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('3D',400102,'3/1/2019',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8L',400103,'1/12/2018',208012);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('7A',400104,'5/5/2018',208008);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('5D',400105,'4/20/2021',208002);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('6A',400106,'6/10/2019',208004);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('2B',400107,'4/20/2021',208002);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('4D',400108,'6/10/2019',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('9D',400109,'5/5/2018',208005);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8K',400110,'7/1/2019',208003);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('3K',400111,'9/20/2017',208000);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('5A',400112,'4/19/2021',208010);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('10L',400113,'6/6/2022',208007);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('7K',400114,'4/7/2022',208001);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('4A',400115,'7/1/2019',208003);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('5A',400116,'9/20/2017',208000);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400117,'4/19/2021',208010);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('1D',400118,'8/8/2017',208006);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('1L',400119,'3/1/2019',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400120,'7/1/2019',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('10K',400121,'9/20/2017',208001);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('5B',400122,'4/19/2021',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400123,'6/6/2022',208012);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('6A',400124,'4/7/2022',208008);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('2L',400125,'7/1/2019',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('4B',400126,'9/20/2017',208004);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400127,'4/19/2021',208002);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('4D',400128,'8/8/2017',208004);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('10K',400129,'3/1/2019',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('5A',400130,'4/19/2021',208003);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('7B',400131,'6/6/2022',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('4K',400132,'4/7/2022',208010);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400133,'7/1/2019',208007);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('6B',400134,'9/20/2017',208001);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('10K',400135,'4/19/2021',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8B',400136,'8/8/2017',208000);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('4L',400137,'3/1/2019',208010);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400138,'7/1/2019',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('9A',400139,'9/20/2017',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('2D',400140,'4/19/2021',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('10K',400141,'4/7/2022',208001);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('10A',400142,'7/1/2019',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('1A',400143,'9/20/2017',208012);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('2K',400144,'4/19/2021',208008);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('5B',400145,'8/8/2017',208002);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('3D',400146,'3/1/2019',208004);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('10L',400147,'7/1/2019',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400148,'9/20/2017',208004);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('2K',400149,'4/19/2021',208005);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('1B',400150,'1/19/2002',208003);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('7D',400151,'4/7/2022',208000);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('1B',400152,'3/1/2019',208010);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('2L',400153,'1/12/2018',208007);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('2L',400154,'5/5/2018',208001);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('9K',400155,'4/20/2021',208003);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8K',400156,'6/10/2019',208000);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400157,'4/20/2021',208010);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('9D',400158,'6/10/2019',208006);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('9B',400159,'5/5/2018',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('1B',400160,'7/1/2019',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('10K',400161,'9/20/2017',208001);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('2D',400162,'4/19/2021',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('9L',400163,'6/6/2022',208012);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('6D',400164,'7/1/2019',208008);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('5K',400165,'9/20/2017',208002);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400166,'4/19/2021',208004);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('10L',400167,'8/8/2017',208002);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('3A',400168,'3/1/2019',208004);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('1D',400169,'7/1/2019',208005);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8A',400170,'9/20/2017',208003);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('6K',400171,'4/19/2021',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('10B',400172,'6/6/2022',208010);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400173,'4/7/2022',208007);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('7L',400174,'7/1/2019',208001);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('3B',400175,'9/20/2017',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('5K',400176,'4/19/2021',208000);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('1L',400177,'8/8/2017',208010);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400178,'3/1/2019',208006);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('1K',400179,'4/19/2021',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('10K',400180,'6/6/2022',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('2A',400181,'4/7/2022',208001);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('5L',400182,'7/1/2019',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8A',400183,'9/20/2017',208012);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('10D',400184,'4/20/2021',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400185,'6/10/2019',208002);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('7K',400186,'4/20/2021',208004);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('5B',400187,'6/10/2019',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('2B',400188,'5/5/2018',208004);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('6L',400189,'7/1/2019',208005);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400190,'9/20/2017',208003);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('9K',400191,'4/19/2021',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('7B',400192,'6/6/2022',208010);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('3K',400193,'4/7/2022',208007);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('9A',400194,'7/1/2019',208001);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('3L',400195,'9/20/2017',208003);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('6K',400196,'4/19/2021',208000);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400197,'8/8/2017',208010);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('10K',400198,'3/1/2019',208006);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('5B',400199,'7/1/2019',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400200,'9/20/2017',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('4B',400201,'6/10/2019',208004);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400202,'4/20/2021',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('4D',400203,'6/10/2019',208003);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('10K',400204,'5/5/2018',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('5D',400205,'7/1/2019',208010);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('7B',400206,'9/20/2017',208007);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('4K',400207,'4/19/2021',208001);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400208,'6/6/2022',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('6B',400209,'4/7/2022',208000);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('10K',400210,'7/1/2019',208010);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('9L',400211,'9/20/2017',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('6D',400212,'4/7/2022',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('5K',400213,'7/1/2019',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400214,'9/20/2017',208003);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('10L',400215,'4/20/2021',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('3A',400216,'6/10/2019',208010);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('1D',400217,'4/20/2021',208007);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8A',400218,'6/10/2019',208001);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('6K',400219,'5/5/2018',208003);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('10B',400220,'7/1/2019',208000);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400221,'9/20/2017',208010);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('7L',400222,'4/19/2021',208006);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('3B',400223,'6/6/2022',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('5K',400224,'4/7/2022',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('1L',400225,'7/1/2019',208004);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400226,'9/20/2017',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('1K',400227,'4/19/2021',208003);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('10K',400228,'8/8/2017',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('2A',400229,'9/20/2017',208003);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('5L',400230,'4/19/2021',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8A',400231,'6/6/2022',208010);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('10D',400232,'4/7/2022',208007);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400233,'7/1/2019',208001);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('7K',400234,'9/20/2017',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('5B',400235,'4/19/2021',208000);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('2B',400236,'8/8/2017',208010);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('6L',400237,'3/1/2019',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400238,'7/1/2019',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('9K',400239,'9/20/2017',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('7B',400240,'4/19/2021',208003);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('3K',400241,'6/6/2022',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('9A',400242,'4/7/2022',208010);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('3L',400243,'7/1/2019',208007);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('6D',400244,'9/20/2017',208001);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400245,'4/19/2021',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('10K',400246,'6/6/2022',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('5B',400247,'4/7/2022',208009);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('8D',400248,'7/1/2019',208003);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('7L',400249,'9/20/2017',208011);
INSERT INTO LinkSeatCustomer(SeatNo,CustomerID,SeatBookingDate,FlightID) VALUES ('3B',400250,'4/19/2021',208007);




---- /******************** Non clustered index  ********************/ --------


CREATE NONCLUSTERED INDEX NCIX_Airport_AirportName ON dbo.Airport(AirportName);
CREATE NONCLUSTERED INDEX NCIX_FlightSchedule_ScheduleDate ON dbo.FlightSchedule(ScheduleDate);
CREATE NONCLUSTERED INDEX NCIX_Customer_CustomerPhone ON dbo.Customer(CustomerPhone);
CREATE NONCLUSTERED INDEX NCIX_Employee_EmployeePhone ON dbo.Employee(EmployeePhone);




--------------------------------- STORED PROCEDURE -----------------------------------

---- /******************** Stored procedure 1: Tickets per Flight ********************/ -------- 
GO
CREATE OR ALTER PROCEDURE CountTicketPerFlight (@FlightID int, @TicketCount int OUTPUT)
AS
BEGIN
    SELECT TicketBookingID
    FROM TicketBooking
    WHERE FlightID = @FlightID;

    SELECT @TicketCount = @@ROWCOUNT;

END;

DECLARE @count INT;

EXEC CountTicketPerFlight @FlightID = 208012, @TicketCount = @count OUTPUT;

SELECT @count AS 'COUNT OF TICKETS PER FLIGHT';



---- /******************** Stored procedure 2: Amount per Flight ********************/ -------- 
GO
CREATE OR ALTER PROCEDURE CountTotalAmountPerFlight (@FlightID int, @TicketAmount int OUTPUT)
AS
BEGIN
    SELECT @TicketAmount = SUM(TicketBookingAmount)
    From TicketBooking 
    WHERE FlightID = @FlightID
    
    
END;

DECLARE @Amount INT;

EXEC CountTotalAmountPerFlight @FlightID = 208012, @TicketAmount = @Amount OUTPUT;

SELECT @Amount AS 'Total Amount per flight';



---- /******************** Stored procedure : Top 3 most popular seats ********************/ -------- 
GO
CREATE or ALTER PROCEDURE popularSeats (@top varchar(200) OUTPUT)
AS
BEGIN
     SET NOCOUNT ON;
	 SELECT @top = COALESCE(@TOP + ',', '') + CAST(SeatNo AS VARCHAR(5))
	 FROM 
	 (SELECT SeatNo,DENSE_RANK() OVER(ORDER BY COUNT(SeatNo) DESC) AS rnk, COUNT(SeatNo) AS cnt
	 FROM LinkSeatCustomer
	 GROUP by SeatNo) t 
	 WHERE rnk < 4
END;


DECLARE @Result VARCHAR(200)
EXEC popularSeats @Result OUTPUT
SELECT value FROM string_split(@Result,',');






---------------------- VIEW ------------------------

--- /******************** View 1 : Hotspot destination ********************/ -------- 
GO
CREATE OR ALTER VIEW hotspotDestination AS
	SELECT TOP 3 a.airportName, COUNT(tb.ticketBookingID) as totalCount
	FROM Airport a 
    JOIN FlightSchedule fs ON a.AirportID = fs.DestinationAirportID
	JOIN TicketBooking tb ON fs.FlightID = tb.FlightID
	GROUP BY airportName
	ORDER BY COUNT(tb.ticketBookingID) desc

SELECT * FROM hotspotDestination
--- /******************** View 2 : Number of Tickets booked in a year ********************/ -------- 

GO
CREATE OR ALTER VIEW bookingsPerYear AS
	SELECT datepart(year, ticketbookingdate) AS year,
	COUNT(TicketBookingID) AS count1
	FROM TicketBooking
	GROUP BY datepart(year, ticketbookingdate)
	ORDER BY COUNT(TicketBookingID) DESC
	OFFSET 0 ROWS

SELECT * FROM bookingsPerYear
--- /******************** View 3 : most used promocode ********************/ -------- 

GO
CREATE OR ALTER VIEW MostUsedPromocodeView AS
	SELECT TOP 5 TicketPromoCode, COUNT(TicketPromoCode)as CountPromocode
	FROM TicketBooking
	GROUP BY TicketPromoCode
	ORDER BY COUNT(TicketPromoCode) DESC
	

SELECT * FROM MostUsedPromocodeView

--- /******************** View 4 : Total Cost by year ********************/ -------- 



CREATE VIEW TotalCostPerYear AS
	SELECT datepart(year, ticketbookingdate) AS year, SUM(TicketBookingAmount) AS TotalCost
	FROM TicketBooking
	GROUP BY datepart(year, ticketbookingdate)
	ORDER BY COUNT(TicketBookingID) DESC
	OFFSET 0 ROWS

SELECT * FROM TotalCostPerYear




