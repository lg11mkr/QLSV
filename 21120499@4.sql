-- Q27. Cho biết số lượng giáo viên viên và tổng lương của họ.
SELECT COUNT(MAGV) as SLGV, SUM(LUONG) as TongLuong
FROM GIAOVIEN
-- Q28. Cho biết số lượng giáo viên và lương trung bình của từng bộ môn.
SELECT BM.TENBM,AVG(GV.LUONG) as LuongTB
FROM GIAOVIEN GV, BOMON BM
WHERE GV.MABM=BM.MABM
GROUP BY BM.TENBM
-- Q29. Cho biết tên chủ đề và số lượng đề tài thuộc về chủ đề đó.
SELECT CD.TENCD,COUNT(MADT) as SLDeTai
FROM DETAI DT,  CHUDE CD
WHERE CD.MACD = DT.MACD
GROUP BY CD.TENCD
-- Q30. Cho biết tên giáo viên và số lượng đề tài mà giáo viên đó tham gia.
SELECT GV.HOTEN,COUNT(DISTINCT TG.MADT) as SLDeTaiThamGia
FROM GIAOVIEN GV, THAMGIADT TG
WHERE GV.MAGV=TG.MAGV
GROUP BY GV.HOTEN
-- Q31. Cho biết tên giáo viên và số lượng đề tài mà giáo viên đó làm chủ nhiệm.
SELECT GV.HOTEN,COUNT(DT.MADT) as SLDeTaiChuNhiem
FROM GIAOVIEN GV, DETAI DT
WHERE GV.MAGV=DT.GVCNDT
GROUP BY GV.HOTEN
-- Q32. Với mỗi giáo viên cho tên giáo viên và số người thân của giáo viên đó.
SELECT GV.HOTEN,COUNT(*) as SLNguoiThan
FROM GIAOVIEN GV, NGUOI_THAN NT
WHERE GV.MAGV=NT.MAGV
GROUP BY GV.HOTEN
-- Q33. Cho biết tên những giáo viên đã tham gia từ 3 đề tài trở lên.
SELECT GV.HOTEN
FROM GIAOVIEN GV, THAMGIADT TG
WHERE GV.MAGV=TG.MAGV
GROUP BY GV.HOTEN
HAVING COUNT(DISTINCT TG.MADT) >=3
-- Q34. Cho biết số lượng giáo viên đã tham gia vào đề tài Ứng dụng hóa học xanh.
SELECT COUNT(DISTINCT TG.MAGV) as SLGiaoVien
FROM THAMGIADT TG, DETAI DT
WHERE DT.TENDT = N'Ứng dụng hóa học xanh' and TG.MADT=DT.MADT
