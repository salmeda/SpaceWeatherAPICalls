USE NASANW

DELIMITER //

DROP procedure nasatester //

CREATE PROCEDURE nasatester ()
begin
	DECLARE errno INT;
	DECLARE msg TEXT;
	DECLARE vTrxType TINYINT;
	DECLARE vCallID 	INT;  
	DECLARE vApiName VARCHAR(50);
	DECLARE vStartDate DATE;
	DECLARE vEndDate DATE;
    DECLARE vCreationDate TIMESTAMP; 
	DECLARE vModifiedDate TIMESTAMP;
	DECLARE vStatus VARCHAR(15);
	DECLARE vFileStatus VARCHAR(15);
	DECLARE vMessage VARCHAR(1500);
	DECLARE vSpStatus TINYINT; -- Success = 0, Error = 1, Warning = 2
	DECLARE vSpMsg TEXT;

set vTrxType= '2';
set vCallID='85';
set vStatus= 'Finished';

		/* select  apiName, StartDate, EndDate, CreationDate, ModifiedDate, Status , FileStatus, Message 
		 into  vApiName, vStartDate, vEndDate, vCreationDate, vModifiedDate, vStatus, vFileStatus, vMessage 
        from NASANW.nasaAPIcalls
        where CallID = '84';
        */

 CALL nasaAPIcallsHandler(vTrxType, vCallID, vApiName, vStartDate, vEndDate, vStatus, vFileStatus, vMessage, vSpStatus,vSpMsg );

END//

DELIMITER ;
 