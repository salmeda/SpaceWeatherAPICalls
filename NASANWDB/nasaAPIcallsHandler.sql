Delimiter //
CREATE PROCEDURE nasaAPIcallsHandler (
IN pTrxType TINYINT(1), -- Insert = 1, Update =2 
IN pCallID INT,
IN pApiName VARCHAR(50),
IN pStartDate DATE,
IN pEndDate DATE,
IN pStatus VARCHAR(15),
IN pFileStatus VARCHAR(15),
IN pMessage VARCHAR(1500),
OUT pSpStatus TINYINT(1),
OUT pSpMsg TEXT 
)
BEGIN
  -- Declare variables to hold diagnostics area information
	DECLARE errno INT;
	DECLARE msg TEXT;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN 
        GET CURRENT DIAGNOSTICS CONDITION 1
		errno = MYSQL_ERRNO, msg = MESSAGE_TEXT; 
        
        Set pSpStatus = 1;
        Set pSpMsg = concat(errno,' - ', msg);
        
	END;

	DECLARE EXIT HANDLER FOR pTrxType = 1 and pCallID is not null
	BEGIN 
        
        Set pSpStatus = 1;
        Set pSpMsg = 'CallID does not need to be supplied on an Insert Statement';
        
	END;
    
Set pSpStatus = 0;

    If pTrxType = 1 then
    
    else if pTrxType = 1 then
    
    else
    
    end;
END//
Delimiter;
