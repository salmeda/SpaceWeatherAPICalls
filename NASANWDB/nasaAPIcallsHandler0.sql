USE NASANW

DELIMITER //

 DROP PROCEDURE nasaAPIcallsHandler//

CREATE PROCEDURE nasaAPIcallsHandler (
IN pTrxType TINYINT, -- Insert = 1, Update =2 
INOUT pCallID INT,
IN pApiName VARCHAR(50),
IN pStartDate DATE,
IN pEndDate DATE,
IN pStatus VARCHAR(15),
IN pFileStatus VARCHAR(15),
IN pMessage VARCHAR(1500),
OUT pSpStatus TINYINT, -- Success = 0, Error = 1, Warning = 2
OUT pSpMsg TEXT 
)
/* *************************************************************************************************************
SP Name: nasaAPIcallsHandler
SP Version: 1.0
Author: Sara Almeda Caballero
Creation Date: 22 Dec 2019
****************************************************************************************************************
Comments:
The nasaAPIcallsHandler works as follows:
	1- The insert transaction just needs two fields: API Name and Start Date. The rest of fields
    are defaulted.
    2- The update transaction is always done by CallID. If CallID is not provided then the transaction
    does not take place. If callID does not exist in table then the transaction does not take place.
    3- If any other info is required the insert, like a different status, it needs to be handled
    in a different update transaction after Insert.
    4- Update transaction does not allow updation of the following fields. If data is populated in these fields
    they will be ignored. These are populated in Insert and it can't be updated through handler.
		- CAllID 
        - ApiName
        - StartDate
        - EndDate
	5- The following fields can be updated in an Update Transaction:
        - Status 
        - fileStatus
        - Message
	6- The following validation rules apply to End Date updates:
		- It can't be earlier than Start Date.
        - It can't be null if Status = 'Finished'
	7- The following validation rules apply to Status
		- If Status = 'Finished' then EndDate should be populated. 
        - Once Status is Finished it can't be moved back to other status.
        - When Status = 'Error' then message needs to be populated.
	8- The following rules apply to field FileStatus	
		- it could contain the following values: HDFS, HDFSError, CFormat, CFormatError, HiveT, HiveTError
		- When the following statuses are populated then field Message should be populated with error 
        message: HDFSError, CFormatError, HiveTError
 
 
****************************************************************************************************************/
        
BEGIN
  -- Declare variables to hold diagnostics area information
	DECLARE errno INT;
	DECLARE msg TEXT;
	DECLARE vCallID 	INT;  
	DECLARE vApiName VARCHAR(50);
	DECLARE vStartDate DATE;
	DECLARE vEndDate DATE;
    DECLARE vCreationDate TIMESTAMP; 
	DECLARE vModifiedDate TIMESTAMP;
	DECLARE vStatus VARCHAR(15);
	DECLARE vFileStatus VARCHAR(15);
	DECLARE vMessage VARCHAR(1500);
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN 
        GET CURRENT DIAGNOSTICS CONDITION 1
		errno = MYSQL_ERRNO, msg = MESSAGE_TEXT; 
        
        Set pSpStatus = 1;
        Set pSpMsg = concat(errno,' - ', msg);
        
        SELECT pSpMsg;
        
	END;
 
    
Set pSpStatus = 0;
 
    If pTrxType = 1 then
    
			INSERT INTO NASANW.nasaAPIcalls
				(apiName,
				StartDate,
                EndDate)
				VALUES
				(pApiName,
				pStartDate,
                pEndDate);
			
            SELECT LAST_INSERT_ID()
					into vCallID;
			
            set pCallID = vCallID;
            
	END IF;
 
    if  pTrxType = 2 then
 
		select  apiName, StartDate, EndDate, CreationDate, ModifiedDate, Status, FileStatus, Message 
		into  vApiName, vStartDate, vEndDate, vCreationDate, vModifiedDate, vStatus, vFileStatus, vMessage 
        from NASANW.nasaAPIcalls
        where CallID = pCallID;
        
    select pCallID;
    -- Rule 5 - only some fields are updated
	  If (ifnull(pStatus,'')<> '' 
				or ifnull(pFileStatus,'')<> '' 
				or ifnull(pmessage,'')<> '' ) then 
          
			UPDATE NASANW.nasaAPIcalls
				SET Status = CASE IFNULL(pStatus,'') WHEN '' THEN vStatus
							ELSE  pStatus END,
                    FileStatus = CASE IFNULL(pFileStatus,'') WHEN '' then vFileStatus
							ELSE  pFileStatus END, 
                    Message = CASE IFNULL(pMessage,'') WHEN '' THEN vMessage 
							ELSE  pMessage END,
                    ModifiedDate = CURRENT_TIMESTAMP()
			WHERE CallID = pCallID;
            

         end if;    
  
    end if;
    
    if pTrxType not in (1,2) then
		SET pSpStatus = 2;
        SET pSpMsg = 'Invalid transaction type. Valid trx types: 1 (Insert)  or 2 (Update)';
        
        SELECT pSpMsg;
        
    end if;
  
END//

DELIMITER ;
