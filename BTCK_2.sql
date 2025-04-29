CREATE DATABASE ThucTap;
USE ThucTap;

CREATE TABLE GiangVien (
    magv INT PRIMARY KEY,
    hoten VARCHAR(100),
    luong DECIMAL(10,2)
);

CREATE TABLE SinhVien (
    masv INT PRIMARY KEY,
    hoten VARCHAR(100),
    namsinh INT,
    quequan VARCHAR(100)
);

CREATE TABLE DeTai (
    madt INT PRIMARY KEY,
    tendt VARCHAR(100),
    kinhphi DECIMAL(10,2),
    NoiThucTap VARCHAR(100)
);

CREATE TABLE HuongDan (
    id INT PRIMARY KEY,
    masv INT,
    madt INT,
    magv INT,
    ketqua VARCHAR(10),
    FOREIGN KEY (masv) REFERENCES SinhVien(masv),
    FOREIGN KEY (madt) REFERENCES DeTai(madt),
    FOREIGN KEY (magv) REFERENCES GiangVien(magv)
);

INSERT INTO GiangVien VALUES (1, 'Nguyen Van A', 1500.00);
INSERT INTO GiangVien VALUES (2, 'Tran Thi B', 1800.00);
INSERT INTO GiangVien VALUES (3, 'Le Van C', 1700.00);

INSERT INTO SinhVien VALUES (101, 'Nguyen Tuan', 2002, 'Ha Noi');
INSERT INTO SinhVien VALUES (102, 'Tran Minh', 2001, 'Da Nang');
INSERT INTO SinhVien VALUES (103, 'Le Lan', 2003, 'Hai Phong');

INSERT INTO DeTai VALUES (201, 'CONG NGHE SINH HOC', 100000.00, 'Cong ty ABC');
INSERT INTO DeTai VALUES (202, 'TRI TUE NHAN TAO', 120000.00, 'Cong ty XYZ');
INSERT INTO DeTai VALUES (203, 'PHAT TRIEN WEB', 90000.00, 'Cong ty 123');

INSERT INTO HuongDan VALUES (1, 101, 201, 1, 'A');
INSERT INTO HuongDan VALUES (2, 102, 202, 2, 'B');

-- 2
-- a
SELECT *
FROM SinhVien
WHERE masv NOT IN (SELECT masv FROM HuongDan);

-- b
SELECT COUNT(*) AS SoSinhVien
FROM HuongDan hd
JOIN DeTai dt ON hd.madt = dt.madt
WHERE dt.tendt = 'CONG NGHE SINH HOC';

-- 3
CREATE VIEW SinhVienInfo AS
SELECT
    sv.masv,
    sv.hoten,
    COALESCE(dt.tendt, 'Chưa có') AS tendetai
FROM SinhVien sv
LEFT JOIN HuongDan hd ON sv.masv = hd.masv
LEFT JOIN DeTai dt ON hd.madt = dt.madt;

-- 4
DELIMITER //
CREATE TRIGGER check_namsinh
BEFORE INSERT ON SinhVien
FOR EACH ROW
BEGIN
    IF NEW.namsinh <= 1900 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'năm sinh phải > 1900';
    END IF;
END;

//
DELIMITER ;

-- 5
ALTER TABLE HuongDan
DROP FOREIGN KEY huongdan_ibfk_1, 
ADD CONSTRAINT fk_sv
FOREIGN KEY (masv) REFERENCES SinhVien(masv)
ON DELETE CASCADE;

