SELECT l.lprod_id, l.lprod_nm, p.prod_id, p.prod_name
FROM prod p, lprod l
WHERE p.prod_lgu = l.lprod_gu;

SELECT *
FROM prod;

SELECT *
FROM lprod;

SELECT b.buyer_id, b.buyer_name, p.prod_id, p.prod_name
FROM buyer b, prod p
WHERE b.buyer_id = p.prod_buyer
ORDER BY b.buyer_id;

SELECT m.mem_id, m.mem_name, p.prod_id, p.prod_name, c.cart_qty
FROM member m , cart c, prod p
WHERE m.mem_id = c.cart_member 
   AND c.cart_prod = p.prod_id;

--ansi문법으로 바꿨을때 
SELECT  m.mem_id, m.mem_name, p.prod_id, p.prod_name, c.cart_qty
FROM member m JOIN cart c ON(m.mem_id = c.cart_member)
     JOIN prod p ON(c.cart_prod = p.prod_id);

SELECT *
FROM customer;

SELECT *
FROM product;

SELECT *
FROM cycle;

--데이터 결합 ( 실습 join4 )
--erd 다이어그램을 참고하여 customer, cycle 테이블을 조인하여
--고객별 애음 제품, 애음요일, 개수를 다음과 같은 결과가 나오도록 쿼리를
--작성해보세요(고객명이 brown, sally인 고객만 조회)
--(*정렬과 관계없이 값이 맞으면 정답)

SELECT c.cid, c.cnm, y.pid, y.day, y.cnt
FROM customer c, cycle y
WHERE c.cid = y.cid 
   AND c.cnm IN ('brown', 'sally');
   
--데이터 결합 ( 실습 join5 )
--erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여
--고객별 애음 제품, 애음요일, 개수, 제품명을 다음과 같은 결과가 나오도록
--쿼리를 작성해보세요(고객명이 brown, sally인 고객만 조회)
--(*정렬과 관계없이 값이 맞으면 정답)

SELECT c.cid, c.cnm, y.pid, p.pnm, y.day, y.cnt
FROM customer c, cycle y, product p
WHERE c.cid = y.cid 
   AND y.pid = p.pid
   AND c.cnm IN ('brown', 'sally');

--데이터 결합 ( 실습 join6 )
-- erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여
--애음요일과 관계없이 고객별 애음 제품별, 개수의 합과, 제품명을 다음과 같은
--결과가 나오도록 쿼리를 작성해보세요
--(*정렬과 관계없이 값이 맞으면 정답
--1번고객 같으제품 

SELECT  c.cid, c.cnm, y.pid, p.pnm, p.pnm,  SUM (y.cnt) cnt 
FROM customer c, cycle y, product p
WHERE c.cid = y.cid 
   AND y.pid = p.pid
   AND c.cnm IN ('brown', 'sally')
GROUP BY c.cid, c.cnm, y.pid, p.pnm;

--데이터 결합 ( 실습 join7 )
--erd 다이어그램을 참고하여 cycle, product 테이블을 이용하여
--제품별, 개수의 합과, 제품명을 다음과 같은 결과가 나오도록 쿼리를
--작성해보세요
--(*정렬과 관계없이 값이 맞으면 정답)

SELECT y.pid, p.pnm, SUM(y.cnt) cnt
FROM cycle y, product p
WHERE y.pid = p.pid
GROUP BY y.pid, p.pnm;

﻿
-- 직원의 이름, 직원의 상사 이름 두개의 컬럼이 나오도록 join query작성
SELECT e.ename, e.mgr, m.ename 
FROM emp e, emp m
WHERE e.mgr = m.empno;

--LEFT OUTER JOIN (ansi문법)
SELECT e.ename, e.mgr, m.ename 
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

--LEFT OUTER JOIN (oracle문법)
--데이터가 안나오는쪽에다 붙여준다 
--outer조인으로 인해 데이터가 안나오는 쪽 컬럼에 (+)를 붙여준다 
﻿SELECT e.ename, e.mgr, m.ename 
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

SELECT empno, ename, deptno
FROM emp


SELECT e.ename, m.ename , m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno AND m.deptno = 10);

SELECT e.ename, m.ename , m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
WHERE m.deptno = 10;

SELECT e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
  AND m.deptno = 10;
  
SELECT e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
  AND m.deptno(+) = 10;
  
SELECT empno, ename, mgr
FROM emp

ON절에다가 모든 절을 넣었을때는 null값까지 모두 표현
where절을 밖에다 쓰면 행의 갯수를 제한시킬수있음

SELECT e.ename, m.ename , m.deptno
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);


--FULL OUTER : ﻿LEFT OUTER JOIN(14) + RIGHT OUTER JOIN(21) - 중복 데이터 1개만 남기고 제거 (13) = 22
SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

SELECT e.ename, m.ename , m.deptno
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);

--FULL OUTER 조인은 오라클 SQL 문법으로 제공하지 않는다 (이쿼리는 에러)
SELECT e.ename, e.mgr, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr(+) = m.empno(+);

outerjoin1)
SELECT *
FROM buyprod
WHERE buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD');

SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buyqty
FROM buyprod b, prod p 
WHERE b.buyprod = p.prod_id(+);

SELECT COUNT(*)
FROM prod;

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON (buyprod.buyprod = prod.prod_id AND buyprod.buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD'));

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod, prod 
WHERE buyprod.buyprod = prod.prod_id(+) AND
       buyprod.buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');

모든 제품을 다 보여주고 , 실제 구매가 있을 때는 구매수량을 조회, 없을때는 null로 표현 
제품 코드 : 수량


SELECT *
FROM prod;


