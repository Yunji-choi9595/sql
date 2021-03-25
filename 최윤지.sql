-- outerjoin5 : 과제 
-- 4에 고객(customer) 이름 컬럼 추가하기 
SELECT *
FROM
(SELECT p.*, :cid cid, NVL(c.day, 0) day, NVL(c.cnt, 0) cnt 
FROM cycle c, product p
WHERE p.pid = c.pid(+) AND 
c.cid(+) = :cid) a, customer cu;