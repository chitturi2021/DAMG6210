
--CREATE DATABASE Group7
--USE Group7

-- -----------------------------------------------------
-- Table Address
-- -----------------------------------------------------
DROP TABLE IF EXISTS Address ;

CREATE TABLE Address (
  AddressID INT NOT NULL,
  Addressline1 VARCHAR(45) NOT NULL,
  Addressline2 VARCHAR(45) NOT NULL,
  City VARCHAR(45) NOT NULL,
  State VARCHAR(45) NOT NULL,
  ZipCode INT NOT NULL,
  CONSTRAINT PK_Address PRIMARY KEY (AddressID));

-- -----------------------------------------------------
-- Table CovidTestingCentre
-- -----------------------------------------------------
DROP TABLE IF EXISTS CovidTestingCentre ;

CREATE TABLE CovidTestingCentre (
  CovidTestingCentreID INT NOT NULL,
  TestDate DATE NOT NULL,
  AvailSlots INT NOT NULL,
  CONSTRAINT PK_CovidTestingCentre PRIMARY KEY (CovidTestingCentreID));

-- -----------------------------------------------------
-- Table EmergencyHelpLine
-- -----------------------------------------------------
DROP TABLE IF EXISTS EmergencyHelpLine ;

CREATE TABLE EmergencyHelpLine (
  CustomerCareNumber VARCHAR(45) NOT NULL,
  ServiceProviderName VARCHAR(45) NOT NULL,
  AvailableHours VARCHAR(45) NOT NULL,
  CONSTRAINT PK_EmergencyHelpLine PRIMARY KEY (CustomerCareNumber));

-- -----------------------------------------------------
-- Table Grocery
-- -----------------------------------------------------
DROP TABLE IF EXISTS Grocery ;

CREATE TABLE Grocery (
  GroceryID INT NOT NULL,
  StoreName VARCHAR(45) NOT NULL,
  PhoneNumber VARCHAR(45) NOT NULL,
  CONSTRAINT PK_Grocery PRIMARY KEY (GroceryID),
  AddressID INT NOT NULL,
  CONSTRAINT FK_Grocery_Address FOREIGN KEY (AddressID) REFERENCES Address (AddressID));

-- -----------------------------------------------------
-- Table FoodSuppliers
-- -----------------------------------------------------
DROP TABLE IF EXISTS FoodSuppliers ;

CREATE TABLE FoodSuppliers (
  FoodSuppliersID INT NOT NULL,
  StoreName VARCHAR(45) NOT NULL,
  PhoneNumber VARCHAR(45) NOT NULL,
  AddressID INT NOT NULL,
  CONSTRAINT PK_FoodSuppliers PRIMARY KEY (FoodSuppliersID),
  CONSTRAINT FK_FoodSuppliers_Address FOREIGN KEY (AddressID) REFERENCES Address (AddressID));

-- -----------------------------------------------------
-- Table Pharmacy
-- -----------------------------------------------------
DROP TABLE IF EXISTS Pharmacy ;

CREATE TABLE Pharmacy (
  PharmacyID INT NOT NULL,
  StoreName VARCHAR(45) NOT NULL,
  PhoneNumber VARCHAR(45) NOT NULL,
  AddressID INT NOT NULL,
  CONSTRAINT PK_Pharmacy PRIMARY KEY (PharmacyID),
  CONSTRAINT FK_Pharmacy_Address FOREIGN KEY (AddressID) REFERENCES Address (AddressID));

-- -----------------------------------------------------
-- Table Hospital
-- -----------------------------------------------------
DROP TABLE IF EXISTS Hospital ;

CREATE TABLE Hospital (
  HospitalID INT NOT NULL,
  HospitalName VARCHAR(45) NOT NULL,
  PhoneNumber VARCHAR(45) NOT NULL,
  NumberOfSpecialist INT NOT NULL,
  NumberofBeds INT NOT NULL,
  NumberOfNursers INT NOT NULL,
  AddressID INT NOT NULL,
  CovidTestingCentreID INT NOT NULL,
  CONSTRAINT PK_Hospital PRIMARY KEY (HospitalID),
  CONSTRAINT FK_Hospital_Address FOREIGN KEY (AddressID) REFERENCES Address (AddressID),
  CONSTRAINT FK_Hospital_CovidTestingCentre FOREIGN KEY (CovidTestingCentreID) REFERENCES CovidTestingCentre (CovidTestingCentreID));

-- -----------------------------------------------------
-- Table Ambulance
-- -----------------------------------------------------
DROP TABLE IF EXISTS Ambulance ;

CREATE TABLE Ambulance (
  AmbulanceLicenseNumber INT NOT NULL,
  FirstName VARCHAR(45) NOT NULL,
  LastName VARCHAR(45) NOT NULL,
  ServiceProvider VARCHAR(45) NULL,
  PhoneNumber Varchar(45) NOT NULL,
  Status VARCHAR(45) NOT NULL,
  HospitalID INT NOT NULL,
  CONSTRAINT PK_Ambulance PRIMARY KEY (AmbulanceLicenseNumber),
  CONSTRAINT FK_Ambulance_Hospital FOREIGN KEY (HospitalID) REFERENCES Hospital (HospitalID));

-- -----------------------------------------------------
-- Table OxygenSupplier
-- -----------------------------------------------------
DROP TABLE IF EXISTS OxygenSupplier ;

CREATE TABLE OxygenSupplier (
  OxygensupplierID INT NOT NULL,
  NumberOfCylinders INT NOT NULL,
  StoreName VARCHAR(45) NOT NULL,
  PhoneNumber VARCHAR(45) NOT NULL,
  Zipcode INT NOT NULL,
  HospitalID INT NOT NULL,
  CONSTRAINT PK_OxygenSupplier PRIMARY KEY (OxygensupplierID),
  CONSTRAINT FK_OxygenSupplier_Hospital FOREIGN KEY (HospitalID) REFERENCES Hospital (HospitalID));

-- -----------------------------------------------------
-- Table Person
-- -----------------------------------------------------
DROP TABLE IF EXISTS Person ;

CREATE TABLE Person (
  PersonID INT NOT NULL,
  FirstName VARCHAR(45) NOT NULL,
  LastName VARCHAR(45) NOT NULL,
  DateofBirth DATE NOT NULL,
  PhoneNumber Varchar(45) NOT NULL,
  Occupation VARCHAR(45) NOT NULL,
  BloodGroup VARCHAR(45) NOT NULL,
  Gender VARCHAR(45) NOT NULL,
  VaccinationStatus VARCHAR(45) NULL,
  AddressID INT NOT NULL,
  CustomerCareNumber VARCHAR(45) NULL,
  CONSTRAINT PK_Person PRIMARY KEY (PersonID),
  CONSTRAINT FK_Person_Address FOREIGN KEY (AddressID) REFERENCES Address (AddressID),
  CONSTRAINT FK_Person_EmergencyHelpLine  FOREIGN KEY (CustomerCareNumber) REFERENCES EmergencyHelpLine (CustomerCareNumber));

-- -----------------------------------------------------
-- Table DailyServices
-- -----------------------------------------------------
DROP TABLE IF EXISTS DailyServices ;

CREATE TABLE DailyServices (
  DailyServicesID INT NOT NULL,
  PersonID INT NOT NULL,
  GroceryID INT NULL,
  FoodSuppliersID INT NULL,
  CONSTRAINT PK_DailyServices PRIMARY KEY (DailyServicesID),
  CONSTRAINT FK_DailyServices_Person FOREIGN KEY (PersonID) REFERENCES Person (PersonID),
  CONSTRAINT FK_DailyServices_Grocery FOREIGN KEY (GroceryID) REFERENCES Grocery (GroceryID),
  CONSTRAINT FK_DailyServices_FoodSuppliers FOREIGN KEY (FoodSuppliersID) REFERENCES FoodSuppliers (FoodSuppliersID));

-- -----------------------------------------------------
-- Table QuarintineCentre
-- -----------------------------------------------------
DROP TABLE IF EXISTS QuarintineCentre ;

CREATE TABLE QuarintineCentre (
  QuarintineCentreID INT NOT NULL,
  CentreName VARCHAR(45) NOT NULL,
  NumberOfBeds INT NOT NULL,
  CONSTRAINT PK_QuarintineCentre PRIMARY KEY (QuarintineCentreID));

-- -----------------------------------------------------
-- Table Patient
-- -----------------------------------------------------
DROP TABLE IF EXISTS Patient ;

CREATE TABLE Patient (
  PatientID INT NOT NULL,
  PatientRecord VARCHAR(45) NULL,
  DateofAdmit DATE NOT NULL,
  DateofDischarge DATE NULL,
  LastVisitDate DATE NULL,
  LastCovidtestDate DATE NULL,
  CovidSymptoms VARCHAR(45) NULL,
  PersonID INT NOT NULL,
  HospitalID INT NOT NULL,
  PharmacyID INT NULL,
  QuarintineCentreID INT NULL,
  CONSTRAINT PK_Patient PRIMARY KEY (PatientID),
  CONSTRAINT FK_Patient_Person FOREIGN KEY (PersonID) REFERENCES Person (PersonID),
  CONSTRAINT FK_Patient_Hospital FOREIGN KEY (HospitalID) REFERENCES Hospital (HospitalID),
  CONSTRAINT FK_Patient_Pharmacy FOREIGN KEY (PharmacyID) REFERENCES Pharmacy (PharmacyID),
  CONSTRAINT FK_Patient_QuarintineCentre FOREIGN KEY (QuarintineCentreID) REFERENCES QuarintineCentre (QuarintineCentreID));

-- -----------------------------------------------------
-- Table PlasmaDonor
-- -----------------------------------------------------
DROP TABLE IF EXISTS PlasmaDonor ;

CREATE TABLE PlasmaDonor (
  PlasmaDonated VARCHAR(45) NOT NULL,
  LastCovidTestDate DATE NOT NULL,
  CurrentCovidStatus VARCHAR(45) NOT NULL,
  PatientID INT NOT NULL,
  CONSTRAINT PK_PlasmaDonor PRIMARY KEY (PatientID),
  CONSTRAINT FK_PlasmaDonor_Patient FOREIGN KEY (PatientID) REFERENCES Patient (PatientID));

-- -----------------------------------------------------
-- Table VaccinationCentre
-- -----------------------------------------------------
DROP TABLE IF EXISTS VaccinationCentre ;

CREATE TABLE VaccinationCentre (
  VaccinationCentreID INT NOT NULL,
  TypeOfVaccination VARCHAR(45) NOT NULL,
  Quantity INT NOT NULL,
  NumberOfAvailSlots INT NOT NULL,
  AvailDate DATE NOT NULL,
  AddressID INT NOT NULL,
  CONSTRAINT PK_VaccinationCentre PRIMARY KEY (VaccinationCentreID),
  CONSTRAINT FK_VaccinationCentre_Address FOREIGN KEY (AddressID) REFERENCES Address (AddressID));

-- -----------------------------------------------------
-- Table Vaccines
-- -----------------------------------------------------
DROP TABLE IF EXISTS Vaccines ;

CREATE TABLE Vaccines (
  TypeOfVaccination VARCHAR(45) NOT NULL,
  NumberOfdoses INT NOT NULL,
  CONSTRAINT PK_Vaccines PRIMARY KEY (TypeOfVaccination));

-- -----------------------------------------------------
-- Table VaccinationLinker
-- -----------------------------------------------------
DROP TABLE IF EXISTS VaccinationLinker ;

CREATE TABLE VaccinationLinker (
  VaccinationID INT NOT NULL,
  TypeOfVaccination VARCHAR(45) NOT NULL,
  VaccinationCentreID INT NOT NULL,
  PersonID INT NOT NULL,
  CONSTRAINT PK_VaccinationLinker PRIMARY KEY (VaccinationID),
  CONSTRAINT FK_VaccinationLinker_Vaccines FOREIGN KEY (TypeOfVaccination) REFERENCES Vaccines (TypeOfVaccination),
  CONSTRAINT FK_VaccinationLinker_VaccinationCentre FOREIGN KEY (VaccinationCentreID) REFERENCES VaccinationCentre (VaccinationCentreID),
  CONSTRAINT FK_VaccinationLinker_Person FOREIGN KEY (PersonID) REFERENCES Person (PersonID));


/*
ALTER TABLE Person
ADD CONSTRAINT FK_Person_EmergencyHelpLine  FOREIGN KEY (CustomerCareNumber) REFERENCES EmergencyHelpLine (CustomerCareNumber);

ALTER TABLE EmergencyHelpLine
ADD CONSTRAINT PK_EmergencyHelpLine PRIMARY KEY (CustomerCareNumber);

ALTER TABLE Patient
ALTER COLUMN QuarintineCentreID INT NULL;
*/

-- -----------------------------------------------------
-- -----------------------------------------------------
-- Function to calculate the age of a person based on the date of birth.
GO
CREATE FUNCTION AgeCal()
RETURNS TABLE AS
RETURN(
SELECT PersonID,FirstName, LastName, DATEDIFF(hour,DateofBirth,GETDATE())/8766 AS Age
FROM Person
);
GO

SELECT * FROM AgeCal()
ORDER BY PersonID;
GO

-- -----------------------------------------------------
-- Triggers(Computed column)
-- -----------------------------------------------------
-- Trigger to update the vaccination status of a person.
CREATE TRIGGER VaccineStatus
ON VaccinationLinker
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
SET NOCOUNT ON;
DECLARE @count INT, @pid INT, @status varchar(45), @type varchar(45), @doses INT;

SELECT @pid=ISNULL(i.PersonID,d.PersonID)
FROM inserted i FULL JOIN deleted d
ON i.PersonID=d.PersonID;

SELECT @count=ISNULL(COUNT(PersonID),0)
FROM VaccinationLinker
WHERE PersonID=@pid;

SELECT @type=ISNULL(TypeOfVaccination,0)
FROM VaccinationLinker
WHERE PersonID=@pid;

SELECT @doses=ISNULL(NumberOfdoses,0)
FROM Vaccines
WHERE TypeOfVaccination=@type;

IF @count=0 SET @status='Not Vaccinated';
ELSE
	BEGIN
		IF @count = @doses SET @status='Fully Vaccinated';
		ELSE 
			BEGIN	
				SET @status ='Partially Vaccinated';
			END
	END
	UPDATE Person SET VaccinationStatus=@status
			WHERE PersonID=@pid;
END
GO

--DROP TRIGGER VaccineStatus


-- -----------------------------------------------------
-- -----------------------------------------------------
-- Trigger to update the number of beds in a quarantine centre based on the number of patients filled in the quarantine centre.  
GO
CREATE TRIGGER UpdateBedsQuarintineCentre
ON Patient
AFTER Insert, Update, Delete
AS
BEGIN
SET NOCOUNT ON;
DECLARE @result int, @count int, @qid int, @beds int;

SELECT @qid=ISNULL(i.QuarintineCentreID, d.QuarintineCentreID)
FROM inserted i FULL JOIN deleted d
ON i.QuarintineCentreID=d.QuarintineCentreID;

SELECT @count=ISNULL(COUNT(i.PersonID),0)
FROM inserted i
Where QuarintineCentreID=@qid;

SELECT @beds=ISNULL(NumberOfBeds,0)
FROM QuarintineCentre
WHERE QuarintineCentreID = @qid;

SET @result=@beds-@count;

UPDATE QuarintineCentre SET NumberOfBeds=@result
WHERE QuarintineCentreID=@qid;

END;
GO
--SELECT * from QuarintineCentre;

--DROP TRIGGER UpdateBedsQuarintineCentre;

-- ----------------------------------------------
-- Check constraints based on a function
-- ----------------------------------------------

--DROP FUNCTION CheckVaccineType;
-- Check constraint to check the vaccination type.
GO
CREATE FUNCTION CheckVaccineType(@pid int)
RETURNS varchar(45)
AS
BEGIN
DECLARE @vname varchar(45);
SELECT @vname=VaccinationLinker.TypeOfVaccination
FROM VaccinationLinker
WHERE @pid=PersonID;
RETURN @vname
END;
GO

ALTER TABLE VaccinationLinker
ADD CONSTRAINT VaccineType CHECK (dbo.CheckVaccineType(PersonID)=TypeOfVaccination);

/*
ALTER TABLE VaccinationLinker
DROP CONSTRAINT VaccineType;

SELECT * from VaccinationLinker

DELETE FROM VaccinationLinker where VaccinationID>1401;
*/

-- -----------------------------------------------------
-- -----------------------------------------------------
-- Check constraint to check if a person is fully vaccinated and if a person is fully vaccinated then he cannot get further doses.
GO
CREATE FUNCTION MultipleDoses(@pid int)
RETURNS smallint
AS
BEGIN
DECLARE @status varchar(45);
SELECT @status=VaccinationStatus
FROM Person
WHERE @pid=PersonID;
DECLARE @result smallint;

IF @status='Fully Vaccinated' SET @result=0;
ELSE SET @result=1;
RETURN @result
END;
GO

--DROP FUNCTION MultipleDoses;
/*
ALTER TABLE VaccinationLinker
ADD CONSTRAINT MultipleDoses1 CHECK (dbo.MultipleDoses(PersonID)=0);


SELECT * from VaccinationLinker

DELETE FROM VaccinationLinker where VaccinationID>1402;

ALTER TABLE VaccinationLinker
DROP CONSTRAINT MultipleDoses1;
*/

-- -----------------------------------------------------
-- -----------------------------------------------------
-- Check constraint to check if beds are available in a quarantine centre.
GO
CREATE FUNCTION CheckIfBedsAvailableQuarintineCentre(@qcentreID int)
RETURNS smallint
AS
BEGIN
DECLARE @beds int, @result smallint;
SELECT @beds=NumberOfBeds
FROM QuarintineCentre
WHERE QuarintineCentreID=@qcentreID;
IF @beds>=0 SET @result=0;
ELSE SET @result=1;

RETURN @result
END
GO

ALTER TABLE Patient
ADD CONSTRAINT CloseQuarintineCentre CHECK (dbo.CheckIfBedsAvailableQuarintineCentre(QuarintineCentreID)=0);

/*
ALTER TABLE QuarintineCentre
DROP CONSTRAINT CloseQuarintineCentre;

*/
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Check constraint to check if slots are available in a vaccination centre.
GO
CREATE FUNCTION CheckIfSlotsAvailableVaccinationCentre(@vcentreID int)
RETURNS smallint
AS
BEGIN
DECLARE @slots int, @result int;
SELECT @slots=NumberOfAvailSlots
FROM VaccinationCentre
WHERE VaccinationCentreID=@vcentreID;
IF @slots> 0 SET @result=0;
ELSE SET @slots =1;
RETURN @result
END
GO

ALTER TABLE VaccinationLinker
ADD CONSTRAINT CloseVaccinationCentre CHECK (dbo.CheckIfSlotsAvailableVaccinationCentre(VaccinationCentreID)=0);

/*
DROP FUNCTION CheckIfSlotsAvailableVaccinationCentre;
ALTER TABLE VaccinationLinker
DROP CONSTRAINT CloseVaccinationCentre;
*/



-- -----------------------------------------------------
-- -----------------------------------------------------
-- Check constraint to check if the hospital phone number consists of 13 characters before entering.
GO
CREATE FUNCTION CheckPhoneNumber(@PN varchar(25))
RETURNS smallint
AS
BEGIN 
     DECLARE @count smallint = 0;
	 SELECT @count = LEN(PhoneNumber)
	 FROM Hospital
	 WHERE PhoneNumber = @PN
	 RETURN @count
END;
GO
ALTER TABLE Hospital ADD CONSTRAINT CheckNumber CHECK (dbo.CheckPhoneNumber(PhoneNumber)=13);

/*ALTER TABLE Hospital
DROP CONSTRAINT CheckNumber
*/

-- -----------------------------------------------------
-- -----------------------------------------------------
-- Check constraint to check if the emergency contact number consists of 13 characters before entering.
GO
CREATE FUNCTION CheckEPhoneNumber(@Pn varchar(25))
RETURNS smallint
AS
BEGIN 
     DECLARE @count smallint = 0;
	 SELECT @count = LEN(CustomerCareNumber)
	 FROM EmergencyHelpLine
	 WHERE CustomerCareNumber = @Pn
	 RETURN @count
END;
GO
ALTER TABLE EmergencyHelpLine ADD CONSTRAINT CheckENumber CHECK (dbo.CheckEPhoneNumber(CustomerCareNumber)=13);

ALTER TABLE EmergencyHelpline
DROP CONSTRAINT CheckENumber

-- -----------------------------------------------------
-- -----------------------------------------------------
-- Check constraint to check if the zipcode consists of 5 digits before entering.
GO
CREATE FUNCTION CheckZipCode(@AId int)
RETURNS smallint
AS
BEGIN
     DECLARE @n smallint = 0;
	 SELECT @n = LEN(ZipCode)
	 FROM Address
	 WHERE AddressID = @AId
	 RETURN @n
END;
GO
ALTER TABLE Address ADD CONSTRAINT CheckZCode CHECK (dbo.CheckZipCode(AddressID) = 5);

/*INSERT INTO Address(AddressID, Addressline1, Addressline2, City, State, ZipCode) VALUES (402, '82 Commonwealth Avenue', 'Flat 213', 'Hartford', 'Connecticut', 0215)

INSERT INTO Address(AddressID, Addressline1, Addressline2, City, State, ZipCode) VALUES (403, '81 Commonwealth Avenue', 'Flat 214', 'Hartford', 'Connecticut', 22151)*/

-- -----------------------------------------------------
-- Computed columns based on a function
-- -----------------------------------------------------
-- To compute the number of days a patient was in the hospital. 
GO
CREATE FUNCTION NumberDays(@PId int)
RETURNS smallint
AS
BEGIN
     DECLARE @c smallint = 0;
	 SELECT @c = DATEDIFF(day, DateofAdmit, DateofDischarge)
	 FROM Patient
	 WHERE PatientID = @PId
	 RETURN @c
END;
GO
ALTER TABLE Patient ADD NumberOfDaysinHospital AS (dbo.NumberDays(PatientID));

ALTER TABLE Patient
DROP COLUMN NumberOfDaysinHospital;

-- ----------------------------------------------------
-- ----------------------------------------------------
-- To compute the total number of staff in a hospital.

GO
CREATE FUNCTION NumberStaff(@hId int)
RETURNS smallint
AS 
BEGIN
     DECLARE @num smallint = 0;
	 SELECT @num = (NumberOfSpecialist + NumberOfNursers)
	 FROM Hospital
	 WHERE HospitalID = @hId
	 RETURN @num
END;
GO
ALTER TABLE Hospital ADD NumberOfStaffinHospital AS (dbo.NumberStaff(HospitalID))

/*ALTER TABLE Hospital
DROP COLUMN NumberOfStaffinHospital;
GO
*/

-- -------------------------------------------------------
-- Views
-- -------------------------------------------------------
-- View to display the total number of persons in a hospital
GO
create view [Total number of persons in a hospital]
 as
select ho.HospitalID,count(ho.personid)[Total number of persons]
from Patient ho 
group by ho.HospitalID;
GO

SELECT * FROM dbo.[Total number of persons in a hospital]
-- -------------------------------------------------------
-- -------------------------------------------------------
-- View to display total number of persons and hospitals in a zipcode
GO
create view [Find total number of persons and hospital in a zipcode]
as
with temp1 as 
(
select ad.zipcode,count(pr.PersonID)[Total no of persons] 
from person pr inner join Address ad on pr.AddressID = ad.AddressID
group by ad.zipcode
),
temp2 as
(
select ad.zipcode,count(ho.HospitalID)[total no of hospital]
from Hospital ho inner join Address ad on ho.AddressID = ad.AddressID
group by ad.zipcode
)
select t1.zipcode,[Total no of persons],[total no of hospital]
from temp1 t1 inner join temp2 t2 on t1.ZipCode = t2.ZipCode
GO
select * from dbo.[Find total number of persons and hospital in a zipcode]

-- --------------------------------------------------------
-- --------------------------------------------------------
-- View to display the number of hospitals in a city
GO
CREATE VIEW [Number of Hospitals in a City]
AS
SELECT a.City, COUNT(h.HospitalID) [Count Hospitals]
FROM Address a
JOIN Hospital h
ON a.AddressID = h.AddressID
GROUP BY a.City;
GO
SELECT *
FROM dbo.[Number of Hospitals in a City]
-- -----------------------------------------------------
-- -----------------------------------------------------
-- View to display the number of vaccination centres in a state
GO
CREATE VIEW [Number of Vaccination centers in a State]
AS
SELECT a.State, COUNT(v.VaccinationCentreID) [Count Vaccination Centres]
FROM Address a
JOIN VaccinationCentre v
ON a.AddressID = v.AddressID
GROUP BY a.State; 
GO
SELECT *
FROM dbo.[Number of Vaccination centers in a State]


