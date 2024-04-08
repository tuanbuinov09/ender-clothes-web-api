USE [master]
GO
/****** Object:  Database [CLOTHING_STORE]    Script Date: 19/01/2024 11:16:33 pm ******/
CREATE DATABASE [CLOTHING_STORE]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CLOTHING_STORE', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\CLOTHING_STORE.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'CLOTHING_STORE_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\CLOTHING_STORE_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [CLOTHING_STORE] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CLOTHING_STORE].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CLOTHING_STORE] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CLOTHING_STORE] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CLOTHING_STORE] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CLOTHING_STORE] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CLOTHING_STORE] SET ARITHABORT OFF 
GO
ALTER DATABASE [CLOTHING_STORE] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CLOTHING_STORE] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CLOTHING_STORE] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CLOTHING_STORE] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CLOTHING_STORE] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CLOTHING_STORE] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CLOTHING_STORE] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CLOTHING_STORE] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CLOTHING_STORE] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CLOTHING_STORE] SET  DISABLE_BROKER 
GO
ALTER DATABASE [CLOTHING_STORE] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CLOTHING_STORE] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CLOTHING_STORE] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CLOTHING_STORE] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CLOTHING_STORE] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CLOTHING_STORE] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CLOTHING_STORE] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CLOTHING_STORE] SET RECOVERY FULL 
GO
ALTER DATABASE [CLOTHING_STORE] SET  MULTI_USER 
GO
ALTER DATABASE [CLOTHING_STORE] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CLOTHING_STORE] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CLOTHING_STORE] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CLOTHING_STORE] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [CLOTHING_STORE] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [CLOTHING_STORE] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'CLOTHING_STORE', N'ON'
GO
ALTER DATABASE [CLOTHING_STORE] SET QUERY_STORE = OFF
GO
USE [CLOTHING_STORE]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_diagramobjects]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE   FUNCTION [dbo].[fn_diagramobjects]() 
	RETURNS int
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		declare @id_upgraddiagrams		int
		declare @id_sysdiagrams			int
		declare @id_helpdiagrams		int
		declare @id_helpdiagramdefinition	int
		declare @id_creatediagram	int
		declare @id_renamediagram	int
		declare @id_alterdiagram 	int 
		declare @id_dropdiagram		int
		declare @InstalledObjects	int

		select @InstalledObjects = 0

		select 	@id_upgraddiagrams = object_id(N'dbo.sp_upgraddiagrams'),
			@id_sysdiagrams = object_id(N'dbo.sysdiagrams'),
			@id_helpdiagrams = object_id(N'dbo.sp_helpdiagrams'),
			@id_helpdiagramdefinition = object_id(N'dbo.sp_helpdiagramdefinition'),
			@id_creatediagram = object_id(N'dbo.sp_creatediagram'),
			@id_renamediagram = object_id(N'dbo.sp_renamediagram'),
			@id_alterdiagram = object_id(N'dbo.sp_alterdiagram'), 
			@id_dropdiagram = object_id(N'dbo.sp_dropdiagram')

		if @id_upgraddiagrams is not null
			select @InstalledObjects = @InstalledObjects + 1
		if @id_sysdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 2
		if @id_helpdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 4
		if @id_helpdiagramdefinition is not null
			select @InstalledObjects = @InstalledObjects + 8
		if @id_creatediagram is not null
			select @InstalledObjects = @InstalledObjects + 16
		if @id_renamediagram is not null
			select @InstalledObjects = @InstalledObjects + 32
		if @id_alterdiagram  is not null
			select @InstalledObjects = @InstalledObjects + 64
		if @id_dropdiagram is not null
			select @InstalledObjects = @InstalledObjects + 128
		
		return @InstalledObjects 
	END
	
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_KiemTraDotKhuyenMaiDangKhuyenMai]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[UDF_KiemTraDotKhuyenMaiDangKhuyenMai] (@MA_KM VARCHAR(15)) 
    RETURNS INT
AS
    BEGIN 
	DECLARE @ngayBatDau DATETIME
	DECLARE @ngayKetThuc DATETIME
	DECLARE @ngayHienTai DATETIME = GETDATE()
		IF EXISTS(SELECT * FROM dbo.KHUYEN_MAI WHERE MA_KM=@MA_KM AND TRANG_THAI = 1)
		BEGIN
			SELECT @ngayBatDau = NGAY_AP_DUNG, @ngayKetThuc=DATEADD(DAY, THOI_GIAN, @ngayBatDau) FROM dbo.KHUYEN_MAI WHERE MA_KM=@MA_KM
			IF(@ngayHienTai>@ngayBatDau AND @ngayHienTai<=@ngayKetThuc)
				RETURN 1
			ELSE
				RETURN 0
		END
	RETURN 0
	END 

--SELECT dbo.UDF_KiemTraDotKhuyenMaiDangKhuyenMai('KM0001')
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LayGiaCuaChiTietSP]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[UDF_LayGiaCuaChiTietSP]
(
    @MA_CT_SP INT
)
RETURNS INT
AS
BEGIN
    DECLARE @result INT = 0;
   
        SET @result =
        (
            SELECT TOP (1)
                   TDG.GIA
            FROM dbo.THAY_DOI_GIA TDG
            WHERE TDG.MA_CT_SP = @MA_CT_SP
            ORDER BY TDG.NGAY_THAY_DOI DESC
        );
    RETURN @result;
END;

--SELECT dbo.[UDF_LayGiaNhoNhatCuaSizeTrongThayDoiGiaCuaSanPham] ('SP0000000000001')
--SELECT dbo.[UDF_LayGiaLonNhatCuaSizeTrongThayDoiGiaCuaSanPham] ('SP0000000000001')
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LayGiaLonNhatTrongThayDoiGiaCuaSanPham]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[UDF_LayGiaLonNhatTrongThayDoiGiaCuaSanPham]
(
    @MA_SP VARCHAR(15)
)
RETURNS INT
AS
BEGIN
    DECLARE @result INT = 0;
    DECLARE @temp INT = 0;

    DECLARE @MA_CT_SP INT;

    DECLARE cursorMaCTSP CURSOR FOR -- khai báo con trỏ cursorMaCTSP
    SELECT CTSP.MA_CT_SP
    FROM
    (
        SELECT CTSP.MA_CT_SP
        FROM
        (SELECT SP.MA_SP FROM dbo.SAN_PHAM SP WHERE SP.MA_SP = @MA_SP) SP
            INNER JOIN dbo.CHI_TIET_SAN_PHAM CTSP
                ON CTSP.MA_SP = SP.MA_SP
    ) CTSP; -- dữ liệu trỏ tới
    OPEN cursorMaCTSP; -- Mở con trỏ

    FETCH NEXT FROM cursorMaCTSP -- Đọc dòng đầu tiên
    INTO @MA_CT_SP;

    IF (@@FETCH_STATUS = 0)
        SET @result =
    (
        SELECT TOP (1)
               TDG.GIA
        FROM dbo.THAY_DOI_GIA TDG
        WHERE TDG.MA_CT_SP = @MA_CT_SP
        ORDER BY TDG.NGAY_THAY_DOI DESC
    )   ;
    WHILE @@FETCH_STATUS = 0 --vòng lặp WHILE khi đọc Cursor thành công
    BEGIN

        SET @temp =
        (
            SELECT TOP (1)
                   TDG.GIA
            FROM dbo.THAY_DOI_GIA TDG
            WHERE TDG.MA_CT_SP = @MA_CT_SP
            ORDER BY TDG.NGAY_THAY_DOI DESC
        );
        IF (@result < @temp)
            SET @result = @temp;

        FETCH NEXT FROM cursorMaCTSP -- Đọc dòng tiếp
        INTO @MA_CT_SP;
    END;

    CLOSE cursorMaCTSP; -- Đóng Cursor
    DEALLOCATE cursorMaCTSP; -- Giải phóng tài nguyên
    RETURN @result;
END;

--SELECT dbo.[UDF_LayTongSoLuongTonCuaMotSP] ('SP0000000000001')
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LayGiaNhoNhatDaGiamGiaTrongThayDoiGiaCuaSanPham]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[UDF_LayGiaNhoNhatDaGiamGiaTrongThayDoiGiaCuaSanPham]
(
    @MA_SP VARCHAR(15)
)
RETURNS INT
AS
BEGIN
    DECLARE @result INT = 0;
    DECLARE @temp INT = 0;
    DECLARE @MA_CT_SP INT;
	DECLARE @MA_KM VARCHAR(15)
		IF EXISTS(SELECT * FROM dbo.CHI_TIET_KHUYEN_MAI WHERE MA_SP = @MA_SP AND dbo.UDF_KiemTraDotKhuyenMaiDangKhuyenMai(MA_KM) = 1)
		BEGIN
			SET @MA_KM = (SELECT MA_KM FROM dbo.CHI_TIET_KHUYEN_MAI WHERE MA_SP = @MA_SP AND dbo.UDF_KiemTraDotKhuyenMaiDangKhuyenMai(MA_KM) = 1)
		END

    DECLARE cursorMaCTSP CURSOR FOR -- khai báo con trỏ cursorMaCTSP
    SELECT CTSP.MA_CT_SP
    FROM
    (
        SELECT CTSP.MA_CT_SP
        FROM
        (SELECT SP.MA_SP FROM dbo.SAN_PHAM SP WHERE SP.MA_SP = @MA_SP) SP
            INNER JOIN dbo.CHI_TIET_SAN_PHAM CTSP
                ON CTSP.MA_SP = SP.MA_SP
    ) CTSP; -- dữ liệu trỏ tới
    OPEN cursorMaCTSP; -- Mở con trỏ

    FETCH NEXT FROM cursorMaCTSP -- Đọc dòng đầu tiên

    INTO @MA_CT_SP;
    --init result đầu tiên, vì nếu không thì khi vào while temp đều lớn hơn 0, nên result luôn = 0
    IF (@@FETCH_STATUS = 0)
        SET @result =
    (
        SELECT TOP (1)
               TDG.GIA
        FROM dbo.THAY_DOI_GIA TDG
        WHERE TDG.MA_CT_SP = @MA_CT_SP
        ORDER BY TDG.NGAY_THAY_DOI DESC
    )   ;

    WHILE @@FETCH_STATUS = 0 --vòng lặp WHILE khi đọc Cursor thành công
    BEGIN
        SET @temp =
        (
            SELECT TOP (1)
                   TDG.GIA
            FROM dbo.THAY_DOI_GIA TDG
            WHERE TDG.MA_CT_SP = @MA_CT_SP
            ORDER BY TDG.NGAY_THAY_DOI DESC
        );
        IF (@result > @temp)
            SET @result = @temp;

        FETCH NEXT FROM cursorMaCTSP -- Đọc dòng tiếp
        INTO @MA_CT_SP;
    END;

    CLOSE cursorMaCTSP; -- Đóng Cursor
    DEALLOCATE cursorMaCTSP; -- Giải phóng tài nguyên

	IF(dbo.UDF_KiemTraDotKhuyenMaiDangKhuyenMai(@MA_KM)=1)
			BEGIN
				DECLARE @phanTramGiam int = 0; 
				SET @phanTramGiam = (SELECT PHAN_TRAM_GIAM FROM dbo.CHI_TIET_KHUYEN_MAI WHERE MA_SP = @MA_SP AND MA_KM = @MA_KM)
				SET @result = @result - @result * @phanTramGiam/100
			END
    RETURN @result;
END;

--SELECT dbo.[UDF_LayGiaNhoNhatDaGiamGiaTrongThayDoiGiaCuaSanPham] ('SP0000000000001')

GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LayGiaNhoNhatTrongThayDoiGiaCuaSanPham]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[UDF_LayGiaNhoNhatTrongThayDoiGiaCuaSanPham]
(
    @MA_SP VARCHAR(15)
)
RETURNS INT
AS
BEGIN
    DECLARE @result INT = 0;
    DECLARE @temp INT = 0;
    DECLARE @MA_CT_SP INT;

    DECLARE cursorMaCTSP CURSOR FOR -- khai báo con trỏ cursorMaCTSP
    SELECT CTSP.MA_CT_SP
    FROM
    (
        SELECT CTSP.MA_CT_SP
        FROM
        (SELECT SP.MA_SP FROM dbo.SAN_PHAM SP WHERE SP.MA_SP = @MA_SP) SP
            INNER JOIN dbo.CHI_TIET_SAN_PHAM CTSP
                ON CTSP.MA_SP = SP.MA_SP
    ) CTSP; -- dữ liệu trỏ tới
    OPEN cursorMaCTSP; -- Mở con trỏ

    FETCH NEXT FROM cursorMaCTSP -- Đọc dòng đầu tiên

    INTO @MA_CT_SP;
    --init result đầu tiên, vì nếu không thì khi vào while temp đều lớn hơn 0, nên result luôn = 0
    IF (@@FETCH_STATUS = 0)
        SET @result =
    (
        SELECT TOP (1)
               TDG.GIA
        FROM dbo.THAY_DOI_GIA TDG
        WHERE TDG.MA_CT_SP = @MA_CT_SP
        ORDER BY TDG.NGAY_THAY_DOI DESC
    )   ;

    WHILE @@FETCH_STATUS = 0 --vòng lặp WHILE khi đọc Cursor thành công
    BEGIN
        SET @temp =
        (
            SELECT TOP (1)
                   TDG.GIA
            FROM dbo.THAY_DOI_GIA TDG
            WHERE TDG.MA_CT_SP = @MA_CT_SP
            ORDER BY TDG.NGAY_THAY_DOI DESC
        );
        IF (@result > @temp)
            SET @result = @temp;

        FETCH NEXT FROM cursorMaCTSP -- Đọc dòng tiếp
        INTO @MA_CT_SP;
    END;

    CLOSE cursorMaCTSP; -- Đóng Cursor
    DEALLOCATE cursorMaCTSP; -- Giải phóng tài nguyên
    RETURN @result;
END;

--SELECT dbo.[UDF_LayGiaNhoNhatCuaSizeTrongThayDoiGiaCuaSanPham] ('SP0000000000001')
--SELECT dbo.[UDF_LayGiaLonNhatCuaSizeTrongThayDoiGiaCuaSanPham] ('SP0000000000001')
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LayMaCacSPTrongDotKM]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[UDF_LayMaCacSPTrongDotKM] (@MA_KM varchar(15)) 
    RETURNS NVARCHAR(MAX)
AS
    BEGIN 
	DECLARE @RETURN_VAL NVARCHAR(MAX) = 'start'
		IF EXISTS(SELECT * FROM dbo.CHI_TIET_KHUYEN_MAI WHERE MA_KM = @MA_KM)
		BEGIN
			SELECT @RETURN_VAL = COALESCE(@RETURN_VAL + ', ', '') + SP.MA_SP  FROM (SELECT * FROM CHI_TIET_KHUYEN_MAI WHERE MA_KM = @MA_KM 
			--offset 0 rows vì order by k dùng đc trong subquery
			ORDER BY MA_SP DESC OFFSET 0 ROWS) SP
			SET @RETURN_VAL = REPLACE(@RETURN_VAL, 'start, ', '')
			RETURN @RETURN_VAL
		END
			RETURN @RETURN_VAL
	END 

	--SELECT dbo.[UDF_LayMaCacSPTrongDotKM]('KM0000000000001')
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LayMaCacSPTrongPN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[UDF_LayMaCacSPTrongPN] (@MA_PN varchar(15)) 
    RETURNS NVARCHAR(MAX)
AS
    BEGIN 
	DECLARE @RETURN_VAL NVARCHAR(MAX) = 'start'
		IF EXISTS(SELECT * FROM dbo.CHI_TIET_PHIEU_NHAP WHERE MA_PN = @MA_PN)
		BEGIN
			SELECT @RETURN_VAL = COALESCE(@RETURN_VAL + ', ', '') + SP.MA_SP FROM 
			(SELECT DISTINCT SP.MA_SP FROM CHI_TIET_PHIEU_NHAP ctpn 
			INNER JOIN CHI_TIET_SAN_PHAM ctsp ON ctpn.MA_CT_SP = ctsp.MA_CT_SP 
			INNER JOIN SAN_PHAM sp ON ctsp.MA_SP = sp.MA_SP  WHERE MA_PN = @MA_PN 
			--offset 0 rows vì order by k dùng đc trong subquery
			ORDER BY sp.MA_SP DESC OFFSET 0 ROWS) SP
			SET @RETURN_VAL = REPLACE(@RETURN_VAL, 'start, ', '')
			RETURN @RETURN_VAL
		END
			RETURN @RETURN_VAL
	END 

	--SELECT dbo.[UDF_LayMaCacSPTrongPN]('PN0000000000024')
	--SELECT * FROM PHIEU_NHAP

	--SELECT DISTINCT TOP (100000) SP.MA_SP FROM CHI_TIET_PHIEU_NHAP ctpn INNER JOIN CHI_TIET_SAN_PHAM ctsp ON ctpn.MA_CT_SP = ctsp.MA_CT_SP INNER JOIN SAN_PHAM sp ON ctsp.MA_SP = sp.MA_SP  WHERE MA_PN = 'PN0000000000024' ORDER BY sp.MA_SP DESC
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LaySoDonNhanVienDangGiao]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[UDF_LaySoDonNhanVienDangGiao]
(
    @MA_NV VARCHAR(15)
)
RETURNS INT
AS
BEGIN
    DECLARE @RETURN_VAL INT = -1;

    --trạng thái 1: đang giao
    SET @RETURN_VAL =
    (
        SELECT COUNT(*)
        FROM dbo.DON_HANG
        WHERE MA_NV_GIAO = @MA_NV
              AND TRANG_THAI = 1
    );
    RETURN @RETURN_VAL;
END;

--SELECT dbo.UDF_LayStringSize('SP0000000000001')
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LaySoLuongBanCuaSanPhamTheoKhoangNgay]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[UDF_LaySoLuongBanCuaSanPhamTheoKhoangNgay] (@MA_SP varchar(15), @NGAY DATETIME, @NGAY2 DATETIME) 
    RETURNS INT
AS
    BEGIN 
	DECLARE @RETURN_VAL INT = 0
	DECLARE @PRICE INT = 0
	DECLARE @QUANTITY INT = 0
		IF EXISTS(SELECT * FROM dbo.CHI_TIET_DON_HANG INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_DON_HANG.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP INNER JOIN DON_HANG ON DON_HANG.ID_DH = CHI_TIET_DON_HANG.ID_DH WHERE MA_SP = @MA_SP AND TRANG_THAI <> -1 and TRANG_THAI <> -99 AND NGAY_TAO BETWEEN @NGAY AND DATEADD(DAY,1,@NGAY2))
		BEGIN
			SELECT @PRICE = SUM(CHI_TIET_DON_HANG.GIA * CHI_TIET_DON_HANG.SO_LUONG), @QUANTITY = SUM(CHI_TIET_DON_HANG.SO_LUONG)
			FROM dbo.CHI_TIET_DON_HANG INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_DON_HANG.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP INNER JOIN DON_HANG ON DON_HANG.ID_DH = CHI_TIET_DON_HANG.ID_DH WHERE MA_SP = @MA_SP AND TRANG_THAI <> -1 and TRANG_THAI <> -99 AND NGAY_TAO BETWEEN @NGAY AND DATEADD(DAY,1,@NGAY2)
			
			SET @RETURN_VAL = ISNULL(@QUANTITY, 0)
			RETURN @RETURN_VAL
		END
			RETURN @RETURN_VAL
	END 

	--SELECT dbo.[UDF_LaySoLuongBanCuaSanPhamTheoKhoangNgay]('SP0000000000014', '2022-12-23','12/26/2022')

	--SELECT * 
		--	FROM dbo.CHI_TIET_PHIEU_NHAP INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_PHIEU_NHAP.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP WHERE MA_SP = 'SP0000000000023'
	
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LaySoLuongBanCuaSanPhamTheoNam]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[UDF_LaySoLuongBanCuaSanPhamTheoNam] (@MA_SP varchar(15), @NAM DATETIME) 
    RETURNS INT
AS
    BEGIN 
	DECLARE @RETURN_VAL INT = 0
	DECLARE @PRICE INT = 0
	DECLARE @QUANTITY INT = 0
		IF EXISTS(SELECT * FROM dbo.CHI_TIET_DON_HANG INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_DON_HANG.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP INNER JOIN DON_HANG ON DON_HANG.ID_DH = CHI_TIET_DON_HANG.ID_DH WHERE MA_SP = @MA_SP AND TRANG_THAI <> -1 and TRANG_THAI <> -99 AND FORMAT(@NAM, 'yyyy') = FORMAT(NGAY_TAO, 'yyyy'))
		BEGIN
			SELECT @PRICE = SUM(CHI_TIET_DON_HANG.GIA * CHI_TIET_DON_HANG.SO_LUONG), @QUANTITY = SUM(CHI_TIET_DON_HANG.SO_LUONG)
			FROM dbo.CHI_TIET_DON_HANG INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_DON_HANG.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP INNER JOIN DON_HANG ON DON_HANG.ID_DH = CHI_TIET_DON_HANG.ID_DH WHERE MA_SP = @MA_SP AND TRANG_THAI <> -1 and TRANG_THAI <> -99 AND FORMAT(@NAM, 'yyyy') = FORMAT(NGAY_TAO, 'yyyy')
			
			SET @RETURN_VAL = ISNULL(@QUANTITY, 0)
			RETURN @RETURN_VAL
		END
			RETURN @RETURN_VAL
	END 

	--SELECT dbo.[UDF_LayTrungBinhGiaBanCuaSanPhamTheoThang]('SP0000000000028', '2022-12-23')

	--SELECT * 
		--	FROM dbo.CHI_TIET_PHIEU_NHAP INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_PHIEU_NHAP.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP WHERE MA_SP = 'SP0000000000023'
	
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LaySoLuongBanCuaSanPhamTheoNgay]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[UDF_LaySoLuongBanCuaSanPhamTheoNgay] (@MA_SP varchar(15), @NGAY DATETIME) 
    RETURNS INT
AS
    BEGIN 
	DECLARE @RETURN_VAL INT = 0
	DECLARE @PRICE INT = 0
	DECLARE @QUANTITY INT = 0
		IF EXISTS(SELECT * FROM dbo.CHI_TIET_DON_HANG INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_DON_HANG.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP INNER JOIN DON_HANG ON DON_HANG.ID_DH = CHI_TIET_DON_HANG.ID_DH WHERE MA_SP = @MA_SP AND TRANG_THAI <> -1 and TRANG_THAI <> -99 AND FORMAT(@NGAY, 'dd/MM/yyyy') = FORMAT(NGAY_TAO, 'dd/MM/yyyy'))
		BEGIN
			SELECT @PRICE = SUM(CHI_TIET_DON_HANG.GIA * CHI_TIET_DON_HANG.SO_LUONG), @QUANTITY = SUM(CHI_TIET_DON_HANG.SO_LUONG)
			FROM dbo.CHI_TIET_DON_HANG INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_DON_HANG.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP INNER JOIN DON_HANG ON DON_HANG.ID_DH = CHI_TIET_DON_HANG.ID_DH WHERE MA_SP = @MA_SP AND TRANG_THAI <> -1 and TRANG_THAI <> -99 AND FORMAT(@NGAY, 'dd/MM/yyyy') = FORMAT(NGAY_TAO, 'dd/MM/yyyy')
			
			SET @RETURN_VAL = ISNULL(@QUANTITY, 0)
			RETURN @RETURN_VAL
		END
			RETURN @RETURN_VAL
	END 

	--SELECT dbo.[UDF_LayTrungBinhGiaBanCuaSanPhamTheoNgay]('SP0000000000023', getDate())

	--SELECT * 
		--	FROM dbo.CHI_TIET_PHIEU_NHAP INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_PHIEU_NHAP.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP WHERE MA_SP = 'SP0000000000023'
	
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LaySoLuongBanCuaSanPhamTheoThang]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[UDF_LaySoLuongBanCuaSanPhamTheoThang] (@MA_SP varchar(15), @THANG DATETIME) 
    RETURNS INT
AS
    BEGIN 
	DECLARE @RETURN_VAL INT = 0
	DECLARE @PRICE INT = 0
	DECLARE @QUANTITY INT = 0
		IF EXISTS(SELECT * FROM dbo.CHI_TIET_DON_HANG INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_DON_HANG.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP INNER JOIN DON_HANG ON DON_HANG.ID_DH = CHI_TIET_DON_HANG.ID_DH WHERE MA_SP = @MA_SP AND TRANG_THAI <> -1 and TRANG_THAI <> -99 AND FORMAT(@THANG, 'MM/yyyy') = FORMAT(NGAY_TAO, 'MM/yyyy'))
		BEGIN
			SELECT @PRICE = SUM(CHI_TIET_DON_HANG.GIA * CHI_TIET_DON_HANG.SO_LUONG), @QUANTITY = SUM(CHI_TIET_DON_HANG.SO_LUONG)
			FROM dbo.CHI_TIET_DON_HANG INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_DON_HANG.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP INNER JOIN DON_HANG ON DON_HANG.ID_DH = CHI_TIET_DON_HANG.ID_DH WHERE MA_SP = @MA_SP AND TRANG_THAI <> -1 and TRANG_THAI <> -99 AND FORMAT(@THANG, 'MM/yyyy') = FORMAT(NGAY_TAO, 'MM/yyyy')
			
			SET @RETURN_VAL = ISNULL(@QUANTITY, 0)
			RETURN @RETURN_VAL
		END
			RETURN @RETURN_VAL
	END 

	--SELECT dbo.[UDF_LayTrungBinhGiaBanCuaSanPhamTheoNgay]('SP0000000000033', '2022-12-23')

	--SELECT * 
		--	FROM dbo.CHI_TIET_PHIEU_NHAP INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_PHIEU_NHAP.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP WHERE MA_SP = 'SP0000000000023'
	
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LayStringGia]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[UDF_LayStringGia] (@MA_SP VARCHAR(15)) 
    RETURNS VARCHAR(50)
AS
    BEGIN 
	DECLARE @RETURN_VAL VARCHAR(50) = ''
		DECLARE @giaSizeNhoNhat INT
        DECLARE @giaSizeLonNhat INT
		IF EXISTS(SELECT * FROM dbo.CHI_TIET_SAN_PHAM WHERE MA_SP = @MA_SP)
		BEGIN
			SET @giaSizeNhoNhat = dbo.[UDF_LayGiaNhoNhatTrongThayDoiGiaCuaSanPham](@MA_SP)
			SET @giaSizeLonNhat = dbo.[UDF_LayGiaLonNhatTrongThayDoiGiaCuaSanPham](@MA_SP)
			--RETURN CONCAT(@giaSizeNhoNhat+'', '-', @giaSizeLonNhat+'')
			IF(@giaSizeNhoNhat=@giaSizeLonNhat) -- trường hợp sp chỉ có 1 size
					BEGIN
						SET @RETURN_VAL = CAST(@giaSizeNhoNhat AS VARCHAR(20))
						RETURN @RETURN_VAL
					END
			
			SET @RETURN_VAL = CONCAT(CAST(@giaSizeNhoNhat AS VARCHAR(20)),' - ',CAST(@giaSizeLonNhat AS  VARCHAR(20)))
			RETURN @RETURN_VAL
		END
			RETURN @RETURN_VAL
	END 
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LayStringGiaDaGiam]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[UDF_LayStringGiaDaGiam] (@MA_SP VARCHAR(15)) 
    RETURNS VARCHAR(50)
AS
    BEGIN 
	DECLARE @RETURN_VAL VARCHAR(50) = ''
		DECLARE @giaSizeNhoNhat INT
        DECLARE @giaSizeLonNhat INT
		DECLARE @phanTramGiam SMALLINT
		DECLARE @MA_KM VARCHAR(15)
		IF EXISTS(SELECT * FROM dbo.CHI_TIET_KHUYEN_MAI ctkm INNER JOIN KHUYEN_MAI km ON ctkm.MA_KM = km.MA_KM WHERE MA_SP = @MA_SP AND [dbo].[UDF_KiemTraDotKhuyenMaiDangKhuyenMai](km.MA_KM) = 1)
		BEGIN
			SET @MA_KM = (SELECT km.MA_KM FROM dbo.CHI_TIET_KHUYEN_MAI ctkm INNER JOIN KHUYEN_MAI km ON ctkm.MA_KM = km.MA_KM  WHERE MA_SP = @MA_SP AND [dbo].[UDF_KiemTraDotKhuyenMaiDangKhuyenMai](km.MA_KM) = 1)
			IF(dbo.UDF_KiemTraDotKhuyenMaiDangKhuyenMai(@MA_KM)=1)
			BEGIN
				SET @phanTramGiam = (SELECT PHAN_TRAM_GIAM FROM dbo.CHI_TIET_KHUYEN_MAI WHERE MA_SP = @MA_SP AND MA_KM = @MA_KM)
				IF EXISTS(SELECT * FROM dbo.CHI_TIET_SAN_PHAM WHERE MA_SP = @MA_SP)
				BEGIN
					SET @giaSizeNhoNhat = dbo.[UDF_LayGiaNhoNhatTrongThayDoiGiaCuaSanPham](@MA_SP)
					SET @giaSizeLonNhat = dbo.[UDF_LayGiaLonNhatTrongThayDoiGiaCuaSanPham](@MA_SP)

					SET @giaSizeNhoNhat = @giaSizeNhoNhat - @giaSizeNhoNhat*@phanTramGiam/100
					SET @giaSizeLonNhat = @giaSizeLonNhat - @giaSizeLonNhat*@phanTramGiam/100
					--RETURN CONCAT(@giaSizeNhoNhat+'', '-', @giaSizeLonNhat+'')
					IF(@giaSizeNhoNhat=@giaSizeLonNhat) -- trường hợp sp chỉ có 1 size
					BEGIN
						SET @RETURN_VAL = CAST(@giaSizeNhoNhat AS VARCHAR(20))
						RETURN @RETURN_VAL
					END
					SET @RETURN_VAL = CONCAT(CAST(@giaSizeNhoNhat AS VARCHAR(20)),' - ',CAST(@giaSizeLonNhat AS  VARCHAR(20)))
					RETURN @RETURN_VAL
				END
					
			END

			RETURN @RETURN_VAL
		END
		RETURN @RETURN_VAL
	END 
	--SELECT [dbo].[UDF_LayStringGiaDaGiam]('SP0000000000017')

	--SELECT km.MA_KM FROM dbo.CHI_TIET_KHUYEN_MAI ctkm INNER JOIN KHUYEN_MAI km ON ctkm.MA_KM = km.MA_KM  WHERE MA_SP = 'SP0000000000017' AND [dbo].[UDF_KiemTraDotKhuyenMaiDangKhuyenMai](km.MA_KM) = 1
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LayStringSize]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[UDF_LayStringSize] (@MA_SP VARCHAR(15)) 
    RETURNS NVARCHAR(MAX)
AS
    BEGIN 
	DECLARE @RETURN_VAL NVARCHAR(MAX) = ''
	DECLARE @RETURN_COLOR INT = 0	
		IF EXISTS(SELECT * FROM dbo.CHI_TIET_SAN_PHAM WHERE MA_SP = @MA_SP)
		BEGIN
			SELECT @RETURN_VAL = COALESCE(@RETURN_VAL + ', ', '') + S.TEN_SIZE  FROM (SELECT DISTINCT BANG_SIZE.MA_SIZE, TEN_SIZE FROM dbo.CHI_TIET_SAN_PHAM INNER JOIN dbo.BANG_SIZE ON BANG_SIZE.MA_SIZE = CHI_TIET_SAN_PHAM.MA_SIZE WHERE MA_SP = @MA_SP) AS S
			SELECT @RETURN_COLOR = COUNT (*) FROM (SELECT DISTINCT BANG_MAU.MA_MAU, TEN_MAU FROM dbo.CHI_TIET_SAN_PHAM INNER JOIN dbo.BANG_MAU ON BANG_MAU.MA_MAU = CHI_TIET_SAN_PHAM.MA_MAU WHERE MA_SP = @MA_SP) AS M

			RETURN @RETURN_VAL + '; ' + CAST(@RETURN_COLOR AS VARCHAR(50)) + N' màu'
		END
			RETURN @RETURN_VAL
	END 

	--SELECT dbo.UDF_LayStringSize('SP0000000000001')
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LayTenCacSPTrongPN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[UDF_LayTenCacSPTrongPN] (@MA_PN varchar(15)) 
    RETURNS NVARCHAR(MAX)
AS
    BEGIN 
	DECLARE @RETURN_VAL NVARCHAR(MAX) = 'start'
		IF EXISTS(SELECT * FROM dbo.CHI_TIET_PHIEU_NHAP WHERE MA_PN = @MA_PN)
		BEGIN
			SELECT @RETURN_VAL = COALESCE(@RETURN_VAL + ', ', '') + SP.TEN_SP FROM 
				(SELECT DISTINCT SP.TEN_SP, SP.MA_SP FROM CHI_TIET_PHIEU_NHAP ctpn 
				INNER JOIN CHI_TIET_SAN_PHAM ctsp ON ctpn.MA_CT_SP = ctsp.MA_CT_SP 
				INNER JOIN SAN_PHAM sp ON ctsp.MA_SP = sp.MA_SP  WHERE MA_PN = @MA_PN 
				--offset 0 rows vì order by k dùng đc trong subquery
				ORDER BY sp.MA_SP DESC OFFSET 0 ROWS) SP
			SET @RETURN_VAL = REPLACE(@RETURN_VAL, 'start, ', '')
			RETURN @RETURN_VAL
		END
			RETURN @RETURN_VAL
	END 

	--SELECT dbo.[UDF_LayTenCacSPTrongPN]('PN0000000000024')
	--SELECT * FROM PHIEU_NHAP
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LayTongSoDanhGiaCuaSanPham]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[UDF_LayTongSoDanhGiaCuaSanPham] (@MA_SP VARCHAR(15)) 
    RETURNS INT
AS
    BEGIN 
	DECLARE @count INT = 0;
		SELECT @count = COUNT(*) FROM dbo.DANH_GIA_SAN_PHAM dgsp INNER JOIN CHI_TIET_DON_HANG ctgh
			ON dgsp.MA_CT_DH = ctgh.MA_CT_DH INNER JOIN CHI_TIET_SAN_PHAM ctsp ON ctgh.MA_CT_SP = ctsp.MA_CT_SP
		WHERE ctsp.MA_SP=@MA_SP
	RETURN @count
	END 

--SELECT dbo.[UDF_LayTongSoDanhGiaCuaSanPham] ('SP0000000000023')
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LayTongSoLuongTonCuaMotSP]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[UDF_LayTongSoLuongTonCuaMotSP] (@MA_SP VARCHAR(15)) 
    RETURNS INT
AS
    BEGIN 
	DECLARE @sum INT = 0;
		SELECT @sum = SUM(SL_TON) FROM dbo.CHI_TIET_SAN_PHAM WHERE dbo.CHI_TIET_SAN_PHAM.MA_SP=@MA_SP
	RETURN @sum
	END 

--SELECT dbo.[UDF_LayTongSoLuongTonCuaMotSP] ('SP0000000000001')
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LayTrungBinhGiaBanCuaSanPhamTheoKhoangNgay]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[UDF_LayTrungBinhGiaBanCuaSanPhamTheoKhoangNgay] (@MA_SP varchar(15), @NGAY DATETIME, @NGAY2 DATETIME) 
    RETURNS INT
AS
    BEGIN 
	DECLARE @RETURN_VAL INT = 0
	DECLARE @PRICE INT = 0
	DECLARE @QUANTITY INT = 0
		IF EXISTS(SELECT * FROM dbo.CHI_TIET_DON_HANG INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_DON_HANG.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP INNER JOIN DON_HANG ON DON_HANG.ID_DH = CHI_TIET_DON_HANG.ID_DH WHERE MA_SP = @MA_SP AND TRANG_THAI <> -1 and TRANG_THAI <> -99 AND NGAY_TAO BETWEEN @NGAY AND DATEADD(DAY,1,@NGAY2))
		BEGIN
			SELECT @PRICE = SUM(CHI_TIET_DON_HANG.GIA * CHI_TIET_DON_HANG.SO_LUONG), @QUANTITY = SUM(CHI_TIET_DON_HANG.SO_LUONG)
			FROM dbo.CHI_TIET_DON_HANG INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_DON_HANG.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP INNER JOIN DON_HANG ON DON_HANG.ID_DH = CHI_TIET_DON_HANG.ID_DH WHERE MA_SP = @MA_SP AND TRANG_THAI <> -1 and TRANG_THAI <> -99 AND NGAY_TAO BETWEEN @NGAY AND DATEADD(DAY,1,@NGAY2)
			
			SET @RETURN_VAL = ISNULL(@PRICE/@QUANTITY, 0)
			RETURN @RETURN_VAL
		END
			RETURN @RETURN_VAL
	END 

	--SELECT dbo.[UDF_LayTrungBinhGiaBanCuaSanPhamTheoNgay]('SP0000000000023', getDate())

	--SELECT * 
		--	FROM dbo.CHI_TIET_PHIEU_NHAP INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_PHIEU_NHAP.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP WHERE MA_SP = 'SP0000000000023'
	
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LayTrungBinhGiaBanCuaSanPhamTheoNam]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[UDF_LayTrungBinhGiaBanCuaSanPhamTheoNam] (@MA_SP varchar(15), @NAM DATETIME) 
    RETURNS INT
AS
    BEGIN 
	DECLARE @RETURN_VAL INT = 0
	DECLARE @PRICE INT = 0
	DECLARE @QUANTITY INT = 0
		IF EXISTS(SELECT * FROM dbo.CHI_TIET_DON_HANG INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_DON_HANG.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP INNER JOIN DON_HANG ON DON_HANG.ID_DH = CHI_TIET_DON_HANG.ID_DH WHERE MA_SP = @MA_SP AND TRANG_THAI <> -1 and TRANG_THAI <> -99 AND FORMAT(@NAM, 'yyyy') = FORMAT(NGAY_TAO, 'yyyy'))
		BEGIN
			SELECT @PRICE = SUM(CHI_TIET_DON_HANG.GIA * CHI_TIET_DON_HANG.SO_LUONG), @QUANTITY = SUM(CHI_TIET_DON_HANG.SO_LUONG)
			FROM dbo.CHI_TIET_DON_HANG INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_DON_HANG.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP INNER JOIN DON_HANG ON DON_HANG.ID_DH = CHI_TIET_DON_HANG.ID_DH WHERE MA_SP = @MA_SP AND TRANG_THAI <> -1 and TRANG_THAI <> -99 AND FORMAT(@NAM, 'yyyy') = FORMAT(NGAY_TAO, 'yyyy')
			
			SET @RETURN_VAL = ISNULL(@PRICE/@QUANTITY, 0)
			RETURN @RETURN_VAL
		END
			RETURN @RETURN_VAL
	END 

	--SELECT dbo.[UDF_LayTrungBinhGiaBanCuaSanPhamTheoThang]('SP0000000000028', '2022-12-23')

	--SELECT * 
		--	FROM dbo.CHI_TIET_PHIEU_NHAP INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_PHIEU_NHAP.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP WHERE MA_SP = 'SP0000000000023'
	
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LayTrungBinhGiaBanCuaSanPhamTheoNgay]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[UDF_LayTrungBinhGiaBanCuaSanPhamTheoNgay] (@MA_SP varchar(15), @NGAY DATETIME) 
    RETURNS INT
AS
    BEGIN 
	DECLARE @RETURN_VAL INT = 0
	DECLARE @PRICE INT = 0
	DECLARE @QUANTITY INT = 0
		IF EXISTS(SELECT * FROM dbo.CHI_TIET_DON_HANG INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_DON_HANG.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP INNER JOIN DON_HANG ON DON_HANG.ID_DH = CHI_TIET_DON_HANG.ID_DH WHERE MA_SP = @MA_SP AND TRANG_THAI <> -1 and TRANG_THAI <> -99 AND FORMAT(@NGAY, 'dd/MM/yyyy') = FORMAT(NGAY_TAO, 'dd/MM/yyyy'))
		BEGIN
			SELECT @PRICE = SUM(CHI_TIET_DON_HANG.GIA * CHI_TIET_DON_HANG.SO_LUONG), @QUANTITY = SUM(CHI_TIET_DON_HANG.SO_LUONG)
			FROM dbo.CHI_TIET_DON_HANG INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_DON_HANG.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP INNER JOIN DON_HANG ON DON_HANG.ID_DH = CHI_TIET_DON_HANG.ID_DH WHERE MA_SP = @MA_SP AND TRANG_THAI <> -1 and TRANG_THAI <> -99 AND FORMAT(@NGAY, 'dd/MM/yyyy') = FORMAT(NGAY_TAO, 'dd/MM/yyyy')
			
			SET @RETURN_VAL = ISNULL(@PRICE/@QUANTITY, 0)
			RETURN @RETURN_VAL
		END
			RETURN @RETURN_VAL
	END 

	--SELECT dbo.[UDF_LayTrungBinhGiaBanCuaSanPhamTheoNgay]('SP0000000000023', getDate())

	--SELECT * 
		--	FROM dbo.CHI_TIET_PHIEU_NHAP INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_PHIEU_NHAP.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP WHERE MA_SP = 'SP0000000000023'
	
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LayTrungBinhGiaBanCuaSanPhamTheoThang]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[UDF_LayTrungBinhGiaBanCuaSanPhamTheoThang] (@MA_SP varchar(15), @THANG DATETIME) 
    RETURNS INT
AS
    BEGIN 
	DECLARE @RETURN_VAL INT = 0
	DECLARE @PRICE INT = 0
	DECLARE @QUANTITY INT = 0
		IF EXISTS(SELECT * FROM dbo.CHI_TIET_DON_HANG INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_DON_HANG.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP INNER JOIN DON_HANG ON DON_HANG.ID_DH = CHI_TIET_DON_HANG.ID_DH WHERE MA_SP = @MA_SP AND TRANG_THAI <> -1 and TRANG_THAI <> -99 AND FORMAT(@THANG, 'MM/yyyy') = FORMAT(NGAY_TAO, 'MM/yyyy'))
		BEGIN
			SELECT @PRICE = SUM(CHI_TIET_DON_HANG.GIA * CHI_TIET_DON_HANG.SO_LUONG), @QUANTITY = SUM(CHI_TIET_DON_HANG.SO_LUONG)
			FROM dbo.CHI_TIET_DON_HANG INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_DON_HANG.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP INNER JOIN DON_HANG ON DON_HANG.ID_DH = CHI_TIET_DON_HANG.ID_DH WHERE MA_SP = @MA_SP AND TRANG_THAI <> -1 and TRANG_THAI <> -99 AND FORMAT(@THANG, 'MM/yyyy') = FORMAT(NGAY_TAO, 'MM/yyyy')
			
			SET @RETURN_VAL = ISNULL(@PRICE/@QUANTITY, 0)
			RETURN @RETURN_VAL
		END
			RETURN @RETURN_VAL
	END 

	--SELECT dbo.[UDF_LayTrungBinhGiaBanCuaSanPhamTheoNgay]('SP0000000000033', '2022-12-23')

	--SELECT * 
		--	FROM dbo.CHI_TIET_PHIEU_NHAP INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_PHIEU_NHAP.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP WHERE MA_SP = 'SP0000000000023'
	
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LayTrungBinhGiaNhapCuaSanPham]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[UDF_LayTrungBinhGiaNhapCuaSanPham] (@MA_SP varchar(15)) 
    RETURNS INT
AS
    BEGIN 
	DECLARE @RETURN_VAL INT = 0
	DECLARE @PRICE INT = 0
	DECLARE @QUANTITY INT = 0
		IF EXISTS(SELECT * FROM dbo.CHI_TIET_PHIEU_NHAP INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_PHIEU_NHAP.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP WHERE MA_SP = @MA_SP)
		BEGIN
			SELECT @PRICE = SUM(CHI_TIET_PHIEU_NHAP.GIA * CHI_TIET_PHIEU_NHAP.SO_LUONG), @QUANTITY = SUM(CHI_TIET_PHIEU_NHAP.SO_LUONG)
			FROM dbo.CHI_TIET_PHIEU_NHAP INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_PHIEU_NHAP.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP WHERE MA_SP = @MA_SP
			
			SET @RETURN_VAL = ISNULL(@PRICE/@QUANTITY, 0)
			RETURN @RETURN_VAL
		END
			RETURN @RETURN_VAL
	END 

	--SELECT dbo.[UDF_LayTrungBinhGiaNhapCuaSanPham]('SP0000000000023')

	--SELECT * 
		--	FROM dbo.CHI_TIET_PHIEU_NHAP INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_PHIEU_NHAP.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP WHERE MA_SP = 'SP0000000000023'
	
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_LayTrungBinhSoSaoDanhGiaCuaSanPham]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[UDF_LayTrungBinhSoSaoDanhGiaCuaSanPham] (@MA_SP VARCHAR(15)) 
    RETURNS INT
AS
    BEGIN 
	DECLARE @avg FLOAT = 0;
		SELECT @avg = AVG(dgsp.DANH_GIA) FROM dbo.DANH_GIA_SAN_PHAM dgsp INNER JOIN CHI_TIET_DON_HANG ctgh
			ON dgsp.MA_CT_DH = ctgh.MA_CT_DH INNER JOIN CHI_TIET_SAN_PHAM ctsp ON ctgh.MA_CT_SP = ctsp.MA_CT_SP
		WHERE ctsp.MA_SP=@MA_SP
	RETURN @avg
	END 

--SELECT dbo.[UDF_LayTrungBinhSoSaoDanhGiaCuaSanPham] ('SP0000000000023')
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_TONG_SL_MUA_CUA_SP_TRONG_N_THANG_GAN_NHAT]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[UDF_TONG_SL_MUA_CUA_SP_TRONG_N_THANG_GAN_NHAT]
(
    @MA_SP VARCHAR(15),
	@N INT
)
RETURNS INT
AS
BEGIN
    DECLARE @result INT = 0;
	DECLARE @d DATETIME = DATEADD(MONTH,-@N, GETDATE())
        SET @result =
        (
            SELECT SUM (SO_LUONG) FROM dbo.CHI_TIET_DON_HANG 
			INNER JOIN (SELECT * FROM DON_HANG WHERE DON_HANG.TRANG_THAI <> -1 AND TRANG_THAI <> -99) DON_HANG
			ON DON_HANG.ID_DH = CHI_TIET_DON_HANG.ID_DH
			INNER JOIN CHI_TIET_SAN_PHAM ON CHI_TIET_DON_HANG.MA_CT_SP = CHI_TIET_SAN_PHAM.MA_CT_SP
			WHERE CHI_TIET_SAN_PHAM.MA_SP = @MA_SP AND (MONTH(NGAY_TAO) >= MONTH(@d) AND (YEAR(NGAY_TAO) >= YEAR(@d)))
        );
    RETURN @result;
END;

--SELECT dbo.[UDF_LayGiaNhoNhatCuaSizeTrongThayDoiGiaCuaSanPham] ('SP0000000000001')
--SELECT dbo.[UDF_LayGiaLonNhatCuaSizeTrongThayDoiGiaCuaSanPham] ('SP0000000000001')
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_TRI_GIA_CUA_DH]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[UDF_TRI_GIA_CUA_DH]
(
    @ID_DH INT
)
RETURNS INT
AS
BEGIN
    DECLARE @result INT = 0;
   
        SET @result =
        (
            SELECT SUM (SO_LUONG * GIA) FROM dbo.CHI_TIET_DON_HANG WHERE ID_DH = @ID_DH
        );

		IF @result IS NULL
			 SET @result = 0;
    RETURN @result;
END;

--SELECT dbo.[UDF_LayGiaNhoNhatCuaSizeTrongThayDoiGiaCuaSanPham] ('SP0000000000001')
--SELECT dbo.[UDF_LayGiaLonNhatCuaSizeTrongThayDoiGiaCuaSanPham] ('SP0000000000001')
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_TRI_GIA_CUA_PN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[UDF_TRI_GIA_CUA_PN]
(
    @MA_PN VARCHAR(15)
)
RETURNS INT
AS
BEGIN
    DECLARE @result INT = 0;
   
        SET @result =
        (
            SELECT SUM (ctpn.SO_LUONG * ctpn.GIA) FROM dbo.CHI_TIET_PHIEU_NHAP ctpn WHERE ctpn.MA_PN = @MA_PN
        );
		IF @result IS NULL
			 SET @result = 0;
    RETURN @result;
END;

--SELECT dbo.[UDF_TRI_GIA_CUA_PN] ('PN0000000000001')
--SELECT dbo.[UDF_LayGiaLonNhatCuaSizeTrongThayDoiGiaCuaSanPham] ('SP0000000000001')
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_TRI_GIA_CUA_PT]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [dbo].[UDF_TRI_GIA_CUA_PT]
(
    @MA_PT VARCHAR(15)
)
RETURNS INT
AS
BEGIN
	DECLARE @ID_DH INT = -1;
	SET @ID_DH = (SELECT ID_DH FROM HOA_DON INNER JOIN PHIEU_TRA ON HOA_DON.MA_HD = PHIEU_TRA.MA_HD WHERE MA_PT = @MA_PT)
    DECLARE @result INT = 0;
   
        SET @result =
        (
            SELECT SUM (ctpt.SO_LUONG * ctgh.GIA) 
			FROM dbo.CHI_TIET_DON_HANG ctgh 
			INNER JOIN (SELECT gh.ID_DH, ctpt1.SO_LUONG, ctpt1.MA_CT_SP FROM CHI_TIET_PHIEU_TRA ctpt1 INNER JOIN PHIEU_TRA pt ON 
			ctpt1.MA_PT = pt.MA_PT INNER JOIN HOA_DON hd ON hd.MA_HD = pt.MA_HD INNER JOIN DON_HANG
			gh ON hd.ID_DH = gh.ID_DH WHERE pt.MA_PT = @MA_PT) ctpt ON ctgh.MA_CT_SP = ctpt.MA_CT_SP WHERE ctgh.ID_DH = @ID_DH
			
        );

		IF @result IS NULL
			 SET @result = 0;
    RETURN @result;
END;
--
--SELECT dbo.[UDF_TRI_GIA_CUA_PT] ('PT0000000000012')
/*
SELECT * FROM PHIEU_TRA WHERE MA_PT='PT0000000000012' 
SELECT * FROM HOA_DON WHERE MA_HD= 'HD0000000000021'
SELECT * FROM CHI_TIET_DON_HANG WHERE ID_DH = 63
SELECT * FROM CHI_TIET_PHIEU_TRA WHERE MA_PT = 'PT0000000000012'
SELECT * FROM CHI_TIET_SAN_PHAM WHERE MA_CT_SP = 399


SELECT *
			FROM dbo.CHI_TIET_DON_HANG ctgh 
			INNER JOIN (SELECT gh.ID_DH, ctpt1.SO_LUONG, ctpt1.MA_CT_SP FROM CHI_TIET_PHIEU_TRA ctpt1 INNER JOIN PHIEU_TRA pt ON 
			ctpt1.MA_PT = pt.MA_PT INNER JOIN HOA_DON hd ON hd.MA_HD = pt.MA_HD INNER JOIN DON_HANG
			gh ON hd.ID_DH = gh.ID_DH WHERE pt.MA_PT = 'PT0000000000012') ctpt ON ctgh.MA_CT_SP = ctpt.MA_CT_SP

*/
--SELECT dbo.[UDF_LayGiaLonNhatCuaSizeTrongThayDoiGiaCuaSanPham] ('SP0000000000001')
GO
/****** Object:  Table [dbo].[BANG_MAU]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BANG_MAU](
	[MA_MAU] [varchar](15) NOT NULL,
	[TEN_MAU] [nvarchar](50) NOT NULL,
	[TEN_TIENG_ANH] [varchar](20) NOT NULL,
	[NGAY_TAO] [datetime] NOT NULL,
	[MA_NV] [varchar](15) NOT NULL,
 CONSTRAINT [PK_BANG_MAU] PRIMARY KEY CLUSTERED 
(
	[MA_MAU] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BANG_SIZE]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BANG_SIZE](
	[MA_SIZE] [varchar](15) NOT NULL,
	[TEN_SIZE] [nvarchar](50) NOT NULL,
	[NGAY_TAO] [datetime] NOT NULL,
	[MA_NV] [varchar](15) NOT NULL,
 CONSTRAINT [PK_BANG_SIZE] PRIMARY KEY CLUSTERED 
(
	[MA_SIZE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CHI_TIET_DON_DAT_HANG_PENDING_DELETE]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHI_TIET_DON_DAT_HANG_PENDING_DELETE](
	[MA_DDH] [varchar](15) NOT NULL,
	[MA_CT_SP] [varchar](15) NOT NULL,
	[SO_LUONG] [int] NULL,
	[GIA] [float] NULL,
 CONSTRAINT [PK_CHI_TIET_DON_DAT_HANG] PRIMARY KEY CLUSTERED 
(
	[MA_DDH] ASC,
	[MA_CT_SP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CHI_TIET_DON_HANG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHI_TIET_DON_HANG](
	[MA_CT_DH] [int] IDENTITY(1,1) NOT NULL,
	[ID_DH] [int] NOT NULL,
	[MA_CT_SP] [int] NOT NULL,
	[SO_LUONG] [int] NOT NULL,
	[GIA] [int] NOT NULL,
 CONSTRAINT [PK_CHI_TIET_GIO_HANG] PRIMARY KEY CLUSTERED 
(
	[MA_CT_DH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_ID_GH_MA_CTSP] UNIQUE NONCLUSTERED 
(
	[ID_DH] ASC,
	[MA_CT_SP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CHI_TIET_KHUYEN_MAI]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHI_TIET_KHUYEN_MAI](
	[MA_KM] [varchar](15) NOT NULL,
	[MA_SP] [varchar](15) NOT NULL,
	[PHAN_TRAM_GIAM] [smallint] NOT NULL,
 CONSTRAINT [PK_CHI_TIET_KHUYEN_MAI] PRIMARY KEY CLUSTERED 
(
	[MA_KM] ASC,
	[MA_SP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CHI_TIET_PHIEU_NHAP]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHI_TIET_PHIEU_NHAP](
	[MA_PN] [varchar](15) NOT NULL,
	[MA_CT_SP] [int] NOT NULL,
	[SO_LUONG] [int] NULL,
	[GIA] [int] NULL,
 CONSTRAINT [PK_CHI_TIET_PHIEU_NHAP] PRIMARY KEY CLUSTERED 
(
	[MA_PN] ASC,
	[MA_CT_SP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CHI_TIET_PHIEU_TRA]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHI_TIET_PHIEU_TRA](
	[MA_PT] [varchar](15) NOT NULL,
	[MA_CT_SP] [int] NOT NULL,
	[SO_LUONG] [int] NULL,
 CONSTRAINT [PK_CHI_TIET_PHIEU_TRA] PRIMARY KEY CLUSTERED 
(
	[MA_PT] ASC,
	[MA_CT_SP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CHI_TIET_SAN_PHAM]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHI_TIET_SAN_PHAM](
	[MA_CT_SP] [int] IDENTITY(1,1) NOT NULL,
	[MA_SP] [varchar](15) NOT NULL,
	[MA_MAU] [varchar](15) NULL,
	[MA_SIZE] [varchar](15) NOT NULL,
	[SL_TON] [int] NOT NULL,
 CONSTRAINT [PK_CHI_TIET_SAN_PHAM] PRIMARY KEY CLUSTERED 
(
	[MA_CT_SP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_CHI_TIET_SAN_PHAM] UNIQUE NONCLUSTERED 
(
	[MA_SP] ASC,
	[MA_SIZE] ASC,
	[MA_MAU] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DANH_GIA_SAN_PHAM]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DANH_GIA_SAN_PHAM](
	[MA_KH] [varchar](15) NOT NULL,
	[MA_CT_DH] [int] NOT NULL,
	[DANH_GIA] [smallint] NOT NULL,
	[NOI_DUNG] [nvarchar](1000) NULL,
	[NGAY_DANH_GIA] [datetime] NOT NULL,
 CONSTRAINT [PK_DANH_GIA_SAN_PHAM] PRIMARY KEY CLUSTERED 
(
	[MA_KH] ASC,
	[MA_CT_DH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DON_DAT_HANG_PENDING_DELETE]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DON_DAT_HANG_PENDING_DELETE](
	[MA_DDH] [varchar](15) NOT NULL,
	[MA_NCC] [varchar](15) NOT NULL,
	[NGAY_TAO] [datetime] NULL,
	[MA_NV] [varchar](15) NULL,
 CONSTRAINT [PK_DON_DAT_HANG] PRIMARY KEY CLUSTERED 
(
	[MA_DDH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DON_HANG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DON_HANG](
	[ID_DH] [int] IDENTITY(1,1) NOT NULL,
	[MA_KH] [varchar](15) NOT NULL,
	[HO_TEN] [nvarchar](60) NULL,
	[SDT] [varchar](50) NULL,
	[EMAIL] [varchar](50) NULL,
	[NGAY_TAO] [datetime] NULL,
	[NGAY_GIAO] [datetime] NULL,
	[DIA_CHI] [nvarchar](200) NULL,
	[GHI_CHU] [nvarchar](500) NULL,
	[TRANG_THAI] [smallint] NULL,
	[MA_NV_DUYET] [varchar](15) NULL,
	[MA_NV_GIAO] [varchar](15) NULL,
 CONSTRAINT [PK_GIO_HANG] PRIMARY KEY CLUSTERED 
(
	[ID_DH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HELPER_GEN_CODE]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HELPER_GEN_CODE](
	[TABLE_NAME] [varchar](100) NOT NULL,
	[COUNTER] [int] NULL,
 CONSTRAINT [PK_HELPER_GEN_CODE] PRIMARY KEY CLUSTERED 
(
	[TABLE_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HELPER_OTP]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HELPER_OTP](
	[EMAIL] [varchar](50) NOT NULL,
	[OTP] [varchar](6) NOT NULL,
	[NGAY_TAO] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HINH_ANH_SAN_PHAM]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HINH_ANH_SAN_PHAM](
	[MA_SP] [varchar](15) NOT NULL,
	[MA_MAU] [varchar](15) NOT NULL,
	[HINH_ANH] [nvarchar](400) NULL,
 CONSTRAINT [PK_HINH_ANH_SAN_PHAM] PRIMARY KEY CLUSTERED 
(
	[MA_SP] ASC,
	[MA_MAU] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HOA_DON]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOA_DON](
	[MA_HD] [varchar](15) NOT NULL,
	[ID_DH] [int] NOT NULL,
	[NGAY_TAO] [datetime] NOT NULL,
	[MA_NV] [varchar](15) NULL,
 CONSTRAINT [PK_HOA_DON] PRIMARY KEY CLUSTERED 
(
	[MA_HD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_ID_GH_HOA_DON] UNIQUE NONCLUSTERED 
(
	[ID_DH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KHACH_HANG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KHACH_HANG](
	[MA_KH] [varchar](15) NOT NULL,
	[HO_TEN] [nvarchar](60) NOT NULL,
	[SDT] [varchar](15) NOT NULL,
	[EMAIL] [varchar](50) NOT NULL,
	[DIA_CHI] [nvarchar](200) NULL,
	[MA_SO_THUE] [varchar](15) NULL,
	[MA_TK] [varchar](15) NOT NULL,
	[TRANG_THAI] [bit] NOT NULL,
	[NGAY_TAO] [datetime] NOT NULL,
 CONSTRAINT [PK_KHACH_HANG] PRIMARY KEY CLUSTERED 
(
	[MA_KH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_EMAIL_KH] UNIQUE NONCLUSTERED 
(
	[EMAIL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_MA_TK_KHACH_HANG] UNIQUE NONCLUSTERED 
(
	[MA_TK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KHUYEN_MAI]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KHUYEN_MAI](
	[MA_KM] [varchar](15) NOT NULL,
	[MA_NV] [varchar](15) NULL,
	[NGAY_AP_DUNG] [datetime] NULL,
	[NGAY_TAO] [datetime] NULL,
	[THOI_GIAN] [int] NULL,
	[GHI_CHU] [nvarchar](1000) NULL,
	[TRANG_THAI] [bit] NOT NULL,
 CONSTRAINT [PK_KHUYEN_MAI] PRIMARY KEY CLUSTERED 
(
	[MA_KM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NHA_CUNG_CAP_PENDING_DELETE]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NHA_CUNG_CAP_PENDING_DELETE](
	[MA_NCC] [varchar](15) NOT NULL,
	[TEN_NCC] [nvarchar](50) NOT NULL,
	[DIA_CHI] [nvarchar](200) NULL,
	[SDT] [varchar](10) NULL,
	[EMAIL] [varchar](50) NULL,
 CONSTRAINT [PK_NHA_CUNG_CAP] PRIMARY KEY CLUSTERED 
(
	[MA_NCC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NHAN_VIEN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NHAN_VIEN](
	[MA_NV] [varchar](15) NOT NULL,
	[HO_TEN] [nvarchar](60) NOT NULL,
	[SDT] [varchar](15) NOT NULL,
	[EMAIL] [varchar](50) NOT NULL,
	[DIA_CHI] [nvarchar](200) NULL,
	[CMND] [varchar](15) NULL,
	[MA_TK] [varchar](15) NOT NULL,
	[TRANG_THAI] [bit] NOT NULL,
	[NGAY_TAO] [datetime] NOT NULL,
 CONSTRAINT [PK_NHAN_VIEN] PRIMARY KEY CLUSTERED 
(
	[MA_NV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_EMAIL] UNIQUE NONCLUSTERED 
(
	[EMAIL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_MA_TK] UNIQUE NONCLUSTERED 
(
	[MA_TK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PHIEU_NHAP]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PHIEU_NHAP](
	[MA_PN] [varchar](15) NOT NULL,
	[NGAY_TAO] [datetime] NOT NULL,
	[MA_NV] [varchar](15) NOT NULL,
	[GHI_CHU] [nvarchar](1000) NULL,
 CONSTRAINT [PK_PHIEU_NHAP] PRIMARY KEY CLUSTERED 
(
	[MA_PN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PHIEU_TRA]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PHIEU_TRA](
	[MA_PT] [varchar](15) NOT NULL,
	[MA_HD] [varchar](15) NOT NULL,
	[NGAY_TAO] [datetime] NOT NULL,
	[MA_NV] [varchar](15) NOT NULL,
	[GHI_CHU] [nchar](10) NULL,
 CONSTRAINT [PK_PHIEU_TRA] PRIMARY KEY CLUSTERED 
(
	[MA_PT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QUYEN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QUYEN](
	[MA_QUYEN] [varchar](15) NOT NULL,
	[TEN_QUYEN] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_QUYEN] PRIMARY KEY CLUSTERED 
(
	[MA_QUYEN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SAN_PHAM]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAN_PHAM](
	[MA_SP] [varchar](15) NOT NULL,
	[TEN_SP] [nvarchar](150) NOT NULL,
	[MA_TL] [varchar](15) NOT NULL,
	[LUOT_XEM] [int] NOT NULL,
	[NGAY_TAO] [datetime] NOT NULL,
	[HINH_ANH] [nvarchar](400) NULL,
	[MO_TA] [nvarchar](500) NULL,
	[MA_NV] [varchar](15) NULL,
 CONSTRAINT [PK_SAN_PHAM] PRIMARY KEY CLUSTERED 
(
	[MA_SP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sysdiagrams]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysdiagrams](
	[name] [sysname] NOT NULL,
	[principal_id] [int] NOT NULL,
	[diagram_id] [int] IDENTITY(1,1) NOT NULL,
	[version] [int] NULL,
	[definition] [varbinary](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[diagram_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_principal_name] UNIQUE NONCLUSTERED 
(
	[principal_id] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TAI_KHOAN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TAI_KHOAN](
	[MA_TK] [varchar](15) NOT NULL,
	[MAT_KHAU] [varchar](max) NOT NULL,
	[MA_QUYEN] [varchar](15) NOT NULL,
 CONSTRAINT [PK_TAI_KHOAN] PRIMARY KEY CLUSTERED 
(
	[MA_TK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[THAY_DOI_GIA]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[THAY_DOI_GIA](
	[MA_NV] [varchar](15) NOT NULL,
	[MA_CT_SP] [int] NOT NULL,
	[NGAY_THAY_DOI] [datetime] NOT NULL,
	[GIA] [int] NOT NULL,
 CONSTRAINT [PK_THAY_DOI_GIA] PRIMARY KEY CLUSTERED 
(
	[MA_NV] ASC,
	[MA_CT_SP] ASC,
	[NGAY_THAY_DOI] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[THE_LOAI]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[THE_LOAI](
	[MA_TL] [varchar](15) NOT NULL,
	[TEN_TL] [nvarchar](50) NOT NULL,
	[CAP_TL] [smallint] NOT NULL,
	[MA_TL_CHA] [varchar](15) NULL,
 CONSTRAINT [PK_THE_LOAI] PRIMARY KEY CLUSTERED 
(
	[MA_TL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TI_GIA]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TI_GIA](
	[MA_NV] [varchar](15) NOT NULL,
	[NGAY_AP_DUNG] [datetime] NOT NULL,
	[TI_GIA] [int] NULL,
 CONSTRAINT [PK_TI_GIA] PRIMARY KEY CLUSTERED 
(
	[MA_NV] ASC,
	[NGAY_AP_DUNG] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[YEU_THICH_SAN_PHAM]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[YEU_THICH_SAN_PHAM](
	[MA_KH] [varchar](15) NOT NULL,
	[MA_SP] [varchar](15) NOT NULL,
	[NGAY_TAO] [datetime] NOT NULL,
 CONSTRAINT [PK_YEU_THICH_SAN_PHAM] PRIMARY KEY CLUSTERED 
(
	[MA_KH] ASC,
	[MA_SP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BANG_MAU]  WITH CHECK ADD  CONSTRAINT [FK_BANG_MAU_NHAN_VIEN] FOREIGN KEY([MA_NV])
REFERENCES [dbo].[NHAN_VIEN] ([MA_NV])
GO
ALTER TABLE [dbo].[BANG_MAU] CHECK CONSTRAINT [FK_BANG_MAU_NHAN_VIEN]
GO
ALTER TABLE [dbo].[BANG_SIZE]  WITH CHECK ADD  CONSTRAINT [FK_BANG_SIZE_NHAN_VIEN] FOREIGN KEY([MA_NV])
REFERENCES [dbo].[NHAN_VIEN] ([MA_NV])
GO
ALTER TABLE [dbo].[BANG_SIZE] CHECK CONSTRAINT [FK_BANG_SIZE_NHAN_VIEN]
GO
ALTER TABLE [dbo].[CHI_TIET_DON_HANG]  WITH CHECK ADD  CONSTRAINT [FK_CHI_TIET_GIO_HANG_CHI_TIET_SAN_PHAM] FOREIGN KEY([MA_CT_SP])
REFERENCES [dbo].[CHI_TIET_SAN_PHAM] ([MA_CT_SP])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CHI_TIET_DON_HANG] CHECK CONSTRAINT [FK_CHI_TIET_GIO_HANG_CHI_TIET_SAN_PHAM]
GO
ALTER TABLE [dbo].[CHI_TIET_DON_HANG]  WITH CHECK ADD  CONSTRAINT [FK_CHI_TIET_GIO_HANG_GIO_HANG] FOREIGN KEY([ID_DH])
REFERENCES [dbo].[DON_HANG] ([ID_DH])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CHI_TIET_DON_HANG] CHECK CONSTRAINT [FK_CHI_TIET_GIO_HANG_GIO_HANG]
GO
ALTER TABLE [dbo].[CHI_TIET_KHUYEN_MAI]  WITH CHECK ADD  CONSTRAINT [FK_CHI_TIET_KHUYEN_MAI_KHUYEN_MAI] FOREIGN KEY([MA_KM])
REFERENCES [dbo].[KHUYEN_MAI] ([MA_KM])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CHI_TIET_KHUYEN_MAI] CHECK CONSTRAINT [FK_CHI_TIET_KHUYEN_MAI_KHUYEN_MAI]
GO
ALTER TABLE [dbo].[CHI_TIET_KHUYEN_MAI]  WITH CHECK ADD  CONSTRAINT [FK_CHI_TIET_KHUYEN_MAI_SAN_PHAM] FOREIGN KEY([MA_SP])
REFERENCES [dbo].[SAN_PHAM] ([MA_SP])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CHI_TIET_KHUYEN_MAI] CHECK CONSTRAINT [FK_CHI_TIET_KHUYEN_MAI_SAN_PHAM]
GO
ALTER TABLE [dbo].[CHI_TIET_PHIEU_NHAP]  WITH CHECK ADD  CONSTRAINT [FK_CHI_TIET_PHIEU_NHAP_CHI_TIET_SAN_PHAM] FOREIGN KEY([MA_CT_SP])
REFERENCES [dbo].[CHI_TIET_SAN_PHAM] ([MA_CT_SP])
GO
ALTER TABLE [dbo].[CHI_TIET_PHIEU_NHAP] CHECK CONSTRAINT [FK_CHI_TIET_PHIEU_NHAP_CHI_TIET_SAN_PHAM]
GO
ALTER TABLE [dbo].[CHI_TIET_PHIEU_NHAP]  WITH CHECK ADD  CONSTRAINT [FK_CHI_TIET_PHIEU_NHAP_PHIEU_NHAP] FOREIGN KEY([MA_PN])
REFERENCES [dbo].[PHIEU_NHAP] ([MA_PN])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CHI_TIET_PHIEU_NHAP] CHECK CONSTRAINT [FK_CHI_TIET_PHIEU_NHAP_PHIEU_NHAP]
GO
ALTER TABLE [dbo].[CHI_TIET_PHIEU_TRA]  WITH CHECK ADD  CONSTRAINT [FK_CHI_TIET_PHIEU_TRA_CHI_TIET_SAN_PHAM] FOREIGN KEY([MA_CT_SP])
REFERENCES [dbo].[CHI_TIET_SAN_PHAM] ([MA_CT_SP])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CHI_TIET_PHIEU_TRA] CHECK CONSTRAINT [FK_CHI_TIET_PHIEU_TRA_CHI_TIET_SAN_PHAM]
GO
ALTER TABLE [dbo].[CHI_TIET_PHIEU_TRA]  WITH CHECK ADD  CONSTRAINT [FK_CHI_TIET_PHIEU_TRA_PHIEU_TRA] FOREIGN KEY([MA_PT])
REFERENCES [dbo].[PHIEU_TRA] ([MA_PT])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CHI_TIET_PHIEU_TRA] CHECK CONSTRAINT [FK_CHI_TIET_PHIEU_TRA_PHIEU_TRA]
GO
ALTER TABLE [dbo].[CHI_TIET_SAN_PHAM]  WITH CHECK ADD  CONSTRAINT [FK_CHI_TIET_SAN_PHAM_BANG_MAU] FOREIGN KEY([MA_MAU])
REFERENCES [dbo].[BANG_MAU] ([MA_MAU])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CHI_TIET_SAN_PHAM] CHECK CONSTRAINT [FK_CHI_TIET_SAN_PHAM_BANG_MAU]
GO
ALTER TABLE [dbo].[CHI_TIET_SAN_PHAM]  WITH CHECK ADD  CONSTRAINT [FK_CHI_TIET_SAN_PHAM_BANG_SIZE] FOREIGN KEY([MA_SIZE])
REFERENCES [dbo].[BANG_SIZE] ([MA_SIZE])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CHI_TIET_SAN_PHAM] CHECK CONSTRAINT [FK_CHI_TIET_SAN_PHAM_BANG_SIZE]
GO
ALTER TABLE [dbo].[CHI_TIET_SAN_PHAM]  WITH CHECK ADD  CONSTRAINT [FK_CHI_TIET_SAN_PHAM_SAN_PHAM] FOREIGN KEY([MA_SP])
REFERENCES [dbo].[SAN_PHAM] ([MA_SP])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CHI_TIET_SAN_PHAM] CHECK CONSTRAINT [FK_CHI_TIET_SAN_PHAM_SAN_PHAM]
GO
ALTER TABLE [dbo].[DANH_GIA_SAN_PHAM]  WITH CHECK ADD  CONSTRAINT [FK_DANH_GIA_SAN_PHAM_CHI_TIET_GIO_HANG] FOREIGN KEY([MA_CT_DH])
REFERENCES [dbo].[CHI_TIET_DON_HANG] ([MA_CT_DH])
GO
ALTER TABLE [dbo].[DANH_GIA_SAN_PHAM] CHECK CONSTRAINT [FK_DANH_GIA_SAN_PHAM_CHI_TIET_GIO_HANG]
GO
ALTER TABLE [dbo].[DANH_GIA_SAN_PHAM]  WITH CHECK ADD  CONSTRAINT [FK_DANH_GIA_SAN_PHAM_KHACH_HANG] FOREIGN KEY([MA_KH])
REFERENCES [dbo].[KHACH_HANG] ([MA_KH])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[DANH_GIA_SAN_PHAM] CHECK CONSTRAINT [FK_DANH_GIA_SAN_PHAM_KHACH_HANG]
GO
ALTER TABLE [dbo].[DON_HANG]  WITH CHECK ADD  CONSTRAINT [FK_GIO_HANG_KHACH_HANG] FOREIGN KEY([MA_KH])
REFERENCES [dbo].[KHACH_HANG] ([MA_KH])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[DON_HANG] CHECK CONSTRAINT [FK_GIO_HANG_KHACH_HANG]
GO
ALTER TABLE [dbo].[DON_HANG]  WITH CHECK ADD  CONSTRAINT [FK_GIO_HANG_NHAN_VIEN] FOREIGN KEY([MA_NV_DUYET])
REFERENCES [dbo].[NHAN_VIEN] ([MA_NV])
GO
ALTER TABLE [dbo].[DON_HANG] CHECK CONSTRAINT [FK_GIO_HANG_NHAN_VIEN]
GO
ALTER TABLE [dbo].[DON_HANG]  WITH CHECK ADD  CONSTRAINT [FK_GIO_HANG_NHAN_VIEN1] FOREIGN KEY([MA_NV_GIAO])
REFERENCES [dbo].[NHAN_VIEN] ([MA_NV])
GO
ALTER TABLE [dbo].[DON_HANG] CHECK CONSTRAINT [FK_GIO_HANG_NHAN_VIEN1]
GO
ALTER TABLE [dbo].[HINH_ANH_SAN_PHAM]  WITH CHECK ADD  CONSTRAINT [FK_HINH_ANH_SAN_PHAM_BANG_MAU] FOREIGN KEY([MA_MAU])
REFERENCES [dbo].[BANG_MAU] ([MA_MAU])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[HINH_ANH_SAN_PHAM] CHECK CONSTRAINT [FK_HINH_ANH_SAN_PHAM_BANG_MAU]
GO
ALTER TABLE [dbo].[HINH_ANH_SAN_PHAM]  WITH CHECK ADD  CONSTRAINT [FK_HINH_ANH_SAN_PHAM_SAN_PHAM] FOREIGN KEY([MA_SP])
REFERENCES [dbo].[SAN_PHAM] ([MA_SP])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[HINH_ANH_SAN_PHAM] CHECK CONSTRAINT [FK_HINH_ANH_SAN_PHAM_SAN_PHAM]
GO
ALTER TABLE [dbo].[HOA_DON]  WITH CHECK ADD  CONSTRAINT [FK_HOA_DON_GIO_HANG] FOREIGN KEY([ID_DH])
REFERENCES [dbo].[DON_HANG] ([ID_DH])
GO
ALTER TABLE [dbo].[HOA_DON] CHECK CONSTRAINT [FK_HOA_DON_GIO_HANG]
GO
ALTER TABLE [dbo].[HOA_DON]  WITH CHECK ADD  CONSTRAINT [FK_HOA_DON_NHAN_VIEN] FOREIGN KEY([MA_NV])
REFERENCES [dbo].[NHAN_VIEN] ([MA_NV])
GO
ALTER TABLE [dbo].[HOA_DON] CHECK CONSTRAINT [FK_HOA_DON_NHAN_VIEN]
GO
ALTER TABLE [dbo].[KHACH_HANG]  WITH CHECK ADD  CONSTRAINT [FK_KHACH_HANG_TAI_KHOAN] FOREIGN KEY([MA_TK])
REFERENCES [dbo].[TAI_KHOAN] ([MA_TK])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[KHACH_HANG] CHECK CONSTRAINT [FK_KHACH_HANG_TAI_KHOAN]
GO
ALTER TABLE [dbo].[KHUYEN_MAI]  WITH CHECK ADD  CONSTRAINT [FK_KHUYEN_MAI_NHAN_VIEN] FOREIGN KEY([MA_NV])
REFERENCES [dbo].[NHAN_VIEN] ([MA_NV])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[KHUYEN_MAI] CHECK CONSTRAINT [FK_KHUYEN_MAI_NHAN_VIEN]
GO
ALTER TABLE [dbo].[NHAN_VIEN]  WITH CHECK ADD  CONSTRAINT [FK_NHAN_VIEN_TAI_KHOAN] FOREIGN KEY([MA_TK])
REFERENCES [dbo].[TAI_KHOAN] ([MA_TK])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[NHAN_VIEN] CHECK CONSTRAINT [FK_NHAN_VIEN_TAI_KHOAN]
GO
ALTER TABLE [dbo].[PHIEU_NHAP]  WITH CHECK ADD  CONSTRAINT [FK_PHIEU_NHAP_NHAN_VIEN] FOREIGN KEY([MA_NV])
REFERENCES [dbo].[NHAN_VIEN] ([MA_NV])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[PHIEU_NHAP] CHECK CONSTRAINT [FK_PHIEU_NHAP_NHAN_VIEN]
GO
ALTER TABLE [dbo].[PHIEU_TRA]  WITH CHECK ADD  CONSTRAINT [FK_PHIEU_TRA_HOA_DON] FOREIGN KEY([MA_HD])
REFERENCES [dbo].[HOA_DON] ([MA_HD])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[PHIEU_TRA] CHECK CONSTRAINT [FK_PHIEU_TRA_HOA_DON]
GO
ALTER TABLE [dbo].[PHIEU_TRA]  WITH CHECK ADD  CONSTRAINT [FK_PHIEU_TRA_NHAN_VIEN] FOREIGN KEY([MA_NV])
REFERENCES [dbo].[NHAN_VIEN] ([MA_NV])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[PHIEU_TRA] CHECK CONSTRAINT [FK_PHIEU_TRA_NHAN_VIEN]
GO
ALTER TABLE [dbo].[SAN_PHAM]  WITH CHECK ADD  CONSTRAINT [FK_SAN_PHAM_NHAN_VIEN] FOREIGN KEY([MA_NV])
REFERENCES [dbo].[NHAN_VIEN] ([MA_NV])
GO
ALTER TABLE [dbo].[SAN_PHAM] CHECK CONSTRAINT [FK_SAN_PHAM_NHAN_VIEN]
GO
ALTER TABLE [dbo].[SAN_PHAM]  WITH CHECK ADD  CONSTRAINT [FK_SAN_PHAM_THE_LOAI] FOREIGN KEY([MA_TL])
REFERENCES [dbo].[THE_LOAI] ([MA_TL])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[SAN_PHAM] CHECK CONSTRAINT [FK_SAN_PHAM_THE_LOAI]
GO
ALTER TABLE [dbo].[TAI_KHOAN]  WITH CHECK ADD  CONSTRAINT [FK_TAI_KHOAN_QUYEN] FOREIGN KEY([MA_QUYEN])
REFERENCES [dbo].[QUYEN] ([MA_QUYEN])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[TAI_KHOAN] CHECK CONSTRAINT [FK_TAI_KHOAN_QUYEN]
GO
ALTER TABLE [dbo].[THAY_DOI_GIA]  WITH CHECK ADD  CONSTRAINT [FK_THAY_DOI_GIA_CHI_TIET_SAN_PHAM] FOREIGN KEY([MA_CT_SP])
REFERENCES [dbo].[CHI_TIET_SAN_PHAM] ([MA_CT_SP])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[THAY_DOI_GIA] CHECK CONSTRAINT [FK_THAY_DOI_GIA_CHI_TIET_SAN_PHAM]
GO
ALTER TABLE [dbo].[THAY_DOI_GIA]  WITH CHECK ADD  CONSTRAINT [FK_THAY_DOI_GIA_NHAN_VIEN] FOREIGN KEY([MA_NV])
REFERENCES [dbo].[NHAN_VIEN] ([MA_NV])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[THAY_DOI_GIA] CHECK CONSTRAINT [FK_THAY_DOI_GIA_NHAN_VIEN]
GO
ALTER TABLE [dbo].[TI_GIA]  WITH CHECK ADD  CONSTRAINT [FK_TI_GIA_NHAN_VIEN] FOREIGN KEY([MA_NV])
REFERENCES [dbo].[NHAN_VIEN] ([MA_NV])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[TI_GIA] CHECK CONSTRAINT [FK_TI_GIA_NHAN_VIEN]
GO
ALTER TABLE [dbo].[YEU_THICH_SAN_PHAM]  WITH CHECK ADD  CONSTRAINT [FK_YEU_THICH_SAN_PHAM_KHACH_HANG] FOREIGN KEY([MA_KH])
REFERENCES [dbo].[KHACH_HANG] ([MA_KH])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[YEU_THICH_SAN_PHAM] CHECK CONSTRAINT [FK_YEU_THICH_SAN_PHAM_KHACH_HANG]
GO
ALTER TABLE [dbo].[YEU_THICH_SAN_PHAM]  WITH CHECK ADD  CONSTRAINT [FK_YEU_THICH_SAN_PHAM_SAN_PHAM] FOREIGN KEY([MA_SP])
REFERENCES [dbo].[SAN_PHAM] ([MA_SP])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[YEU_THICH_SAN_PHAM] CHECK CONSTRAINT [FK_YEU_THICH_SAN_PHAM_SAN_PHAM]
GO
/****** Object:  StoredProcedure [dbo].[BAO_CAO_DOANH_THU_LOI_NHUAN_THEO_SAN_PHAM_THEO_KHOANG_NGAY]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[BAO_CAO_DOANH_THU_LOI_NHUAN_THEO_SAN_PHAM_THEO_KHOANG_NGAY] @NGAY DATETIME, @NGAY2 DATETIME
AS
BEGIN

	SELECT TEN_SP, 
		[dbo].[UDF_LayTrungBinhGiaBanCuaSanPhamTheoKhoangNgay](sp.MA_SP, @NGAY, @NGAY2) as GIA_BAN_TRUNG_BINH, --THEO NGAY NAY
		[dbo].[UDF_LayTrungBinhGiaNhapCuaSanPham](sp.MA_SP) as GIA_NHAP_TRUNG_BINH,  -- TU TRUOC TOI NAY
		[dbo].[UDF_LaySoLuongBanCuaSanPhamTheoKhoangNgay](sp.MA_SP, @NGAY, @NGAY2) as SO_LUONG --SO_LUONG_MUA
		,[dbo].[UDF_LayTrungBinhGiaBanCuaSanPhamTheoKhoangNgay](sp.MA_SP, @NGAY, @NGAY2) * [dbo].[UDF_LaySoLuongBanCuaSanPhamTheoKhoangNgay](sp.MA_SP, @NGAY, @NGAY2) AS TONG_DOANH_THU
		,[dbo].[UDF_LayTrungBinhGiaBanCuaSanPhamTheoKhoangNgay](sp.MA_SP, @NGAY, @NGAY2) * [dbo].[UDF_LaySoLuongBanCuaSanPhamTheoKhoangNgay](sp.MA_SP, @NGAY, @NGAY2) - [dbo].[UDF_LayTrungBinhGiaNhapCuaSanPham](sp.MA_SP) * [dbo].[UDF_LaySoLuongBanCuaSanPhamTheoKhoangNgay](sp.MA_SP, @NGAY, @NGAY2)  AS TONG_LOI_NHUAN
		FROM SAN_PHAM sp
	ORDER BY SO_LUONG DESC
	
END

--EXEC [BAO_CAO_DOANH_THU_LOI_NHUAN_THEO_SAN_PHAM_THEO_NGAY] '2022-12-23'
GO
/****** Object:  StoredProcedure [dbo].[BAO_CAO_DOANH_THU_LOI_NHUAN_THEO_SAN_PHAM_THEO_NAM]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[BAO_CAO_DOANH_THU_LOI_NHUAN_THEO_SAN_PHAM_THEO_NAM] @NGAY DATETIME
AS
BEGIN

	SELECT TEN_SP, 
		[dbo].[UDF_LayTrungBinhGiaBanCuaSanPhamTheoNam](sp.MA_SP, @NGAY) as GIA_BAN_TRUNG_BINH, --THEO NAM cua @ngay
		[dbo].[UDF_LayTrungBinhGiaNhapCuaSanPham](sp.MA_SP) as GIA_NHAP_TRUNG_BINH,  -- TU TRUOC TOI NAY
		[dbo].[UDF_LaySoLuongBanCuaSanPhamTheoNam](sp.MA_SP, @NGAY) as SO_LUONG --SO_LUONG_MUA nam cua @NgAY
		,[dbo].[UDF_LayTrungBinhGiaBanCuaSanPhamTheoNam](sp.MA_SP, @NGAY) * [dbo].[UDF_LaySoLuongBanCuaSanPhamTheoNam](sp.MA_SP, @NGAY) AS TONG_DOANH_THU
		,[dbo].[UDF_LayTrungBinhGiaBanCuaSanPhamTheoNam](sp.MA_SP, @NGAY) * [dbo].[UDF_LaySoLuongBanCuaSanPhamTheoNam](sp.MA_SP, @NGAY) - [dbo].[UDF_LayTrungBinhGiaNhapCuaSanPham](sp.MA_SP) * [dbo].[UDF_LaySoLuongBanCuaSanPhamTheoNam](sp.MA_SP, @NGAY)  AS TONG_LOI_NHUAN
		FROM SAN_PHAM sp
	ORDER BY SO_LUONG DESC
	
END

--EXEC [BAO_CAO_DOANH_THU_LOI_NHUAN_THEO_SAN_PHAM_THEO_NGAY] '2022-12-23'
GO
/****** Object:  StoredProcedure [dbo].[BAO_CAO_DOANH_THU_LOI_NHUAN_THEO_SAN_PHAM_THEO_NGAY]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[BAO_CAO_DOANH_THU_LOI_NHUAN_THEO_SAN_PHAM_THEO_NGAY] @NGAY DATETIME
AS
BEGIN

	SELECT TEN_SP, 
		[dbo].[UDF_LayTrungBinhGiaBanCuaSanPhamTheoNgay](sp.MA_SP, @NGAY) as GIA_BAN_TRUNG_BINH, --THEO NGAY NAY
		[dbo].[UDF_LayTrungBinhGiaNhapCuaSanPham](sp.MA_SP) as GIA_NHAP_TRUNG_BINH,  -- TU TRUOC TOI NAY
		[dbo].[UDF_LaySoLuongBanCuaSanPhamTheoNgay](sp.MA_SP, @NGAY) as SO_LUONG --SO_LUONG_MUA
		,[dbo].[UDF_LayTrungBinhGiaBanCuaSanPhamTheoNgay](sp.MA_SP, @NGAY) * [dbo].[UDF_LaySoLuongBanCuaSanPhamTheoNgay](sp.MA_SP, @NGAY) AS TONG_DOANH_THU
		,[dbo].[UDF_LayTrungBinhGiaBanCuaSanPhamTheoNgay](sp.MA_SP, @NGAY) * [dbo].[UDF_LaySoLuongBanCuaSanPhamTheoNgay](sp.MA_SP, @NGAY) - [dbo].[UDF_LayTrungBinhGiaNhapCuaSanPham](sp.MA_SP) * [dbo].[UDF_LaySoLuongBanCuaSanPhamTheoNgay](sp.MA_SP, @NGAY)  AS TONG_LOI_NHUAN
		FROM SAN_PHAM sp
	ORDER BY SO_LUONG DESC
	
END

--EXEC [BAO_CAO_DOANH_THU_LOI_NHUAN_THEO_SAN_PHAM_THEO_NGAY] '2022-12-23'
GO
/****** Object:  StoredProcedure [dbo].[BAO_CAO_DOANH_THU_LOI_NHUAN_THEO_SAN_PHAM_THEO_THANG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[BAO_CAO_DOANH_THU_LOI_NHUAN_THEO_SAN_PHAM_THEO_THANG] @NGAY DATETIME
AS
BEGIN

	SELECT TEN_SP, 
		[dbo].[UDF_LayTrungBinhGiaBanCuaSanPhamTheoThang](sp.MA_SP, @NGAY) as GIA_BAN_TRUNG_BINH, --THEO THANG cua @ngay
		[dbo].[UDF_LayTrungBinhGiaNhapCuaSanPham](sp.MA_SP) as GIA_NHAP_TRUNG_BINH,  -- TU TRUOC TOI NAY
		[dbo].[UDF_LaySoLuongBanCuaSanPhamTheoThang](sp.MA_SP, @NGAY) as SO_LUONG --SO_LUONG_MUA theo thang cua @ngay
		,[dbo].[UDF_LayTrungBinhGiaBanCuaSanPhamTheoThang](sp.MA_SP, @NGAY) * [dbo].[UDF_LaySoLuongBanCuaSanPhamTheoThang](sp.MA_SP, @NGAY) AS TONG_DOANH_THU
		,[dbo].[UDF_LayTrungBinhGiaBanCuaSanPhamTheoThang](sp.MA_SP, @NGAY) * [dbo].[UDF_LaySoLuongBanCuaSanPhamTheoThang](sp.MA_SP, @NGAY) - [dbo].[UDF_LayTrungBinhGiaNhapCuaSanPham](sp.MA_SP) * [dbo].[UDF_LaySoLuongBanCuaSanPhamTheoThang](sp.MA_SP, @NGAY)  AS TONG_LOI_NHUAN
		FROM SAN_PHAM sp
	ORDER BY SO_LUONG DESC
	
END

--EXEC [BAO_CAO_DOANH_THU_LOI_NHUAN_THEO_SAN_PHAM_THEO_NGAY] '2022-12-23'
GO
/****** Object:  StoredProcedure [dbo].[BAO_CAO_DOANH_THU_N_NGAY_GAN_NHAT]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[BAO_CAO_DOANH_THU_N_NGAY_GAN_NHAT] @N INT
AS
BEGIN

	DECLARE @a INT = 0;

	IF EXISTS (SELECT * FROM sysobjects WHERE name='#tmp' and xtype='U')
			DROP TABLE #tmp
	CREATE TABLE #tmp (
		NGAY DATETIME
	)

	DECLARE @d DATE = GETDATE()
	set @d = dateAdd(DAY, 1, @d)
	WHILE @a<@N
		BEGIN
			set @d = dateAdd(DAY, -1, @d)
			INSERT INTO #tmp values(@d)
			set @a = @a + 1
		END
	--SELECT * FROM #tmp
	SELECT tmp.*, FORMAT(tmp.NGAY, 'dd/MM/yyyy') AS NGAY_STR , SUM(dbo.UDF_TRI_GIA_CUA_DH(GH.ID_DH)) AS TONG_TRI_GIA 
	FROM #tmp tmp left join (SELECT * FROM DON_HANG WHERE TRANG_THAI<>-1 AND TRANG_THAI <> -99) GH ON 
		DATEDIFF(day, CAST(tmp.NGAY as date), CAST(GH.NGAY_TAO as date)) = 0
	--CAST(tmp.NGAY as date) = CAST(GH.NGAY_TAO as date)
	--WHERE GH.TRANG_THAI <> -1

	GROUP BY NGAY
	ORDER BY NGAY ASC
END

--EXEC BAO_CAO_DOANH_THU_N_NGAY_GAN_NHAT 7

--DECLARE @a INT = 0;

--	IF EXISTS (SELECT * FROM sysobjects WHERE name='#tmp' and xtype='U')
--			DROP TABLE #tmp
--	ELSE
--	IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='#tmp' and xtype='U')
--		CREATE TABLE #tmp (
--			NGAY DATETIME
--		)
--	ELSE
--		DELETE FROM #tmp

--	DECLARE @d DATE = GETDATE()
--	WHILE @a<7
--		BEGIN
--			set @d = dateAdd(DAY, -1,@d)
--			INSERT INTO #tmp values(@d)
--			set @a = @a + 1
--		END
--SELECT tmp.* , SUM(dbo.UDF_TRI_GIA_CUA_GH(GH.ID_GH)) AS TONG_TRI_GIA  FROM #tmp tmp left join GIO_HANG GH 
--on DATEDIFF(day, CAST(tmp.NGAY as date), CAST(GH.NGAY_TAO as date)) = 0 WHERE GH.TRANG_THAI <> -1
--GROUP BY NGAY
GO
/****** Object:  StoredProcedure [dbo].[BAO_CAO_DOANH_THU_THEO_KHOANG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[BAO_CAO_DOANH_THU_THEO_KHOANG] @fromDate DATETIME, @toDate DATETIME
AS
BEGIN
	IF EXISTS (SELECT * FROM sysobjects WHERE name='#tmp' and xtype='U')
		DROP TABLE #tmp

	CREATE TABLE #tmp (
		THANG DATETIME
	)

	DECLARE @d DATE = @fromDate
	WHILE DATEDIFF(MONTH, @d, @toDate) >= 0
		BEGIN
			INSERT INTO #tmp values(@d)
			set @d = dateAdd(MONTH, 1, @d)
		END
	--SELECT * FROM #tmp

	SET @toDate = dateadd(day, 1, @toDate)
	SELECT FORMAT(tmp.THANG, 'MM/yyyy') AS THANG, SUM(dbo.UDF_TRI_GIA_CUA_DH(GH.ID_DH)) AS TONG_TRI_GIA 
	FROM #tmp tmp left join (SELECT * FROM DON_HANG WHERE (TRANG_THAI<>-1 AND TRANG_THAI <>-99) AND (NGAY_TAO BETWEEN @fromDate AND @toDate)) GH ON 
		FORMAT(tmp.THANG, 'MM/yyyy') = FORMAT(GH.NGAY_TAO, 'MM/yyyy')
	GROUP BY tmp.THANG
END
GO
/****** Object:  StoredProcedure [dbo].[BAO_CAO_LOI_NHUAN_THEO_KHOANG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[BAO_CAO_LOI_NHUAN_THEO_KHOANG] @fromDate DATETIME, @toDate DATETIME
AS
BEGIN
	IF EXISTS (SELECT * FROM sysobjects WHERE name='#tmp' and xtype='U')
		DROP TABLE #tmp

	CREATE TABLE #tmp (
		THANG DATETIME
	)

	DECLARE @d DATE = @fromDate
	WHILE DATEDIFF(MONTH, @d, @toDate) >= 0
		BEGIN
			INSERT INTO #tmp values(@d)
			set @d = dateAdd(MONTH, 1, @d)
		END
	--SELECT * FROM #tmp

	SET @toDate = dateadd(day, 1, @toDate)
	SELECT FORMAT(tmp.THANG, 'MM/yyyy') AS THANG, 
	ISNULL(
	(SELECT SUM(dbo.UDF_TRI_GIA_CUA_DH(ID_DH)) FROM DON_HANG WHERE (TRANG_THAI<>-1 AND TRANG_THAI <> -99) AND (NGAY_TAO BETWEEN @fromDate AND @toDate) AND FORMAT(tmp.THANG, 'MM/yyyy') = FORMAT(NGAY_TAO, 'MM/yyyy'))
	, 0
	)
	AS TONG_DOANH_THU,
	ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PN(MA_PN)) FROM PHIEU_NHAP WHERE (NGAY_TAO BETWEEN @fromDate AND @toDate) AND FORMAT(tmp.THANG, 'MM/yyyy') = FORMAT(NGAY_TAO, 'MM/yyyy'))
	, 0
	)
		AS TONG_GIA_NHAP,
	ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PT(MA_PT)) FROM PHIEU_TRA WHERE (NGAY_TAO BETWEEN @fromDate AND @toDate) AND FORMAT(tmp.THANG, 'MM/yyyy') = FORMAT(NGAY_TAO, 'MM/yyyy'))
	, 0
	)
		AS TONG_GIA_TRA
	--SUM(dbo.UDF_TRI_GIA_CUA_GH(GH.ID_GH)) AS TONG_DOANH_THU, 
	--,SUM(dbo.UDF_TRI_GIA_CUA_PN(PN.MA_PN)) AS TONG_GIA_NHAP 
	
	, (
	ISNULL(
	(SELECT SUM(dbo.UDF_TRI_GIA_CUA_DH(ID_DH)) FROM DON_HANG WHERE (TRANG_THAI<>-1 AND TRANG_THAI <> -99) AND (NGAY_TAO BETWEEN @fromDate AND @toDate) AND FORMAT(tmp.THANG, 'MM/yyyy') = FORMAT(NGAY_TAO, 'MM/yyyy'))
	, 0
	) - ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PN(MA_PN)) FROM PHIEU_NHAP WHERE (NGAY_TAO BETWEEN @fromDate AND @toDate) AND FORMAT(tmp.THANG, 'MM/yyyy') = FORMAT(NGAY_TAO, 'MM/yyyy'))
	, 0
	) - ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PT(MA_PT)) FROM PHIEU_TRA WHERE (NGAY_TAO BETWEEN @fromDate AND @toDate) AND FORMAT(tmp.THANG, 'MM/yyyy') = FORMAT(NGAY_TAO, 'MM/yyyy'))
	, 0
	)) AS TONG_LOI_NHUAN
	FROM #tmp tmp 
	--left join (SELECT * FROM GIO_HANG WHERE (TRANG_THAI<>-1) AND (NGAY_TAO BETWEEN @fromDate AND @toDate)) GH ON 
		--FORMAT(tmp.THANG, 'MM/yyyy') = FORMAT(GH.NGAY_TAO, 'MM/yyyy')

		--left join (SELECT * FROM PHIEU_NHAP WHERE (NGAY_TAO BETWEEN @fromDate AND @toDate)) PN ON 
		--FORMAT(tmp.THANG, 'MM/yyyy') = FORMAT(PN.NGAY_TAO, 'MM/yyyy')
	GROUP BY tmp.THANG
END
GO
/****** Object:  StoredProcedure [dbo].[BAO_CAO_LOI_NHUAN_THEO_NAM]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[BAO_CAO_LOI_NHUAN_THEO_NAM] @fromDate DATETIME, @toDate DATETIME
AS
BEGIN
	IF EXISTS (SELECT * FROM sysobjects WHERE name='#tmp' and xtype='U')
		DROP TABLE #tmp

	CREATE TABLE #tmp (
		NAM DATETIME
	)

	DECLARE @d DATE = @fromDate
	WHILE DATEDIFF(YEAR, @d, @toDate) >= 0
		BEGIN
			INSERT INTO #tmp values(@d)
			set @d = dateAdd(YEAR, 1, @d)
		END
	--SELECT * FROM #tmp
	--lấy năm từ ngày tháng
	SELECT (N'Năm '  + CAST(DATEPART(year, tmp.NAM) as varchar(4))) AS NAM, 
	ISNULL(
	(SELECT SUM(dbo.UDF_TRI_GIA_CUA_DH(ID_DH)) FROM DON_HANG WHERE (TRANG_THAI<>-1 AND TRANG_THAI <> -99) AND (NGAY_TAO BETWEEN @fromDate AND @toDate) AND (DATEPART(year, tmp.NAM) = DATEPART(year, NGAY_TAO)))
	, 0
	)
	AS TONG_DOANH_THU,
	ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PN(MA_PN)) FROM PHIEU_NHAP WHERE (NGAY_TAO BETWEEN @fromDate AND @toDate) AND (DATEPART(year, tmp.NAM) = DATEPART(year, NGAY_TAO)))
	, 0
	)
		AS TONG_GIA_NHAP,
	ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PT(MA_PT)) FROM PHIEU_TRA WHERE (NGAY_TAO BETWEEN @fromDate AND @toDate) AND (DATEPART(year, tmp.NAM) = DATEPART(year, NGAY_TAO)))
	, 0
	)
		AS TONG_GIA_TRA


	, (
	ISNULL(
	(SELECT SUM(dbo.UDF_TRI_GIA_CUA_DH(ID_DH)) FROM DON_HANG WHERE (TRANG_THAI<>-1 AND TRANG_THAI <> -99) AND (NGAY_TAO BETWEEN @fromDate AND @toDate) AND (DATEPART(year, tmp.NAM) = DATEPART(year, NGAY_TAO)))
	, 0
	) - ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PN(MA_PN)) FROM PHIEU_NHAP WHERE (NGAY_TAO BETWEEN @fromDate AND @toDate)  AND (DATEPART(year, tmp.NAM) = DATEPART(year, NGAY_TAO)))
	, 0
	) - ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PT(MA_PT)) FROM PHIEU_TRA WHERE (NGAY_TAO BETWEEN @fromDate AND @toDate) AND (DATEPART(year, tmp.NAM) = DATEPART(year, NGAY_TAO)))
	, 0
	)) AS TONG_LOI_NHUAN
	FROM #tmp tmp 

	GROUP BY NAM

	
END
GO
/****** Object:  StoredProcedure [dbo].[BAO_CAO_LOI_NHUAN_THEO_NGAY]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[BAO_CAO_LOI_NHUAN_THEO_NGAY] @fromDate DATETIME, @toDate DATETIME
AS
BEGIN
	IF EXISTS (SELECT * FROM sysobjects WHERE name='#tmp' and xtype='U')
		DROP TABLE #tmp

	CREATE TABLE #tmp (
		NGAY DATETIME
	)

	DECLARE @d DATE = @fromDate
	WHILE DATEDIFF(DAY, @d, @toDate) >= 0
		BEGIN
			INSERT INTO #tmp values(@d)
			set @d = dateAdd(DAY, 1, @d)
		END
	--SELECT * FROM #tmp

	SET @toDate = dateadd(day, 1, @toDate)
	SELECT FORMAT(tmp.NGAY, 'dd/MM/yyyy') AS NGAY, 
	ISNULL(
	(SELECT SUM(dbo.UDF_TRI_GIA_CUA_DH(ID_DH)) FROM DON_HANG WHERE (TRANG_THAI<>-1 AND TRANG_THAI <> -99) AND (NGAY_TAO BETWEEN @fromDate AND @toDate) AND FORMAT(tmp.NGAY, 'dd/MM/yyyy') = FORMAT(NGAY_TAO, 'dd/MM/yyyy'))
	, 0
	)
	AS TONG_DOANH_THU,
	ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PN(MA_PN)) FROM PHIEU_NHAP WHERE (NGAY_TAO BETWEEN @fromDate AND @toDate) AND FORMAT(tmp.NGAY, 'dd/MM/yyyy') = FORMAT(NGAY_TAO, 'dd/MM/yyyy'))
	, 0
	)
		AS TONG_GIA_NHAP,
	ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PT(MA_PT)) FROM PHIEU_TRA WHERE (NGAY_TAO BETWEEN @fromDate AND @toDate) AND FORMAT(tmp.NGAY, 'dd/MM/yyyy') = FORMAT(NGAY_TAO, 'dd/MM/yyyy'))
	, 0
	)
		AS TONG_GIA_TRA
	--SUM(dbo.UDF_TRI_GIA_CUA_GH(GH.ID_GH)) AS TONG_DOANH_THU, 
	--,SUM(dbo.UDF_TRI_GIA_CUA_PN(PN.MA_PN)) AS TONG_GIA_NHAP  
	, (
	ISNULL(
	(SELECT SUM(dbo.UDF_TRI_GIA_CUA_DH(ID_DH)) FROM DON_HANG WHERE (TRANG_THAI<>-1 AND TRANG_THAI <> -99) AND (NGAY_TAO BETWEEN @fromDate AND @toDate) AND FORMAT(tmp.NGAY, 'dd/MM/yyyy') = FORMAT(NGAY_TAO, 'dd/MM/yyyy'))
	, 0
	) - ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PN(MA_PN)) FROM PHIEU_NHAP WHERE (NGAY_TAO BETWEEN @fromDate AND @toDate) AND FORMAT(tmp.NGAY, 'dd/MM/yyyy') = FORMAT(NGAY_TAO, 'dd/MM/yyyy'))
	, 0
	) - ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PT(MA_PT)) FROM PHIEU_TRA WHERE (NGAY_TAO BETWEEN @fromDate AND @toDate) AND FORMAT(tmp.NGAY, 'dd/MM/yyyy') = FORMAT(NGAY_TAO, 'dd/MM/yyyy'))
	, 0
	)) AS TONG_LOI_NHUAN
	FROM #tmp tmp 
	--left join (SELECT * FROM GIO_HANG WHERE (TRANG_THAI<>-1) AND (NGAY_TAO BETWEEN @fromDate AND @toDate)) GH ON 
		--FORMAT(tmp.THANG, 'dd/MM/yyyy') = FORMAT(GH.NGAY_TAO, 'dd/MM/yyyy')

		--left join (SELECT * FROM PHIEU_NHAP WHERE (NGAY_TAO BETWEEN @fromDate AND @toDate)) PN ON 
		--FORMAT(tmp.THANG, 'dd/MM/yyyy') = FORMAT(PN.NGAY_TAO, 'dd/MM/yyyy')
	GROUP BY tmp.NGAY
END
GO
/****** Object:  StoredProcedure [dbo].[BAO_CAO_LOI_NHUAN_THEO_QUY]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[BAO_CAO_LOI_NHUAN_THEO_QUY] @fromDate DATETIME, @toDate DATETIME
AS
BEGIN
	IF EXISTS (SELECT * FROM sysobjects WHERE name='#tmp' and xtype='U')
		DROP TABLE #tmp
	CREATE TABLE #tmp (
		QUY DATETIME
	)
	DECLARE @d DATE = @fromDate
	WHILE DATEDIFF(MONTH, @d, @toDate) >= 0
		BEGIN
			INSERT INTO #tmp values(@d)
			set @d = dateAdd(MONTH, 3, @d)
		END
	--SELECT * FROM #tmp
	--lấy quý từ ngày tháng
	SELECT (N'Quý ' + CAST(DATEPART(quarter, tmp.QUY) AS VARCHAR(1)) + N' năm ' + CAST(DATEPART(year, tmp.QUY) as varchar(4))) AS QUY, 
	ISNULL(
	(SELECT SUM(dbo.UDF_TRI_GIA_CUA_DH(ID_DH)) FROM DON_HANG WHERE (TRANG_THAI<>-1 AND TRANG_THAI <>-99) AND (NGAY_TAO BETWEEN @fromDate AND @toDate) AND (DATEPART(quarter, tmp.QUY) = DATEPART(quarter, NGAY_TAO) AND (DATEPART(year, tmp.QUY) = DATEPART(year, NGAY_TAO))))
	, 0) AS TONG_DOANH_THU,
	ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PN(MA_PN)) FROM PHIEU_NHAP WHERE (NGAY_TAO BETWEEN @fromDate AND @toDate) AND (DATEPART(quarter, tmp.QUY) = DATEPART(quarter, NGAY_TAO) AND (DATEPART(year, tmp.QUY) = DATEPART(year, NGAY_TAO))))
	, 0) AS TONG_GIA_NHAP,
	ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PT(MA_PT)) FROM PHIEU_TRA WHERE (NGAY_TAO BETWEEN @fromDate AND @toDate) AND (DATEPART(quarter, tmp.QUY) = DATEPART(quarter, NGAY_TAO) AND (DATEPART(year, tmp.QUY) = DATEPART(year, NGAY_TAO))))
	, 0 ) AS TONG_GIA_TRA
	,(ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_DH(ID_DH)) FROM DON_HANG WHERE (TRANG_THAI<>-1 AND TRANG_THAI <>-99) AND (NGAY_TAO BETWEEN @fromDate AND @toDate) AND (DATEPART(quarter, tmp.QUY) = DATEPART(quarter, NGAY_TAO) AND (DATEPART(year, tmp.QUY) = DATEPART(year, NGAY_TAO))))
	, 0) - ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PN(MA_PN)) FROM PHIEU_NHAP WHERE (NGAY_TAO BETWEEN @fromDate AND @toDate) AND (DATEPART(quarter, tmp.QUY) = DATEPART(quarter, NGAY_TAO) AND (DATEPART(year, tmp.QUY) = DATEPART(year, NGAY_TAO))))
	, 0) - ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PT(MA_PT)) FROM PHIEU_TRA WHERE (NGAY_TAO BETWEEN @fromDate AND @toDate) AND (DATEPART(quarter, tmp.QUY) = DATEPART(quarter, NGAY_TAO) AND (DATEPART(year, tmp.QUY) = DATEPART(year, NGAY_TAO))))
	, 0))  AS TONG_LOI_NHUAN
	FROM #tmp tmp 

	GROUP BY QUY
		
END
	--SET @toDate = dateadd(day, 1, @toDate)
	--SELECT FORMAT(tmp.THANG, 'MM/yyyy') AS THANG, 
	--ISNULL(
	--(SELECT SUM(dbo.UDF_TRI_GIA_CUA_GH(ID_GH)) FROM GIO_HANG WHERE (TRANG_THAI<>-1) AND (NGAY_TAO BETWEEN @fromDate AND @toDate) AND FORMAT(tmp.THANG, 'MM/yyyy') = FORMAT(NGAY_TAO, 'MM/yyyy'))
	--, 0
	--)
	--AS TONG_DOANH_THU,
	--ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PN(MA_PN)) FROM PHIEU_NHAP WHERE (NGAY_TAO BETWEEN @fromDate AND @toDate) AND FORMAT(tmp.THANG, 'MM/yyyy') = FORMAT(NGAY_TAO, 'MM/yyyy'))
	--, 0
	--)
	--	AS TONG_GIA_NHAP

	--, (
	--ISNULL(
	--(SELECT SUM(dbo.UDF_TRI_GIA_CUA_GH(ID_GH)) FROM GIO_HANG WHERE (TRANG_THAI<>-1) AND (NGAY_TAO BETWEEN @fromDate AND @toDate) AND FORMAT(tmp.THANG, 'MM/yyyy') = FORMAT(NGAY_TAO, 'MM/yyyy'))
	--, 0
	--) - ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PN(MA_PN)) FROM PHIEU_NHAP WHERE (NGAY_TAO BETWEEN @fromDate AND @toDate) AND FORMAT(tmp.THANG, 'MM/yyyy') = FORMAT(NGAY_TAO, 'MM/yyyy'))
	--, 0
	--)) AS TONG_LOI_NHUAN
	--FROM #tmp tmp 

	--GROUP BY tmp.THANG



GO
/****** Object:  StoredProcedure [dbo].[BAO_CAO_LOI_NHUAN_THEO_QUY_HIEN_TAI]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[BAO_CAO_LOI_NHUAN_THEO_QUY_HIEN_TAI]
AS
BEGIN
	IF EXISTS (SELECT * FROM sysobjects WHERE name='#tmp' and xtype='U')
		DROP TABLE #tmp
	CREATE TABLE #tmp (
		THANG DATETIME
	)

	IF(DATEPART(quarter, getDate()) = 1)
	BEGIN
		INSERT INTO #tmp VALUES(CAST(DATEPART(year, getDate()) as varchar(4)) +'-01-01')
		INSERT INTO #tmp VALUES(CAST(DATEPART(year, getDate()) as varchar(4)) +'-02-01')
		INSERT INTO #tmp VALUES(CAST(DATEPART(year, getDate()) as varchar(4)) +'-03-01')
	END
	IF(DATEPART(quarter, getDate()) = 2)
	BEGIN
		INSERT INTO #tmp VALUES(CAST(DATEPART(year, getDate()) as varchar(4)) +'-04-01')
		INSERT INTO #tmp VALUES(CAST(DATEPART(year, getDate()) as varchar(4)) +'-05-01')
		INSERT INTO #tmp VALUES(CAST(DATEPART(year, getDate()) as varchar(4)) +'-06-01')
	END
	IF(DATEPART(quarter, getDate()) = 3)
	BEGIN
		INSERT INTO #tmp VALUES(CAST(DATEPART(year, getDate()) as varchar(4)) +'-07-01')
		INSERT INTO #tmp VALUES(CAST(DATEPART(year, getDate()) as varchar(4)) +'-08-01')
		INSERT INTO #tmp VALUES(CAST(DATEPART(year, getDate()) as varchar(4)) +'-09-01')
	END
	IF(DATEPART(quarter, getDate()) = 4)
	BEGIN
		INSERT INTO #tmp VALUES(CAST(DATEPART(year, getDate()) as varchar(4)) +'-10-01')
		INSERT INTO #tmp VALUES(CAST(DATEPART(year, getDate()) as varchar(4)) +'-11-01')
		INSERT INTO #tmp VALUES(CAST(DATEPART(year, getDate()) as varchar(4)) +'-12-01')
	END
	--SELECT * FROM #tmp
	--lấy quý từ ngày tháng
	SELECT (FORMAT(tmp.THANG, 'MM/yyyy')) AS THANG, 
	ISNULL(
	(SELECT SUM(dbo.UDF_TRI_GIA_CUA_DH(ID_DH)) FROM DON_HANG WHERE (TRANG_THAI<>-1 AND TRANG_THAI <>-99) AND (DATEPART(MONTH, tmp.THANG) = DATEPART(MONTH, NGAY_TAO) AND (DATEPART(year, tmp.THANG) = DATEPART(year, NGAY_TAO))))
	, 0) AS TONG_DOANH_THU,
	ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PN(MA_PN)) FROM PHIEU_NHAP WHERE (DATEPART(MONTH, tmp.THANG) = DATEPART(MONTH, NGAY_TAO) AND (DATEPART(year, tmp.THANG) = DATEPART(year, NGAY_TAO))))
	, 0) AS TONG_GIA_NHAP,
	ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PT(MA_PT)) FROM PHIEU_TRA WHERE (DATEPART(MONTH, tmp.THANG) = DATEPART(MONTH, NGAY_TAO) AND (DATEPART(year, tmp.THANG) = DATEPART(year, NGAY_TAO))))
	, 0 ) AS TONG_GIA_TRA
	,(ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_DH(ID_DH)) FROM DON_HANG WHERE (TRANG_THAI<>-1 AND TRANG_THAI <>-99) AND (DATEPART(MONTH, tmp.THANG) = DATEPART(MONTH, NGAY_TAO) AND (DATEPART(year, tmp.THANG) = DATEPART(year, NGAY_TAO))))
	, 0) - ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PN(MA_PN)) FROM PHIEU_NHAP WHERE (DATEPART(MONTH, tmp.THANG) = DATEPART(MONTH, NGAY_TAO) AND (DATEPART(year, tmp.THANG) = DATEPART(year, NGAY_TAO))))
	, 0) - ISNULL((SELECT SUM(dbo.UDF_TRI_GIA_CUA_PT(MA_PT)) FROM PHIEU_TRA WHERE (DATEPART(MONTH, tmp.THANG) = DATEPART(MONTH, NGAY_TAO) AND (DATEPART(year, tmp.THANG) = DATEPART(year, NGAY_TAO))))
	, 0))  AS TONG_LOI_NHUAN
	FROM #tmp tmp 

	GROUP BY THANG
		
END
	-- EXEC [BAO_CAO_LOI_NHUAN_THEO_QUY_HIEN_TAI]



GO
/****** Object:  StoredProcedure [dbo].[BAO_CAO_SO_LUONG_MUA_CUA_CAC_SP_CUA_N_THANG_GAN_NHAT]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[BAO_CAO_SO_LUONG_MUA_CUA_CAC_SP_CUA_N_THANG_GAN_NHAT] @n INT, @top INT
AS
BEGIN

	SELECT TOP(@top) MA_SP, TEN_SP, ISNULL([dbo].[UDF_TONG_SL_MUA_CUA_SP_TRONG_N_THANG_GAN_NHAT](MA_SP, @n), 0) AS SO_LUONG FROM SAN_PHAM

	ORDER BY SO_LUONG DESC
END

--EXEC [BAO_CAO_SO_LUONG_MUA_CUA_CAC_SP_CUA_N_THANG_GAN_NHAT] 3, 10

GO
/****** Object:  StoredProcedure [dbo].[BAO_CAO_SO_LUONG_MUA_CUA_CAC_SP_CUA_THANG_HIEN_TAI]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[BAO_CAO_SO_LUONG_MUA_CUA_CAC_SP_CUA_THANG_HIEN_TAI]
AS
BEGIN

	SELECT MA_SP, TEN_SP, ISNULL([dbo].[UDF_TONG_SL_MUA_CUA_SP_TRONG_N_THANG_GAN_NHAT](MA_SP, 6), 0) AS SO_LUONG FROM SAN_PHAM

	ORDER BY SO_LUONG ASC
END

--EXEC [BAO_CAO_SO_LUONG_MUA_CUA_CAC_SP_CUA_THANG_HIEN_TAI] 7

GO
/****** Object:  StoredProcedure [dbo].[BAO_CAO_SO_LUONG_MUA_CUA_CAC_TL_CUA_N_THANG_GAN_NHAT]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[BAO_CAO_SO_LUONG_MUA_CUA_CAC_TL_CUA_N_THANG_GAN_NHAT] @n INT, @top INT
AS
BEGIN

	SELECT TOP(@top) TEN_TL, 
		SUM(ISNULL([dbo].[UDF_TONG_SL_MUA_CUA_SP_TRONG_N_THANG_GAN_NHAT](MA_SP, @n), 0)) AS SO_LUONG 
		FROM SAN_PHAM sp INNER JOIN THE_LOAI tl ON sp.MA_TL = tl.MA_TL
GROUP BY TEN_TL
	ORDER BY SO_LUONG DESC
	
END
GO
/****** Object:  StoredProcedure [dbo].[DUYET_GH__PENDING_DELETE]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[DUYET_GH__PENDING_DELETE] @ID_GH INT, @MA_NV_DUYET VARCHAR(15)
AS
BEGIN
	UPDATE dbo.GIO_HANG SET TRANG_THAI = 1, MA_NV_DUYET = @MA_NV_DUYET WHERE ID_GH = @ID_GH

	IF @@ERROR <> 0
		BEGIN
		SELECT 'Lỗi duyệt' AS errorDesc
			RETURN
		END
	SELECT 'Duyệt đơn hàng thành công' AS responseMessage
END
GO
/****** Object:  StoredProcedure [dbo].[GEN_CODE]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[GEN_CODE] @tableName varchar(100), @prefix varchar(10), @result varchar(15) OUTPUT
AS
BEGIN
	DECLARE @counter int
	SELECT @counter = [COUNTER] FROM HELPER_GEN_CODE WHERE [TABLE_NAME] = @tableName

	IF(@counter IS NULL)
	BEGIN
		SET @counter = 1
		INSERT INTO HELPER_GEN_CODE VALUES (@tableName, @counter)
	END

	--GEN MÃ LUÔN RA 15 KÝ TỰ
	SET @result = @prefix + right('00000000000000' + convert(varchar(15), @counter), 15 - len(@prefix))

	SET @counter = @counter + 1

	UPDATE HELPER_GEN_CODE SET [COUNTER] = @counter WHERE [TABLE_NAME] = @tableName

END
GO
/****** Object:  StoredProcedure [dbo].[GIAO_GH_CHO_NV_GIAO]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[GIAO_GH_CHO_NV_GIAO] @ID_GH INT,@MA_NV_DUYET VARCHAR(15), @MA_NV_GIAO VARCHAR(15)
AS
BEGIN
DECLARE @MA_HD_MOI VARCHAR(15)
		EXEC GEN_CODE @tableName = 'HOA_DON', @prefix = 'HD', @result = @MA_HD_MOI OUTPUT

	UPDATE dbo.DON_HANG SET TRANG_THAI = 1,MA_NV_DUYET = @MA_NV_DUYET, MA_NV_GIAO = @MA_NV_GIAO WHERE ID_DH = @ID_GH
	IF EXISTS(SELECT * FROM HOA_DON WHERE ID_DH = @ID_GH)
		RETURN
	
	INSERT INTO HOA_DON(MA_HD, ID_DH, NGAY_TAO, MA_NV) VALUES (@MA_HD_MOI, @ID_GH, GETDATE(), @MA_NV_DUYET)

	IF @@ERROR <> 0
		BEGIN
		SELECT 'Lỗi giao cho NV vận chuyển' AS errorDesc
			RETURN
		END
	SELECT 'Giao cho NV vận chuyển '+ @MA_NV_GIAO+ 'thành công'  AS responseMessage
END
GO
/****** Object:  StoredProcedure [dbo].[HOANTAT_GH]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[HOANTAT_GH] @ID_GH INT
AS
BEGIN
	UPDATE dbo.DON_HANG SET TRANG_THAI = 2, NGAY_GIAO = GETDATE() WHERE ID_DH = @ID_GH

	IF @@ERROR <> 0
		BEGIN
		SELECT 'Lỗi hoàn tất đơn' AS errorDesc
			RETURN
		END
	SELECT 'Hoàn tất đơn hàng thành công' AS responseMessage
END
GO
/****** Object:  StoredProcedure [dbo].[HUY_GH]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[HUY_GH] @ID_GH INT
AS
BEGIN
	IF ((SELECT TRANG_THAI FROM DON_HANG WHERE ID_DH = @ID_GH)=-1)
	BEGIN
		print('do nothing')
		SELECT N'Đơn đã được hủy trước đó' AS errorDesc
			RETURN
	END
	ELSE
	BEGIN
		UPDATE dbo.DON_HANG SET TRANG_THAI = -1 WHERE ID_DH = @ID_GH
	DECLARE @MA_CT_SP INT
	DECLARE @SL_TRONG_GH INT

	DECLARE cursorCTGioHang CURSOR FOR -- khai báo con trỏ cursorCTGioHang
	SELECT MA_CT_SP, SO_LUONG FROM CHI_TIET_DON_HANG WHERE ID_DH = @ID_GH -- dữ liệu trỏ tới
        
    OPEN cursorCTGioHang; -- Mở con trỏ

    FETCH NEXT FROM cursorCTGioHang -- Đọc dòng đầu tiên
    INTO @MA_CT_SP, @SL_TRONG_GH;
    WHILE @@FETCH_STATUS = 0 --vòng lặp WHILE khi đọc Cursor thành công
    BEGIN

	-- trả lại số lượng đã đặt
		UPDATE CHI_TIET_SAN_PHAM SET SL_TON = (SL_TON + @SL_TRONG_GH) WHERE MA_CT_SP = @MA_CT_SP

        FETCH NEXT FROM cursorCTGioHang -- Đọc dòng tiếp
        INTO @MA_CT_SP, @SL_TRONG_GH;
    END;

    CLOSE cursorCTGioHang; -- Đóng Cursor
    DEALLOCATE cursorCTGioHang; -- Giải phóng tài nguyên

	IF @@ERROR <> 0
		BEGIN
		SELECT N'Lỗi hủy đơn' AS errorDesc
			RETURN
		END
	SELECT N'Hủy đơn hàng thành công' AS responseMessage
	END
	
END
GO
/****** Object:  StoredProcedure [dbo].[KHACH_HANG_CAP_NHAT_THONG_TIN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[KHACH_HANG_CAP_NHAT_THONG_TIN]
@diaChi nvarchar(200), @hoTen nvarchar(60), @soDienThoai varchar(15),@maKhachHang varchar(15)
AS
BEGIN
	UPDATE KHACH_HANG SET HO_TEN = @hoTen, DIA_CHI = @diaChi, SDT = @soDienThoai whERE MA_KH = @maKhachHang
	SELECT KH.*, TK.MA_QUYEN, TK.MAT_KHAU, Q.TEN_QUYEN FROM dbo.KHACH_HANG KH 
	INNER JOIN dbo.TAI_KHOAN TK ON TK.MA_TK = KH.MA_TK
	INNER JOIN dbo.QUYEN Q ON Q.MA_QUYEN = TK.MA_QUYEN 
		WHERE KH.MA_KH = @maKhachHang 
END
GO
/****** Object:  StoredProcedure [dbo].[KHACH_HANG_DOI_MAT_KHAU]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[KHACH_HANG_DOI_MAT_KHAU] @password VARCHAR(MAX), @maKhachHang varchar(15)
AS
BEGIN
	UPDATE TAI_KHOAN SET MAT_KHAU = @password WHERE MA_TK = (SELECT MA_TK FROM KHACH_HANG WHERE MA_KH=@maKhachHang)
	SELECT KH.*, TK.MA_QUYEN, TK.MAT_KHAU, Q.TEN_QUYEN FROM dbo.KHACH_HANG KH 
	INNER JOIN dbo.TAI_KHOAN TK ON TK.MA_TK = KH.MA_TK
	INNER JOIN dbo.QUYEN Q ON Q.MA_QUYEN = TK.MA_QUYEN 
		WHERE KH.MA_KH = @maKhachHang
END
GO
/****** Object:  StoredProcedure [dbo].[KHACH_HANG_LOGIN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[KHACH_HANG_LOGIN] @email VARCHAR(50), @password VARCHAR(MAX)
AS
BEGIN
	SELECT KH.*, TK.MA_QUYEN, TK.MAT_KHAU, Q.TEN_QUYEN FROM dbo.KHACH_HANG KH 
	INNER JOIN dbo.TAI_KHOAN TK ON TK.MA_TK = KH.MA_TK
	INNER JOIN dbo.QUYEN Q ON Q.MA_QUYEN = TK.MA_QUYEN 
		WHERE KH.EMAIL = @email-- AND TK.MAT_KHAU = @password
END
GO
/****** Object:  StoredProcedure [dbo].[KHACH_HANG_QUEN_MAT_KHAU]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[KHACH_HANG_QUEN_MAT_KHAU] @EMAIL VARCHAR(50), @OTP VARCHAR(6), @PASSWORD VARCHAR(MAX)
AS
BEGIN
	DECLARE @errorMessage NVARCHAR(500) = N''
	DECLARE @responseMessage NVARCHAR(500) = N''

	BEGIN TRANSACTION
		IF NOT EXISTS(SELECT * FROM KHACH_HANG WHERE EMAIL = @EMAIL)
		BEGIN
			SET @errorMessage = N'Email đã nhập không phải của khách hàng nào trong hệ thống'
			GOTO ABORT
		END
		IF NOT EXISTS(SELECT * FROM HELPER_OTP WHERE EMAIL = @EMAIL)
		BEGIN
			SET @errorMessage = N'Hệ thống không tìm thấy yêu cầu xác thực của bạn'
			GOTO ABORT
		END
		IF EXISTS(SELECT * FROM HELPER_OTP WHERE EMAIL = @EMAIL AND OTP <> @OTP)
		BEGIN
			SET @errorMessage = N'Mã xác thực không đúng'
			GOTO ABORT
		END
		IF EXISTS(SELECT * FROM HELPER_OTP WHERE EMAIL = @EMAIL AND OTP = @OTP AND DATEDIFF(MINUTE, NGAY_TAO, GETDATE())>5  )
		BEGIN
			SET @errorMessage = N'Đã quá hạn xác thực (5 phút), hãy gửi yêu cầu nhận mã xác thực mới'
			GOTO ABORT
		END
		UPDATE TAI_KHOAN SET MAT_KHAU = @PASSWORD WHERE MA_TK = (SELECT MA_TK FROM KHACH_HANG WHERE EMAIL = @EMAIL)
		IF @@ERROR <>0
			GOTO ABORT
		DELETE HELPER_OTP WHERE EMAIL = @EMAIL
		IF @@ERROR <>0
			GOTO ABORT
	COMMIT TRANSACTION
	SELECT @EMAIL AS affectedId, N'Thay đổi mật khẩu thành công' AS responseMessage
	ABORT:
		ROLLBACK TRANSACTION
		SELECT '' AS affectedId, @errorMessage AS errorDesc, @responseMessage AS responseMessage
END;
GO
/****** Object:  StoredProcedure [dbo].[KHACH_HANG_SIGN_UP]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[KHACH_HANG_SIGN_UP] @email VARCHAR(50), @password VARCHAR(MAX),
@diaChi nvarchar(200), @hoTen nvarchar(60), @soDienThoai varchar(15),@maKhachHang varchar(15),@maTaiKhoan varchar(15)
AS
BEGIN
	DECLARE @MA_KH_MOI VARCHAR(15)
		EXEC GEN_CODE @tableName = 'KHACH_HANG', @prefix = 'KH', @result = @MA_KH_MOI OUTPUT

		DECLARE @MA_TK_MOI VARCHAR(15)
		EXEC GEN_CODE @tableName = 'TAI_KHOAN', @prefix = 'TK', @result = @MA_TK_MOI OUTPUT
	INSERT INTO TAI_KHOAN VALUES (@MA_TK_MOI, @password, 'Q03')

	INSERT INTO KHACH_HANG(MA_KH, HO_TEN, DIA_CHI, EMAIL, SDT, MA_TK, TRANG_THAI, NGAY_TAO) VALUES(@MA_KH_MOI, @hoTen, @diaChi, @email, @soDienThoai, @MA_TK_MOI, 1,GETDATE())

	SELECT KH.*, TK.MA_QUYEN, Q.TEN_QUYEN FROM dbo.KHACH_HANG KH 
	INNER JOIN dbo.TAI_KHOAN TK ON TK.MA_TK = KH.MA_TK
	INNER JOIN dbo.QUYEN Q ON Q.MA_QUYEN = TK.MA_QUYEN 
		WHERE KH.EMAIL = @email AND TK.MAT_KHAU = @password
END
GO
/****** Object:  StoredProcedure [dbo].[KICH_HOAT_TAI_KHOAN_KHACH_HANG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[KICH_HOAT_TAI_KHOAN_KHACH_HANG] @MA_KH VARCHAR(15)
AS
BEGIN
	DECLARE @errorMessage NVARCHAR(500) = N''
	DECLARE @responseMessage NVARCHAR(500) = N''

	BEGIN TRANSACTION
		--IF EXISTS(SELECT * FROM CHI_TIET_SAN_PHAM WHERE MA_SIZE = @MA_SIZE)
		--BEGIN
		--	SET @errorMessage = N'Size đã được sử dụng, không thể xóa'
		--	GOTO ABORT
		--END
		UPDATE KHACH_HANG SET TRANG_THAI = 1 WHERE MA_KH = @MA_KH
		IF @@ERROR <>0
			GOTO ABORT
	COMMIT TRANSACTION
	SELECT @MA_KH AS affectedId, N'Kích hoạt tài khoản khách hàng '+ @MA_KH  +N' thành công' AS responseMessage
	ABORT:
		ROLLBACK TRANSACTION
		SELECT '' AS affectedId, @errorMessage AS errorDesc, @responseMessage AS responseMessage
END;
GO
/****** Object:  StoredProcedure [dbo].[KICH_HOAT_TAI_KHOAN_NHAN_VIEN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[KICH_HOAT_TAI_KHOAN_NHAN_VIEN] @MA_NV VARCHAR(15)
AS
BEGIN
	DECLARE @errorMessage NVARCHAR(500) = N''
	DECLARE @responseMessage NVARCHAR(500) = N''

	BEGIN TRANSACTION
		--IF EXISTS(SELECT * FROM CHI_TIET_SAN_PHAM WHERE MA_SIZE = @MA_SIZE)
		--BEGIN
		--	SET @errorMessage = N'Size đã được sử dụng, không thể xóa'
		--	GOTO ABORT
		--END
		UPDATE NHAN_VIEN SET TRANG_THAI = 1 WHERE MA_NV = @MA_NV
		IF @@ERROR <>0
			GOTO ABORT
	COMMIT TRANSACTION
	SELECT @MA_NV AS affectedId, N'Kích hoạt tài khoản nhân viên '+ @MA_NV  +N' thành công' AS responseMessage
	ABORT:
		ROLLBACK TRANSACTION
		SELECT '' AS affectedId, @errorMessage AS errorDesc, @responseMessage AS responseMessage
END;
GO
/****** Object:  StoredProcedure [dbo].[KIEM_TRA_KHACH_HANG_CAP_NHAT_THONG_TIN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[KIEM_TRA_KHACH_HANG_CAP_NHAT_THONG_TIN] @maKhachHang VARCHAR(15), @phone VARCHAR(15)
AS
BEGIN
	DECLARE @checkPhone varchar(1) = '0';
	IF EXISTS(SELECT * FROM ((SELECT EMAIL, SDT FROM NHAN_VIEN) UNION ALL (SELECT EMAIL, SDT FROM KHACH_HANG WHERE MA_KH <> @maKhachHang)) B WHERE B.SDT = @phone)
	BEGIN
		SET @checkPhone = '1';
	END

	SELECT @checkPhone AS SDT 
END
GO
/****** Object:  StoredProcedure [dbo].[KIEM_TRA_KHACH_HANG_CO_THE_DANH_GIA_SP]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[KIEM_TRA_KHACH_HANG_CO_THE_DANH_GIA_SP] @MA_SP VARCHAR(15), @MA_KH VARCHAR(15)
AS
	IF (EXISTS (SELECT * FROM CHI_TIET_DON_HANG ctgh 
	INNER JOIN DON_HANG gh ON ctgh.ID_DH = gh.ID_DH
	INNER JOIN CHI_TIET_SAN_PHAM ctsp ON ctgh.MA_CT_SP = ctsp.MA_CT_SP
		WHERE gh.MA_KH = @MA_KH AND ctsp.MA_SP = @MA_SP AND gh.TRANG_THAI = 2 --đã hoàn tất mới cho comment
	) AND NOT EXISTS (SELECT * FROM DANH_GIA_SAN_PHAM dgsp INNER JOIN CHI_TIET_DON_HANG ctgh 
	ON dgsp.MA_CT_DH = ctgh.MA_CT_DH
	INNER JOIN DON_HANG gh ON ctgh.ID_DH = gh.ID_DH
	INNER JOIN CHI_TIET_SAN_PHAM ctsp ON ctgh.MA_CT_SP = ctsp.MA_CT_SP
		WHERE dgsp.MA_KH = @MA_KH AND ctsp.MA_SP = @MA_SP AND gh.TRANG_THAI = 2 --đã hoàn tất mới cho comment
	))
	BEGIN
		SELECT '1' AS affectedId, N'Có thể bình luận, đánh giá' as responseMessage
		RETURN
	END

	ELSE
	BEGIN
		SELECT '0' AS affectedId, N'Không thể bình luận, đánh giá' as responseMessage
		RETURN
	END
GO
/****** Object:  StoredProcedure [dbo].[KIEM_TRA_KHACH_HANG_SIGN_UP]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[KIEM_TRA_KHACH_HANG_SIGN_UP] @email VARCHAR(50), @phone VARCHAR(15)
AS
BEGIN

	DECLARE @checkEmail varchar(1) = '0';
	DECLARE @checkPhone varchar(1) = '0';

	IF EXISTS(SELECT * FROM ((SELECT EMAIL, SDT FROM NHAN_VIEN) UNION ALL (SELECT EMAIL, SDT FROM KHACH_HANG)) B WHERE B.EMAIL = @email)
	BEGIN
		SET @checkEmail = '1';
	END

	IF EXISTS(SELECT * FROM ((SELECT EMAIL, SDT FROM NHAN_VIEN) UNION ALL (SELECT EMAIL, SDT FROM KHACH_HANG)) B WHERE B.SDT = @phone)
	BEGIN
		SET @checkPhone = '1';
	END

	SELECT @checkEmail AS EMAIL, @checkPhone AS SDT 
END
GO
/****** Object:  StoredProcedure [dbo].[KIEM_TRA_NHAN_VIEN_CAP_NHAT_THONG_TIN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[KIEM_TRA_NHAN_VIEN_CAP_NHAT_THONG_TIN] @maNhanVien VARCHAR(15), @phone VARCHAR(15)
AS
BEGIN
	DECLARE @checkPhone varchar(1) = '0';
	IF EXISTS(SELECT * FROM ((SELECT EMAIL, SDT FROM NHAN_VIEN WHERE MA_NV <> @maNhanVien) UNION ALL (SELECT EMAIL, SDT FROM KHACH_HANG)) B WHERE B.SDT = @phone)
	BEGIN
		SET @checkPhone = '1';
	END

	SELECT @checkPhone AS SDT 
END
GO
/****** Object:  StoredProcedure [dbo].[KIEM_TRA_SO_LUONG_KHI_THANH_TOAN_GIO_HANG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[KIEM_TRA_SO_LUONG_KHI_THANH_TOAN_GIO_HANG]
	 @MA_KH VARCHAR(15)
	,@xml_LIST_CHI_TIET_SP_STR NVARCHAR(MAX)
AS
BEGIN
		-- xử lý xml list chi tiết sản phẩm
		DECLARE @XML_LIST_CHI_TIET_SP XML = CAST(@xml_LIST_CHI_TIET_SP_STR AS XML) ;

		DECLARE @idoc_CTSP int
		--Create an internal representation of the XML document.
		EXEC sp_xml_preparedocument @idoc_CTSP OUTPUT, @XML_LIST_CHI_TIET_SP;
		-- Execute a SELECT statement that uses the OPENXML rowset provider.
		--SELECT    *
		--FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
		--            WITH (
		--				MA_MAU		VARCHAR(15),
		--				HINH_ANH	NVARCHAR(400)
		--			);

		DECLARE @ctsp_MA_CT_SP INT, @ctsp_SO_LUONG INT, @ctsp_GIA INT

		DECLARE cur_CTSP CURSOR FOR
			SELECT *
			FROM OPENXML (@idoc_CTSP, '/ArrayOfCHI_TIET_SAN_PHAM_ENTITY/CHI_TIET_SAN_PHAM_ENTITY',2)
					WITH (
						MA_CT_SP INT,
						SO_LUONG INT,
						GIA INT
					);

		OPEN cur_CTSP

		DECLARE @SP_MAU_SIZE_LIMIT NVARCHAR(MAX) = N''
		FETCH NEXT FROM cur_CTSP
		INTO @ctsp_MA_CT_SP, @ctsp_SO_LUONG, @ctsp_GIA

		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF(@ctsp_SO_LUONG > (SELECT SL_TON FROM CHI_TIET_SAN_PHAM ctspp WHERE ctspp.MA_CT_SP = @ctsp_MA_CT_SP))
			BEGIN
				SET @SP_MAU_SIZE_LIMIT = @SP_MAU_SIZE_LIMIT + (SELECT sp.TEN_SP +N'/ '+ bs.TEN_SIZE  + N'/ ' + bm.TEN_MAU +': ' + CAST(SL_TON AS nvarchar(MAX)) FROM SAN_PHAM sp INNER JOIN CHI_TIET_SAN_PHAM ctsp1 ON sp.MA_SP = ctsp1.MA_SP INNER JOIN BANG_SIZE bs ON ctsp1.MA_SIZE = bs.MA_SIZE  INNER JOIN BANG_MAU bm ON ctsp1.MA_MAU = bm.MA_MAU WHERE MA_CT_SP = @ctsp_MA_CT_SP)+ ' ; ' 
	
			END
			FETCH NEXT FROM cur_CTSP
			INTO @ctsp_MA_CT_SP, @ctsp_SO_LUONG, @ctsp_GIA
		END

		CLOSE cur_CTSP;
		DEALLOCATE cur_CTSP;
		--end xử lý xml list chi tiet san pham

			
			--INSERT INTO THAY_DOI_GIA (MA_CT_SP, GIA, NGAY_THAY_DOI, MA_NV) 
			--	SELECT MA_CT_SP, 0 AS GIA, GETDATE() AS NGAY_THAY_DOI, @MA_NV AS MA_NV FROM CHI_TIET_SAN_PHAM WHERE MA_SP = @MA_SP_MOI
			--IF @@ERROR <> 0
			--		GOTO ABORT


			SELECT @SP_MAU_SIZE_LIMIT AS errorDesc
	ABORT:
		CLOSE cur;
		DEALLOCATE cur;
		CLOSE cur_CTSP;
		DEALLOCATE cur_CTSP;
		SELECT '' AS affectedId, @@ERROR AS errorDesc, 'Có lỗi xảy ra' AS responseMessage 
END

--DECLARE @XML_STR NVARCHAR(MAX) = '<?xml version="1.0"?>
--<ArrayOfHINH_ANH_SAN_PHAM_ENTITY xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <HINH_ANH_SAN_PHAM_ENTITY>
--    <MA_MAU>M01</MA_MAU>
--    <HINH_ANH>images3.jpg</HINH_ANH>
--  </HINH_ANH_SAN_PHAM_ENTITY>
--</ArrayOfHINH_ANH_SAN_PHAM_ENTITY>'

--DECLARE @XML XML = CAST(@XML_STR AS XML) ;

--DECLARE @tempTable TABLE
--(
--	MA_MAU		VARCHAR(15),
--	HINH_ANH	NVARCHAR(400)
--)
--DECLARE @idoc int
----Create an internal representation of the XML document.
--EXEC sp_xml_preparedocument @idoc OUTPUT, @XML;
---- Execute a SELECT statement that uses the OPENXML rowset provider.
----SELECT    *
----FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
----            WITH (
----				MA_MAU		VARCHAR(15),
----				HINH_ANH	NVARCHAR(400)
----			);

--DECLARE @MA_MAU VARCHAR(15), @HINH_ANH NVARCHAR(400)

--DECLARE cur CURSOR FOR
--	SELECT    *
--	FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
--            WITH (
--				MA_MAU		VARCHAR(15),
--				HINH_ANH	NVARCHAR(400)
--			);

--OPEN cur
GO
/****** Object:  StoredProcedure [dbo].[KIEM_TRA_SUA_NHAN_VIEN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[KIEM_TRA_SUA_NHAN_VIEN] @phone VARCHAR(15), @maNhanVien VARCHAR(15), @cmnd VARCHAR(15)
AS
BEGIN
--k cần check email vì email k cho sửa
	DECLARE @checkPhone varchar(1) = '0';
	DECLARE @checkCmnd varchar(1) = '0';

	IF EXISTS(SELECT * FROM ((SELECT EMAIL, SDT FROM NHAN_VIEN WHERE MA_NV <> @maNhanVien) UNION ALL (SELECT EMAIL, SDT FROM KHACH_HANG)) B WHERE B.SDT = @phone)
	BEGIN
		SET @checkPhone = '1';
	END
	IF EXISTS(SELECT * FROM ((SELECT EMAIL, SDT, CMND FROM NHAN_VIEN WHERE MA_NV <> @maNhanVien)) B WHERE B.CMND = @cmnd)
	BEGIN
		SET @checkCmnd = '1';
	END
	SELECT @checkPhone AS SDT ,@checkCmnd AS CMND
END
GO
/****** Object:  StoredProcedure [dbo].[KIEM_TRA_THEM_NHAN_VIEN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[KIEM_TRA_THEM_NHAN_VIEN] @email VARCHAR(50), @phone VARCHAR(15), @cmnd VARCHAR(15)
AS
BEGIN

	DECLARE @checkEmail varchar(1) = '0';
	DECLARE @checkPhone varchar(1) = '0';
	DECLARE @checkCmnd varchar(1) = '0';

	IF EXISTS(SELECT * FROM ((SELECT EMAIL, SDT FROM NHAN_VIEN) UNION ALL (SELECT EMAIL, SDT FROM KHACH_HANG)) B WHERE B.EMAIL = @email)
	BEGIN
		SET @checkEmail = '1';
	END

	IF EXISTS(SELECT * FROM ((SELECT EMAIL, SDT FROM NHAN_VIEN) UNION ALL (SELECT EMAIL, SDT FROM KHACH_HANG)) B WHERE B.SDT = @phone)
	BEGIN
		SET @checkPhone = '1';
	END
	IF EXISTS(SELECT * FROM ((SELECT EMAIL, SDT, CMND FROM NHAN_VIEN)) B WHERE B.CMND = @cmnd)
	BEGIN
		SET @checkCmnd = '1';
	END
	SELECT @checkEmail AS EMAIL, @checkPhone AS SDT ,@checkCmnd AS CMND
END
GO
/****** Object:  StoredProcedure [dbo].[LAY_CHI_TIET_GIO_HANG_TRANG_THAI_AM_99_CUA_NGUOI_DUNG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROC [dbo].[LAY_CHI_TIET_GIO_HANG_TRANG_THAI_AM_99_CUA_NGUOI_DUNG] @ID_GH INT
AS
BEGIN
		SELECT ROW_NUMBER() 
		OVER (ORDER BY CTGH.ID_DH DESC) AS STT, CTGH.MA_CT_DH, CTGH.MA_CT_SP, CTGH.SO_LUONG,  CTSP.SL_TON AS SO_LUONG_TON,
		-- lên front end sẽ dựa vào % của đầu sản phẩm làm giá giảm nếu có
		dbo.UDF_LayGiaCuaChiTietSP(CTGH.MA_CT_SP) AS GIA, SP.MA_SP, SP.TEN_SP, SP.HINH_ANH, TL.TEN_TL, BS.TEN_SIZE, BM.TEN_MAU
		FROM dbo.CHI_TIET_DON_HANG CTGH 
		INNER JOIN dbo.CHI_TIET_SAN_PHAM CTSP ON CTSP.MA_CT_SP = CTGH.MA_CT_SP
		INNER JOIN dbo.SAN_PHAM SP ON SP.MA_SP = CTSP.MA_SP 
		INNER JOIN dbo.BANG_MAU BM ON BM.MA_MAU = CTSP.MA_MAU 
		INNER JOIN dbo.THE_LOAI TL ON TL.MA_TL = SP.MA_TL
		INNER JOIN dbo.BANG_SIZE BS ON BS.MA_SIZE = CTSP.MA_SIZE

		WHERE CTGH.ID_DH = @ID_GH
END
GO
/****** Object:  StoredProcedure [dbo].[LAY_CHI_TIET_MOT_DOT_KHUYEN_MAI]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[LAY_CHI_TIET_MOT_DOT_KHUYEN_MAI] @MA_KM VARCHAR(15)
AS
BEGIN

	SELECT * FROM CHI_TIET_KHUYEN_MAI WHERE MA_KM = @MA_KM ORDER BY MA_SP DESC
END

-- EXEC [LAY_CHI_TIET_MOT_DOT_KHUYEN_MAI] @MA_KM = 'KM0000000000001'
GO
/****** Object:  StoredProcedure [dbo].[LAY_CHI_TIET_MOT_GIO_HANG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE     PROC [dbo].[LAY_CHI_TIET_MOT_GIO_HANG] @ID_GH INT
AS
BEGIN
		SELECT ROW_NUMBER() 
		OVER (ORDER BY CTGH.ID_DH DESC) AS STT, CTGH.*,SP.MA_SP, SP.TEN_SP, SP.HINH_ANH, TL.TEN_TL, BS.TEN_SIZE, BM.TEN_MAU
		FROM dbo.CHI_TIET_DON_HANG CTGH 
		INNER JOIN dbo.CHI_TIET_SAN_PHAM CTSP ON CTSP.MA_CT_SP = CTGH.MA_CT_SP
		INNER JOIN dbo.SAN_PHAM SP ON SP.MA_SP = CTSP.MA_SP 
		INNER JOIN dbo.BANG_MAU BM ON BM.MA_MAU = CTSP.MA_MAU 
		INNER JOIN dbo.THE_LOAI TL ON TL.MA_TL = SP.MA_TL
		INNER JOIN dbo.BANG_SIZE BS ON BS.MA_SIZE = CTSP.MA_SIZE

		WHERE CTGH.ID_DH = @ID_GH
END
GO
/****** Object:  StoredProcedure [dbo].[LAY_CHI_TIET_MOT_GIO_HANG_VA_SL_DA_TRA]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROC [dbo].[LAY_CHI_TIET_MOT_GIO_HANG_VA_SL_DA_TRA] @ID_GH INT
AS
BEGIN
	SELECT ROW_NUMBER() 
		OVER (ORDER BY CTGH.ID_DH DESC) 
		AS STT, CTGH.*,SP.MA_SP, SP.TEN_SP, SP.HINH_ANH, TL.TEN_TL, BS.TEN_SIZE, BM.TEN_MAU 
		, 
		
		(SELECT SUM(ctpt.SO_LUONG)
			FROM CHI_TIET_PHIEU_TRA ctpt 
			INNER JOIN PHIEU_TRA pt ON ctpt.MA_PT = pt.MA_PT
			INNER JOIN HOA_DON hd ON pt.MA_HD = hd.MA_HD
			INNER JOIN DON_HANG gh ON gh.ID_DH = hd.ID_DH 
			WHERE ctpt.MA_CT_SP = CTGH.MA_CT_SP AND gh.ID_DH = @ID_GH) AS SL_DA_TRA

FROM dbo.CHI_TIET_DON_HANG CTGH 
		INNER JOIN dbo.CHI_TIET_SAN_PHAM CTSP ON CTSP.MA_CT_SP = CTGH.MA_CT_SP
		INNER JOIN dbo.SAN_PHAM SP ON SP.MA_SP = CTSP.MA_SP 
		INNER JOIN dbo.BANG_MAU BM ON BM.MA_MAU = CTSP.MA_MAU 
		INNER JOIN  dbo.THE_LOAI TL ON TL.MA_TL = SP.MA_TL
		INNER JOIN dbo.BANG_SIZE BS ON BS.MA_SIZE = CTSP.MA_SIZE

		WHERE CTGH.ID_DH = @ID_GH
END
GO
/****** Object:  StoredProcedure [dbo].[LAY_CHI_TIET_MOT_PHIEU_NHAP]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[LAY_CHI_TIET_MOT_PHIEU_NHAP] @MA_PN VARCHAR(15)
AS
BEGIN

	SELECT * FROM CHI_TIET_PHIEU_NHAP WHERE MA_PN = @MA_PN
END

-- EXEC LAY_CHI_TIET_MOT_PHIEU_NHAP @MA_PN = 'PN0000000000001'
GO
/****** Object:  StoredProcedure [dbo].[LAY_CHI_TIET_MOT_PHIEU_TRA]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[LAY_CHI_TIET_MOT_PHIEU_TRA] @MA_PT VARCHAR(15)
AS
BEGIN

	SELECT ctpt.MA_CT_SP, ctpt.MA_PT, ctpt.SO_LUONG AS SL_TRA FROM CHI_TIET_PHIEU_TRA ctpt WHERE ctpt.MA_PT = @MA_PT
END

-- EXEC [LAY_CHI_TIET_MOT_PHIEU_TRA] @MA_PT = 'PT0000000000001'
GO
/****** Object:  StoredProcedure [dbo].[LAY_CT_SP_CUA_SP]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[LAY_CT_SP_CUA_SP] @productId VARCHAR(15)
AS
BEGIN
    SELECT CTSP.*,
           BS.TEN_SIZE,
           dbo.[UDF_LayGiaCuaChiTietSP](CTSP.MA_CT_SP) AS GIA,
		   BM.TEN_MAU,
		   BM.TEN_TIENG_ANH, -- tên màu tiếng anh làm class trên fe
		  (SELECT HINH_ANH FROM HINH_ANH_SAN_PHAM HASP WHERE HASP.MA_MAU = CTSP.MA_MAU AND HASP.MA_SP = @productId)HINH_ANH
    FROM dbo.SAN_PHAM S
        INNER JOIN dbo.CHI_TIET_SAN_PHAM CTSP
            ON CTSP.MA_SP = S.MA_SP
        INNER JOIN dbo.BANG_SIZE BS
            ON BS.MA_SIZE = CTSP.MA_SIZE
		INNER JOIN dbo.BANG_MAU BM
			ON CTSP.MA_MAU = BM.MA_MAU
		
    WHERE S.MA_SP = @productId

    ORDER BY MA_MAU;

END;
GO
/****** Object:  StoredProcedure [dbo].[LAY_DANH_SACH_YEU_THICH_CUA_KH]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[LAY_DANH_SACH_YEU_THICH_CUA_KH] @MA_KH VARCHAR(15), @POPULATED INT = NULL
AS 
	BEGIN
	IF (@POPULATED IS NULL)
		SELECT MA_SP FROM YEU_THICH_SAN_PHAM WHERE MA_KH = @MA_KH
	IF(@POPULATED = 1)
		SELECT S.*
				,TL.TEN_TL
				-- chỉ lấy phần trăm giảm nếu đợt khuyến mãi đó đang khuyến mãi (xem UDF_KiemTraDotKhuyenMaiDangKhuyenMai)
				, CASE WHEN dbo. UDF_KiemTraDotKhuyenMaiDangKhuyenMai(KM.MA_KM)=1 THEN CTKM.PHAN_TRAM_GIAM  ELSE NULL END as PHAN_TRAM_GIAM 
				, dbo.UDF_LayStringGia(S.MA_SP) AS GIA_STR
				, dbo.UDF_LayStringGiaDaGiam(S.MA_SP) AS GIA_STR_DA_GIAM
				, dbo.UDF_LayTongSoLuongTonCuaMotSP(S.MA_SP) AS TONG_SL_TON 
				FROM dbo.SAN_PHAM S
				LEFT JOIN (SELECT * FROM dbo.CHI_TIET_KHUYEN_MAI WHERE dbo. UDF_KiemTraDotKhuyenMaiDangKhuyenMai(MA_KM)=1) CTKM ON CTKM.MA_SP = S.MA_SP
								LEFT JOIN dbo.KHUYEN_MAI KM ON KM.MA_KM = CTKM.MA_KM 
								LEFT JOIN dbo.THE_LOAI TL ON TL.MA_TL = S.MA_TL
								INNER JOIN (SELECT * FROM YEU_THICH_SAN_PHAM WHERE MA_KH = @MA_KH) dsyt ON dsyt.MA_SP = S.MA_SP
								ORDER BY dsyt.NGAY_TAO DESC

	END
GO
/****** Object:  StoredProcedure [dbo].[LAY_DS_CHI_TIET_CUA_SP]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[LAY_DS_CHI_TIET_CUA_SP] @productId varchar(15)
AS
BEGIN
	SELECT ctsp.MA_CT_SP, ctsp.MA_SIZE, bs.TEN_SIZE, ctsp.MA_MAU, bm.TEN_MAU FROM CHI_TIET_SAN_PHAM ctsp 
		inner join BANG_SIZE bs on ctsp.MA_SIZE = bs.MA_SIZE 
		inner join BANG_MAU bm on ctsp.MA_MAU = bm.MA_MAU
	where ctsp.MA_SP = @productId ORDER BY MA_MAU, MA_SIZE
END

-- EXEC LAY_DS_CHI_TIET_CUA_SP @productId = 'SP0000000000023'
GO
/****** Object:  StoredProcedure [dbo].[LAY_DS_CHI_TIET_CUA_SP_KEM_GIA_HIEN_TAI]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[LAY_DS_CHI_TIET_CUA_SP_KEM_GIA_HIEN_TAI] @productId varchar(15)
AS
BEGIN
	SELECT ctsp.MA_CT_SP, ctsp.MA_SIZE, bs.TEN_SIZE, ctsp.MA_MAU, bm.TEN_MAU, dbo.UDF_LayGiaCuaChiTietSP(ctsp.MA_CT_SP) AS GIA -- giá hiện tại
	FROM CHI_TIET_SAN_PHAM ctsp 
		inner join BANG_SIZE bs on ctsp.MA_SIZE = bs.MA_SIZE 
		inner join BANG_MAU bm on ctsp.MA_MAU = bm.MA_MAU
	where ctsp.MA_SP = @productId ORDER BY MA_MAU, MA_SIZE
END

-- EXEC LAY_DS_CHI_TIET_CUA_SP_KEM_GIA_HIEN_TAI @productId = 'SP0000000000023'
GO
/****** Object:  StoredProcedure [dbo].[LAY_GIO_HANG_TRANG_THAI_AM_99_CUA_NGUOI_DUNG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROC [dbo].[LAY_GIO_HANG_TRANG_THAI_AM_99_CUA_NGUOI_DUNG] @MA_KH VARCHAR(15)
AS
BEGIN
	SELECT GH.*
	FROM dbo.DON_HANG GH WHERE GH.MA_KH = @MA_KH AND TRANG_THAI = -99
END
GO
/****** Object:  StoredProcedure [dbo].[LAY_HINH_ANH_CUA_SP]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[LAY_HINH_ANH_CUA_SP] @productId VARCHAR(15)
AS
BEGIN
    SELECT HASP.*,
			BM.TEN_MAU,
			BM.TEN_TIENG_ANH
    FROM dbo.SAN_PHAM S
        INNER JOIN dbo.HINH_ANH_SAN_PHAM HASP ON S.MA_SP = HASP.MA_SP
		INNER JOIN dbo.BANG_MAU BM ON BM.MA_MAU = HASP.MA_MAU
    WHERE S.MA_SP = @productId
    ORDER BY HASP.MA_MAU;

END;
GO
/****** Object:  StoredProcedure [dbo].[LAY_HOA_DON_THEO_ID_GH]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[LAY_HOA_DON_THEO_ID_GH]
	@ID_GH INT
AS
BEGIN
	SELECT * FROM HOA_DON WHERE ID_DH = @ID_GH
END
GO
/****** Object:  StoredProcedure [dbo].[LAY_MOT_DOT_KHUYEN_MAI]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[LAY_MOT_DOT_KHUYEN_MAI] @MA_KM VARCHAR(15)
AS
BEGIN

	SELECT km.MA_KM, km.MA_NV, km.GHI_CHU, km.NGAY_TAO, km.NGAY_AP_DUNG,
		nv.HO_TEN AS HO_TEN_NV, km.THOI_GIAN,
		dbo.[UDF_LayMaCacSPTrongDotKM](km.MA_KM) AS MA_CAC_SP,
		dbo.UDF_KiemTraDotKhuyenMaiDangKhuyenMai(@MA_KM) AS DANG_KHUYEN_MAI,
		(SELECT COUNT (*) FROM CHI_TIET_KHUYEN_MAI ctkm2 WHERE ctkm2.MA_KM = km.MA_KM) AS SO_LUONG_SP
		
		FROM KHUYEN_MAI km
		INNER JOIN NHAN_VIEN nv ON km.MA_NV = nv.MA_NV
		WHERE MA_KM = @MA_KM

END

-- EXEC [LAY_MOT_DOT_KHUYEN_MAI] @MA_KM = 'KM0000000000001'
GO
/****** Object:  StoredProcedure [dbo].[LAY_MOT_GIO_HANG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROC [dbo].[LAY_MOT_GIO_HANG] @ID_GH INT
AS
BEGIN
	SELECT GH.*, (SELECT KH.HO_TEN FROM dbo.KHACH_HANG KH WHERE MA_KH = GH.MA_KH) AS HO_TEN_KH 
		, (SELECT HO_TEN FROM dbo.NHAN_VIEN WHERE MA_NV = GH.MA_NV_DUYET) AS TEN_NV_DUYET
		, (SELECT HO_TEN FROM dbo.NHAN_VIEN WHERE MA_NV = GH.MA_NV_GIAO) AS TEN_NV_GIAO
		, dbo.[UDF_TRI_GIA_CUA_DH](@ID_GH) AS TONG_TRI_GIA
		, (SELECT SDT FROM dbo.NHAN_VIEN WHERE MA_NV = GH.MA_NV_GIAO) AS SDT_NV_GIAO
	FROM dbo.DON_HANG GH WHERE GH.ID_DH = @ID_GH
END
GO
/****** Object:  StoredProcedure [dbo].[LAY_MOT_KHACH_HANG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[LAY_MOT_KHACH_HANG] @MA_KH VARCHAR(15)
AS
BEGIN
        SELECT KHACH_HANG.* FROM KHACH_HANG
	WHERE MA_KH = @MA_KH
	
END;

GO
/****** Object:  StoredProcedure [dbo].[LAY_MOT_MAU]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[LAY_MOT_MAU] @MA_MAU VARCHAR(15) = NULL
AS
BEGIN
        SELECT BANG_MAU.*, NHAN_VIEN.HO_TEN AS HO_TEN_NV FROM BANG_MAU LEFT JOIN NHAN_VIEN ON BANG_MAU.MA_NV = NHAN_VIEN.MA_NV
		WHERE MA_MAU = @MA_MAU
END;
GO
/****** Object:  StoredProcedure [dbo].[LAY_MOT_NHAN_VIEN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[LAY_MOT_NHAN_VIEN] @MA_NV VARCHAR(15)
AS
BEGIN
        SELECT NHAN_VIEN.*, TAI_KHOAN.MA_QUYEN, QUYEN.TEN_QUYEN FROM NHAN_VIEN INNER JOIN TAI_KHOAN ON NHAN_VIEN.MA_TK = TAI_KHOAN.MA_TK
		INNER JOIN QUYEN ON QUYEN.MA_QUYEN = TAI_KHOAN.MA_QUYEN
	WHERE NHAN_VIEN.MA_NV = @MA_NV
		
END;

GO
/****** Object:  StoredProcedure [dbo].[LAY_MOT_PHIEU_NHAP]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[LAY_MOT_PHIEU_NHAP] @MA_PN VARCHAR(15)
AS
BEGIN

	SELECT @MA_PN AS MA_PN, pn.MA_NV, pn.GHI_CHU, pn.NGAY_TAO, 
		nv.HO_TEN AS HO_TEN_NV, 
		--(SELECT DISTINCT sp.MA_SP FROM CHI_TIET_PHIEU_NHAP ctpn INNER JOIN CHI_TIET_SAN_PHAM ctsp ON ctpn.MA_CT_SP = ctsp.MA_CT_SP
		--	INNER JOIN SAN_PHAM sp ON sp.MA_SP = ctsp.MA_SP WHERE ctpn.MA_PN = pn.MA_PN
		--) AS MA_SP,
		dbo.[UDF_LayMaCacSPTrongPN](PN.MA_PN) AS MA_SP,
		--(SELECT DISTINCT sp.TEN_SP FROM CHI_TIET_PHIEU_NHAP ctpn INNER JOIN CHI_TIET_SAN_PHAM ctsp ON ctpn.MA_CT_SP = ctsp.MA_CT_SP
		--	INNER JOIN SAN_PHAM sp ON sp.MA_SP = ctsp.MA_SP WHERE ctpn.MA_PN = pn.MA_PN
		--) AS TEN_SP,
		dbo.[UDF_LayTenCacSPTrongPN](PN.MA_PN) AS TEN_SP,
		(SELECT SUM(ctpn.GIA * ctpn.SO_LUONG) FROM CHI_TIET_PHIEU_NHAP ctpn WHERE ctpn.MA_PN = @MA_PN) AS TONG_GIA_NHAP,
		(SELECT SUM(ctpn.SO_LUONG) FROM CHI_TIET_PHIEU_NHAP ctpn WHERE ctpn.MA_PN = @MA_PN) AS TONG_SO_LUONG
		
		FROM PHIEU_NHAP pn INNER JOIN NHAN_VIEN nv ON pn.MA_NV = nv.MA_NV WHERE MA_PN = @MA_PN

END

-- EXEC [LAY_MOT_PHIEU_NHAP] @MA_PN = 'PN0000000000024'
GO
/****** Object:  StoredProcedure [dbo].[LAY_MOT_PHIEU_TRA]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[LAY_MOT_PHIEU_TRA] @MA_PT VARCHAR(15)
AS
BEGIN
SELECT @MA_PT AS MA_PT, pt.MA_NV, pt.GHI_CHU, pt.NGAY_TAO, 
		nv.HO_TEN AS HO_TEN_NV, kh.HO_TEN as HO_TEN_KH, kh.SDT as SDT_KH, gh.ID_DH, kh.MA_KH,
		(SELECT SUM(ctpt.SO_LUONG) FROM CHI_TIET_PHIEU_TRA ctpt WHERE ctpt.MA_PT = @MA_PT) AS TONG_SO_LUONG
		FROM PHIEU_TRA pt INNER JOIN NHAN_VIEN nv ON pt.MA_NV = nv.MA_NV
		INNER JOIN HOA_DON hd ON hd.MA_HD = pt.MA_HD
		INNER JOIN DON_HANG gh ON hd.ID_DH = gh.ID_DH
		INNER JOIn KHACH_HANG kh ON kh.MA_KH = gh.MA_KH
		WHERE pt.MA_PT = @MA_PT

END

-- EXEC [LAY_MOT_PHIEU_TRA] @MA_PT = 'PT0000000000001'
GO
/****** Object:  StoredProcedure [dbo].[LAY_MOT_SIZE]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[LAY_MOT_SIZE] @MA_SIZE VARCHAR(15) = NULL
AS
BEGIN
        SELECT BANG_SIZE.*, NHAN_VIEN.HO_TEN AS HO_TEN_NV FROM BANG_SIZE LEFT JOIN NHAN_VIEN ON BANG_SIZE.MA_NV = NHAN_VIEN.MA_NV
		WHERE MA_SIZE = @MA_SIZE
END;
GO
/****** Object:  StoredProcedure [dbo].[LAY_MOT_SP]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[LAY_MOT_SP] @productId VARCHAR(15)
AS
BEGIN
			SELECT S.*
				,TL.TEN_TL
				-- chỉ lấy phần trăm giảm nếu đợt khuyến mãi đó đang khuyến mãi (xem UDF_KiemTraDotKhuyenMaiDangKhuyenMai)
				, CASE WHEN dbo. UDF_KiemTraDotKhuyenMaiDangKhuyenMai(KM.MA_KM)=1 THEN CTKM.PHAN_TRAM_GIAM  ELSE NULL END as PHAN_TRAM_GIAM
				, dbo.UDF_LayStringGia(S.MA_SP) AS GIA_STR
				, dbo.UDF_LayStringGiaDaGiam(S.MA_SP) AS GIA_STR_DA_GIAM 
				, dbo.UDF_LayTongSoLuongTonCuaMotSP(S.MA_SP) AS TONG_SL_TON 
				, dbo.[UDF_LayTongSoDanhGiaCuaSanPham] (S.MA_SP) AS TONG_SO_LUOT_DANH_GIA
				, dbo.[UDF_LayTrungBinhSoSaoDanhGiaCuaSanPham] (S.MA_SP) AS DIEM_TRUNG_BINH
				FROM dbo.SAN_PHAM S LEFT JOIN (SELECT * FROM dbo.CHI_TIET_KHUYEN_MAI WHERE dbo. UDF_KiemTraDotKhuyenMaiDangKhuyenMai(MA_KM)=1) CTKM ON CTKM.MA_SP = S.MA_SP
								LEFT JOIN dbo.KHUYEN_MAI KM ON KM.MA_KM = CTKM.MA_KM 
								LEFT JOIN dbo.THE_LOAI TL ON TL.MA_TL = S.MA_TL
							
							WHERE S.MA_SP = @productId
							ORDER BY S.NGAY_TAO DESC
								
	
END

--EXEC [LAY_MOT_SP] 'SP0000000000023'
GO
/****** Object:  StoredProcedure [dbo].[LAY_NHAN_VIEN_VA_SO_DON_DANG_GIAO]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[LAY_NHAN_VIEN_VA_SO_DON_DANG_GIAO]
AS
BEGIN
	SELECT NV.*, dbo.[UDF_LaySoDonNhanVienDangGiao](NV.MA_NV) AS SO_GH_NV_DANG_GIAO FROM dbo.NHAN_VIEN NV INNER JOIN TAI_KHOAN TK ON NV.MA_TK = TK.MA_TK
	WHERE TK.MA_QUYEN = 'Q04' --AND NV.TRANG_THAI <> 0 --trang thai 0 la tai khoan dang bi vo hieu hoa
	ORDER BY SO_GH_NV_DANG_GIAO
END
GO
/****** Object:  StoredProcedure [dbo].[LAY_SP_BAN_CHAY_TRONG_N_THANG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[LAY_SP_BAN_CHAY_TRONG_N_THANG] @top INT = NULL, @n INT = NULL
AS
BEGIN
	IF(@top IS NULL)
	SET @top = (SELECT COUNT(*) FROM dbo.SAN_PHAM)

		BEGIN
			SELECT TOP(@top) S.*
				,TL.TEN_TL
				-- chỉ lấy phần trăm giảm nếu đợt khuyến mãi đó đang khuyến mãi (xem UDF_KiemTraDotKhuyenMaiDangKhuyenMai)
				, CASE WHEN dbo. UDF_KiemTraDotKhuyenMaiDangKhuyenMai(KM.MA_KM)=1 THEN CTKM.PHAN_TRAM_GIAM  ELSE NULL END as PHAN_TRAM_GIAM 
				, dbo.UDF_LayStringGia(S.MA_SP) AS GIA_STR
				, dbo.UDF_LayStringGiaDaGiam(S.MA_SP) AS GIA_STR_DA_GIAM
				, dbo.UDF_LayTongSoLuongTonCuaMotSP(S.MA_SP) AS TONG_SL_TON 
				, dbo.[UDF_TONG_SL_MUA_CUA_SP_TRONG_N_THANG_GAN_NHAT](S.MA_SP, @n) AS TONG_SL_DA_BAN
				FROM dbo.SAN_PHAM S
				LEFT JOIN (SELECT * FROM dbo.CHI_TIET_KHUYEN_MAI WHERE dbo. UDF_KiemTraDotKhuyenMaiDangKhuyenMai(MA_KM)=1) CTKM ON CTKM.MA_SP = S.MA_SP
								LEFT JOIN dbo.KHUYEN_MAI KM ON KM.MA_KM = CTKM.MA_KM 
								LEFT JOIN dbo.THE_LOAI TL ON TL.MA_TL = S.MA_TL ORDER BY TONG_SL_DA_BAN DESC, S.NGAY_TAO DESC
		END
	
END
GO
/****** Object:  StoredProcedure [dbo].[LAY_SP_DANG_KHUYEN_MAI]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[LAY_SP_DANG_KHUYEN_MAI] @top INT = NULL
AS
BEGIN
	IF(@top IS NULL)
	SET @top = (SELECT COUNT(*) FROM dbo.SAN_PHAM)
			SELECT TOP(@top) S.*,
				CTKM.PHAN_TRAM_GIAM,
				TL.TEN_TL,
				dbo.UDF_LayStringGia(S.MA_SP) AS GIA_STR,
				dbo.UDF_LayStringGiaDaGiam(S.MA_SP) AS GIA_STR_DA_GIAM,
				dbo.UDF_LayTongSoLuongTonCuaMotSP(S.MA_SP) AS TONG_SL_TON 

			FROM
				(SELECT * FROM dbo.KHUYEN_MAI KM WHERE dbo.UDF_KiemTraDotKhuyenMaiDangKhuyenMai(KM.MA_KM)=1) AS KM 
					INNER JOIN dbo.CHI_TIET_KHUYEN_MAI CTKM ON CTKM.MA_KM = KM.MA_KM
					INNER JOIN dbo.SAN_PHAM S ON S.MA_SP = CTKM.MA_SP
					LEFT JOIN dbo.THE_LOAI TL ON TL.MA_TL = S.MA_TL
			ORDER BY CTKM.PHAN_TRAM_GIAM DESC
END
GO
/****** Object:  StoredProcedure [dbo].[LAY_SP_MOI_VE]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[LAY_SP_MOI_VE] @top INT = NULL
AS
BEGIN
	IF(@top IS NULL)
	SET @top = (SELECT COUNT(*) FROM dbo.SAN_PHAM)

		BEGIN
			SELECT TOP(@top) S.*
				,TL.TEN_TL
				-- chỉ lấy phần trăm giảm nếu đợt khuyến mãi đó đang khuyến mãi (xem UDF_KiemTraDotKhuyenMaiDangKhuyenMai)
				, CASE WHEN dbo. UDF_KiemTraDotKhuyenMaiDangKhuyenMai(KM.MA_KM)=1 THEN CTKM.PHAN_TRAM_GIAM  ELSE NULL END as PHAN_TRAM_GIAM 
				, dbo.UDF_LayStringGia(S.MA_SP) AS GIA_STR
				, dbo.UDF_LayStringGiaDaGiam(S.MA_SP) AS GIA_STR_DA_GIAM
				, dbo.UDF_LayTongSoLuongTonCuaMotSP(S.MA_SP) AS TONG_SL_TON 
				FROM dbo.SAN_PHAM S
				LEFT JOIN (SELECT * FROM dbo.CHI_TIET_KHUYEN_MAI WHERE dbo. UDF_KiemTraDotKhuyenMaiDangKhuyenMai(MA_KM)=1) CTKM ON CTKM.MA_SP = S.MA_SP
								LEFT JOIN dbo.KHUYEN_MAI KM ON KM.MA_KM = CTKM.MA_KM 
								LEFT JOIN dbo.THE_LOAI TL ON TL.MA_TL = S.MA_TL
								ORDER BY S.NGAY_TAO DESC
		END
	
END


--EXEC [LAY_SP_MOI_VE]
GO
/****** Object:  StoredProcedure [dbo].[LAY_SP_THEO_THE_LOAI]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[LAY_SP_THEO_THE_LOAI] @top INT = NULL, @MA_TL VARCHAR(15)=NULL
AS
BEGIN
	IF(@top IS NULL)
	SET @top = (SELECT COUNT(*) FROM dbo.SAN_PHAM)
		
		BEGIN
			SELECT TOP(@top) S.*,
				TL.TEN_TL
				,TL.TEN_TL-- chỉ lấy phần trăm giảm nếu đợt khuyến mãi đó đang khuyến mãi (xem UDF_KiemTraDotKhuyenMaiDangKhuyenMai)
				,CASE WHEN dbo. UDF_KiemTraDotKhuyenMaiDangKhuyenMai(KM.MA_KM)=1 THEN CTKM.PHAN_TRAM_GIAM  ELSE NULL END as PHAN_TRAM_GIAM
				,dbo.UDF_LayStringGia(S.MA_SP) AS GIA_STR,
				dbo.UDF_LayStringGiaDaGiam(S.MA_SP) AS GIA_STR_DA_GIAM 
				, dbo.UDF_LayTongSoLuongTonCuaMotSP(S.MA_SP) AS TONG_SL_TON 
			FROM dbo.SAN_PHAM S LEFT JOIN (SELECT * FROM dbo.CHI_TIET_KHUYEN_MAI WHERE dbo. UDF_KiemTraDotKhuyenMaiDangKhuyenMai(MA_KM)=1) CTKM ON CTKM.MA_SP = S.MA_SP
								LEFT JOIN dbo.KHUYEN_MAI KM ON KM.MA_KM = CTKM.MA_KM 
								INNER JOIN (SELECT DISTINCT * FROM dbo.THE_LOAI WHERE MA_TL = @MA_TL OR MA_TL_CHA = @MA_TL) TL ON TL.MA_TL = S.MA_TL 
								 ORDER BY s.NGAY_TAO DESC
		END
	
END
-- EXEC [LAY_SP_THEO_THE_LOAI] @MA_TL='TL13'
GO
/****** Object:  StoredProcedure [dbo].[LAY_SP_XEM_NHIEU]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[LAY_SP_XEM_NHIEU] @top INT = NULL
AS
BEGIN
	IF(@top IS NULL)
	SET @top = (SELECT COUNT(*) FROM dbo.SAN_PHAM)
		
		BEGIN
			SELECT TOP(@top) S.*,
				TL.TEN_TL
				,TL.TEN_TL-- chỉ lấy phần trăm giảm nếu đợt khuyến mãi đó đang khuyến mãi (xem UDF_KiemTraDotKhuyenMaiDangKhuyenMai)
				,CASE WHEN dbo. UDF_KiemTraDotKhuyenMaiDangKhuyenMai(KM.MA_KM)=1 THEN CTKM.PHAN_TRAM_GIAM  ELSE NULL END as PHAN_TRAM_GIAM
				,dbo.UDF_LayStringGia(S.MA_SP) AS GIA_STR,
				dbo.UDF_LayStringGiaDaGiam(S.MA_SP) AS GIA_STR_DA_GIAM 
				, dbo.UDF_LayTongSoLuongTonCuaMotSP(S.MA_SP) AS TONG_SL_TON 
			FROM dbo.SAN_PHAM S LEFT JOIN (SELECT * FROM dbo.CHI_TIET_KHUYEN_MAI WHERE dbo. UDF_KiemTraDotKhuyenMaiDangKhuyenMai(MA_KM)=1) CTKM ON CTKM.MA_SP = S.MA_SP
								LEFT JOIN dbo.KHUYEN_MAI KM ON KM.MA_KM = CTKM.MA_KM 
								LEFT JOIN dbo.THE_LOAI TL ON TL.MA_TL = S.MA_TL ORDER BY s.LUOT_XEM DESC
		END
	
END
-- EXEC [LAY_SP_XEM_NHIEU]
GO
/****** Object:  StoredProcedure [dbo].[LAY_TAT_CA_DANH_GIA_CUA_SAN_PHAM]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[LAY_TAT_CA_DANH_GIA_CUA_SAN_PHAM] @MA_SP VARCHAR(15)
AS
BEGIN
	SELECT dgsp.*, kh.HO_TEN as TEN_KH, kh.EMAIL FROM DANH_GIA_SAN_PHAM dgsp INNER JOIN CHI_TIET_DON_HANG ctgh 
	ON dgsp.MA_CT_DH = ctgh.MA_CT_DH
	INNER JOIN DON_HANG gh ON ctgh.ID_DH = gh.ID_DH
	INNER JOIN CHI_TIET_SAN_PHAM ctsp ON ctgh.MA_CT_SP = ctsp.MA_CT_SP
	INNER JOIN KHACH_HANG kh ON dgsp.MA_KH = kh.MA_KH
		WHERE ctsp.MA_SP = @MA_SP AND gh.TRANG_THAI = 2
		ORDER BY dgsp.NGAY_DANH_GIA DESC
END


--EXEC LAY_TAT_CA_DANH_GIA_CUA_SAN_PHAM 'SP0000000000023'
GO
/****** Object:  StoredProcedure [dbo].[LAY_TAT_CA_DOT_KHUYEN_MAI]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[LAY_TAT_CA_DOT_KHUYEN_MAI]
AS
BEGIN

	SELECT km.MA_KM, km.MA_NV, km.GHI_CHU, km.NGAY_TAO, km.NGAY_AP_DUNG,
		nv.HO_TEN AS HO_TEN_NV, km.THOI_GIAN, km.TRANG_THAI,
		dbo.[UDF_LayMaCacSPTrongDotKM](km.MA_KM) AS MA_CAC_SP,
		dbo.UDF_KiemTraDotKhuyenMaiDangKhuyenMai(km.MA_KM) AS DANG_KHUYEN_MAI,
		(SELECT COUNT (*) FROM CHI_TIET_KHUYEN_MAI ctkm2 WHERE ctkm2.MA_KM = km.MA_KM) AS SO_LUONG_SP
		
		FROM KHUYEN_MAI km
		INNER JOIN NHAN_VIEN nv ON km.MA_NV = nv.MA_NV
ORDER BY km.NGAY_TAO DESC
END

-- EXEC [LAY_TAT_CA_DOT_KHUYEN_MAI]
GO
/****** Object:  StoredProcedure [dbo].[LAY_TAT_CA_GIO_HANG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[LAY_TAT_CA_GIO_HANG] @TRANG_THAI INT
AS
BEGIN
    IF @TRANG_THAI = -2
    BEGIN
        SELECT GH.*, KH.HO_TEN AS HO_TEN_KH, KH.SDT AS SDT_KH, KH.EMAIL AS EMAIL_KH, 
		(SELECT HO_TEN FROM NHAN_VIEN WHERE MA_NV=GH.MA_NV_DUYET) AS TEN_NV_DUYET,
		(SELECT HO_TEN FROM NHAN_VIEN WHERE MA_NV=GH.MA_NV_GIAO) AS TEN_NV_GIAO
        FROM dbo.DON_HANG GH INNER JOIN dbo.KHACH_HANG KH ON GH.MA_KH = KH.MA_KH
		 WHERE GH.TRANG_THAI <> -99
		ORDER BY NGAY_TAO DESC;
    END;
    ELSE
    BEGIN
         SELECT GH.*, KH.HO_TEN AS HO_TEN_KH, KH.SDT AS SDT_KH, KH.EMAIL AS EMAIL_KH,
		 (SELECT HO_TEN FROM NHAN_VIEN WHERE MA_NV = GH.MA_NV_DUYET) AS TEN_NV_DUYET,
		(SELECT HO_TEN FROM NHAN_VIEN WHERE MA_NV = GH.MA_NV_GIAO) AS TEN_NV_GIAO
        FROM dbo.DON_HANG GH INNER JOIN dbo.KHACH_HANG KH ON GH.MA_KH = KH.MA_KH
		
        WHERE GH.TRANG_THAI = @TRANG_THAI
		ORDER BY NGAY_TAO DESC;
    END;
END;

GO
/****** Object:  StoredProcedure [dbo].[LAY_TAT_CA_GIO_HANG_CUA_KH]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[LAY_TAT_CA_GIO_HANG_CUA_KH] @TRANG_THAI INT, @MA_KH VARCHAR(15)
AS
BEGIN
    IF @TRANG_THAI = -2
    BEGIN
       SELECT GH.*, KH.HO_TEN AS HO_TEN_KH, KH.SDT AS SDT_KH, KH.EMAIL AS EMAIL_KH, 
		(SELECT HO_TEN FROM NHAN_VIEN WHERE MA_NV=GH.MA_NV_DUYET) AS TEN_NV_DUYET,
		(SELECT HO_TEN FROM NHAN_VIEN WHERE MA_NV=GH.MA_NV_GIAO) AS TEN_NV_GIAO
        FROM dbo.DON_HANG GH INNER JOIN dbo.KHACH_HANG KH ON GH.MA_KH = KH.MA_KH
		WHERE GH.MA_KH = @MA_KH AND GH.TRANG_THAI <> -99
		ORDER BY NGAY_TAO DESC;
    END;
    ELSE
    BEGIN
        SELECT GH.*, KH.HO_TEN AS HO_TEN_KH, KH.SDT AS SDT_KH, KH.EMAIL AS EMAIL_KH, 
		(SELECT HO_TEN FROM NHAN_VIEN WHERE MA_NV=GH.MA_NV_DUYET) AS TEN_NV_DUYET,
		(SELECT HO_TEN FROM NHAN_VIEN WHERE MA_NV=GH.MA_NV_GIAO) AS TEN_NV_GIAO
        FROM dbo.DON_HANG GH INNER JOIN dbo.KHACH_HANG KH ON GH.MA_KH = KH.MA_KH
        WHERE GH.TRANG_THAI = @TRANG_THAI AND GH.MA_KH = @MA_KH ORDER BY NGAY_TAO DESC;
    END;
END;

GO
/****** Object:  StoredProcedure [dbo].[LAY_TAT_CA_GIO_HANG_NV_DANG_GIAO]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[LAY_TAT_CA_GIO_HANG_NV_DANG_GIAO] @MANV_GIAO VARCHAR(15)
AS
BEGIN
        SELECT GH.*, KH.HO_TEN AS HO_TEN_KH, KH.SDT AS SDT_KH, KH.EMAIL AS EMAIL_KH  
        FROM (SELECT TOP((SELECT COUNT (*) FROM DON_HANG)) * FROM dbo.DON_HANG  ORDER BY ID_DH DESC) GH INNER JOIN dbo.KHACH_HANG KH ON GH.MA_KH = KH.MA_KH
        WHERE (GH.TRANG_THAI = 1 
		--OR GH.TRANG_THAI = 2
		) 
		AND MA_NV_GIAO = @MANV_GIAO --ORDER BY TRANG_THAI ASC, NGAY_TAO DESC --quan trọng: not and or
		UNION ALL
		 SELECT GH.*, KH.HO_TEN AS HO_TEN_KH, KH.SDT AS SDT_KH, KH.EMAIL AS EMAIL_KH  
        FROM dbo.DON_HANG GH INNER JOIN dbo.KHACH_HANG KH ON GH.MA_KH = KH.MA_KH
        WHERE (GH.TRANG_THAI = 2 
		--OR GH.TRANG_THAI = 2
		) 
		AND MA_NV_GIAO = @MANV_GIAO --ORDER BY TRANG_THAI ASC, NGAY_TAO DESC --quan trọng: not and or
		UNION ALL
		SELECT GH.*, KH.HO_TEN AS HO_TEN_KH, KH.SDT AS SDT_KH, KH.EMAIL AS EMAIL_KH  
        FROM dbo.DON_HANG GH INNER JOIN dbo.KHACH_HANG KH ON GH.MA_KH = KH.MA_KH
        WHERE (GH.TRANG_THAI = -1) AND MA_NV_GIAO = @MANV_GIAO --ORDER BY TRANG_THAI ASC, NGAY_TAO DESC --quan trọng: not and or
		
END;

--EXEC [LAY_TAT_CA_GIO_HANG_NV_DANG_GIAO] 'NV02'
GO
/****** Object:  StoredProcedure [dbo].[LAY_TAT_CA_KHACH_HANG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[LAY_TAT_CA_KHACH_HANG]
AS
BEGIN
        SELECT KHACH_HANG.* FROM KHACH_HANG
	
		ORDER BY NGAY_TAO DESC;
END;

GO
/****** Object:  StoredProcedure [dbo].[LAY_TAT_CA_KHACH_HANG_TUNG_MUA_HANG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[LAY_TAT_CA_KHACH_HANG_TUNG_MUA_HANG]
AS
BEGIN
	SELECT kh.MA_KH, kh.HO_TEN, kh.SDT, kh.EMAIL, kh.DIA_CHI FROM KHACH_HANG kh WHERE kh.MA_KH IN (SELECT MA_KH FROM DON_HANG WHERE ID_DH <> -99)
END
GO
/****** Object:  StoredProcedure [dbo].[LAY_TAT_CA_MAU]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[LAY_TAT_CA_MAU]
AS
BEGIN
        SELECT BANG_MAU.*, NHAN_VIEN.HO_TEN AS HO_TEN_NV FROM BANG_MAU LEFT JOIN NHAN_VIEN ON BANG_MAU.MA_NV = NHAN_VIEN.MA_NV
	
		ORDER BY NGAY_TAO DESC;
END;

GO
/****** Object:  StoredProcedure [dbo].[LAY_TAT_CA_NHAN_VIEN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[LAY_TAT_CA_NHAN_VIEN]
AS
BEGIN
        SELECT NHAN_VIEN.*, TAI_KHOAN.MA_QUYEN, QUYEN.TEN_QUYEN FROM NHAN_VIEN INNER JOIN TAI_KHOAN ON NHAN_VIEN.MA_TK = TAI_KHOAN.MA_TK
		INNER JOIN QUYEN ON QUYEN.MA_QUYEN = TAI_KHOAN.MA_QUYEN
	
		ORDER BY NGAY_TAO DESC;
END;

GO
/****** Object:  StoredProcedure [dbo].[LAY_TAT_CA_PHIEU_NHAP]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[LAY_TAT_CA_PHIEU_NHAP]
AS
BEGIN

	SELECT pn.MA_PN, pn.MA_NV, pn.GHI_CHU, pn.NGAY_TAO, 
		nv.HO_TEN AS HO_TEN_NV, 
		--(SELECT DISTINCT sp.MA_SP FROM CHI_TIET_PHIEU_NHAP ctpn INNER JOIN CHI_TIET_SAN_PHAM ctsp ON ctpn.MA_CT_SP = ctsp.MA_CT_SP
		--	INNER JOIN SAN_PHAM sp ON sp.MA_SP = ctsp.MA_SP WHERE ctpn.MA_PN = pn.MA_PN
		--) AS MA_SP,
		dbo.[UDF_LayMaCacSPTrongPN](PN.MA_PN) AS MA_SP,
		--(SELECT DISTINCT sp.TEN_SP FROM CHI_TIET_PHIEU_NHAP ctpn INNER JOIN CHI_TIET_SAN_PHAM ctsp ON ctpn.MA_CT_SP = ctsp.MA_CT_SP
		--	INNER JOIN SAN_PHAM sp ON sp.MA_SP = ctsp.MA_SP WHERE ctpn.MA_PN = pn.MA_PN
		--) AS TEN_SP,
		dbo.[UDF_LayTenCacSPTrongPN](PN.MA_PN) AS TEN_SP,
		(SELECT SUM(ctpn.GIA * ctpn.SO_LUONG) FROM CHI_TIET_PHIEU_NHAP ctpn WHERE ctpn.MA_PN = pn.MA_PN) AS TONG_GIA_NHAP,
		(SELECT SUM(ctpn.SO_LUONG) FROM CHI_TIET_PHIEU_NHAP ctpn WHERE ctpn.MA_PN = pn.MA_PN) AS TONG_SO_LUONG
		
		FROM PHIEU_NHAP pn INNER JOIN NHAN_VIEN nv ON pn.MA_NV = nv.MA_NV
ORDER BY pn.NGAY_TAO DESC
END

-- EXEC LAY_TAT_CA_PHIEU_NHAP
GO
/****** Object:  StoredProcedure [dbo].[LAY_TAT_CA_PHIEU_TRA]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[LAY_TAT_CA_PHIEU_TRA]
AS
BEGIN

	SELECT pt.MA_PT, pt.MA_NV, pt.GHI_CHU, pt.NGAY_TAO, 
		nv.HO_TEN AS HO_TEN_NV, kh.HO_TEN as HO_TEN_KH, kh.SDT as SDT_KH, gh.ID_DH, kh.MA_KH,
		(SELECT SUM(ctpt.SO_LUONG) FROM CHI_TIET_PHIEU_TRA ctpt WHERE ctpt.MA_PT = pt.MA_PT) AS TONG_SO_LUONG
		FROM PHIEU_TRA pt INNER JOIN NHAN_VIEN nv ON pt.MA_NV = nv.MA_NV
		INNER JOIN HOA_DON hd ON hd.MA_HD = pt.MA_HD
		INNER JOIN DON_HANG gh ON hd.ID_DH = gh.ID_DH
		INNER JOIn KHACH_HANG kh ON kh.MA_KH = gh.MA_KH
		ORDER BY pt.NGAY_TAO DESC
END

-- EXEC [LAY_TAT_CA_PHIEU_TRA]
GO
/****** Object:  StoredProcedure [dbo].[LAY_TAT_CA_QUYEN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[LAY_TAT_CA_QUYEN]
AS
BEGIN
        SELECT QUYEN.* FROM QUYEN

END;

GO
/****** Object:  StoredProcedure [dbo].[LAY_TAT_CA_SIZE]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[LAY_TAT_CA_SIZE]
AS
BEGIN
        SELECT BANG_SIZE.*, NHAN_VIEN.HO_TEN AS HO_TEN_NV FROM BANG_SIZE LEFT JOIN NHAN_VIEN ON BANG_SIZE.MA_NV = NHAN_VIEN.MA_NV
	
		ORDER BY NGAY_TAO DESC;
END;

GO
/****** Object:  StoredProcedure [dbo].[LAY_TAT_CA_SP]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[LAY_TAT_CA_SP] @top INT = NULL
AS
BEGIN
	IF(@top IS NULL)
	SET @top = (SELECT COUNT(*) FROM dbo.SAN_PHAM)
	
		BEGIN
			SELECT TOP(@top) S.*, TL.TEN_TL,
			dbo.UDF_LayStringGia(S.MA_SP) AS GIA_STR
				,dbo.UDF_LayStringGiaDaGiam(S.MA_SP) AS GIA_STR_DA_GIAM 
				, dbo.UDF_LayTongSoLuongTonCuaMotSP(S.MA_SP) AS TONG_SL_TON 
        ,dbo.UDF_LayStringSize(S.MA_SP) AS SIZE_STR
			FROM dbo.SAN_PHAM S LEFT JOIN dbo.THE_LOAI TL ON TL.MA_TL = S.MA_TL
			ORDER BY NGAY_TAO DESC
		END
	
END

-- EXEC LAY_TAT_CA_SP 10

GO
/****** Object:  StoredProcedure [dbo].[LAY_TAT_CA_THAY_DOI_GIA]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[LAY_TAT_CA_THAY_DOI_GIA]
AS
BEGIN

	SELECT tdg.MA_NV, tdg.NGAY_THAY_DOI, tdg.MA_CT_SP, tdg.GIA AS GIA_THAY_DOI,
		nv.HO_TEN AS HO_TEN_NV, sp.MA_SP, sp.TEN_SP, bm.MA_MAU, bm.TEN_MAU, bs.MA_SIZE, bs.TEN_SIZE,
		(SELECT TOP(1) tdg2.GIA FROM THAY_DOI_GIA tdg2 WHERE tdg2.NGAY_THAY_DOI < tdg.NGAY_THAY_DOI AND tdg2.MA_CT_SP = tdg.MA_CT_SP ORDER BY tdg2.NGAY_THAY_DOI DESC) AS GIA -- đây là giá trước thay đổi
		FROM THAY_DOI_GIA tdg INNER JOIN NHAN_VIEN nv ON tdg.MA_NV = nv.MA_NV
		INNER JOIN CHI_TIET_SAN_PHAM ctsp ON ctsp.MA_CT_SP = tdg.MA_CT_SP
		INNER JOIN SAN_PHAM sp ON sp.MA_SP = ctsp.MA_SP
		INNER JOIN BANG_MAU bm ON ctsp.MA_MAU = bm.MA_MAU
		INNER JOIN BANG_SIZE bs ON ctsp.MA_SIZE = bs.MA_SIZE
ORDER BY tdg.NGAY_THAY_DOI DESC
END

-- EXEC LAY_TAT_CA_THAY_DOI_GIA
GO
/****** Object:  StoredProcedure [dbo].[LAY_THONG_TIN_THONG_KE_TONG_QUAN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[LAY_THONG_TIN_THONG_KE_TONG_QUAN]
AS
BEGIN
	SELECT (SELECT COUNT(*) FROM SAN_PHAM) AS TONG_SO_SP 
	,(SELECT COUNT(*) FROM DON_HANG) AS TONG_SO_GH
	,(SELECT SUM(dbo.UDF_TRI_GIA_CUA_DH(DON_HANG.ID_DH)) FROM DON_HANG WHERE TRANG_THAI<>-1 AND TRANG_THAI <> -99) AS TONG_DOANH_THU
	,(SELECT COUNT(*) FROM KHACH_HANG) AS TONG_SO_KH
	,(SELECT COUNT(*) FROM DON_HANG WHERE TRANG_THAI = 0) AS TONG_SO_GH_CHUA_DUYET
END;
GO
/****** Object:  StoredProcedure [dbo].[LAY_TI_GIA_HIEN_TAI]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[LAY_TI_GIA_HIEN_TAI]
AS
BEGIN
		SELECT TOP(1) TI_GIA FROM TI_GIA ORDER BY NGAY_AP_DUNG DESC
END
GO
/****** Object:  StoredProcedure [dbo].[NHAN_VIEN_DOI_MAT_KHAU]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[NHAN_VIEN_DOI_MAT_KHAU] @password VARCHAR(MAX), @maNhanVien varchar(15)
AS
BEGIN
	UPDATE TAI_KHOAN SET MAT_KHAU = @password WHERE MA_TK = (SELECT MA_TK FROM NHAN_VIEN WHERE MA_NV=@maNhanVien)
	SELECT NV.*, TK.MA_QUYEN, TK.MAT_KHAU, Q.TEN_QUYEN FROM dbo.NHAN_VIEN NV 
	INNER JOIN dbo.TAI_KHOAN TK ON TK.MA_TK = NV.MA_TK
	INNER JOIN dbo.QUYEN Q ON Q.MA_QUYEN = TK.MA_QUYEN 
		WHERE NV.MA_NV = @maNhanVien
END
GO
/****** Object:  StoredProcedure [dbo].[NHAN_VIEN_LOGIN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[NHAN_VIEN_LOGIN] @email VARCHAR(50), @password VARCHAR(MAX)
AS
BEGIN
	SELECT NV.*, TK.MA_QUYEN, TK.MAT_KHAU, Q.TEN_QUYEN FROM dbo.NHAN_VIEN NV 
	INNER JOIN dbo.TAI_KHOAN TK ON TK.MA_TK = NV.MA_TK
	INNER JOIN dbo.QUYEN Q ON Q.MA_QUYEN = TK.MA_QUYEN 
		WHERE NV.EMAIL = @email --AND TK.MAT_KHAU = @password
END
GO
/****** Object:  StoredProcedure [dbo].[RESET_MAT_KHAU_NHAN_VIEN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[RESET_MAT_KHAU_NHAN_VIEN] @password VARCHAR(MAX), @maNhanVien varchar(15)
AS
BEGIN
	DECLARE @errorMessage NVARCHAR(500) = N''
	DECLARE @responseMessage NVARCHAR(500) = N''

	BEGIN TRANSACTION
	UPDATE TAI_KHOAN SET MAT_KHAU = @password WHERE MA_TK = (SELECT MA_TK FROM NHAN_VIEN WHERE MA_NV=@maNhanVien)
	IF @@ERROR <>0
			GOTO ABORT
	COMMIT TRANSACTION
	SELECT @maNhanVien AS affectedId, N'Reset mật khẩu tài khoản nhân viên '+ @maNhanVien  +N' thành công' AS responseMessage
	ABORT:
		ROLLBACK TRANSACTION
		SELECT '' AS affectedId, @errorMessage AS errorDesc, @responseMessage AS responseMessage
END
GO
/****** Object:  StoredProcedure [dbo].[SUA_KHUYEN_MAI]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
--exec SUA_KHUYEN_MAI @MA_KM='KM0001',@GHI_CHU=N'KM',@MA_NV='NV01',@NGAY_AP_DUNG='2023-04-18 09:30:00',@THOI_GIAN=90,@xml_LIST_CHI_TIET_KM_STR=N'<?xml version="1.0"?>
--<ArrayOfCHI_TIET_KHUYEN_MAI_ENTITY xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <CHI_TIET_KHUYEN_MAI_ENTITY>
--    <MA_KM>KM0001</MA_KM>
--    <MA_SP>SP0000000000001</MA_SP>
--    <PHAN_TRAM_GIAM>20</PHAN_TRAM_GIAM>
--  </CHI_TIET_KHUYEN_MAI_ENTITY>
--  <CHI_TIET_KHUYEN_MAI_ENTITY>
--    <MA_KM>KM0001</MA_KM>
--    <MA_SP>SP0000000000002</MA_SP>
--    <PHAN_TRAM_GIAM>20</PHAN_TRAM_GIAM>
--  </CHI_TIET_KHUYEN_MAI_ENTITY>
--  <CHI_TIET_KHUYEN_MAI_ENTITY>
--    <MA_KM>KM0001</MA_KM>
--    <MA_SP>SP0000000000014</MA_SP>
--    <PHAN_TRAM_GIAM>15</PHAN_TRAM_GIAM>
--  </CHI_TIET_KHUYEN_MAI_ENTITY>
--</ArrayOfCHI_TIET_KHUYEN_MAI_ENTITY>'
--go
-- =============================================
CREATE   PROCEDURE [dbo].[SUA_KHUYEN_MAI]
@MA_KM varchar(15)
	 ,@GHI_CHU NVARCHAR(1000) = NULL
	,@MA_NV VARCHAR(15)
	,@NGAY_AP_DUNG DATETIME
	,@THOI_GIAN INT
	,@xml_LIST_CHI_TIET_KM_STR NVARCHAR(MAX)
AS
BEGIN
	BEGIN TRANSACTION
		DECLARE @dateBegin DATETIME = @NGAY_AP_DUNG
		DECLARE @dateEnd DATETIME = DATEADD(DAY, @THOI_GIAN, @dateBegin)
		DECLARE @errorMessage NVARCHAR(max) = ''

		DECLARE @maKmChongCheo VARCHAR(MAX) = ''

		IF EXISTS(
		SELECT * FROM KHUYEN_MAI 
				WHERE 
				(((@dateBegin BETWEEN NGAY_AP_DUNG AND (DATEADD(DAY,THOI_GIAN, NGAY_AP_DUNG))) 
					OR (@dateEnd BETWEEN NGAY_AP_DUNG AND (DATEADD(DAY, THOI_GIAN, NGAY_AP_DUNG)))) AND TRANG_THAI = 1)AND MA_KM <> @MA_KM) 
				BEGIN
					SELECT @maKmChongCheo = @maKmChongCheo + MA_KM + ', ' FROM KHUYEN_MAI 
					WHERE (((@dateBegin BETWEEN NGAY_AP_DUNG AND (DATEADD(DAY,THOI_GIAN, NGAY_AP_DUNG)))
					OR (@dateEnd BETWEEN NGAY_AP_DUNG AND (DATEADD(DAY, THOI_GIAN, NGAY_AP_DUNG)))) AND TRANG_THAI = 1) AND MA_KM <> @MA_KM
					
					SET @maKmChongCheo = @maKmChongCheo + 'end'

					SET @maKmChongCheo = REPLACE(@maKmChongCheo, ', end', '')

					SET @errorMessage = 
					N'Khoảng thời gian áp dụng bạn đã chọn chồng chéo với (các) đợt khuyến mãi có mã sau: ' + @maKmChongCheo

					GOTO ABORT_THOI_GIAN
				END
		
		--DECLARE @MA_KM_MOI VARCHAR(15)
		--EXEC GEN_CODE @tableName = 'KHUYEN_MAI', @prefix = 'KM', @result = @MA_KM_MOI OUTPUT
		
		-- chỉnh sửa vào bảng khuyến mãi
			UPDATE KHUYEN_MAI SET GHI_CHU=@GHI_CHU, MA_NV=@MA_NV, NGAY_TAO=GETDATE(), NGAY_AP_DUNG=@NGAY_AP_DUNG, THOI_GIAN=@THOI_GIAN
				WHERE MA_KM = @MA_KM
		
				IF @@ERROR <> 0
				GOTO ABORT

			DELETE FROM CHI_TIET_KHUYEN_MAI WHERE MA_KM = @MA_KM
				IF @@ERROR <> 0
				GOTO ABORT

		-- xử lý xml list chi tiết khuyến mãi
		DECLARE @XML_LIST_CHI_TIET_KM XML = CAST(@xml_LIST_CHI_TIET_KM_STR AS XML) ;

		DECLARE @idoc_CTSP int
		--Create an internal representation of the XML document.
		EXEC sp_xml_preparedocument @idoc_CTSP OUTPUT, @XML_LIST_CHI_TIET_KM;
		-- Execute a SELECT statement that uses the OPENXML rowset provider.
		--SELECT    *
		--FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
		--            WITH (
		--				MA_MAU		VARCHAR(15),
		--				HINH_ANH	NVARCHAR(400)
		--			);

		DECLARE @ctsp_MA_SP VARCHAR(15), @ctsp_PHAN_TRAM_GIAM INT

		DECLARE cur_CTSP CURSOR FOR
			SELECT *
			FROM OPENXML (@idoc_CTSP, '/ArrayOfCHI_TIET_KHUYEN_MAI_ENTITY/CHI_TIET_KHUYEN_MAI_ENTITY',2)
					WITH (
						MA_SP VARCHAR(15),
						PHAN_TRAM_GIAM INT
					);

		OPEN cur_CTSP

		FETCH NEXT FROM cur_CTSP
		INTO @ctsp_MA_SP, @ctsp_PHAN_TRAM_GIAM

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO CHI_TIET_KHUYEN_MAI(MA_KM, MA_SP, PHAN_TRAM_GIAM) 
				VALUES (@MA_KM, @ctsp_MA_SP, @ctsp_PHAN_TRAM_GIAM);
			IF @@ERROR <> 0
				GOTO ABORT

			--PRINT(@ctsp_MA_CT_SP + ', ' + @ctsp_SO_LUONG +',' + @ctsp_GIA)
			FETCH NEXT FROM cur_CTSP
			INTO @ctsp_MA_SP, @ctsp_PHAN_TRAM_GIAM
		END

		CLOSE cur_CTSP;
		DEALLOCATE cur_CTSP;
		--end xử lý xml list chi tiet san pham

	COMMIT TRANSACTION

	SELECT @MA_KM AS affectedId, '' AS errorDesc, 'OK' AS responseMessage 
	
	ABORT:
		ROLLBACK TRANSACTION

		CLOSE cur_CTSP;
		DEALLOCATE cur_CTSP;
		SELECT '' AS affectedId, @@ERROR AS errorDesc, N'Tạo đợt khuyến mãi không thành công' AS responseMessage 

	ABORT_THOI_GIAN:
		ROLLBACK TRANSACTION
		SELECT '' AS affectedId, 'SAI_THOI_GIAN' AS errorDesc, @errorMessage AS responseMessage 
END

--DECLARE @XML_STR NVARCHAR(MAX) = '<?xml version="1.0"?>
--<ArrayOfHINH_ANH_SAN_PHAM_ENTITY xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <HINH_ANH_SAN_PHAM_ENTITY>
--    <MA_MAU>M01</MA_MAU>
--    <HINH_ANH>images3.jpg</HINH_ANH>
--  </HINH_ANH_SAN_PHAM_ENTITY>
--</ArrayOfHINH_ANH_SAN_PHAM_ENTITY>'

--DECLARE @XML XML = CAST(@XML_STR AS XML) ;

--DECLARE @tempTable TABLE
--(
--	MA_MAU		VARCHAR(15),
--	HINH_ANH	NVARCHAR(400)
--)
--DECLARE @idoc int
----Create an internal representation of the XML document.
--EXEC sp_xml_preparedocument @idoc OUTPUT, @XML;
---- Execute a SELECT statement that uses the OPENXML rowset provider.
----SELECT    *
----FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
----            WITH (
----				MA_MAU		VARCHAR(15),
----				HINH_ANH	NVARCHAR(400)
----			);

--DECLARE @MA_MAU VARCHAR(15), @HINH_ANH NVARCHAR(400)

--DECLARE cur CURSOR FOR
--	SELECT    *
--	FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
--            WITH (
--				MA_MAU		VARCHAR(15),
--				HINH_ANH	NVARCHAR(400)
--			);

--OPEN cur
GO
/****** Object:  StoredProcedure [dbo].[SUA_MAU]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SUA_MAU] @MA_MAU VARCHAR(15), @TEN_MAU NVARCHAR(50),@TEN_TIENG_ANH VARCHAR(20), @MA_NV VARCHAR(15)
AS
BEGIN
	DECLARE @errorMessage NVARCHAR(500) = N''
	DECLARE @responseMessage NVARCHAR(500) = N''

	BEGIN TRANSACTION
		IF EXISTS(SELECT * FROM BANG_MAU WHERE TEN_MAU = @TEN_MAU COLLATE SQL_Latin1_General_CP1_CI_AS AND MA_MAU <> @MA_MAU)
		BEGIN
			SET @errorMessage = N'Tên màu đã tồn tại'
			GOTO ABORT
		END

		UPDATE BANG_MAU SET TEN_MAU = @TEN_MAU, TEN_TIENG_ANH = @TEN_TIENG_ANH, MA_NV = @MA_NV WHERE MA_MAU = @MA_MAU
		IF @@ERROR <>0
			GOTO ABORT
	COMMIT TRANSACTION
	SELECT @MA_MAU AS affectedId, N'Sửa màu '+ @MA_MAU  +N' thành công' AS responseMessage
	ABORT:
		ROLLBACK TRANSACTION
		SELECT '' AS affectedId, @errorMessage AS errorDesc, @responseMessage AS responseMessage
END;
GO
/****** Object:  StoredProcedure [dbo].[SUA_NHAN_VIEN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[SUA_NHAN_VIEN] 
@diaChi nvarchar(200), @hoTen nvarchar(60), @soDienThoai varchar(15),@cmnd varchar(15), @maQuyen VARCHAR(15), @maNhanVien VARCHAR(15)
AS
BEGIN
	DECLARE @errorMessage NVARCHAR(500) = N''
	DECLARE @responseMessage NVARCHAR(500) = N''

	BEGIN TRANSACTION
	IF NOT EXISTS(SELECT * FROM NHAN_VIEN NV INNER JOIN TAI_KHOAN TK ON NV.MA_TK = TK.MA_TK WHERE TK.MA_QUYEN = 'Q02' AND NV.MA_NV <> @maNhanVien AND NV.TRANG_THAI = 1)--quyền quản lý
		BEGIN
			SET @errorMessage = N'Không thể đổi quyền của quản lý duy nhất còn hoạt động'
			GOTO ABORT
		END
	IF EXISTS(SELECT * FROM ((SELECT EMAIL, SDT FROM NHAN_VIEN WHERE MA_NV <> @maNhanVien) UNION ALL (SELECT EMAIL, SDT FROM KHACH_HANG)) B WHERE B.SDT = @soDienThoai)
	BEGIN
		SET @errorMessage = N'Số điện thoại đã được sử dụng'
			GOTO ABORT
	END
		IF EXISTS(SELECT * FROM ((SELECT EMAIL, SDT, CMND FROM NHAN_VIEN WHERE MA_NV <> @maNhanVien)) B WHERE B.CMND = @cmnd)
	BEGIN
		SET @errorMessage = N'CMND đã được sử dụng'
			GOTO ABORT
	END
	UPDATE TAI_KHOAN SET MA_QUYEN = @maQuyen WHERE MA_TK = (SELECT MA_TK FROM NHAN_VIEN WHERE MA_NV = @maNhanVien)
	UPDATE NHAN_VIEN SET HO_TEN = @hoTen, DIA_CHI = @diaChi, CMND = @cmnd, SDT = @soDienThoai WHERE MA_NV = @maNhanVien
		IF @@ERROR <> 0
			GOTO ABORT
	COMMIT TRANSACTION
	SELECT @maNhanVien AS affectedId, N'Sửa nhân viên thành công' AS responseMessage
	ABORT:
		ROLLBACK TRANSACTION
		SELECT '' AS affectedId, @errorMessage AS errorDesc, @responseMessage AS responseMessage
END;
GO
/****** Object:  StoredProcedure [dbo].[SUA_SAN_PHAM]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[SUA_SAN_PHAM]
	 @TEN_SP nvarchar(150)
	,@MA_TL VARCHAR(15)
	,@HINH_ANH nvarchar(400)
	,@MO_TA NVARCHAR(500) = NULL
	,@MA_NV VARCHAR(15)
	,@xml_LIST_HINH_ANH_SP_STR NVARCHAR(MAX)
	,@xml_LIST_CHI_TIET_SP_STR NVARCHAR(MAX)
	,@MA_SP VARCHAR(15)
AS
BEGIN
DECLARE @errorMessage NVARCHAR(500) = N''
	BEGIN TRANSACTION

		IF EXISTS (SELECT * FROM SAN_PHAM WHERE TEN_SP = @TEN_SP AND MA_SP <> @MA_SP)
		BEGIN
			set @errorMessage = N'Tên sản phẩm đã tồn tại'
			GOTO ABORT
		END
		-- thêm vào bảng sản phẩm
			UPDATE SAN_PHAM SET TEN_SP = @TEN_SP, MA_TL = @MA_TL, NGAY_TAO = GETDATE(), HINH_ANH = @HINH_ANH, MO_TA= @MO_TA, MA_NV = @MA_NV WHERE MA_SP = @MA_SP
		
				IF @@ERROR <> 0
				GOTO ABORT

		-- xử lý xml list hình ảnh sản phẩm
		DECLARE @XML_LIST_HINH_ANH_SP XML = CAST(@xml_LIST_HINH_ANH_SP_STR AS XML) ;

		DECLARE @idoc int
		--Create an internal representation of the XML document.
		EXEC sp_xml_preparedocument @idoc OUTPUT, @XML_LIST_HINH_ANH_SP;
		-- Execute a SELECT statement that uses the OPENXML rowset provider.
		--SELECT    *
		--FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
		--            WITH (
		--				MA_MAU		VARCHAR(15),
		--				HINH_ANH	NVARCHAR(400)
		--			);

		DECLARE @x_MA_MAU VARCHAR(15), @x_HINH_ANH NVARCHAR(400)
		DECLARE cur CURSOR FOR
			SELECT    *
				FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
					WITH (
						MA_MAU		VARCHAR(15),
						HINH_ANH	NVARCHAR(400)
					);
		OPEN cur

		FETCH NEXT FROM cur
		INTO @x_MA_MAU, @x_HINH_ANH

		WHILE @@FETCH_STATUS = 0
		BEGIN
		--nếu có hình ảnh thì xét cập nhật hoặc thêm mới
			IF(@x_HINH_ANH='' OR @x_HINH_ANH IS NULL)
				BEGIN
					print('do nothing');
				END
			ELSE
				BEGIN
					IF NOT EXISTS(SELECT * FROM HINH_ANH_SAN_PHAM WHERE MA_SP = @MA_SP AND MA_MAU = @x_MA_MAU)
						BEGIN
							INSERT INTO HINH_ANH_SAN_PHAM(MA_SP, MA_MAU, HINH_ANH) 
							VALUES (@MA_SP, @x_MA_MAU, @x_HINH_ANH);
							IF @@ERROR <> 0
								GOTO ABORT
						END
					ELSE
						BEGIN
							UPDATE HINH_ANH_SAN_PHAM SET HINH_ANH = @x_HINH_ANH
							WHERE MA_SP = @MA_SP AND MA_MAU = @x_MA_MAU
							IF @@ERROR <> 0
								GOTO ABORT
						END
					
				END
			

			PRINT(@x_MA_MAU + ', ' + @x_HINH_ANH)
			FETCH NEXT FROM cur
			INTO @x_MA_MAU, @x_HINH_ANH
		END

		CLOSE cur;
		DEALLOCATE cur;
		--end xử lý xml list hinh anh san pham

		-- xử lý xml list chi tiết sản phẩm
		DECLARE @XML_LIST_CHI_TIET_SP XML = CAST(@xml_LIST_CHI_TIET_SP_STR AS XML) ;

		DECLARE @idoc_CTSP int
		--Create an internal representation of the XML document.
		EXEC sp_xml_preparedocument @idoc_CTSP OUTPUT, @XML_LIST_CHI_TIET_SP;
		-- Execute a SELECT statement that uses the OPENXML rowset provider.
		--SELECT    *
		--FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
		--            WITH (
		--				MA_MAU		VARCHAR(15),
		--				HINH_ANH	NVARCHAR(400)
		--			);

		DECLARE @ctsp_MA_MAU VARCHAR(15), @ctsp_MA_SIZE VARCHAR(15), @ctsp_GIA INT

		DECLARE cur_CTSP CURSOR FOR
			SELECT *
			FROM OPENXML (@idoc_CTSP, '/ArrayOfCHI_TIET_SAN_PHAM_ENTITY/CHI_TIET_SAN_PHAM_ENTITY', 2)
					WITH (
						MA_MAU	VARCHAR(15),
						MA_SIZE	VARCHAR(15),
						GIA INT
					);

		OPEN cur_CTSP

		FETCH NEXT FROM cur_CTSP
		INTO @ctsp_MA_MAU, @ctsp_MA_SIZE, @ctsp_GIA

		WHILE @@FETCH_STATUS = 0
		BEGIN
		--nếu đã có chi tiết sản phẩm đó r thì k thêm, xét giá nếu có thay đổi thì thay, nếu chưa có chi tiết sản phẩm đó thì thêm, và thêm luôn thay đổi giá
			IF EXISTS(SELECT * FROM CHI_TIET_SAN_PHAM WHERE MA_SP=@MA_SP AND MA_MAU = @ctsp_MA_MAU AND MA_SIZE = @ctsp_MA_SIZE)
				BEGIN
					DECLARE @MA_CT_SP_P INT = (SELECT MA_CT_SP FROM CHI_TIET_SAN_PHAM WHERE MA_SP=@MA_SP AND MA_MAU = @ctsp_MA_MAU AND MA_SIZE = @ctsp_MA_SIZE)
					--xét giá nếu có thay đổi thì thay
					IF(dbo.UDF_LayGiaCuaChiTietSP(@MA_CT_SP_P) <> @ctsp_GIA)
					BEGIN
						INSERT INTO THAY_DOI_GIA (MA_CT_SP, GIA, NGAY_THAY_DOI, MA_NV) 
						SELECT MA_CT_SP, @ctsp_GIA AS GIA, GETDATE() AS NGAY_THAY_DOI, @MA_NV AS MA_NV FROM CHI_TIET_SAN_PHAM WHERE  MA_SP=@MA_SP AND MA_MAU = @ctsp_MA_MAU AND MA_SIZE = @ctsp_MA_SIZE
						IF @@ERROR <> 0
						GOTO ABORT
					END
					print('do nothing')
				END
			ELSE
				BEGIN
					INSERT INTO CHI_TIET_SAN_PHAM(MA_SP, MA_MAU, MA_SIZE, SL_TON) 
					VALUES (@MA_SP, @ctsp_MA_MAU, @ctsp_MA_SIZE, 0);
					IF @@ERROR <> 0
						GOTO ABORT

					INSERT INTO THAY_DOI_GIA (MA_CT_SP, GIA, NGAY_THAY_DOI, MA_NV) 
					SELECT MA_CT_SP, @ctsp_GIA AS GIA, GETDATE() AS NGAY_THAY_DOI, @MA_NV AS MA_NV FROM CHI_TIET_SAN_PHAM WHERE  MA_SP=@MA_SP AND MA_MAU = @ctsp_MA_MAU AND MA_SIZE = @ctsp_MA_SIZE
					IF @@ERROR <> 0
					GOTO ABORT
						
				END
			
			PRINT(@ctsp_MA_MAU + ', ' + @ctsp_MA_SIZE)
			FETCH NEXT FROM cur_CTSP
			INTO @ctsp_MA_MAU, @ctsp_MA_SIZE, @ctsp_GIA
		END

		CLOSE cur_CTSP;
		DEALLOCATE cur_CTSP;
		--end xử lý xml list chi tiet san pham

	COMMIT TRANSACTION

	SELECT @MA_SP AS affectedId, '' AS errorDesc, 'Sửa sản phẩm thành công' AS responseMessage 
	ABORT:
		ROLLBACK TRANSACTION

		IF CURSOR_STATUS('global','cur')>=-1
		BEGIN
				CLOSE cur;
				DEALLOCATE cur;
		END
		IF CURSOR_STATUS('global','cur_CTSP')>=-1
		BEGIN
				CLOSE cur_CTSP;
				DEALLOCATE cur_CTSP;
		END
		--CLOSE cur;
		--DEALLOCATE cur;
		--CLOSE cur_CTSP;
		--DEALLOCATE cur_CTSP;
		SELECT '' AS affectedId, @errorMessage AS errorDesc, '' AS responseMessage 
END

--DECLARE @XML_STR NVARCHAR(MAX) = '<?xml version="1.0"?>
--<ArrayOfHINH_ANH_SAN_PHAM_ENTITY xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <HINH_ANH_SAN_PHAM_ENTITY>
--    <MA_MAU>M01</MA_MAU>
--    <HINH_ANH>images3.jpg</HINH_ANH>
--  </HINH_ANH_SAN_PHAM_ENTITY>
--</ArrayOfHINH_ANH_SAN_PHAM_ENTITY>'

--DECLARE @XML XML = CAST(@XML_STR AS XML) ;

--DECLARE @tempTable TABLE
--(
--	MA_MAU		VARCHAR(15),
--	HINH_ANH	NVARCHAR(400)
--)
--DECLARE @idoc int
----Create an internal representation of the XML document.
--EXEC sp_xml_preparedocument @idoc OUTPUT, @XML;
---- Execute a SELECT statement that uses the OPENXML rowset provider.
----SELECT    *
----FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
----            WITH (
----				MA_MAU		VARCHAR(15),
----				HINH_ANH	NVARCHAR(400)
----			);

--DECLARE @MA_MAU VARCHAR(15), @HINH_ANH NVARCHAR(400)

--DECLARE cur CURSOR FOR
--	SELECT    *
--	FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
--            WITH (
--				MA_MAU		VARCHAR(15),
--				HINH_ANH	NVARCHAR(400)
--			);

--OPEN cur
GO
/****** Object:  StoredProcedure [dbo].[SUA_SIZE]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SUA_SIZE] @MA_SIZE VARCHAR(15), @TEN_SIZE NVARCHAR(50), @MA_NV VARCHAR(15)
AS
BEGIN
	DECLARE @errorMessage NVARCHAR(500) = N''
	DECLARE @responseMessage NVARCHAR(500) = N''

	BEGIN TRANSACTION
		IF EXISTS(SELECT * FROM BANG_SIZE WHERE TEN_SIZE = @TEN_SIZE AND MA_SIZE <> @MA_SIZE)
		BEGIN
			SET @errorMessage = N'Tên size đã tồn tại'
			GOTO ABORT
		END
		UPDATE BANG_SIZE SET TEN_SIZE = @TEN_SIZE, MA_NV = @MA_NV WHERE MA_SIZE = @MA_SIZE
		IF @@ERROR <>0
			GOTO ABORT
	COMMIT TRANSACTION
	SELECT @MA_SIZE AS affectedId, N'Sửa size '+ @MA_SIZE  +N' thành công' AS responseMessage
	ABORT:
		ROLLBACK TRANSACTION
		SELECT '' AS affectedId, @errorMessage AS errorDesc, @responseMessage AS responseMessage
END;
GO
/****** Object:  StoredProcedure [dbo].[TANG_LUOT_XEM]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[TANG_LUOT_XEM] @productId VARCHAR(15)
AS
BEGIN
		BEGIN TRANSACTION
			UPDATE dbo.SAN_PHAM SET LUOT_XEM = LUOT_XEM + 1 WHERE MA_SP=@productId 
			IF @@ERROR <> 0   
				BEGIN  
					-- Return 99 to the calling program to indicate failure.  
					PRINT N'An error occurred deleting the candidate information.'; 
					SELECT 'ERROR' AS errorDesc, '' AS responseMessage
				END 
		COMMIT TRANSACTION
		SELECT '' AS errorDesc, 'OK' AS responseMessage 
END
GO
/****** Object:  StoredProcedure [dbo].[TAO_HOA_DON]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[TAO_HOA_DON]
	@MA_HD VARCHAR(15)
	,@ID_GH INT
	,@MA_NV VARCHAR(15) = NULL
AS
BEGIN
DECLARE @MA_HD_MOI VARCHAR(15)
		EXEC GEN_CODE @tableName = 'HOA_DON', @prefix = 'HD', @result = @MA_HD_MOI OUTPUT

	IF EXISTS(SELECT * FROM HOA_DON WHERE ID_DH=@ID_GH)
	RETURN
		INSERT INTO HOA_DON(MA_HD, ID_DH, NGAY_TAO, MA_NV) VALUES (@MA_HD_MOI, @ID_GH, GETDATE(), @MA_NV)
		--UPDATE GIO_HANG SET MA_HD = @MA_HD WHERE ID_GH = @ID_GH // không cần vì gh với hóa đơn 1 - 1
END
GO
/****** Object:  StoredProcedure [dbo].[TAO_OTP]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[TAO_OTP] @EMAIL VARCHAR(50), @OTP VARCHAR(6)
AS
BEGIN
	DECLARE @errorMessage NVARCHAR(500) = N''
	DECLARE @responseMessage NVARCHAR(500) = N''

	BEGIN TRANSACTION
		IF NOT EXISTS(SELECT * FROM KHACH_HANG WHERE EMAIL = @EMAIL)
		BEGIN
			SET @errorMessage = N'Email đã nhập không phải của khách hàng nào trong hệ thống'
			GOTO ABORT
		END
	
		DELETE FROM HELPER_OTP WHERE EMAIL = @EMAIL
		INSERT INTO HELPER_OTP(EMAIL, OTP, NGAY_TAO) VALUES (@EMAIL, @OTP, GETDATE())
		IF @@ERROR <>0
			GOTO ABORT
	COMMIT TRANSACTION
	SELECT @EMAIL AS affectedId, N'Đã gửi email mã xác nhận' AS responseMessage
	ABORT:
		ROLLBACK TRANSACTION
		SELECT '' AS affectedId, @errorMessage AS errorDesc, @responseMessage AS responseMessage
END;
GO
/****** Object:  StoredProcedure [dbo].[THANH_TOAN_GIO_HANG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[THANH_TOAN_GIO_HANG]

	 @MA_KH VARCHAR(15)
	,@HO_TEN NVARCHAR(60)
	,@SDT VARCHAR(15)
	,@EMAIL VARCHAR(50)
	,@DIA_CHI NVARCHAR(200)
	,@GHI_CHU NVARCHAR(500)
	,@xml_LIST_CHI_TIET_SP_STR NVARCHAR(MAX)
AS
BEGIN
	BEGIN TRANSACTION

	DECLARE @ID_DH_C INT
	SET @ID_DH_C = (SELECT ID_DH FROM DON_HANG WHERE MA_KH = @MA_KH AND TRANG_THAI = -99)
		-- thanh toán giỏ hiện tại, chueyern trạng thái thành 0 : đã thanh toán
		IF (@ID_DH_C IS NOT NULL)
			BEGIN
				
				UPDATE DON_HANG SET HO_TEN = @HO_TEN, SDT = @SDT, EMAIL = @EMAIL, DIA_CHI = @DIA_CHI, GHI_CHU = @GHI_CHU, NGAY_TAO = GETDATE(), TRANG_THAI = 0 WHERE ID_DH = @ID_DH_C
				IF @@ERROR <> 0
				GOTO ABORT
			END
		ELSE
			BEGIN
				INSERT INTO DON_HANG(MA_KH, HO_TEN, SDT, EMAIL, DIA_CHI, GHI_CHU, NGAY_TAO, TRANG_THAI)
				VALUES(@MA_KH,@HO_TEN, @SDT, @EMAIL, @DIA_CHI, @GHI_CHU, GETDATE(), 0)
				IF @@ERROR <> 0
				GOTO ABORT

				SET @ID_DH_C = (SELECT @@IDENTITY FROM DON_HANG WHERE MA_KH = @MA_KH)
				IF @@ERROR <> 0
				GOTO ABORT
			END
			

		-- xử lý xml list chi tiết sản phẩm
		DECLARE @XML_LIST_CHI_TIET_SP XML = CAST(@xml_LIST_CHI_TIET_SP_STR AS XML) ;

		DECLARE @idoc_CTSP int
		--Create an internal representation of the XML document.
		EXEC sp_xml_preparedocument @idoc_CTSP OUTPUT, @XML_LIST_CHI_TIET_SP;
		-- Execute a SELECT statement that uses the OPENXML rowset provider.
		--SELECT    *
		--FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
		--            WITH (
		--				MA_MAU		VARCHAR(15),
		--				HINH_ANH	NVARCHAR(400)
		--			);

		DECLARE @ctsp_MA_CT_SP INT, @ctsp_SO_LUONG INT, @ctsp_GIA INT

		DECLARE cur_CTSP CURSOR FOR
			SELECT *
			FROM OPENXML (@idoc_CTSP, '/ArrayOfCHI_TIET_SAN_PHAM_ENTITY/CHI_TIET_SAN_PHAM_ENTITY',2)
					WITH (
						MA_CT_SP INT,
						SO_LUONG INT,
						GIA INT
					);

		OPEN cur_CTSP

		FETCH NEXT FROM cur_CTSP
		INTO @ctsp_MA_CT_SP, @ctsp_SO_LUONG, @ctsp_GIA

		DELETE CHI_TIET_DON_HANG WHERE ID_DH = @ID_DH_C
			IF @@ERROR <> 0
				GOTO ABORT

		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			IF(@ctsp_MA_CT_SP <> 0 AND @ctsp_MA_CT_SP IS NOT NULL)
			BEGIN
				INSERT INTO CHI_TIET_DON_HANG(ID_DH, MA_CT_SP, SO_LUONG, GIA) 
					VALUES (@ID_DH_C, @ctsp_MA_CT_SP, @ctsp_SO_LUONG, @ctsp_GIA);
				IF @@ERROR <> 0
					GOTO ABORT
				UPDATE dbo.CHI_TIET_SAN_PHAM SET SL_TON = SL_TON - @ctsp_SO_LUONG WHERE MA_CT_SP = @ctsp_MA_CT_SP
				IF @@ERROR <> 0
					GOTO ABORT
			END

			FETCH NEXT FROM cur_CTSP
			INTO @ctsp_MA_CT_SP, @ctsp_SO_LUONG, @ctsp_GIA
		END

		CLOSE cur_CTSP;
		DEALLOCATE cur_CTSP;
		--end xử lý xml list chi tiet san pham

			
			--INSERT INTO THAY_DOI_GIA (MA_CT_SP, GIA, NGAY_THAY_DOI, MA_NV) 
			--	SELECT MA_CT_SP, 0 AS GIA, GETDATE() AS NGAY_THAY_DOI, @MA_NV AS MA_NV FROM CHI_TIET_SAN_PHAM WHERE MA_SP = @MA_SP_MOI
			--IF @@ERROR <> 0
			--		GOTO ABORT


	COMMIT TRANSACTION

	SELECT @ID_DH_C AS affectedId, '' AS errorDesc, 'Thanh toán thành công' AS responseMessage 
	ABORT:
		ROLLBACK TRANSACTION
		CLOSE cur;
		DEALLOCATE cur;
		CLOSE cur_CTSP;
		DEALLOCATE cur_CTSP;
		SELECT '' AS affectedId, @@ERROR AS errorDesc, 'Có lỗi xảy ra' AS responseMessage 
END

--DECLARE @XML_STR NVARCHAR(MAX) = '<?xml version="1.0"?>
--<ArrayOfHINH_ANH_SAN_PHAM_ENTITY xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <HINH_ANH_SAN_PHAM_ENTITY>
--    <MA_MAU>M01</MA_MAU>
--    <HINH_ANH>images3.jpg</HINH_ANH>
--  </HINH_ANH_SAN_PHAM_ENTITY>
--</ArrayOfHINH_ANH_SAN_PHAM_ENTITY>'

--DECLARE @XML XML = CAST(@XML_STR AS XML) ;

--DECLARE @tempTable TABLE
--(
--	MA_MAU		VARCHAR(15),
--	HINH_ANH	NVARCHAR(400)
--)
--DECLARE @idoc int
----Create an internal representation of the XML document.
--EXEC sp_xml_preparedocument @idoc OUTPUT, @XML;
---- Execute a SELECT statement that uses the OPENXML rowset provider.
----SELECT    *
----FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
----            WITH (
----				MA_MAU		VARCHAR(15),
----				HINH_ANH	NVARCHAR(400)
----			);

--DECLARE @MA_MAU VARCHAR(15), @HINH_ANH NVARCHAR(400)

--DECLARE cur CURSOR FOR
--	SELECT    *
--	FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
--            WITH (
--				MA_MAU		VARCHAR(15),
--				HINH_ANH	NVARCHAR(400)
--			);

--OPEN cur
GO
/****** Object:  StoredProcedure [dbo].[THEM_DANH_GIA_SAN_PHAM]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[THEM_DANH_GIA_SAN_PHAM] @MA_SP VARCHAR(15), @MA_KH VARCHAR(15), @NOI_DUNG NVARCHAR(1000), @DANH_GIA INT
AS
BEGIN TRANSACTION
--lấy 1 mã ctgh để đại diện cho khahcs hàng đã mua sản phẩm
	DECLARE @MA_CT_GH INT = (SELECT TOP(1) ctgh.MA_CT_DH FROM CHI_TIET_DON_HANG ctgh 
			INNER JOIN DON_HANG gh ON ctgh.ID_DH = gh.ID_DH
			INNER JOIN CHI_TIET_SAN_PHAM ctsp ON ctgh.MA_CT_SP = ctsp.MA_CT_SP
			WHERE gh.MA_KH = @MA_KH AND ctsp.MA_SP = @MA_SP AND gh.TRANG_THAI = 2 --đã hoàn tất mới cho comment
	)

	INSERT INTO DANH_GIA_SAN_PHAM (DANH_GIA, MA_CT_DH, MA_KH, NGAY_DANH_GIA, NOI_DUNG)
	VALUES (@DANH_GIA, @MA_CT_GH, @MA_KH, GETDATE(), @NOI_DUNG)
	IF @@ERROR <> 0
				GOTO ABORT
	SELECT @MA_SP as affectedId, N'Đã thêm đánh giá' as responseMessage
	
COMMIT TRANSACTION
ABORT: 
BEGIN
	ROLLBACK TRANSACTION
	SELECT '' as affectedId, N'Thêm đánh giá thất bại' as responseMessage
END
GO
/****** Object:  StoredProcedure [dbo].[THEM_GIO_HANG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[THEM_GIO_HANG]
	@MA_KH VARCHAR(15)
	,@HO_TEN NVARCHAR(60)
	,@SDT VARCHAR(15)
	,@EMAIL VARCHAR(50)
	,@DIA_CHI NVARCHAR(200)
	,@GHI_CHU NVARCHAR(500)
AS
BEGIN
	INSERT INTO dbo.DON_HANG
	(
	    MA_KH,
	    HO_TEN,
	    SDT,
	    EMAIL,
	    NGAY_TAO,
	    DIA_CHI,
		GHI_CHU,
	    TRANG_THAI
	    --MA_NV_DUYET,
	    --MA_NV_GIAO
	)
	VALUES
	(   @MA_KH,        -- MA_KH - varchar(15)
	    @HO_TEN,       -- HO_TEN - nvarchar(60)
	    @SDT,        -- SDT - varchar(50)
	    @EMAIL,        -- EMAIL - varchar(50)
	    GETDATE(), -- NGAY_TAO - datetime
	    @DIA_CHI,       -- DIA_CHI - nvarchar(200)
		@GHI_CHU,
	    0        -- TRANG_THAI - smallint - 0: cho duyet
	    --'',        -- MA_NV_DUYET - varchar(15)
	    --''         -- MA_NV_GIAO - varchar(15)
	    )
		DECLARE @ID_GIO_HANG INT
		SET @ID_GIO_HANG = SCOPE_IDENTITY() 
		SELECT @ID_GIO_HANG AS ID_GIO_HANG
END
GO
/****** Object:  StoredProcedure [dbo].[THEM_HOAC_CAP_NHAT_GIO_HANG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[THEM_HOAC_CAP_NHAT_GIO_HANG]
	 @MA_KH VARCHAR(15)
	,@xml_LIST_CHI_TIET_SP_STR NVARCHAR(MAX)
AS
BEGIN
	BEGIN TRANSACTION

	DECLARE @ID_DH_C INT
	SET @ID_DH_C = (SELECT ID_DH FROM DON_HANG WHERE MA_KH = @MA_KH AND TRANG_THAI = -99)
		-- thêm vào bảng đơn hàng, trạng thái -99 biểu hiện của đơn chưa thanh toán (giỏ hàng)
		IF (@ID_DH_C IS NOT NULL)
			BEGIN
				print('do nothing')
			END
		ELSE
			BEGIN
				INSERT INTO DON_HANG(MA_KH, TRANG_THAI)
				VALUES(@MA_KH, -99)
				IF @@ERROR <> 0
				GOTO ABORT

				SET @ID_DH_C = (SELECT ID_DH FROM DON_HANG WHERE MA_KH = @MA_KH AND TRANG_THAI = -99)
				IF @@ERROR <> 0
				GOTO ABORT
			END
			

		-- xử lý xml list chi tiết sản phẩm
		DECLARE @XML_LIST_CHI_TIET_SP XML = CAST(@xml_LIST_CHI_TIET_SP_STR AS XML) ;

		DECLARE @idoc_CTSP int
		--Create an internal representation of the XML document.
		EXEC sp_xml_preparedocument @idoc_CTSP OUTPUT, @XML_LIST_CHI_TIET_SP;
		-- Execute a SELECT statement that uses the OPENXML rowset provider.
		--SELECT    *
		--FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
		--            WITH (
		--				MA_MAU		VARCHAR(15),
		--				HINH_ANH	NVARCHAR(400)
		--			);

		DECLARE @ctsp_MA_CT_SP INT, @ctsp_SO_LUONG INT, @ctsp_GIA INT

		DECLARE cur_CTSP CURSOR FOR
			SELECT *
			FROM OPENXML (@idoc_CTSP, '/ArrayOfCHI_TIET_SAN_PHAM_ENTITY/CHI_TIET_SAN_PHAM_ENTITY',2)
					WITH (
						MA_CT_SP INT,
						SO_LUONG INT,
						GIA INT
					);

		OPEN cur_CTSP

		FETCH NEXT FROM cur_CTSP
		INTO @ctsp_MA_CT_SP, @ctsp_SO_LUONG, @ctsp_GIA

		DELETE CHI_TIET_DON_HANG WHERE ID_DH = @ID_DH_C
			IF @@ERROR <> 0
				GOTO ABORT

		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			IF(@ctsp_MA_CT_SP <> 0 AND @ctsp_MA_CT_SP IS NOT NULL)
			BEGIN
				INSERT INTO CHI_TIET_DON_HANG(ID_DH, MA_CT_SP, SO_LUONG, GIA) 
					VALUES (@ID_DH_C, @ctsp_MA_CT_SP, @ctsp_SO_LUONG, @ctsp_GIA);
				IF @@ERROR <> 0
					GOTO ABORT
			END

			FETCH NEXT FROM cur_CTSP
			INTO @ctsp_MA_CT_SP, @ctsp_SO_LUONG, @ctsp_GIA
		END

		CLOSE cur_CTSP;
		DEALLOCATE cur_CTSP;
		--end xử lý xml list chi tiet san pham

			
			--INSERT INTO THAY_DOI_GIA (MA_CT_SP, GIA, NGAY_THAY_DOI, MA_NV) 
			--	SELECT MA_CT_SP, 0 AS GIA, GETDATE() AS NGAY_THAY_DOI, @MA_NV AS MA_NV FROM CHI_TIET_SAN_PHAM WHERE MA_SP = @MA_SP_MOI
			--IF @@ERROR <> 0
			--		GOTO ABORT


	COMMIT TRANSACTION

	SELECT @ID_DH_C AS affectedId, '' AS errorDesc, 'OK' AS responseMessage 
	ABORT:
		ROLLBACK TRANSACTION
		CLOSE cur;
		DEALLOCATE cur;
		CLOSE cur_CTSP;
		DEALLOCATE cur_CTSP;
		SELECT '' AS affectedId, @@ERROR AS errorDesc, 'Có lỗi xảy ra' AS responseMessage 
END

--DECLARE @XML_STR NVARCHAR(MAX) = '<?xml version="1.0"?>
--<ArrayOfHINH_ANH_SAN_PHAM_ENTITY xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <HINH_ANH_SAN_PHAM_ENTITY>
--    <MA_MAU>M01</MA_MAU>
--    <HINH_ANH>images3.jpg</HINH_ANH>
--  </HINH_ANH_SAN_PHAM_ENTITY>
--</ArrayOfHINH_ANH_SAN_PHAM_ENTITY>'

--DECLARE @XML XML = CAST(@XML_STR AS XML) ;

--DECLARE @tempTable TABLE
--(
--	MA_MAU		VARCHAR(15),
--	HINH_ANH	NVARCHAR(400)
--)
--DECLARE @idoc int
----Create an internal representation of the XML document.
--EXEC sp_xml_preparedocument @idoc OUTPUT, @XML;
---- Execute a SELECT statement that uses the OPENXML rowset provider.
----SELECT    *
----FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
----            WITH (
----				MA_MAU		VARCHAR(15),
----				HINH_ANH	NVARCHAR(400)
----			);

--DECLARE @MA_MAU VARCHAR(15), @HINH_ANH NVARCHAR(400)

--DECLARE cur CURSOR FOR
--	SELECT    *
--	FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
--            WITH (
--				MA_MAU		VARCHAR(15),
--				HINH_ANH	NVARCHAR(400)
--			);

--OPEN cur
GO
/****** Object:  StoredProcedure [dbo].[THEM_KHUYEN_MAI]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
--exec THEM_KHUYEN_MAI @GHI_CHU=N'',@MA_NV='NV01',@NGAY_AP_DUNG='2022-11-13 19:00:00',@THOI_GIAN=50,@xml_LIST_CHI_TIET_KM_STR=N'<?xml version="1.0"?>
--<ArrayOfCHI_TIET_KHUYEN_MAI_ENTITY xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <CHI_TIET_KHUYEN_MAI_ENTITY>
--    <MA_SP>SP0000000000017</MA_SP>
--    <PHAN_TRAM_GIAM>10</PHAN_TRAM_GIAM>
--  </CHI_TIET_KHUYEN_MAI_ENTITY>
--  <CHI_TIET_KHUYEN_MAI_ENTITY>
--    <MA_SP>SP0000000000011</MA_SP>
--    <PHAN_TRAM_GIAM>20</PHAN_TRAM_GIAM>
--  </CHI_TIET_KHUYEN_MAI_ENTITY>
--</ArrayOfCHI_TIET_KHUYEN_MAI_ENTITY>'
--go
-- =============================================
CREATE   PROCEDURE [dbo].[THEM_KHUYEN_MAI]
	 @GHI_CHU NVARCHAR(1000) = NULL
	,@MA_NV VARCHAR(15)
	,@NGAY_AP_DUNG DATETIME
	,@THOI_GIAN INT
	,@xml_LIST_CHI_TIET_KM_STR NVARCHAR(MAX)
AS
BEGIN
	BEGIN TRANSACTION
		DECLARE @dateBegin DATETIME = @NGAY_AP_DUNG
		DECLARE @dateEnd DATETIME = DATEADD(DAY, @THOI_GIAN, @dateBegin)
		DECLARE @errorMessage NVARCHAR(max) = ''

		DECLARE @maKmChongCheo VARCHAR(MAX) = ''

		IF EXISTS(
		SELECT * FROM KHUYEN_MAI 
				WHERE 
				((@dateBegin BETWEEN NGAY_AP_DUNG AND (DATEADD(DAY,THOI_GIAN, NGAY_AP_DUNG))) 
					OR (@dateEnd BETWEEN NGAY_AP_DUNG AND (DATEADD(DAY, THOI_GIAN, NGAY_AP_DUNG)))) AND TRANG_THAI = 1)
				BEGIN
					SELECT @maKmChongCheo = @maKmChongCheo + MA_KM + ', ' FROM KHUYEN_MAI 
					WHERE ((@dateBegin BETWEEN NGAY_AP_DUNG AND (DATEADD(DAY,THOI_GIAN, NGAY_AP_DUNG)))
					OR (@dateEnd BETWEEN NGAY_AP_DUNG AND (DATEADD(DAY, THOI_GIAN, NGAY_AP_DUNG)))) AND TRANG_THAI = 1
					
					SET @maKmChongCheo = @maKmChongCheo + 'end'

					SET @maKmChongCheo = REPLACE(@maKmChongCheo, ', end', '')

					SET @errorMessage = 
					N'Khoảng thời gian áp dụng bạn đã chọn chồng chéo với (các) đợt khuyến mãi có mã sau: ' + @maKmChongCheo

					GOTO ABORT_THOI_GIAN
				END
		
		DECLARE @MA_KM_MOI VARCHAR(15)
		EXEC GEN_CODE @tableName = 'KHUYEN_MAI', @prefix = 'KM', @result = @MA_KM_MOI OUTPUT
		
		-- thêm vào bảng khuyến mãi
			INSERT INTO KHUYEN_MAI(MA_KM, GHI_CHU, MA_NV, NGAY_TAO, NGAY_AP_DUNG, THOI_GIAN, TRANG_THAI)
				VALUES(@MA_KM_MOI, @GHI_CHU, @MA_NV, GETDATE(), @NGAY_AP_DUNG, @THOI_GIAN, 1)
		
				IF @@ERROR <> 0
				GOTO ABORT

		-- xử lý xml list chi tiết khuyến mãi
		DECLARE @XML_LIST_CHI_TIET_KM XML = CAST(@xml_LIST_CHI_TIET_KM_STR AS XML) ;

		DECLARE @idoc_CTSP int
		--Create an internal representation of the XML document.
		EXEC sp_xml_preparedocument @idoc_CTSP OUTPUT, @XML_LIST_CHI_TIET_KM;
		-- Execute a SELECT statement that uses the OPENXML rowset provider.
		--SELECT    *
		--FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
		--            WITH (
		--				MA_MAU		VARCHAR(15),
		--				HINH_ANH	NVARCHAR(400)
		--			);

		DECLARE @ctsp_MA_SP VARCHAR(15), @ctsp_PHAN_TRAM_GIAM INT

		DECLARE cur_CTSP CURSOR FOR
			SELECT *
			FROM OPENXML (@idoc_CTSP, '/ArrayOfCHI_TIET_KHUYEN_MAI_ENTITY/CHI_TIET_KHUYEN_MAI_ENTITY',2)
					WITH (
						MA_SP VARCHAR(15),
						PHAN_TRAM_GIAM INT
					);

		OPEN cur_CTSP

		FETCH NEXT FROM cur_CTSP
		INTO @ctsp_MA_SP, @ctsp_PHAN_TRAM_GIAM

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO CHI_TIET_KHUYEN_MAI(MA_KM, MA_SP, PHAN_TRAM_GIAM) 
				VALUES (@MA_KM_MOI, @ctsp_MA_SP, @ctsp_PHAN_TRAM_GIAM);
			IF @@ERROR <> 0
				GOTO ABORT

			--PRINT(@ctsp_MA_CT_SP + ', ' + @ctsp_SO_LUONG +',' + @ctsp_GIA)
			FETCH NEXT FROM cur_CTSP
			INTO @ctsp_MA_SP, @ctsp_PHAN_TRAM_GIAM
		END

		CLOSE cur_CTSP;
		DEALLOCATE cur_CTSP;
		--end xử lý xml list chi tiet san pham

	COMMIT TRANSACTION

	SELECT @MA_KM_MOI AS affectedId, '' AS errorDesc, 'OK' AS responseMessage 
	
	ABORT:
		ROLLBACK TRANSACTION

		CLOSE cur_CTSP;
		DEALLOCATE cur_CTSP;
		SELECT '' AS affectedId, @@ERROR AS errorDesc, N'Tạo đợt khuyến mãi không thành công' AS responseMessage 

	ABORT_THOI_GIAN:
		ROLLBACK TRANSACTION
		SELECT '' AS affectedId, 'SAI_THOI_GIAN' AS errorDesc, @errorMessage AS responseMessage 
END

--DECLARE @XML_STR NVARCHAR(MAX) = '<?xml version="1.0"?>
--<ArrayOfHINH_ANH_SAN_PHAM_ENTITY xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <HINH_ANH_SAN_PHAM_ENTITY>
--    <MA_MAU>M01</MA_MAU>
--    <HINH_ANH>images3.jpg</HINH_ANH>
--  </HINH_ANH_SAN_PHAM_ENTITY>
--</ArrayOfHINH_ANH_SAN_PHAM_ENTITY>'

--DECLARE @XML XML = CAST(@XML_STR AS XML) ;

--DECLARE @tempTable TABLE
--(
--	MA_MAU		VARCHAR(15),
--	HINH_ANH	NVARCHAR(400)
--)
--DECLARE @idoc int
----Create an internal representation of the XML document.
--EXEC sp_xml_preparedocument @idoc OUTPUT, @XML;
---- Execute a SELECT statement that uses the OPENXML rowset provider.
----SELECT    *
----FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
----            WITH (
----				MA_MAU		VARCHAR(15),
----				HINH_ANH	NVARCHAR(400)
----			);

--DECLARE @MA_MAU VARCHAR(15), @HINH_ANH NVARCHAR(400)

--DECLARE cur CURSOR FOR
--	SELECT    *
--	FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
--            WITH (
--				MA_MAU		VARCHAR(15),
--				HINH_ANH	NVARCHAR(400)
--			);

--OPEN cur
GO
/****** Object:  StoredProcedure [dbo].[THEM_MAU]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[THEM_MAU] @TEN_MAU NVARCHAR(50),@TEN_TIENG_ANH VARCHAR(20), @MA_NV VARCHAR(15)
AS
BEGIN
	DECLARE @errorMessage NVARCHAR(500) = N''
	DECLARE @responseMessage NVARCHAR(500) = N''
	DECLARE @MA_MAU_MOI VARCHAR(15) = ''

	BEGIN TRANSACTION
		IF EXISTS(SELECT * FROM BANG_MAU WHERE TEN_MAU = @TEN_MAU COLLATE SQL_Latin1_General_CP1_CI_AS)
		BEGIN
			SET @errorMessage = N'Tên màu đã tồn tại'
			GOTO ABORT
		END
		EXEC GEN_CODE @tableName = 'BANG_MAU', @prefix = 'M', @result = @MA_MAU_MOI OUTPUT
		INSERT INTO BANG_MAU(MA_MAU, TEN_MAU, TEN_TIENG_ANH, NGAY_TAO, MA_NV) VALUES (@MA_MAU_MOI, @TEN_MAU, @TEN_TIENG_ANH, GETDATE(), @MA_NV)
		IF @@ERROR <>0
			GOTO ABORT
	COMMIT TRANSACTION
	SELECT @MA_MAU_MOI AS affectedId, N'Thêm màu mới thành công' AS responseMessage
	ABORT:
		ROLLBACK TRANSACTION
		SELECT '' AS affectedId, @errorMessage AS errorDesc, @responseMessage AS responseMessage
END;
GO
/****** Object:  StoredProcedure [dbo].[THEM_NHAN_VIEN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[THEM_NHAN_VIEN] @email VARCHAR(50), @password VARCHAR(MAX),
@diaChi nvarchar(200), @hoTen nvarchar(60), @soDienThoai varchar(15),@cmnd varchar(15), @maQuyen VARCHAR(15)
AS
BEGIN
	DECLARE @errorMessage NVARCHAR(500) = N''
	DECLARE @responseMessage NVARCHAR(500) = N''
	DECLARE @MA_NV_MOI VARCHAR(15) = ''

	BEGIN TRANSACTION
	IF EXISTS(SELECT * FROM ((SELECT EMAIL, SDT FROM NHAN_VIEN) UNION ALL (SELECT EMAIL, SDT FROM KHACH_HANG)) B WHERE B.EMAIL = @email)
	BEGIN
		SET @errorMessage = N'Email đã được sử dụng'
			GOTO ABORT
	END

	IF EXISTS(SELECT * FROM ((SELECT EMAIL, SDT FROM NHAN_VIEN) UNION ALL (SELECT EMAIL, SDT FROM KHACH_HANG)) B WHERE B.SDT = @soDienThoai)
	BEGIN
		SET @errorMessage = N'Số điện thoại đã được sử dụng'
			GOTO ABORT
	END
		IF EXISTS(SELECT * FROM ((SELECT EMAIL, SDT, CMND FROM NHAN_VIEN)) B WHERE B.CMND = @cmnd)
	BEGIN
		SET @errorMessage = N'CMND đã được sử dụng'
			GOTO ABORT
	END
		EXEC GEN_CODE @tableName = 'NHAN_VIEN', @prefix = 'NV', @result = @MA_NV_MOI OUTPUT

		DECLARE @MA_TK_MOI VARCHAR(15)
		EXEC GEN_CODE @tableName = 'TAI_KHOAN', @prefix = 'TK', @result = @MA_TK_MOI OUTPUT
	INSERT INTO TAI_KHOAN VALUES (@MA_TK_MOI, @password, @maQuyen)
	IF @@ERROR <> 0
			GOTO ABORT
	INSERT INTO NHAN_VIEN(MA_NV, HO_TEN, DIA_CHI, EMAIL, CMND, SDT, MA_TK, TRANG_THAI, NGAY_TAO) VALUES(@MA_NV_MOI, @hoTen, @diaChi, @email, @cmnd, @soDienThoai, @MA_TK_MOI, 1 ,GETDATE())
		IF @@ERROR <> 0
			GOTO ABORT
	COMMIT TRANSACTION
	SELECT @MA_NV_MOI AS affectedId, N'Thêm nhân viên mới thành công' AS responseMessage
	ABORT:
		ROLLBACK TRANSACTION
		SELECT '' AS affectedId, @errorMessage AS errorDesc, @responseMessage AS responseMessage
END;
GO
/****** Object:  StoredProcedure [dbo].[THEM_PHIEU_NHAP]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
--exec THEM_PHIEU_NHAP @GHI_CHU=N'ghi chú',@MA_NV='NV01',@xml_LIST_CHI_TIET_PN_STR=N'<?xml version="1.0"?>
--<ArrayOfCHI_TIET_SAN_PHAM_ENTITY xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <CHI_TIET_SAN_PHAM_ENTITY>
--    <ID_GH>0</ID_GH>
--    <MA_CT_SP>345</MA_CT_SP>
--    <MA_SIZE>S02</MA_SIZE>
--    <MA_MAU>M06</MA_MAU>
--    <TEN_MAU>Trắng</TEN_MAU>
--    <TEN_SIZE>M</TEN_SIZE>
--    <GIA>200000</GIA>
--    <SO_LUONG>9</SO_LUONG>
--    <SL_TON xsi:nil="true" />
--  </CHI_TIET_SAN_PHAM_ENTITY>
--  <CHI_TIET_SAN_PHAM_ENTITY>
--    <ID_GH>0</ID_GH>
--    <MA_CT_SP>346</MA_CT_SP>
--    <MA_SIZE>S03</MA_SIZE>
--    <MA_MAU>M06</MA_MAU>
--    <TEN_MAU>Trắng</TEN_MAU>
--    <TEN_SIZE>L</TEN_SIZE>
--    <GIA>250000</GIA>
--    <SO_LUONG>8</SO_LUONG>
--    <SL_TON xsi:nil="true" />
--  </CHI_TIET_SAN_PHAM_ENTITY>
--  <CHI_TIET_SAN_PHAM_ENTITY>
--    <ID_GH>0</ID_GH>
--    <MA_CT_SP>349</MA_CT_SP>
--    <MA_SIZE>S03</MA_SIZE>
--    <MA_MAU>M07</MA_MAU>
--    <TEN_MAU>Xám</TEN_MAU>
--    <TEN_SIZE>L</TEN_SIZE>
--    <GIA>250000</GIA>
--    <SO_LUONG>3</SO_LUONG>
--    <SL_TON xsi:nil="true" />
--  </CHI_TIET_SAN_PHAM_ENTITY>
--  <CHI_TIET_SAN_PHAM_ENTITY>
--    <ID_GH>0</ID_GH>
--    <MA_CT_SP>352</MA_CT_SP>
--    <MA_SIZE>S03</MA_SIZE>
--    <MA_MAU>M09</MA_MAU>
--    <TEN_MAU>Xanh đen</TEN_MAU>
--    <TEN_SIZE>L</TEN_SIZE>
--    <GIA>250000</GIA>
--    <SO_LUONG>2</SO_LUONG>
--    <SL_TON xsi:nil="true" />
--  </CHI_TIET_SAN_PHAM_ENTITY>
--  <CHI_TIET_SAN_PHAM_ENTITY>
--    <ID_GH>0</ID_GH>
--    <MA_CT_SP>353</MA_CT_SP>
--    <MA_SIZE>S04</MA_SIZE>
--    <MA_MAU>M09</MA_MAU>
--    <TEN_MAU>Xanh đen</TEN_MAU>
--    <TEN_SIZE>XL</TEN_SIZE>
--    <GIA>270000</GIA>
--    <SO_LUONG>3</SO_LUONG>
--    <SL_TON xsi:nil="true" />
--  </CHI_TIET_SAN_PHAM_ENTITY>
--</ArrayOfCHI_TIET_SAN_PHAM_ENTITY>'
--go
-- =============================================
CREATE   PROCEDURE [dbo].[THEM_PHIEU_NHAP]
	 @GHI_CHU NVARCHAR(1000) = NULL
	,@MA_NV VARCHAR(15)
	,@xml_LIST_CHI_TIET_PN_STR NVARCHAR(MAX)
AS
BEGIN
	BEGIN TRANSACTION
		DECLARE @CAC_SAN_PHAM_CO_THE_BAN_LO NVARCHAR(MAX) = N''
		DECLARE @MA_PN_MOI VARCHAR(15)
		EXEC GEN_CODE @tableName = 'PHIEU_NHAP', @prefix = 'PN', @result = @MA_PN_MOI OUTPUT

		
		-- thêm vào bảng phiếu nhập
			INSERT INTO PHIEU_NHAP (MA_PN, GHI_CHU, MA_NV, NGAY_TAO)
				VALUES(@MA_PN_MOI, @GHI_CHU, @MA_NV, GETDATE())
		
				IF @@ERROR <> 0
				GOTO ABORT

		-- xử lý xml list chi tiết sản phẩm
		DECLARE @XML_LIST_CHI_TIET_SP XML = CAST(@xml_LIST_CHI_TIET_PN_STR AS XML) ;

		DECLARE @idoc_CTSP int
		--Create an internal representation of the XML document.
		EXEC sp_xml_preparedocument @idoc_CTSP OUTPUT, @XML_LIST_CHI_TIET_SP;
		-- Execute a SELECT statement that uses the OPENXML rowset provider.
		--SELECT    *
		--FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
		--            WITH (
		--				MA_MAU		VARCHAR(15),
		--				HINH_ANH	NVARCHAR(400)
		--			);

		DECLARE @ctsp_MA_CT_SP INT, @ctsp_SO_LUONG INT, @ctsp_GIA INT

		DECLARE cur_CTSP CURSOR FOR
			SELECT *
			FROM OPENXML (@idoc_CTSP, '/ArrayOfCHI_TIET_SAN_PHAM_ENTITY/CHI_TIET_SAN_PHAM_ENTITY',2)
					WITH (
						MA_CT_SP INT,
						SO_LUONG INT,
						GIA INT
					);

		OPEN cur_CTSP

		FETCH NEXT FROM cur_CTSP
		INTO @ctsp_MA_CT_SP, @ctsp_SO_LUONG, @ctsp_GIA

		

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO CHI_TIET_PHIEU_NHAP(MA_PN, MA_CT_SP, SO_LUONG, GIA) 
				VALUES (@MA_PN_MOI, @ctsp_MA_CT_SP, @ctsp_SO_LUONG, @ctsp_GIA);
			IF @@ERROR <> 0
				GOTO ABORT
			UPDATE CHI_TIET_SAN_PHAM SET SL_TON = SL_TON + @ctsp_SO_LUONG WHERE MA_CT_SP = @ctsp_MA_CT_SP
			IF @@ERROR <> 0
				GOTO ABORT

			IF(dbo.[UDF_LayGiaCuaChiTietSP](@ctsp_MA_CT_SP) <= @ctsp_GIA)
			BEGIN
				SET @CAC_SAN_PHAM_CO_THE_BAN_LO = @CAC_SAN_PHAM_CO_THE_BAN_LO  + (SELECT SP.TEN_SP+N' - '+ BM.TEN_MAU + N'/ ' + BS.TEN_SIZE FROM CHI_TIET_SAN_PHAM CT INNER JOIN SAN_PHAM SP ON CT.MA_SP = SP.MA_SP INNER JOIN BANG_MAU BM ON CT.MA_MAU = BM.MA_MAU INNER JOIN BANG_SIZE BS ON BS.MA_SIZE = CT.MA_SIZE WHERE CT.MA_CT_SP = @ctsp_MA_CT_SP)+ ', '
			END
			--PRINT(@ctsp_MA_CT_SP + ', ' + @ctsp_SO_LUONG +',' + @ctsp_GIA)
			FETCH NEXT FROM cur_CTSP
			INTO @ctsp_MA_CT_SP, @ctsp_SO_LUONG, @ctsp_GIA
		END

		IF(@CAC_SAN_PHAM_CO_THE_BAN_LO<>N'')
		BEGIN
			GOTO ABORT2
		END

		CLOSE cur_CTSP;
		DEALLOCATE cur_CTSP;
		--end xử lý xml list chi tiet san pham

	COMMIT TRANSACTION

	SELECT @MA_PN_MOI AS affectedId, '' AS errorDesc, 'OK' AS responseMessage 
	
	ABORT:
		ROLLBACK TRANSACTION

		CLOSE cur_CTSP;
		DEALLOCATE cur_CTSP;
		SELECT '' AS affectedId, @@ERROR AS errorDesc, 'Nhập hàng không thành công' AS responseMessage 

	ABORT2:
		ROLLBACK TRANSACTION

		CLOSE cur_CTSP;
		DEALLOCATE cur_CTSP;
		SELECT '' AS affectedId, N'Những sản phẩm sau có giá đang bán thấp hơn hoặc bằng giá nhập, hãy thay đổi giá bán trước khi nhập mới: '+ @CAC_SAN_PHAM_CO_THE_BAN_LO AS errorDesc,  '' AS responseMessage 
END

--DECLARE @XML_STR NVARCHAR(MAX) = '<?xml version="1.0"?>
--<ArrayOfHINH_ANH_SAN_PHAM_ENTITY xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <HINH_ANH_SAN_PHAM_ENTITY>
--    <MA_MAU>M01</MA_MAU>
--    <HINH_ANH>images3.jpg</HINH_ANH>
--  </HINH_ANH_SAN_PHAM_ENTITY>
--</ArrayOfHINH_ANH_SAN_PHAM_ENTITY>'

--DECLARE @XML XML = CAST(@XML_STR AS XML) ;

--DECLARE @tempTable TABLE
--(
--	MA_MAU		VARCHAR(15),
--	HINH_ANH	NVARCHAR(400)
--)
--DECLARE @idoc int
----Create an internal representation of the XML document.
--EXEC sp_xml_preparedocument @idoc OUTPUT, @XML;
---- Execute a SELECT statement that uses the OPENXML rowset provider.
----SELECT    *
----FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
----            WITH (
----				MA_MAU		VARCHAR(15),
----				HINH_ANH	NVARCHAR(400)
----			);

--DECLARE @MA_MAU VARCHAR(15), @HINH_ANH NVARCHAR(400)

--DECLARE cur CURSOR FOR
--	SELECT    *
--	FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
--            WITH (
--				MA_MAU		VARCHAR(15),
--				HINH_ANH	NVARCHAR(400)
--			);

--OPEN cur
GO
/****** Object:  StoredProcedure [dbo].[THEM_PHIEU_TRA]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
--exec THEM_PHIEU_TRA @GHI_CHU=N'',@MA_NV='NV01',@xml_LIST_CHI_TIET_PT_STR=N'<?xml version="1.0"?>
--<ArrayOfCHI_TIET_GIO_HANG_ENTITY xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <CHI_TIET_GIO_HANG_ENTITY>
--    <STT>0</STT>
--    <MA_CT_GH>48</MA_CT_GH>
--    <ID_GH>32</ID_GH>
--    <MA_CT_SP>352</MA_CT_SP>
--    <MA_SP>SP0000000000023</MA_SP>
--    <TEN_SP>Sơ mi lacoste real 2910</TEN_SP>
--    <HINH_ANH>so-mi-lacoste.webp</HINH_ANH>
--    <TEN_SIZE>L</TEN_SIZE>
--    <TEN_MAU>Xanh đen</TEN_MAU>
--    <GIA>330000</GIA>
--    <SO_LUONG>1</SO_LUONG>
--    <SL_DA_TRA>0</SL_DA_TRA>
--    <SL_TRA>1</SL_TRA>
--  </CHI_TIET_GIO_HANG_ENTITY>
--</ArrayOfCHI_TIET_GIO_HANG_ENTITY>'
--go
-- =============================================
CREATE   PROCEDURE [dbo].[THEM_PHIEU_TRA]
	@ID_GH INT,
	 @GHI_CHU NVARCHAR(1000) = NULL
	,@MA_NV VARCHAR(15)
	,@xml_LIST_CHI_TIET_PT_STR NVARCHAR(MAX)
AS
BEGIN
	BEGIN TRANSACTION
		DECLARE @MA_PT_MOI VARCHAR(15)
		EXEC GEN_CODE @tableName = 'PHIEU_TRA', @prefix = 'PT', @result = @MA_PT_MOI OUTPUT

		DECLARE @MA_HD VARCHAR(15)
		SELECT @MA_HD = MA_HD FROM HOA_DON WHERE ID_DH = @ID_GH

		-- thêm vào bảng phiếu trả
			INSERT INTO PHIEU_TRA(MA_PT,MA_HD, GHI_CHU, MA_NV, NGAY_TAO)
				VALUES (@MA_PT_MOI, @MA_HD, @GHI_CHU, @MA_NV, GETDATE())
		
				IF @@ERROR <> 0
				GOTO ABORT

		-- xử lý xml list chi tiết sản phẩm
		DECLARE @XML_LIST_CHI_TIET_SP XML = CAST(@xml_LIST_CHI_TIET_PT_STR AS XML) ;

		DECLARE @idoc_CTSP int
		--Create an internal representation of the XML document.
		EXEC sp_xml_preparedocument @idoc_CTSP OUTPUT, @XML_LIST_CHI_TIET_SP;
		-- Execute a SELECT statement that uses the OPENXML rowset provider.
		--SELECT    *
		--FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
		--            WITH (
		--				MA_MAU		VARCHAR(15),
		--				HINH_ANH	NVARCHAR(400)
		--			);

		DECLARE @ctsp_MA_CT_GH INT, @ctsp_MA_CT_SP INT, @ctsp_SL_TRA INT

		DECLARE cur_CTSP CURSOR FOR
			SELECT *
			FROM OPENXML (@idoc_CTSP, '/ArrayOfCHI_TIET_GIO_HANG_ENTITY/CHI_TIET_GIO_HANG_ENTITY',2)
					WITH (
						MA_CT_GH INT,
						MA_CT_SP INT,
						SL_TRA INT
					);

		OPEN cur_CTSP

		FETCH NEXT FROM cur_CTSP
		INTO @ctsp_MA_CT_GH, @ctsp_MA_CT_SP, @ctsp_SL_TRA

		WHILE @@FETCH_STATUS = 0
		BEGIN

			INSERT INTO CHI_TIET_PHIEU_TRA(MA_PT, MA_CT_SP, SO_LUONG) 
				VALUES (@MA_PT_MOI, @ctsp_MA_CT_SP, @ctsp_SL_TRA);
			IF @@ERROR <> 0
				GOTO ABORT

			UPDATE CHI_TIET_SAN_PHAM SET SL_TON = SL_TON + @ctsp_SL_TRA WHERE MA_CT_SP = @ctsp_MA_CT_SP
			IF @@ERROR <> 0
				GOTO ABORT

			--PRINT(@ctsp_MA_CT_SP + ', ' + @ctsp_SO_LUONG +',' + @ctsp_GIA)
			FETCH NEXT FROM cur_CTSP
			INTO @ctsp_MA_CT_GH, @ctsp_MA_CT_SP, @ctsp_SL_TRA
		END

		CLOSE cur_CTSP;
		DEALLOCATE cur_CTSP;
		--end xử lý xml list chi tiet san pham

	COMMIT TRANSACTION

	SELECT @MA_PT_MOI AS affectedId, '' AS errorDesc, 'OK' AS responseMessage 
	
	ABORT:
		ROLLBACK TRANSACTION

		CLOSE cur_CTSP;
		DEALLOCATE cur_CTSP;
		SELECT '' AS affectedId, @@ERROR AS errorDesc, 'Trả hàng không thành công' AS responseMessage 
END

--DECLARE @XML_STR NVARCHAR(MAX) = '<?xml version="1.0"?>
--<ArrayOfHINH_ANH_SAN_PHAM_ENTITY xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <HINH_ANH_SAN_PHAM_ENTITY>
--    <MA_MAU>M01</MA_MAU>
--    <HINH_ANH>images3.jpg</HINH_ANH>
--  </HINH_ANH_SAN_PHAM_ENTITY>
--</ArrayOfHINH_ANH_SAN_PHAM_ENTITY>'

--DECLARE @XML XML = CAST(@XML_STR AS XML) ;

--DECLARE @tempTable TABLE
--(
--	MA_MAU		VARCHAR(15),
--	HINH_ANH	NVARCHAR(400)
--)
--DECLARE @idoc int
----Create an internal representation of the XML document.
--EXEC sp_xml_preparedocument @idoc OUTPUT, @XML;
---- Execute a SELECT statement that uses the OPENXML rowset provider.
----SELECT    *
----FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
----            WITH (
----				MA_MAU		VARCHAR(15),
----				HINH_ANH	NVARCHAR(400)
----			);

--DECLARE @MA_MAU VARCHAR(15), @HINH_ANH NVARCHAR(400)

--DECLARE cur CURSOR FOR
--	SELECT    *
--	FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
--            WITH (
--				MA_MAU		VARCHAR(15),
--				HINH_ANH	NVARCHAR(400)
--			);

--OPEN cur
GO
/****** Object:  StoredProcedure [dbo].[THEM_SAN_PHAM]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[THEM_SAN_PHAM]
	 @TEN_SP nvarchar(150)
	,@MA_TL VARCHAR(15)
	,@HINH_ANH nvarchar(400)
	,@MO_TA NVARCHAR(500) = NULL
	,@MA_NV VARCHAR(15)
	,@xml_LIST_HINH_ANH_SP_STR NVARCHAR(MAX)
	,@xml_LIST_CHI_TIET_SP_STR NVARCHAR(MAX)
AS
BEGIN
	BEGIN TRANSACTION
		DECLARE @MA_SP_MOI VARCHAR(15)
		EXEC GEN_CODE @tableName = 'SAN_PHAM', @prefix = 'SP', @result = @MA_SP_MOI OUTPUT

		
		-- thêm vào bảng sản phẩm
			INSERT INTO SAN_PHAM(MA_SP ,TEN_SP, MA_TL, NGAY_TAO, LUOT_XEM, HINH_ANH, MO_TA, MA_NV)
				VALUES(@MA_SP_MOI, @TEN_SP, @MA_TL, GETDATE(), 0, @HINH_ANH, @MO_TA, @MA_NV)
		
				IF @@ERROR <> 0
				GOTO ABORT

		-- xử lý xml list hình ảnh sản phẩm
		DECLARE @XML_LIST_HINH_ANH_SP XML = CAST(@xml_LIST_HINH_ANH_SP_STR AS XML) ;

		DECLARE @idoc int
		--Create an internal representation of the XML document.
		EXEC sp_xml_preparedocument @idoc OUTPUT, @XML_LIST_HINH_ANH_SP;
		-- Execute a SELECT statement that uses the OPENXML rowset provider.
		--SELECT    *
		--FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
		--            WITH (
		--				MA_MAU		VARCHAR(15),
		--				HINH_ANH	NVARCHAR(400)
		--			);

		DECLARE @x_MA_MAU VARCHAR(15), @x_HINH_ANH NVARCHAR(400)
		DECLARE cur CURSOR FOR
			SELECT    *
				FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
					WITH (
						MA_MAU		VARCHAR(15),
						HINH_ANH	NVARCHAR(400)
					);
		OPEN cur

		FETCH NEXT FROM cur
		INTO @x_MA_MAU, @x_HINH_ANH

		WHILE @@FETCH_STATUS = 0
		BEGIN

			INSERT INTO HINH_ANH_SAN_PHAM(MA_SP, MA_MAU, HINH_ANH) 
				VALUES (@MA_SP_MOI, @x_MA_MAU, @x_HINH_ANH);
			IF @@ERROR <> 0
				GOTO ABORT

			PRINT(@x_MA_MAU + ', ' + @x_HINH_ANH)
			FETCH NEXT FROM cur
			INTO @x_MA_MAU, @x_HINH_ANH
		END

		CLOSE cur;
		DEALLOCATE cur;
		--end xử lý xml list hinh anh san pham

		-- xử lý xml list chi tiết sản phẩm
		DECLARE @XML_LIST_CHI_TIET_SP XML = CAST(@xml_LIST_CHI_TIET_SP_STR AS XML) ;

		DECLARE @idoc_CTSP int
		--Create an internal representation of the XML document.
		EXEC sp_xml_preparedocument @idoc_CTSP OUTPUT, @XML_LIST_CHI_TIET_SP;
		-- Execute a SELECT statement that uses the OPENXML rowset provider.
		--SELECT    *
		--FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
		--            WITH (
		--				MA_MAU		VARCHAR(15),
		--				HINH_ANH	NVARCHAR(400)
		--			);

		DECLARE @ctsp_MA_MAU VARCHAR(15), @ctsp_MA_SIZE VARCHAR(15), @ctsp_GIA INT

		DECLARE cur_CTSP CURSOR FOR
			SELECT *
			FROM OPENXML (@idoc_CTSP, '/ArrayOfCHI_TIET_SAN_PHAM_ENTITY/CHI_TIET_SAN_PHAM_ENTITY',2)
					WITH (
						MA_MAU	VARCHAR(15),
						MA_SIZE	VARCHAR(15),
						GIA INT
					);

		OPEN cur_CTSP

		FETCH NEXT FROM cur_CTSP
		INTO @ctsp_MA_MAU, @ctsp_MA_SIZE, @ctsp_GIA

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO CHI_TIET_SAN_PHAM(MA_SP, MA_MAU, MA_SIZE, SL_TON) 
				VALUES (@MA_SP_MOI, @ctsp_MA_MAU, @ctsp_MA_SIZE, 0);
			IF @@ERROR <> 0
				GOTO ABORT
			PRINT(@ctsp_MA_MAU + ', ' + @ctsp_MA_SIZE)

			
			INSERT INTO THAY_DOI_GIA (MA_CT_SP, GIA, NGAY_THAY_DOI, MA_NV) 
			VALUES ((SELECT MA_CT_SP FROM CHI_TIET_SAN_PHAM ctsp where ctsp.MA_MAU = @ctsp_MA_MAU and ctsp.MA_SIZE = @ctsp_MA_SIZE and ctsp.MA_SP=@MA_SP_MOI)
			,@ctsp_GIA, GETDATE(), @MA_NV)
				
			IF @@ERROR <> 0
					GOTO ABORT

			FETCH NEXT FROM cur_CTSP
			INTO @ctsp_MA_MAU, @ctsp_MA_SIZE, @ctsp_GIA
		END

		CLOSE cur_CTSP;
		DEALLOCATE cur_CTSP;
		--end xử lý xml list chi tiet san pham

			
			--INSERT INTO THAY_DOI_GIA (MA_CT_SP, GIA, NGAY_THAY_DOI, MA_NV) 
			--	SELECT MA_CT_SP, 0 AS GIA, GETDATE() AS NGAY_THAY_DOI, @MA_NV AS MA_NV FROM CHI_TIET_SAN_PHAM WHERE MA_SP = @MA_SP_MOI
			--IF @@ERROR <> 0
			--		GOTO ABORT


	COMMIT TRANSACTION

	SELECT @MA_SP_MOI AS affectedId, '' AS errorDesc, 'OK' AS responseMessage 
	ABORT:
		ROLLBACK TRANSACTION
		CLOSE cur;
		DEALLOCATE cur;
		CLOSE cur_CTSP;
		DEALLOCATE cur_CTSP;
		SELECT '' AS affectedId, @@ERROR AS errorDesc, 'Có lỗi xảy ra' AS responseMessage 
END

--DECLARE @XML_STR NVARCHAR(MAX) = '<?xml version="1.0"?>
--<ArrayOfHINH_ANH_SAN_PHAM_ENTITY xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <HINH_ANH_SAN_PHAM_ENTITY>
--    <MA_MAU>M01</MA_MAU>
--    <HINH_ANH>images3.jpg</HINH_ANH>
--  </HINH_ANH_SAN_PHAM_ENTITY>
--</ArrayOfHINH_ANH_SAN_PHAM_ENTITY>'

--DECLARE @XML XML = CAST(@XML_STR AS XML) ;

--DECLARE @tempTable TABLE
--(
--	MA_MAU		VARCHAR(15),
--	HINH_ANH	NVARCHAR(400)
--)
--DECLARE @idoc int
----Create an internal representation of the XML document.
--EXEC sp_xml_preparedocument @idoc OUTPUT, @XML;
---- Execute a SELECT statement that uses the OPENXML rowset provider.
----SELECT    *
----FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
----            WITH (
----				MA_MAU		VARCHAR(15),
----				HINH_ANH	NVARCHAR(400)
----			);

--DECLARE @MA_MAU VARCHAR(15), @HINH_ANH NVARCHAR(400)

--DECLARE cur CURSOR FOR
--	SELECT    *
--	FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
--            WITH (
--				MA_MAU		VARCHAR(15),
--				HINH_ANH	NVARCHAR(400)
--			);

--OPEN cur
GO
/****** Object:  StoredProcedure [dbo].[THEM_SIZE]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[THEM_SIZE] @TEN_SIZE NVARCHAR(50), @MA_NV VARCHAR(15)
AS
BEGIN
	DECLARE @errorMessage NVARCHAR(500) = N''
	DECLARE @responseMessage NVARCHAR(500) = N''
	DECLARE @MA_SIZE_MOI VARCHAR(15) = ''

	BEGIN TRANSACTION
		IF EXISTS(SELECT * FROM BANG_SIZE WHERE TEN_SIZE = @TEN_SIZE)
		BEGIN
			SET @errorMessage = N'Tên size đã tồn tại'
			GOTO ABORT
		END
		EXEC GEN_CODE @tableName = 'BANG_SIZE', @prefix = 'SZ', @result = @MA_SIZE_MOI OUTPUT
		INSERT INTO BANG_SIZE(MA_SIZE, TEN_SIZE, NGAY_TAO, MA_NV) VALUES (@MA_SIZE_MOI, @TEN_SIZE, GETDATE(), @MA_NV)
		IF @@ERROR <>0
			GOTO ABORT
	COMMIT TRANSACTION
	SELECT @MA_SIZE_MOI AS affectedId, N'Thêm size mới thành công' AS responseMessage
	ABORT:
		ROLLBACK TRANSACTION
		SELECT '' AS affectedId, @errorMessage AS errorDesc, @responseMessage AS responseMessage
END;
GO
/****** Object:  StoredProcedure [dbo].[THEM_THAY_DOI_GIA]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
--exec THEM_THAY_DOI_GIA @MA_NV='NV01',@xml_LIST_THAY_DOI_GIA_STR=N'<?xml version="1.0"?>
--<ArrayOfTHAY_DOI_GIA_ENTITY xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <THAY_DOI_GIA_ENTITY>
--    <MA_CT_SP>345</MA_CT_SP>
--    <MA_SIZE>S02</MA_SIZE>
--    <MA_MAU>M06</MA_MAU>
--    <TEN_MAU>Trắng</TEN_MAU>
--    <NGAY_THAY_DOI xsi:nil="true" />
--    <TEN_SIZE>M</TEN_SIZE>
--    <GIA>300000</GIA>
--    <GIA_THAY_DOI>199999</GIA_THAY_DOI>
--  </THAY_DOI_GIA_ENTITY>
--  <THAY_DOI_GIA_ENTITY>
--    <MA_CT_SP>346</MA_CT_SP>
--    <MA_SIZE>S03</MA_SIZE>
--    <MA_MAU>M06</MA_MAU>
--    <TEN_MAU>Trắng</TEN_MAU>
--    <NGAY_THAY_DOI xsi:nil="true" />
--    <TEN_SIZE>L</TEN_SIZE>
--    <GIA>330000</GIA>
--    <GIA_THAY_DOI>299999</GIA_THAY_DOI>
--  </THAY_DOI_GIA_ENTITY>
--  <THAY_DOI_GIA_ENTITY>
--    <MA_CT_SP>348</MA_CT_SP>
--    <MA_SIZE>S02</MA_SIZE>
--    <MA_MAU>M07</MA_MAU>
--    <TEN_MAU>Xám</TEN_MAU>
--    <NGAY_THAY_DOI xsi:nil="true" />
--    <TEN_SIZE>M</TEN_SIZE>
--    <GIA>300000</GIA>
--    <GIA_THAY_DOI>199999</GIA_THAY_DOI>
--  </THAY_DOI_GIA_ENTITY>
--  <THAY_DOI_GIA_ENTITY>
--    <MA_CT_SP>349</MA_CT_SP>
--    <MA_SIZE>S03</MA_SIZE>
--    <MA_MAU>M07</MA_MAU>
--    <TEN_MAU>Xám</TEN_MAU>
--    <NGAY_THAY_DOI xsi:nil="true" />
--    <TEN_SIZE>L</TEN_SIZE>
--    <GIA>330000</GIA>
--    <GIA_THAY_DOI>299999</GIA_THAY_DOI>
--  </THAY_DOI_GIA_ENTITY>
--  <THAY_DOI_GIA_ENTITY>
--    <MA_CT_SP>351</MA_CT_SP>
--    <MA_SIZE>S02</MA_SIZE>
--    <MA_MAU>M09</MA_MAU>
--    <TEN_MAU>Xanh đen</TEN_MAU>
--    <NGAY_THAY_DOI xsi:nil="true" />
--    <TEN_SIZE>M</TEN_SIZE>
--    <GIA>300000</GIA>
--    <GIA_THAY_DOI>200000</GIA_THAY_DOI>
--  </THAY_DOI_GIA_ENTITY>
--  <THAY_DOI_GIA_ENTITY>
--    <MA_CT_SP>352</MA_CT_SP>
--    <MA_SIZE>S03</MA_SIZE>
--    <MA_MAU>M09</MA_MAU>
--    <TEN_MAU>Xanh đen</TEN_MAU>
--    <NGAY_THAY_DOI xsi:nil="true" />
--    <TEN_SIZE>L</TEN_SIZE>
--    <GIA>330000</GIA>
--    <GIA_THAY_DOI>299999</GIA_THAY_DOI>
--  </THAY_DOI_GIA_ENTITY>
--</ArrayOfTHAY_DOI_GIA_ENTITY>'
--go
-- =============================================
CREATE   PROCEDURE [dbo].[THEM_THAY_DOI_GIA]
	@MA_NV VARCHAR(15)
	,@xml_LIST_THAY_DOI_GIA_STR NVARCHAR(MAX)
AS
BEGIN
	BEGIN TRANSACTION
		--DECLARE @MA_PN_MOI VARCHAR(15)
		--EXEC GEN_CODE @tableName = 'PHIEU_NHAP', @prefix = 'PN', @result = @MA_PN_MOI OUTPUT
		
		---- thêm vào bảng phiếu nhập
		--	INSERT INTO PHIEU_NHAP (MA_PN, GHI_CHU, MA_NV, NGAY_TAO)
		--		VALUES(@MA_PN_MOI, @GHI_CHU, @MA_NV, GETDATE())
		
		--		IF @@ERROR <> 0
		--		GOTO ABORT

		-- xử lý xml list chi tiết sản phẩm
		DECLARE @XML_LIST_CHI_TIET_SP XML = CAST(@xml_LIST_THAY_DOI_GIA_STR AS XML) ;

		DECLARE @idoc_CTSP int
		--Create an internal representation of the XML document.
		EXEC sp_xml_preparedocument @idoc_CTSP OUTPUT, @XML_LIST_CHI_TIET_SP;
		-- Execute a SELECT statement that uses the OPENXML rowset provider.
		--SELECT    *
		--FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
		--            WITH (
		--				MA_MAU		VARCHAR(15),
		--				HINH_ANH	NVARCHAR(400)
		--			);

		DECLARE @ctsp_MA_CT_SP INT, @ctsp_GIA_THAY_DOI INT

		DECLARE cur_CTSP CURSOR FOR
			SELECT *
			FROM OPENXML (@idoc_CTSP, '/ArrayOfTHAY_DOI_GIA_ENTITY/THAY_DOI_GIA_ENTITY',2)
					WITH (
						MA_CT_SP INT,
						GIA_THAY_DOI INT
					);

		OPEN cur_CTSP

		FETCH NEXT FROM cur_CTSP
		INTO @ctsp_MA_CT_SP, @ctsp_GIA_THAY_DOI

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO THAY_DOI_GIA(MA_NV, MA_CT_SP, NGAY_THAY_DOI, GIA) 
				VALUES (@MA_NV, @ctsp_MA_CT_SP, GETDATE(), @ctsp_GIA_THAY_DOI);
			IF @@ERROR <> 0
				GOTO ABORT

			--PRINT(@ctsp_MA_CT_SP + ', ' + @ctsp_SO_LUONG +',' + @ctsp_GIA)
			FETCH NEXT FROM cur_CTSP
			INTO @ctsp_MA_CT_SP, @ctsp_GIA_THAY_DOI
		END

		CLOSE cur_CTSP;
		DEALLOCATE cur_CTSP;
		--end xử lý xml list chi tiet san pham

	COMMIT TRANSACTION

	SELECT '' AS affectedId, '' AS errorDesc, 'OK' AS responseMessage 
	
	ABORT:
		ROLLBACK TRANSACTION

		CLOSE cur_CTSP;
		DEALLOCATE cur_CTSP;
		SELECT '' AS affectedId, @@ERROR AS errorDesc, 'Thêm thay đổi giá không thành công' AS responseMessage 
END

--DECLARE @XML_STR NVARCHAR(MAX) = '<?xml version="1.0"?>
--<ArrayOfHINH_ANH_SAN_PHAM_ENTITY xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <HINH_ANH_SAN_PHAM_ENTITY>
--    <MA_MAU>M01</MA_MAU>
--    <HINH_ANH>images3.jpg</HINH_ANH>
--  </HINH_ANH_SAN_PHAM_ENTITY>
--</ArrayOfHINH_ANH_SAN_PHAM_ENTITY>'

--DECLARE @XML XML = CAST(@XML_STR AS XML) ;

--DECLARE @tempTable TABLE
--(
--	MA_MAU		VARCHAR(15),
--	HINH_ANH	NVARCHAR(400)
--)
--DECLARE @idoc int
----Create an internal representation of the XML document.
--EXEC sp_xml_preparedocument @idoc OUTPUT, @XML;
---- Execute a SELECT statement that uses the OPENXML rowset provider.
----SELECT    *
----FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
----            WITH (
----				MA_MAU		VARCHAR(15),
----				HINH_ANH	NVARCHAR(400)
----			);

--DECLARE @MA_MAU VARCHAR(15), @HINH_ANH NVARCHAR(400)

--DECLARE cur CURSOR FOR
--	SELECT    *
--	FROM OPENXML (@idoc, '/ArrayOfHINH_ANH_SAN_PHAM_ENTITY/HINH_ANH_SAN_PHAM_ENTITY',2)
--            WITH (
--				MA_MAU		VARCHAR(15),
--				HINH_ANH	NVARCHAR(400)
--			);

--OPEN cur
GO
/****** Object:  StoredProcedure [dbo].[THEM_VAO_CHI_TIET_GIO_HANG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[THEM_VAO_CHI_TIET_GIO_HANG]
	@ID_GIO_HANG INT
	,@MA_CT_SP INT
	,@SO_LUONG INT
	,@GIA INT
	--,@RESULT INT OUTPUT
AS
BEGIN
	INSERT INTO dbo.CHI_TIET_DON_HANG
	(
	    ID_DH,
	    MA_CT_SP,
	    SO_LUONG,
	    GIA
	)
	VALUES
	(   @ID_GIO_HANG, -- ID_GH - int
	    @MA_CT_SP, -- MA_CT_SP - int
	    @SO_LUONG, -- SO_LUONG - int
	    @GIA  -- GIA - int
	    )
	UPDATE dbo.CHI_TIET_SAN_PHAM SET SL_TON = SL_TON - @SO_LUONG WHERE MA_CT_SP=@MA_CT_SP
END
GO
/****** Object:  StoredProcedure [dbo].[THICH_BO_THICH_SAN_PHAM]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[THICH_BO_THICH_SAN_PHAM] @MA_KH VARCHAR(15), @MA_SP VARCHAR(15)
AS
	BEGIN
		IF EXISTS(SELECT * FROM YEU_THICH_SAN_PHAM WHERE MA_KH = @MA_KH AND MA_SP = @MA_SP)
		BEGIN
			DELETE FROM YEU_THICH_SAN_PHAM WHERE MA_KH = @MA_KH AND MA_SP = @MA_SP
			SELECT '' AS affectedId, '' AS errorDesc, N'Đã xóa khỏi danh sách yêu thích' AS responseMessage 
		END 
		ELSE
		BEGIN
			INSERT INTO YEU_THICH_SAN_PHAM(MA_KH, MA_SP, NGAY_TAO) VALUES(@MA_KH, @MA_SP, GETDATE())
			SELECT @MA_SP AS affectedId, '' AS errorDesc, N'Đã thêm vào danh sách yêu thích' AS responseMessage 
		END
	END
GO
/****** Object:  StoredProcedure [dbo].[TIM_SP]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE   PROCEDURE [dbo].[TIM_SP] @top INT = NULL, @keyWord NVARCHAR(500) = NULL , @priceFrom Int = 0, @priceTo Int = 1000000
AS
BEGIN
	IF(@top IS NULL)
	SET @top = (SELECT COUNT(*) FROM dbo.SAN_PHAM)

		BEGIN

			SELECT TOP(@top) S.*,
				TL.TEN_TL
				,TL.TEN_TL-- chỉ lấy phần trăm giảm nếu đợt khuyến mãi đó đang khuyến mãi (xem UDF_KiemTraDotKhuyenMaiDangKhuyenMai)
				,CASE WHEN dbo. UDF_KiemTraDotKhuyenMaiDangKhuyenMai(KM.MA_KM)=1 THEN CTKM.PHAN_TRAM_GIAM  ELSE 0 END as PHAN_TRAM_GIAM
				,dbo.UDF_LayStringGia(S.MA_SP) AS GIA_STR,
				dbo.UDF_LayStringGiaDaGiam(S.MA_SP) AS GIA_STR_DA_GIAM
				,dbo.UDF_LayStringSize(S.MA_SP) AS SIZE_STR
				, dbo.UDF_LayTongSoLuongTonCuaMotSP(S.MA_SP) AS TONG_SL_TON

			FROM dbo.SAN_PHAM S LEFT JOIN (SELECT * FROM dbo.CHI_TIET_KHUYEN_MAI WHERE dbo. UDF_KiemTraDotKhuyenMaiDangKhuyenMai(MA_KM)=1) CTKM ON CTKM.MA_SP = S.MA_SP
								LEFT JOIN dbo.KHUYEN_MAI KM ON KM.MA_KM = CTKM.MA_KM 
								LEFT JOIN dbo.THE_LOAI TL ON TL.MA_TL = S.MA_TL
								WHERE (S.TEN_SP LIKE '%'+@keyWord+'%' OR TL.TEN_TL LIKE '%'+@keyWord+'%')

								-- xét trường hợp khoảng giá trong khoảng cần tìm, đã giảm giá nếu có
								AND (dbo.[UDF_LayGiaNhoNhatDaGiamGiaTrongThayDoiGiaCuaSanPham](S.MA_SP) >= @priceFrom AND dbo.[UDF_LayGiaNhoNhatDaGiamGiaTrongThayDoiGiaCuaSanPham](S.MA_SP) <= @priceTo)
		END
	
END
 --EXEC [TIM_SP] NULL, N'áo khoa', 0, 1000000


GO
/****** Object:  StoredProcedure [dbo].[VO_HIEU_HOA_TAI_KHOAN_KHACH_HANG]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[VO_HIEU_HOA_TAI_KHOAN_KHACH_HANG] @MA_KH VARCHAR(15)
AS
BEGIN
	DECLARE @errorMessage NVARCHAR(500) = N''
	DECLARE @responseMessage NVARCHAR(500) = N''

	BEGIN TRANSACTION
		--IF EXISTS(SELECT * FROM CHI_TIET_SAN_PHAM WHERE MA_SIZE = @MA_SIZE)
		--BEGIN
		--	SET @errorMessage = N'Size đã được sử dụng, không thể xóa'
		--	GOTO ABORT
		--END
		UPDATE KHACH_HANG SET TRANG_THAI = 0 WHERE MA_KH = @MA_KH
		IF @@ERROR <>0
			GOTO ABORT
	COMMIT TRANSACTION
	SELECT @MA_KH AS affectedId, N'Vô hiệu hóa tài khoản khách hàng '+ @MA_KH  +N' thành công' AS responseMessage
	ABORT:
		ROLLBACK TRANSACTION
		SELECT '' AS affectedId, @errorMessage AS errorDesc, @responseMessage AS responseMessage
END;
GO
/****** Object:  StoredProcedure [dbo].[VO_HIEU_HOA_TAI_KHOAN_NHAN_VIEN]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[VO_HIEU_HOA_TAI_KHOAN_NHAN_VIEN] @MA_NV VARCHAR(15)
AS
BEGIN
	DECLARE @errorMessage NVARCHAR(500) = N''
	DECLARE @responseMessage NVARCHAR(500) = N''

	BEGIN TRANSACTION
		--IF EXISTS(SELECT * FROM CHI_TIET_SAN_PHAM WHERE MA_SIZE = @MA_SIZE)
		--BEGIN
		--	SET @errorMessage = N'Size đã được sử dụng, không thể xóa'
		--	GOTO ABORT
		--END

		IF NOT EXISTS(SELECT * FROM NHAN_VIEN NV INNER JOIN TAI_KHOAN TK ON NV.MA_TK = TK.MA_TK WHERE TK.MA_QUYEN = 'Q02' AND NV.MA_NV <> @MA_NV AND NV.TRANG_THAI = 1)--quyền quản lý
		BEGIN
			SET @errorMessage = N'Không thể vô hiệu hóa tài khoản nhân viên quản lý duy nhất còn hoạt động'
			GOTO ABORT
		END

		UPDATE NHAN_VIEN SET TRANG_THAI = 0 WHERE MA_NV = @MA_NV
		IF @@ERROR <>0
			GOTO ABORT
	COMMIT TRANSACTION
	SELECT @MA_NV AS affectedId, N'Vô hiệu hóa tài khoản nhân viên '+ @MA_NV  +N' thành công' AS responseMessage
	ABORT:
		ROLLBACK TRANSACTION
		SELECT '' AS affectedId, @errorMessage AS errorDesc, @responseMessage AS responseMessage
END;
GO
/****** Object:  StoredProcedure [dbo].[XOA_DOT_KHUYEN_MAI]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [dbo].[XOA_DOT_KHUYEN_MAI] @MA_KM VARCHAR(15)
AS
BEGIN
	DECLARE @errorMessage NVARCHAR(500) = N''

	
	BEGIN TRANSACTION
		--DELETE CHI_TIET_KHUYEN_MAI WHERE MA_KM = @MA_KM
		--IF @@ERROR <> 0
		--BEGIN
		--	SET @errorMessage = N'Xóa đợt khuyến mãi không thành công'
		--	GOTO ABORT
		--END
		--DELETE KHUYEN_MAI WHERE MA_KM = @MA_KM
		--IF @@ERROR <> 0
		--BEGIN
		--	SET @errorMessage = N'Xóa đợt khuyến mãi không thành công'
		--	GOTO ABORT
		--END
		UPDATE KHUYEN_MAI SET TRANG_THAI = 0 WHERE MA_KM = @MA_KM
		IF @@ERROR <> 0
		BEGIN
			SET @errorMessage = N'Xóa đợt khuyến mãi không thành công'
			GOTO ABORT
		END
	COMMIT TRANSACTION
	SELECT @MA_KM AS affectedId, N'Xóa đợt khuyến mãi thành công' AS responseMessage
	ABORT:
		ROLLBACK TRANSACTION
		SELECT '' AS affectedId, @errorMessage AS errorDesc
END
GO
/****** Object:  StoredProcedure [dbo].[XOA_MAU]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[XOA_MAU] @MA_MAU VARCHAR(15)
AS
BEGIN
	DECLARE @errorMessage NVARCHAR(500) = N''
	DECLARE @responseMessage NVARCHAR(500) = N''

	BEGIN TRANSACTION
		IF EXISTS(SELECT * FROM CHI_TIET_SAN_PHAM WHERE MA_MAU = @MA_MAU) OR EXISTS(SELECT * FROM HINH_ANH_SAN_PHAM WHERE MA_MAU = @MA_MAU)
		BEGIN
			SET @errorMessage = N'Màu đã được sử dụng, không thể xóa'
			GOTO ABORT
		END
		DELETE BANG_MAU WHERE MA_MAU = @MA_MAU
		IF @@ERROR <>0
			GOTO ABORT
	COMMIT TRANSACTION
	SELECT @MA_MAU AS affectedId, N'Xóa màu '+ @MA_MAU  +N' thành công' AS responseMessage
	ABORT:
		ROLLBACK TRANSACTION
		SELECT '' AS affectedId, @errorMessage AS errorDesc, @responseMessage AS responseMessage
END;
GO
/****** Object:  StoredProcedure [dbo].[XOA_SAN_PHAM]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROC [dbo].[XOA_SAN_PHAM] @MA_SP VARCHAR(15)
AS
BEGIN
	DECLARE @errorMessage NVARCHAR(500) = N''
	DECLARE @LIST_MA_CT_SP TABLE(
		MA_CT_SP INT
	)

	INSERT INTO @LIST_MA_CT_SP
	SELECT MA_CT_SP  FROM CHI_TIET_SAN_PHAM WHERE MA_SP = @MA_SP 
	 
	BEGIN TRANSACTION
		IF EXISTS(SELECT * FROM CHI_TIET_DON_HANG WHERE MA_CT_SP IN (SELECT MA_CT_SP FROM @LIST_MA_CT_SP))
			BEGIN
				SET @errorMessage = N'Sản phẩm đã từng được thêm vào giỏ hàng của khách, không thể xóa'
				GOTO ABORT
			END
		IF EXISTS(SELECT * FROM CHI_TIET_PHIEU_NHAP WHERE MA_CT_SP IN (SELECT MA_CT_SP FROM @LIST_MA_CT_SP))
			BEGIN
				SET @errorMessage = N'Sản phẩm đã xuất hiện trong phiếu nhập, không thể xóa'
				GOTO ABORT
			END
		IF EXISTS(SELECT * FROM CHI_TIET_PHIEU_TRA WHERE MA_CT_SP IN (SELECT MA_CT_SP FROM @LIST_MA_CT_SP))
			BEGIN
				SET @errorMessage = N'Sản phẩm đã xuất hiện trong phiếu trả, không thể xóa'
				GOTO ABORT
			END
		IF EXISTS(SELECT * FROM CHI_TIET_KHUYEN_MAI WHERE MA_SP = @MA_SP)
			BEGIN
				SET @errorMessage = N'Sản phẩm đã xuất hiện trong đợt khuyến mãi, không thể xóa'
				GOTO ABORT
			END
		IF EXISTS(SELECT * FROM YEU_THICH_SAN_PHAM WHERE MA_SP = @MA_SP)
			BEGIN
				SET @errorMessage = N'Sản phẩm đã xuất hiện trong danh sách yêu thích của khách hàng, không thể xóa'
				GOTO ABORT
			END
		DELETE THAY_DOI_GIA WHERE MA_CT_SP IN (SELECT MA_CT_SP FROM @LIST_MA_CT_SP)
		IF @@ERROR <> 0
			BEGIN
				SET @errorMessage = N'Có lỗi xảy ra khi xóa thay đổi giá'
				GOTO ABORT
			END
		DELETE HINH_ANH_SAN_PHAM WHERE MA_SP = @MA_SP
		IF @@ERROR <> 0
			BEGIN
				SET @errorMessage = N'Có lỗi xảy ra khi xóa hình ảnh của sản phẩm'
				GOTO ABORT
			END
		DELETE CHI_TIET_SAN_PHAM WHERE MA_SP = @MA_SP
		IF @@ERROR <> 0
			BEGIN
				SET @errorMessage = N'Có lỗi xảy ra khi xóa chi tiết của sản phẩm'
				GOTO ABORT
			END

		DELETE SAN_PHAM WHERE MA_SP = @MA_SP
		IF @@ERROR <> 0
			BEGIN
				SET @errorMessage = N'Có lỗi xảy ra khi xóa sản phẩm'
				GOTO ABORT
			END
	COMMIT TRANSACTION
	SELECT @MA_SP AS affectedId, N'Xóa sản phẩm thành công' AS responseMessage
	ABORT:
		ROLLBACK TRANSACTION
		SELECT '' AS affectedId, @errorMessage AS errorDesc
END
GO
/****** Object:  StoredProcedure [dbo].[XOA_SIZE]    Script Date: 19/01/2024 11:16:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[XOA_SIZE] @MA_SIZE VARCHAR(15)
AS
BEGIN
	DECLARE @errorMessage NVARCHAR(500) = N''
	DECLARE @responseMessage NVARCHAR(500) = N''

	BEGIN TRANSACTION
		IF EXISTS(SELECT * FROM CHI_TIET_SAN_PHAM WHERE MA_SIZE = @MA_SIZE)
		BEGIN
			SET @errorMessage = N'Size đã được sử dụng, không thể xóa'
			GOTO ABORT
		END
		DELETE BANG_SIZE WHERE MA_SIZE = @MA_SIZE
		IF @@ERROR <>0
			GOTO ABORT
	COMMIT TRANSACTION
	SELECT @MA_SIZE AS affectedId, N'Xóa size '+ @MA_SIZE  +N' thành công' AS responseMessage
	ABORT:
		ROLLBACK TRANSACTION
		SELECT '' AS affectedId, @errorMessage AS errorDesc, @responseMessage AS responseMessage
END;
GO
USE [master]
GO
ALTER DATABASE [CLOTHING_STORE] SET  READ_WRITE 
GO
