ALTER PROC GEN_CODE @tableName varchar(100), @prefix varchar(10), @result varchar(15) OUTPUT
AS
BEGIN
	DECLARE @counter int
	SELECT @counter = [COUNTER] FROM HELPER_GEN_CODE WHERE [TABLE_NAME] = @tableName

	IF(@counter IS NULL)
		INSERT INTO HELPER_GEN_CODE VALUES (@tableName, 1)
	
	--GEN MÃ LUÔN RA 15 KÝ TỰ
	SET @result = @prefix + right('00000000000000' + convert(varchar(15), @counter), 15 - len(@prefix))

	SET @counter = @counter + 1

	UPDATE HELPER_GEN_CODE SET [COUNTER] = @counter WHERE [TABLE_NAME] = @tableName

END