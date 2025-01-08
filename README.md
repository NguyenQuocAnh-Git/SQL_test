DROP VIEW CAU_1
CREATE VIEW CAU_1 AS
SELECT 
    SP.MaSP, 
    SP.TenSP, 
    SUM(CTPX.SoLuong) AS TongSoLuongXuat
FROM 
    SanPham SP
JOIN 
    CTPX ON SP.MaSP = CTPX.MaSP
JOIN 
    PhieuXuat PX ON CTPX.MaPX = PX.MaPX
WHERE 
    YEAR(PX.NgayLap) = 2010
GROUP BY 
    SP.MaSP, SP.TenSP;

SELECT *
FROM CAU_1
ORDER BY TenSP ASC

CREATE VIEW CAU_2 AS
SELECT
	SanPham.MaSP,
	SanPham.TenSP,
	Loai.TenLoai
FROM SanPham
JOIN
	Loai ON Loai.MaLoai = SanPham.MaLoai
JOIN 
	CTPX ON CTPX.MaSP = SanPham.MaSP
JOIN 
	PhieuXuat ON PhieuXuat.MaPX = CTPX.MaPX
WHERE PhieuXuat.NgayLap BETWEEN '2010-01-01' AND '2010-06-30'

SELECT *
FROM CAU_2



DROP PROC P1
CREATE PROCEDURE P1
    @TenSP NVARCHAR(50),       -- Tham số nhận vào là tên sản phẩm
    @TongSoLuongXuat INT OUTPUT -- Tham số trả về tổng số lượng xuất kho
AS
BEGIN
    -- Tính tổng số lượng xuất kho của sản phẩm trong năm 2010
    SELECT 
        @TongSoLuongXuat = COALESCE(SUM(CTPX.SoLuong), 0) -- Gán giá trị vào tham số OUTPUT
    FROM 
        SanPham SP
    JOIN 
        CTPX ON SP.MaSP = CTPX.MaSP
    JOIN 
        PhieuXuat PX ON CTPX.MaPX = PX.MaPX
    WHERE 
        SP.TenSP = @TenSP AND YEAR(PX.NgayLap) = 2010;
END;


DECLARE @TongSoLuong INT; -- Biến để nhận giá trị trả về

-- Gọi procedure với tên sản phẩm cụ thể
EXEC P1 @TenSP = N'iPhone 19', @TongSoLuongXuat = @TongSoLuong OUTPUT;

-- Hiển thị kết quả
PRINT 'Tổng số lượng xuất kho: ' + CAST(@TongSoLuong AS NVARCHAR);

CREATE PROC P2
@TenSP NVARCHAR(50),
@TongtrongKhoang INT OUTPUT
AS
BEGIN
	SELECT
		@TongTrongKhoang = COALESCE(SUM(CTPX.Soluong),0)
	FROM SanPham
	JOIN
		CTPX ON CTPX.MaSP = SanPham.MaSP
	JOIN 
		PhieuXuat ON PhieuXuat.MaPX = CTPX.MaPX
	WHERE @TenSP = SanPham.TenSP 
		AND
		PhieuXuat.NgayLap BETWEEN '2010-04-01' AND '2010-06-30';
END;

DECLARE @TongtrongKhoang INT; -- Biến để nhận giá trị trả về

-- Gọi procedure với tên sản phẩm cụ thể
EXEC P2 @TenSP = N'iPhone 19', @TongTrongKhoang = @TongtrongKhoang  OUTPUT;

-- Hiển thị kết quả
PRINT 'Tổng số lượng xuất kho: ' + CAST(@TongtrongKhoang AS NVARCHAR);


CREATE FUNCTION dbo.F1 (@TenSP NVARCHAR(50), @YEAR INT)
RETURNS INT
AS
BEGIN
	DECLARE @TongXuatKho INT
	
	SELECT @TongXuatKho = SUM(CTPX.SoLuong)

	FROM SanPham
	JOIN 
		CTPX ON CTPX.MaSP = SanPham.MaSP
	JOIN
		PhieuXuat ON PhieuXuat.MaPX = CTPX.MaPX
	WHERE 
		SanPham.TenSP = @TenSP
		AND
		YEAR(NgayLap) = @YEAR
	RETURN @TongXuatKho
END;

SELECT dbo.F1(N'iPhone 15', 2010)




--a) Tạo người dùng User1 có thông tin đăng nhập:
--Login = ‘User1’; Password = “USER1”
--b) Tạo vai trò người dùng (Role) như sau: DataEntry
--c) Gán User1 vào vai trò DataEntry
--Cho vai trò DataEntry các quyền SELECT, INSERT, và UPDATE trên quan hệ

create login User2 with password = 'USER2';
create user User2 for login User2;
create role DateEntry;
alter role DateEntry add member User2;

grant select, insert, update on SCHEMA::dbo TO DateEntry;
