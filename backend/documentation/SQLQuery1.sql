DECLARE @create NVARCHAR(MAX)

DROP TABLE IF EXISTS #log;
CREATE TABLE #log
( [Id] INT IDENTITY(1,1)
, [LogTime] DATETIME2(7) DEFAULT SYSDATETIME()
, [Message] NVARCHAR(MAX)
, [IsError] BIT DEFAULT 0
)

DECLARE @dba_login_id NVARCHAR(100) = N'nv6bspd68ZRbhQym8jq8'
DECLARE @pipeline_login_id NVARCHAR(100) = N'nF4BZ4OCupoFncV5kieE'
DECLARE @app_login_id NVARCHAR(100) = N'daV1MnNqK2HfjT7XKtyJ'

DECLARE @dba_login_pw NVARCHAR(100) = N'^g|VtPP@;\YJvb$EszLlKhZWPB+!V8u,di\#R/,P?R1pC!r!XU'
DECLARE @pipeline_login_pw NVARCHAR(100) = N'jqIBUj:I/aa`;IPUY4`Nn^vUhBL#a+Rzf$0Wb\luD=S$aCb$79'
DECLARE @app_login_pw NVARCHAR(100) = N'@*@|dX\?8s^NCTp^b`fl!N%g?LM8Nt.^RTr`K+W|BF,oPax""S'

BEGIN TRY
  INSERT INTO #log([Message]) SELECT 'creating login ' + @dba_login_id
  SET @create = N'CREATE LOGIN [' + @dba_login_id + '] WITH PASSWORD=N''' + @dba_login_pw + '''';
  
  INSERT INTO #log([Message]) SELECT @create
  EXEC sp_executesql @create
END TRY
BEGIN CATCH
  IF (NOT EXISTS (SELECT TOP 1 1 WHERE ERROR_MESSAGE() LIKE 'The server principal % already exists%'))
  BEGIN
    INSERT INTO #log([Message], [IsError]) SELECT 'Error creating ' + @dba_login_id, 1
    INSERT INTO #log([Message], [IsError]) SELECT ERROR_MESSAGE(), 1
  END
END CATCH

SET @create = N''

BEGIN TRY
  INSERT INTO #log([Message]) SELECT 'creating login ' + @pipeline_login_id
  SET @create = N'CREATE LOGIN [' + @pipeline_login_id + '] WITH PASSWORD=N''' + @pipeline_login_pw + '''';
  
  INSERT INTO #log([Message]) SELECT @create
  EXEC sp_executesql @create
END TRY
BEGIN CATCH
  IF (NOT EXISTS (SELECT TOP 1 1 WHERE ERROR_MESSAGE() LIKE 'The server principal % already exists%'))
  BEGIN
    INSERT INTO #log([Message], [IsError]) SELECT 'Error creating ' + @pipeline_login_id, 1
    INSERT INTO #log([Message], [IsError]) SELECT ERROR_MESSAGE(), 1
  END
END CATCH

SET @create = N''

BEGIN TRY
  INSERT INTO #log([Message]) SELECT 'creating login ' + @app_login_id
  SET @create = N'CREATE LOGIN [' + @app_login_id + '] WITH PASSWORD=N''' + @app_login_pw + '''';
  
  INSERT INTO #log([Message]) SELECT @create
  EXEC sp_executesql @create
END TRY
BEGIN CATCH
  IF (NOT EXISTS (SELECT TOP 1 1 WHERE ERROR_MESSAGE() LIKE 'The server principal % already exists%'))
  BEGIN
    INSERT INTO #log([Message], [IsError]) SELECT 'Error creating ' + @app_login_id, 1
    INSERT INTO #log([Message], [IsError]) SELECT ERROR_MESSAGE(), 1
  END
END CATCH

SELECT * FROM #log