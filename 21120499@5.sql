-- use GiaoVienDeTai
-- Q35. Cho biết mức lương cao nhất của các giảng viên.--
SELECT MAX(LUONG) AS MucLuongCaoNhat
FROM GIAOVIEN;

-- Q36. Cho biết những giáo viên có lương lớn nhất.--
SELECT *
FROM GIAOVIEN
WHERE LUONG = (
    SELECT MAX(LUONG) 
    FROM GIAOVIEN);

-- Q37. Cho biết lương cao nhất trong bộ môn “HTTT”.--
SELECT MAX(LUONG) AS MucLuongCaoNhat
FROM GIAOVIEN
WHERE MABM ='HTTT';

-- Q38. Cho biết tên giáo viên lớn tuổi nhất của bộ môn Hệ thống thông tin.--
SELECT G1.HOTEN
FROM GIAOVIEN G1 JOIN BOMON  B on G1.MABM=B.MABM
WHERE B.TENBM=N'Hệ thống thông tin'
AND NGAYSINH in (
    SELECT MIN(G.NGAYSINH)
    FROM GIAOVIEN G JOIN BOMON  B on G.MABM=B.MABM
    WHERE B.TENBM=N'Hệ thống thông tin'
);
-- Q39. Cho biết tên giáo viên nhỏ tuổi nhất khoa Công nghệ thông tin.--
SELECT G1.HOTEN
FROM GIAOVIEN G1 JOIN BOMON  B on G1.MABM=B.MABM
JOIN KHOA K on B.MAKHOA= K.MAKHOA
WHERE K.TENKHOA =N'Công nghệ thông tin'
AND NGAYSINH in (
    SELECT MAX(G.NGAYSINH)
    FROM GIAOVIEN G JOIN BOMON  B on G.MABM=B.MABM
    JOIN KHOA K on B.MAKHOA= K.MAKHOA
    WHERE K.TENKHOA =N'Công nghệ thông tin'
);
-- Q40. Cho biết tên giáo viên và tên khoa của giáo viên có lương cao nhất.--
SELECT G1.HOTEN,K.TENKHOA
FROM GIAOVIEN G1 JOIN BOMON  B on G1.MABM=B.MABM
JOIN KHOA K on B.MAKHOA= K.MAKHOA
WHERE LUONG in (
    SELECT MAX(LUONG)
    FROM GIAOVIEN
);
-- Q41. Cho biết những giáo viên có lương lớn nhất trong bộ môn của họ.--
SELECT G.*
FROM GIAOVIEN G, (
    SELECT MABM, MAX(LUONG) As MAX
    FROM GIAOVIEN
    GROUP BY MABM
) as T
WHERE G.MABM=T.MABM
AND G.LUONG =T.MAX;

-- Q42. Cho biết tên những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia.--
SELECT *
FROM DETAI
WHERE MADT not in (
    SELECT MADT 
    FROM THAMGIADT
    WHERE  MAGV = (
        SELECT MAGV
        FROM GIAOVIEN
        WHERE HOTEN=N'Nguyễn Hoài An'
    )
);

-- Q43. Cho biết những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia. Xuất ra tên đề tài, tên người chủ nhiệm đề tài.--
SELECT D.TENDT,G.HOTEN
FROM DETAI D JOIN GIAOVIEN G on D.GVCNDT= G.MAGV
WHERE MADT not in (
    SELECT MADT 
    FROM THAMGIADT
    WHERE  MAGV =  (
        SELECT MAGV
        FROM GIAOVIEN
        WHERE HOTEN=N'Nguyễn Hoài An'
    )
);

-- Q44. Cho biết tên những giáo viên khoa Công nghệ thông tin mà chưa tham gia đề tài nào.--
SELECT G1.HOTEN
FROM GIAOVIEN G1 JOIN BOMON  B on G1.MABM=B.MABM
JOIN KHOA K on B.MAKHOA= K.MAKHOA
WHERE K.TENKHOA =N'Công nghệ thông tin'
AND G1.MAGV not in (
    SELECT MAGV
    FROM THAMGIADT
);

-- Q45. Tìm những giáo viên không tham gia bất kỳ đề tài nào--
SELECT G.*
FROM GIAOVIEN G
WHERE G.MAGV not in (
    SELECT MAGV
    FROM THAMGIADT
);
-- Q46. Cho biết giáo viên có lương lớn hơn lương của giáo viên “Nguyễn Hoài An”--
SELECT *
FROM GIAOVIEN
WHERE LUONG > (
    SELECT LUONG
    FROM GIAOVIEN
    WHERE HOTEN=N'Nguyễn Hoài An'
);
-- Q47. Tìm những trưởng bộ môn tham gia tối thiểu 1 đề tài--
SELECT G.*
FROM BOMON B JOIN GIAOVIEN G on B.TRUONGBM= G.MAGV
WHERE MAGV in (
    SELECT MAGV
    FROM THAMGIADT
);

-- Q48. Tìm giáo viên trùng tên và cùng giới tính với giáo viên khác trong cùng bộ môn--
SELECT G.MAGV, G1.MAGV
FROM GIAOVIEN G, GIAOVIEN G1
WHERE G.MAGV != G1.MAGV
AND G.HOTEN = G1.HOTEN
AND G.PHAI = G1.PHAI
AND G.MABM=G1.MABM
-- Q49. Tìm những giáo viên có lương lớn hơn lương của ít nhất một giáo viên bộ môn “Công nghệ phần mềm”--
SELECT HOTEN
FROM GIAOVIEN 
WHERE LUONG > ANY (
    SELECT LUONG
    FROM GIAOVIEN G JOIN BOMON  B on G.MABM=B.MABM
    WHERE B.TENBM=N'Công nghệ phần mềm'
);
-- Q50. Tìm những giáo viên có lương lớn hơn lương của tất cả giáo viên thuộc bộ môn “Hệ thống thông tin”--
SELECT HOTEN
FROM GIAOVIEN 
WHERE LUONG > ALL (
    SELECT LUONG
    FROM GIAOVIEN G JOIN BOMON  B on G.MABM=B.MABM
    WHERE B.TENBM=N'Hệ thống thông tin'
);
-- Q51. Cho biết tên khoa có đông giáo viên nhất--
SELECT TENKHOA
FROM KHOA
WHERE MAKHOA in (
    SELECT K.MAKHOA
    FROM GIAOVIEN G JOIN BOMON  B on G.MABM=B.MABM
    JOIN KHOA K on B.MAKHOA= K.MAKHOA
    GROUP BY K.MAKHOA
    HAVING COUNT(MAGV) >= ALL (
        SELECT COUNT(MAGV)
        FROM GIAOVIEN G JOIN BOMON  B on G.MABM=B.MABM
        JOIN KHOA K on B.MAKHOA= K.MAKHOA
        GROUP BY K.MAKHOA
    )
);

-- Q52. Cho biết họ tên giáo viên chủ nhiệm nhiều đề tài nhất--
SELECT HOTEN
FROM GIAOVIEN
WHERE MAGV in (
    SELECT GVCNDT
    FROM DETAI
    GROUP BY GVCNDT
    HAVING COUNT(*) >= ALL (
        SELECT COUNT(*)
        FROM DETAI
        GROUP BY GVCNDT
    )
);

-- Q53. Cho biết mã bộ môn có nhiều giáo viên nhất--
SELECT B.MABM
FROM GIAOVIEN G JOIN BOMON B on G.MABM =B.MABM
GROUP BY B.MABM
HAVING COUNT(MAGV) >= ALL (
    SELECT COUNT(MAGV)
    FROM GIAOVIEN G JOIN BOMON B on G.MABM =B.MABM
    GROUP BY B.MABM
);

-- Q54. Cho biết tên giáo viên và tên bộ môn của giáo viên tham gia nhiều đề tài nhất.--
SELECT HOTEN, B.TENBM
FROM GIAOVIEN JOIN BOMON B ON GIAOVIEN.MABM=B.MABM
WHERE MAGV in (
    SELECT MAGV
    FROM THAMGIADT
    GROUP BY MAGV
    HAVING COUNT(DISTINCT MADT) >= ALL (
        SELECT COUNT(DISTINCT MADT)
        FROM THAMGIADT
        GROUP BY MAGV
    )
);
-- Q55. Cho biết tên giáo viên tham gia nhiều đề tài nhất của bộ môn HTTT.--
SELECT HOTEN
FROM GIAOVIEN 
WHERE MABM ='HTTT'
AND MAGV in (
    SELECT MAGV
    FROM THAMGIADT
    GROUP BY MAGV
    HAVING COUNT(DISTINCT MADT) >= ALL (
        SELECT COUNT(DISTINCT T.MADT)
        FROM THAMGIADT  T JOIN GIAOVIEN G on T.MAGV=G.MAGV
        WHERE G.MABM ='HTTT'
        GROUP BY T.MAGV
    )
);
-- Q56. Cho biết tên giáo viên và tên bộ môn của giáo viên có nhiều người thân nhất.--
SELECT HOTEN, B.TENBM
FROM GIAOVIEN JOIN BOMON B ON GIAOVIEN.MABM=B.MABM
WHERE MAGV in (
    SELECT MAGV
    FROM NGUOI_THAN
    GROUP BY MAGV
    HAVING COUNT(*) >= ALL (
        SELECT COUNT(*)
        FROM NGUOI_THAN
        GROUP BY MAGV
    )
);
-- Q57. Cho biết tên trưởng bộ môn mà chủ nhiệm nhiều đề tài nhất--
SELECT HOTEN
FROM GIAOVIEN
WHERE MAGV in (
    SELECT GVCNDT 
    FROM DETAI JOIN BOMON B on DETAI.GVCNDT=B.TRUONGBM
    GROUP BY GVCNDT
    HAVING COUNT(*) >= ALL (
        SELECT COUNT(*)
        FROM DETAI JOIN BOMON B on DETAI.GVCNDT=B.TRUONGBM
        GROUP BY GVCNDT
    )
);
