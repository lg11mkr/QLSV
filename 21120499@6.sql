-- use GiaoVienDeTai

-- Q58. Cho biết tên giáo viên nào mà tham gia đề tài đủ tất cả các chủ đề.--
SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv
WHERE gv.MAGV in (
    SELECT tg1.MAGV
    FROM  THAMGIADT tg1
    WHERE NOT EXISTS (
        SELECT cd.MACD FROM CHUDE cd
        EXCEPT
        (SELECT dt.MACD FROM THAMGIADT tg
        INNER JOIN DETAI dt ON tg.MADT = dt.MADT
        WHERE tg.MAGV = tg1.MAGV
        )
    )

)

-- Q59. Cho biết tên đề tài nào mà được tất cả các giáo viên của bộ môn HTTT tham gia.--
SELECT MADT, TENDT
FROM DETAI
WHERE MADT IN (
    SELECT tg.MADT
    FROM THAMGIADT tg
    INNER JOIN GIAOVIEN gv ON tg.MAGV = gv.MAGV
    WHERE gv.MABM = 'HTTT'
    GROUP BY tg.MADT
    HAVING COUNT(DISTINCT tg.MAGV) = (
        SELECT COUNT(*)
        FROM GIAOVIEN
        WHERE MABM = 'HTTT'
    )
)
-- Q60. Cho biết tên đề tài có tất cả giảng viên bộ môn “Hệ thống thông tin” tham gia--
SELECT MADT, TENDT
FROM DETAI
WHERE MADT IN (
    SELECT tg.MADT
    FROM THAMGIADT tg
    INNER JOIN GIAOVIEN gv ON tg.MAGV = gv.MAGV
    INNER JOIN BOMON bm ON bm.MABM = gv.MABM
    WHERE bm.TENBM = N'Hệ thống thông tin'
    GROUP BY tg.MADT
    HAVING COUNT(DISTINCT tg.MAGV) = (
        SELECT COUNT(gv1.MAGV)
        FROM GIAOVIEN gv1
        INNER JOIN BOMON bm1 ON bm1.MABM = gv1.MABM
        WHERE bm1.TENBM = N'Hệ thống thông tin'
    )
)

-- Q61. Cho biết giáo viên nào đã tham gia tất cả các đề tài có mã chủ đề là QLGD.--
SELECT tg1.MAGV , gv.HOTEN 
FROM THAMGIADT tg1, GIAOVIEN gv
WHERE tg1.MAGV=gv.MAGV
AND tg1.MADT IN (
    SELECT MADT FROM DETAI WHERE MACD='QLGD') 
GROUP BY tg1.MAGV, GV.HOTEN
HAVING COUNT(DISTINCT tg1.MADT) = (
    SELECT COUNT(MADT)
    FROM DETAI 
    WHERE MACD='QLGD'
)
-- Q62. Cho biết tên giáo viên nào tham gia tất cả các đề tài mà giáo viên Trần Trà Hương đã tham gia.--
SELECT tg1.MAGV , gv.HOTEN 
FROM THAMGIADT tg1, GIAOVIEN gv
WHERE tg1.MAGV=gv.MAGV
AND tg1.MADT IN (
    SELECT MADT FROM THAMGIADT 
    WHERE MAGV in (
        SELECT MAGV FROM GIAOVIEN
        WHERE HOTEN =N'Trần Trà Hương'
        )
    ) 
GROUP BY tg1.MAGV, GV.HOTEN
HAVING COUNT(DISTINCT tg1.MADT) = (
    SELECT COUNT(MADT)
    FROM THAMGIADT 
    WHERE MAGV in (
        SELECT MAGV FROM GIAOVIEN
        WHERE HOTEN =N'Trần Trà Hương'
    )
)

-- Q63. Cho biết tên đề tài nào mà được tất cả các giáo viên của bộ môn Hóa Hữu Cơ tham gia.--
SELECT MADT, TENDT
FROM DETAI
WHERE MADT IN (
    SELECT tg.MADT
    FROM THAMGIADT tg
    INNER JOIN GIAOVIEN gv ON tg.MAGV = gv.MAGV
    INNER JOIN BOMON bm ON bm.MABM = gv.MABM
    WHERE bm.TENBM = N'Hóa hữu cơ'
    GROUP BY tg.MADT
    HAVING COUNT(DISTINCT tg.MAGV) = (
        SELECT COUNT(gv1.MAGV)
        FROM GIAOVIEN gv1
        INNER JOIN BOMON bm1 ON bm1.MABM = gv1.MABM
        WHERE bm1.TENBM = N'Hóa hữu cơ'
    )
)
-- Q64. Cho biết tên giáo viên nào mà tham gia tất cả các công việc của đề tài 006.--
SELECT MAGV, HOTEN
FROM GIAOVIEN
WHERE MAGV IN(
    SELECT tg1.MAGV
    FROM THAMGIADT tg1
    WHERE tg1.MADT = '006'
    GROUP BY tg1.MAGV, tg1.MADT
    HAVING COUNT(DISTINCT tg1.STT) = (
        SELECT COUNT(STT)
        FROM CONGVIEC
        WHERE MADT ='006'
        GROUP BY MADT
    )
)

-- Q65. Cho biết giáo viên nào đã tham gia tất cả các đề tài của chủ đề Ứng dụng công nghệ.--
SELECT MAGV, HOTEN
FROM GIAOVIEN
WHERE MAGV IN(
    SELECT tg1.MAGV
    FROM THAMGIADT tg1
    WHERE tg1.MADT IN (
        SELECT MADT
        FROM DETAI DT
        JOIN CHUDE CD ON DT.MACD = CD.MACD
        WHERE CD.TENCD = N'Ứng dụng công nghệ' 
    )
    GROUP BY tg1.MAGV
    HAVING COUNT(DISTINCT tg1.MADT) = (
        SELECT COUNT(*)
        FROM DETAI DT
        JOIN CHUDE CD ON DT.MACD = CD.MACD
        WHERE CD.TENCD = N'Ứng dụng công nghệ'
    )
)
-- Q66. Cho biết tên giáo viên nào đã tham gia tất cả các đề tài của do Trần Trà Hương làm chủ nhiệm.--

SELECT tg1.MAGV , gv.HOTEN 
FROM THAMGIADT tg1, GIAOVIEN gv
WHERE tg1.MAGV=gv.MAGV
AND tg1.MADT IN (
    SELECT MADT
    FROM DETAI 
    WHERE GVCNDT in (
        SELECT MAGV FROM GIAOVIEN
        WHERE HOTEN =N'Trần Trà Hương'
    )
) 
GROUP BY tg1.MAGV, GV.HOTEN
HAVING COUNT(DISTINCT tg1.MADT) = (
    SELECT COUNT(MADT)
    FROM DETAI 
    WHERE GVCNDT in (
        SELECT MAGV FROM GIAOVIEN
        WHERE HOTEN =N'Trần Trà Hương'
    )
)

-- Q67. Cho biết tên đề tài nào mà được tất cả các giáo viên của khoa CNTT tham gia.--
SELECT MADT, TENDT
FROM DETAI
WHERE MADT IN (
    SELECT tg.MADT
    FROM THAMGIADT tg
    INNER JOIN GIAOVIEN gv ON tg.MAGV = gv.MAGV
    INNER JOIN BOMON bm ON bm.MABM = gv.MABM
    WHERE bm.MAKHOA='CNTT'
    GROUP BY tg.MADT
    HAVING COUNT(DISTINCT tg.MAGV) = (
        SELECT COUNT(gv1.MAGV)
        FROM GIAOVIEN gv1
        INNER JOIN BOMON bm1 ON bm1.MABM = gv1.MABM
        WHERE bm1.MAKHOA = 'CNTT'
    )
)
-- Q68. Cho biết tên giáo viên nào mà tham gia tất cả các công việc của đề tài Nghiên cứu tế bào gốc.--

SELECT MAGV, HOTEN
FROM GIAOVIEN
WHERE MAGV IN(
    SELECT tg1.MAGV
    FROM THAMGIADT tg1
    WHERE tg1.MADT IN (
        SELECT MADT
        FROM DETAI
        WHERE TENDT = N'Nghiên cứu tế bào gốc'
    )
    GROUP BY tg1.MAGV, tg1.MADT
    HAVING COUNT(DISTINCT tg1.STT) = (
        SELECT COUNT(STT)
        FROM CONGVIEC
        WHERE MADT IN (
            SELECT MADT
            FROM DETAI
            WHERE TENDT = N'Nghiên cứu tế bào gốc'
        )
        GROUP BY MADT
    )
)
-- Q69. Tìm tên các giáo viên được phân công làm tất cả các đề tài có kinh phí trên 100 triệu?--
SELECT MAGV, HOTEN
FROM GIAOVIEN
WHERE MAGV IN(
    SELECT tg1.MAGV
    FROM THAMGIADT tg1
    WHERE tg1.MADT IN (
        SELECT DT.MADT
        FROM DETAI DT
        WHERE DT.KINHPHI > 100 
    )
    GROUP BY tg1.MAGV
    HAVING COUNT(DISTINCT tg1.MADT) = (
        SELECT COUNT(*)
        FROM DETAI
        WHERE KINHPHI > 100 
    )
)

-- Q70. Cho biết tên đề tài nào mà được tất cả các giáo viên của khoa Sinh Học tham gia.--
SELECT MADT, TENDT
FROM DETAI
WHERE MADT IN (
    SELECT tg.MADT
    FROM THAMGIADT tg
    INNER JOIN GIAOVIEN gv ON tg.MAGV = gv.MAGV
    INNER JOIN BOMON bm ON bm.MABM = gv.MABM
    INNER JOIN KHOA k ON bm.MAKHOA = k.MAKHOA
    WHERE k.TENKHOA = N'Sinh Học'
    GROUP BY tg.MADT
    HAVING COUNT(DISTINCT tg.MAGV) = (
        SELECT COUNT(gv1.MAGV)
        FROM GIAOVIEN gv1
        INNER JOIN BOMON bm1 ON bm1.MABM = gv1.MABM
        INNER JOIN KHOA k1 ON bm1.MAKHOA = k1.MAKHOA
        WHERE k1.TENKHOA = N'Sinh Học'
    )
)
-- Q71. Cho biết mã số, họ tên, ngày sinh của giáo viên tham gia tất cả các công việc của đề tài “Ứng dụng hóa học xanh”.--
SELECT MAGV, HOTEN,NGAYSINH
FROM GIAOVIEN
WHERE MAGV IN(
    SELECT tg1.MAGV
    FROM THAMGIADT tg1
    WHERE tg1.MADT IN (
        SELECT MADT
        FROM DETAI
        WHERE TENDT = N'Ứng dụng hóa học xanh'
    )
    GROUP BY tg1.MAGV, tg1.MADT
    HAVING COUNT(DISTINCT tg1.STT) = (
        SELECT COUNT(STT)
        FROM CONGVIEC
        WHERE MADT IN (
            SELECT MADT
            FROM DETAI
            WHERE TENDT = N'Ứng dụng hóa học xanh'
        )
        GROUP BY MADT
    )
)
-- Q72. Cho biết mã số, họ tên, tên bộ môn và tên người quản lý chuyên môn của giáo viên tham gia tất cả các đề tài thuộc chủ đề “Nghiên cứu phát triển”.--
SELECT gv.MAGV, gv.HOTEN, bm.TENBM, gv2.HOTEN as TenGVQLCM
FROM GIAOVIEN gv
JOIN BOMON bm on gv.MABM =bm.MABM
LEFT JOIN GIAOVIEN gv2 on gv.GVQLCM =gv2.MAGV

WHERE gv.MAGV IN(
    SELECT tg1.MAGV
    FROM THAMGIADT tg1
    WHERE tg1.MADT IN (
        SELECT MADT
        FROM DETAI DT
        JOIN CHUDE CD ON DT.MACD = CD.MACD
        WHERE CD.TENCD = N'Nghiên cứu phát triển' 
    )
    GROUP BY tg1.MAGV
    HAVING COUNT(DISTINCT tg1.MADT) = (
        SELECT COUNT(*)
        FROM DETAI DT
        JOIN CHUDE CD ON DT.MACD = CD.MACD
        WHERE CD.TENCD = N'Nghiên cứu phát triển'
    )
)
