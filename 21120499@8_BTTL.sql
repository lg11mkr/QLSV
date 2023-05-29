-- use GiaoVienDeTai
-- go
-- a. In ra câu chào “Hello World !!!”:

CREATE PROCEDURE HelloWorld
AS
BEGIN
    PRINT 'Hello World !!!'
END
go

-- b. In ra tổng 2 số:

CREATE PROCEDURE CalculateSum
    @Number1 INT,
    @Number2 INT
AS
BEGIN
    DECLARE @Sum INT
    SET @Sum = @Number1 + @Number2
    PRINT N'Tổng hai số là: ' + CAST(@Sum AS VARCHAR)
END
go

-- c. Tính tổng 2 số (sử dụng biến output để lưu kết quả trả về):


CREATE PROCEDURE CalculateSumOutput
    @Number1 INT,
    @Number2 INT,
    @Sum INT OUTPUT
AS
BEGIN
    SET @Sum = @Number1 + @Number2
END
go
-- d. In ra tổng 3 số (Sử dụng lại stored procedure Tính tổng 2 số):


Create PROCEDURE CalculateSumThreeNumbers
    @Number1 INT,
    @Number2 INT,
    @Number3 INT
AS
BEGIN
    DECLARE @Sum1 INT, @Sum2 INT
    EXEC CalculateSumOutput @Number1, @Number2, @Sum1 OUTPUT
    EXEC CalculateSumOutput @Sum1, @Number3, @Sum2 OUTPUT
	PRINT N'Tổng của 3 số =' + CAST(@Sum2 AS VARCHAR)
END
GO
-- e. In ra tổng các số nguyên từ m đến n:


CREATE PROCEDURE CalculateSumRange
    @StartNumber INT,
    @EndNumber INT
AS
BEGIN
    DECLARE @Sum INT
    SET @Sum = 0

    WHILE @StartNumber <= @EndNumber
    BEGIN
        SET @Sum = @Sum + @StartNumber
        SET @StartNumber = @StartNumber + 1
    END

    PRINT N'Tổng các số từ ' + CAST(@StartNumber AS VARCHAR) + N' đến ' + CAST(@EndNumber AS VARCHAR) + N' là: ' + CAST(@Sum AS VARCHAR)
END
GO
-- f. Kiểm tra 1 số nguyên có phải là số nguyên tố hay không:


CREATE PROCEDURE CheckPrimeNumber
    @Number INT
AS
BEGIN
    DECLARE @IsPrime BIT
    SET @IsPrime = 1
    DECLARE @Counter INT
    SET @Counter = 2

    WHILE @Counter <= SQRT(@Number)
    BEGIN
        IF @Number % @Counter = 0
        BEGIN
            SET @IsPrime = 0
            BREAK
        END
        SET @Counter = @Counter + 1
    END

    IF @IsPrime = 1
        PRINT N'Số ' + CAST(@Number AS VARCHAR) + N' là số nguyên tố.'
    ELSE
        PRINT N'Số ' + CAST(@Number AS VARCHAR) + N' không là số nguyên tố.'
END
GO
-- g. In ra tổng các số nguyên tố trong đoạn m, n:

CREATE PROCEDURE CalculateSumPrimeNumbers
    @StartNumber INT,
    @EndNumber INT
AS
BEGIN
    DECLARE @Sum INT
    SET @Sum = 0
    DECLARE @Number INT
    SET @Number = @StartNumber
    
    WHILE @Number <= @EndNumber
    BEGIN
        DECLARE @IsPrime BIT
        SET @IsPrime = 1
        DECLARE @Counter INT
        SET @Counter = 2
        
        WHILE @Counter <= SQRT(@Number)
        BEGIN
            IF @Number % @Counter = 0
            BEGIN
                SET @IsPrime = 0
                BREAK
            END
            SET @Counter = @Counter + 1
        END
        
        IF @IsPrime = 1
            SET @Sum = @Sum + @Number
            
        SET @Number = @Number + 1
    END
    
    PRINT N'Tổng các số nguyên tố từ ' + CAST(@StartNumber AS VARCHAR) + N' đến ' + CAST(@EndNumber AS VARCHAR) + N' là: ' + CAST(@Sum AS VARCHAR)
END
GO
-- h. Tính ước chung lớn nhất của 2 số nguyên
CREATE PROCEDURE CalculateGreatestCommonDivisor
    @Number1 INT,
    @Number2 INT,
    @GCD INT OUTPUT
AS
BEGIN
    WHILE @Number2 != 0
    BEGIN
        SET @GCD = @Number2
        SET @Number2 = @Number1 % @Number2
        SET @Number1 = @GCD
    END
END
GO

-- i. Tính bội chung nhỏ nhất của 2 số nguyên
CREATE PROCEDURE CalculateLeastCommonMultiple
    @Number1 INT,
    @Number2 INT,
    @LCM INT OUTPUT
AS
BEGIN
    DECLARE @GCD INT
    EXEC CalculateGreatestCommonDivisor @Number1, @Number2, @GCD OUTPUT

    SET @LCM = (@Number1 * @Number2) / @GCD
END
GO



-- BT su dung csdl tuan 2

go
-- j. Xuất ra toàn bộ danh sách giáo viên.
CREATE PROCEDURE GetAllTeachers
AS
BEGIN
    SELECT * FROM GIAOVIEN
END
GO

-- k. Tính số lượng đề tài mà một giáo viên đang thực hiện.
CREATE PROCEDURE CountProjectsByTeacher
    @MAGV CHAR(5)
AS
BEGIN
    SELECT COUNT(*) AS SoLuongDeTai
    FROM DETAI
    WHERE GVCNDT = @MAGV
END
GO


-- l. In thông tin chi tiết của một giáo viên(sử dụng lệnh print): Thông tin cá nhân, Số lượng đề tài tham gia, Số lượng thân nhân của giáo viên đó.
CREATE PROCEDURE PrintTeacherDetails
    @MAGV CHAR(5)
AS
BEGIN
    DECLARE @SoLuongDeTai INT
    DECLARE @SoLuongThanNhan INT

    SELECT @SoLuongDeTai = COUNT(*) FROM DETAI WHERE GVCNDT = @MAGV
    SELECT @SoLuongThanNhan = COUNT(*) FROM NGUOI_THAN WHERE MAGV = @MAGV

    PRINT N'Thông tin cá nhân của giáo viên:'
    DECLARE @MAGV_CHAR CHAR(5)
    DECLARE @HOTEN NVARCHAR(40)
    DECLARE @LUONG FLOAT
    DECLARE @PHAI NCHAR(3)
    DECLARE @NGAYSINH DATETIME
    DECLARE @DIACHI NVARCHAR(100)
    DECLARE @GVQLCM CHAR(5)
    DECLARE @MABM CHAR(5)

    SELECT @MAGV_CHAR = MAGV, @HOTEN = HOTEN, @LUONG = LUONG, @PHAI = PHAI, @NGAYSINH = NGAYSINH, @DIACHI = DIACHI, @GVQLCM = GVQLCM, @MABM = MABM
    FROM GIAOVIEN
    WHERE MAGV = @MAGV

    PRINT N'Mã giáo viên: ' + @MAGV_CHAR
    PRINT N'Họ tên: ' + @HOTEN
    PRINT N'Lương: ' + CAST(@LUONG AS NVARCHAR(20))
    PRINT N'Giới tính: ' + @PHAI
    PRINT N'Ngày sinh: ' + CAST(@NGAYSINH AS NVARCHAR(20))
    PRINT N'Địa chỉ: ' + @DIACHI
    PRINT N'Giáo viên quản lý chính mình: ' + @GVQLCM
    PRINT N'Mã bộ môn: ' + @MABM

    PRINT N'Số lượng đề tài tham gia: ' + CAST(@SoLuongDeTai AS NVARCHAR(10))
    PRINT N'Số lượng thân nhân: ' + CAST(@SoLuongThanNhan AS NVARCHAR(10))
END
GO

-- m. Kiểm tra xem một giáo viên có tồn tại hay không (dựa vào MAGV).
CREATE PROCEDURE CheckTeacherExists
    @MAGV CHAR(5)
AS
BEGIN
    IF EXISTS (SELECT * FROM GIAOVIEN WHERE MAGV = @MAGV)
        PRINT N'Giáo viên tồn tại'
    ELSE
        PRINT N'Giáo viên không tồn tại'
END
GO

-- n. Kiểm tra quy định của một giáo viên: Chỉ được thực hiện các đề tài mà bộ môn của giáo viên đó làm chủ nhiệm.


CREATE PROCEDURE CheckTeacherRule
    @MAGV CHAR(5)
AS
BEGIN
    IF (EXISTS(
        SELECT *
		FROM DETAI DT
		WHERE DT.GVCNDT = @MAGV
		AND NOT EXISTS (
			SELECT *
			FROM THAMGIADT TG
			WHERE TG.MAGV= @MAGV
			AND TG.MADT <> DT.MADT
		)
    ))
    BEGIN
        PRINT N'Giáo viên không thỏa mãn quy định'
    END
    ELSE
    BEGIN
        PRINT N'Giáo viên thỏa mãn quy định'
    END
END
GO

-- o. Thực hiện thêm một phân công cho giáo viên thực hiện một công việc của đề tài
CREATE PROCEDURE AddTask
    @MADT CHAR(5),
    @STT INT,
    @TENCV NVARCHAR(50),
    @NGAYBD datetime,
	@NGAYKT datetime
AS
BEGIN
    IF ( @MADT NOT IN (SELECT MADT FROM DETAI))
        BEGIN
            PRINT N'Đề tài không tồn tại'
            RETURN
        END

    IF EXISTS (SELECT * FROM CONGVIEC WHERE MADT = @MADT AND STT = @STT)
        BEGIN
            PRINT N'Công việc đã tồn tại'
            RETURN
        END

    IF @NGAYBD < (SELECT NGAYBD FROM DETAI where MADT = @MADT)
	OR @NGAYKT > (SELECT NGAYKT FROM DETAI where MADT = @MADT)
        BEGIN
            PRINT N'Thời gian tham gia không hợp lệ'
            RETURN
        END

    -- Thêm phân công công việc
    INSERT INTO CONGVIEC
    VALUES (@MADT, @STT,@TENCV, @NGAYBD, @NGAYKT)

    PRINT N'Thêm phân công thành công'
END
GO


-- p. Thực hiện xoá một giáo viên theo mã. Nếu giáo viên có thông tin liên quan (Có thân nhân, có làm đề tài, …) thì báo lỗi.
CREATE PROCEDURE DeleteTeacher
    @MAGV CHAR(5)
AS
BEGIN
    IF EXISTS (SELECT * FROM NGUOI_THAN WHERE MAGV = @MAGV)
        BEGIN
            PRINT N'Giáo viên có thân nhân, không thể xoá'
            RETURN
        END

    IF EXISTS (SELECT * FROM DETAI WHERE GVCNDT = @MAGV)
        BEGIN
            PRINT N'Giáo viên đang tham gia làm đề tài, không thể xoá'
            RETURN
        END

    DELETE FROM GIAOVIEN WHERE MAGV = @MAGV

    PRINT N'Xoá giáo viên thành công'
END
GO

-- q. In ra danh sách giáo viên của một phòng ban nào đó cùng với số lượng đề tài mà giáo viên tham gia, số thân nhân, số giáo viên mà giáo viên đó quản lý nếu có
CREATE PROCEDURE PrintTeachersByDepartment
    @MAPB CHAR(5)
AS
BEGIN
    SELECT G.MAGV, G.HOTEN, G.DIACHI, G.LUONG,
        (SELECT COUNT(*) FROM DETAI WHERE GVCNDT = G.MAGV) AS SLDeTai,
        (SELECT COUNT(*) FROM NGUOI_THAN WHERE MAGV = G.MAGV) AS SLThanNhan,
        (SELECT COUNT(*) FROM GIAOVIEN WHERE G.MAGV = GVQLCM) AS SLGiaoVienQL
    FROM GIAOVIEN G
    WHERE G.MABM = @MAPB
END
GO
-- t. Mã giáo viên được xác định tự động theo quy tắc: Nếu đã có giáo viên 001, 002, 003 thì MAGV của giáo viên mới sẽ là 004. Nếu đã có giáo viên 001, 002, 005 thì MAGV của giáo viên mới là 003.
CREATE PROCEDURE GenerateTeacherID
AS
BEGIN
    DECLARE @MaxID INT

    SELECT @MaxID = MAX(CAST(RIGHT(MAGV, 3) AS INT)) FROM GIAOVIEN

    IF @MaxID IS NULL
        SET @MaxID = 0

    DECLARE @NewID NVARCHAR(5)
    SET @NewID = '00' + CAST(@MaxID + 1 AS NVARCHAR(3))

    PRINT N'Mã giáo viên mới: ' + @NewID
END
GO



-- test phần 1

--a--
EXEC HelloWorld

--b--
EXEC CalculateSum @Number1 = 10, @Number2 = 5

--c--
DECLARE @Sum INT
EXEC CalculateSumOutput @Number1 = 10, @Number2 = 5, @Sum = @Sum OUTPUT
PRINT N'SUM: ' + CAST(@Sum AS VARCHAR)


--d--
EXEC CalculateSumThreeNumbers @Number1 = 10, @Number2 = 5, @Number3 = 2

--e--
EXEC CalculateSumRange @StartNumber = 1, @EndNumber = 10

--f--
EXEC CheckPrimeNumber @Number = 17

--g--
EXEC CalculateSumPrimeNumbers @StartNumber = 1, @EndNumber = 20

-- h-
DECLARE @GCD INT
EXEC CalculateGreatestCommonDivisor @Number1 = 24, @Number2 = 36, @GCD = @GCD OUTPUT
PRINT N'Ước chung lớn nhất của 24 và 36 là: ' + CAST(@GCD AS VARCHAR)

-- i--
DECLARE @LCM INT
EXEC CalculateLeastCommonMultiple @Number1 = 6, @Number2 = 8, @LCM = @LCM OUTPUT
PRINT N'Bội chung nhỏ nhất của 6 và 8 là: ' + CAST(@LCM AS VARCHAR)




-- test 2 


-- j--
EXEC GetAllTeachers

-- k--

EXEC CountProjectsByTeacher @MAGV = '001' 

-- l--
EXEC PrintTeacherDetails @MAGV = '001'  

-- m--
EXEC CheckTeacherExists @MAGV = '001'  

-- n--
EXEC CheckTeacherRule @MAGV = '001'  

-- o--
EXEC AddTask @MADT = '001', @STT = 6,@TENCV=N'Làm abc', @NGAYBD = '2008-05-22', @NGAYKT = '2008-05-30'
-- p--
EXEC DeleteTeacher @MAGV = '00'

-- q--
EXEC PrintTeachersByDepartment @MAPB = 'PB001' --

-- t--
EXEC GenerateTeacherID