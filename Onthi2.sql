drop database Onthi2
go
CREATE DATABASE Onthi2_fix
go
use Onthi2_fix
go

Create table Loai(
    MaLoai CHAR(5) PRIMARY KEY,
	TenLoai NVARCHAR(50)
);
CREATE TABLE SanPham(
    MaSP CHAR(5) PRIMARY KEY,
	TenSP NVARCHAR(50),
    MaLoai CHAR(5),
	FOREIGN KEY (MaLoai) REFERENCES Loai(Maloai)
);
CREATE TABLE NhanVien(
	MaNV CHAR(5) PRIMARY KEY,
	HoTen NVARCHAR(50),
	NgaySinh DATE,
	Phai BIT DEFAULT 0 CHECK (Phai IN(0,1))
);
CREATE TABLE PhieuXuat (
    MaPX INT PRIMARY KEY IDENTITY(1,1),
    NgayLap DATE NOT NULL,
    MaNV CHAR(5) NOT NULL,
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);
CREATE TABLE CTPX (
    MaPX INT NOT NULL,
    MaSP CHAR(5) NOT NULL,
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    PRIMARY KEY (MaPX, MaSP),
    FOREIGN KEY (MaPX) REFERENCES PhieuXuat(MaPX),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

-- Thêm dữ liệu vào bảng Loai
INSERT INTO Loai (MaLoai, TenLoai) VALUES
('L001', 'Điện thoại'),
('L002', 'Máy tính bảng'),
('L003', 'Laptop'),
('L004', 'Phụ kiện'),
('L005', 'Máy ảnh');

-- Thêm dữ liệu vào bảng SanPham
INSERT INTO SanPham (MaSP, TenSP, MaLoai) VALUES
('SP001', 'iPhone 15', 'L001'),
('SP002', 'Samsung Galaxy Tab', 'L002'),
('SP003', 'MacBook Pro', 'L003'),
('SP004', 'Tai nghe Bluetooth', 'L004'),
('SP005', 'Canon EOS R5', 'L005');

-- Thêm dữ liệu vào bảng NhanVien
INSERT INTO NhanVien (MaNV, HoTen, NgaySinh, Phai) VALUES
('NV001', 'Nguyen Van A', '1990-05-10', 1),
('NV002', 'Tran Thi B', '1985-08-25', 0),
('NV003', 'Le Van C', '1995-12-15', 1),
('NV004', 'Pham Thi D', '1988-03-22', 0),
('NV005', 'Hoang Van E', '1993-07-30', 1);

-- Thêm dữ liệu vào bảng PhieuXuat
INSERT INTO PhieuXuat (NgayLap, MaNV) VALUES
('2010-02-01', 'NV001'),
('2010-01-02', 'NV002'),
('2010-01-03', 'NV003'),
('2010-01-04', 'NV004'),
('2010-01-05', 'NV005');

-- Thêm dữ liệu vào bảng CTPX
INSERT INTO CTPX (MaPX, MaSP, SoLuong) VALUES
(1, 'SP001', 10),
(1, 'SP003', 5),
(2, 'SP002', 7),
(3, 'SP004', 15),
(4, 'SP005', 2);


--Tạo View
--Câu 1
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