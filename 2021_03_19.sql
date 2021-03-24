grp3)
--부서별로 10일때 ACCOUUNTING 20 RESEARCH 30 SALES
SELECT deptno, max(sal), min(sal),ROUND(avg(sal),2), sum(sal), COUNT(sal), COUNT(mgr), COUNT(*),
DECODE(deptno,10, 'ACCOUUNTING', 20 , 'RESEARCH', 30, 'SALES') dname 
FROM emp
group by deptno;

grp4)
--입사년,월로 몇명의 직원이 입사했는지 
SELECT TO_CHAR(hiredate, 'YYYYMM') HIRE_YYYYMM, count(*)CNT --TO_DATE / TO_CHAR 개념확실히 이해하기
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM')
ORDER BY TO_CHAR(hiredate, 'YYYYMM');

grp5)
--입사년별로 몇명의 직원이 입사했는지 
SELECT TO_CHAR(hiredate, 'YYYY') HIRE_YYYYMM, count(*)CNT --TO_DATE / TO_CHAR 개념확실히 이해하기
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY')
ORDER BY TO_CHAR(hiredate, 'YYYY');

grp6)
--부서테이블의 전체 행의갱수 
SELECT COUNT(*)
FROM dept;

grp7)
--부서가 몇개있는지 갯수 (부서 종류 갯수 출력)
SELECT count(*) CNT
FROM
(SELECT deptno
FROM emp
GROUP BY deptno)


-----------------------------------------------------

데이터 결합
-join  
-RDBMS는 중복을 최소화 하는 형태의 데이터베이스
-다른 테이블과 결합하여 데이터를 조회 

데이터를 확장(결합)
1. 컬럼에 대한 확장 : JOIN
2. 행에 대한 확장 : 집합연산자(UNION ALL, UNION(합집합),  MINUS(차집합),  INTERSECT(교집합))

데이터 결합
-중복을 최소화 하는 RDBMS 방식으로 설계한 경우
-emp 테이블에는 부서코드만 존재,
부서정보를 담은 dept테이블 별도로 생성
-emp테이블과 dept테이블의 연결고리 (deptno)로 조인하여
실제 부서명을 조회한다. 

JOIN  : 
1. 표준 SQL => ANSI SQL
2. 비표준 SQL - DBMS를 만드는 회사에서 만든 공유의 SQL 문법 
(꼭 표준 SQL을 써야하는것은 아니다)
(두개 표현을 다 알려줄것)

표준-
ANSI : SQL
비표준 -
ORACLE : SQL

ANSI-NATURAL JOIN 
--잘안씀 (그냥이해안가면넘어가기)
 -조인하고자 하는 테이블의 연결컬럼 명(타입도 동일)이 동일한 경우 (emp.deptno, dpt.deptno)
 -연결 컬럼의 값이 동일할 때 (=) 컬럼이 확장된다
 
 SELECT *
 FROM emp NATURAL JOIN dept;
 
 --일부 컬럼 필요없을때
SELECT ename, dname
FROM emp NATURAL JOIN dept;

--emp 테이블의 ename 을 출력하고 rownum을 같이 출력해라 (SELECT절에 rownum을 쓰려면 *랑 같이쓰지못함 emp.* 이런식도 안됨 / rownum개념 다시잡기)
SELECT emp.ename, ROWNUM
FROM emp NATURAL JOIN dept;

--연결고리 컬럼은 확장자를 앞에 쓰지못한다(deptno로 조인했기 때문에)
SELECT emp.empno, emp.ename, deptno --(emp.deptno 이런식으로 쓰지못함)
FROM emp NATURAL JOIN dept;

ORACLE join :
1. FROM 절에 조인할 테이블을 (,) 콤마로 구분하여 나열 
2. WHERE : 조인할 테이블의 연결조건을 기술 

--테이블마다 별칭을 따로 붙이지 않고 where절을 주면 에러 (왜냐면 어느테이블의 컬럼을 지칭하는지 알수 없기 때문)
--dept테이블의 deptno_1로 deptno라는 열이 두번 출력이된다.
SELECT *
FROM emp , dept 
WHERE emp.deptno = dept.deptno;

7369 SMITH , 7902 FORD
--smith의 상사는 ford씨이다. (king 조인실패 왜???아 king만 출력되지않았다)
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

(잘안쓰는방법)ANSI SQL : JOIN WITH USING
조인 하려고 하는 테이블의 컬럼명과 타입이 같은 컬럼이 두개 이상인 상황에서
두 컬럼을 모두 조인 조건으로 참여시키지 않고, 개발자가 원하는 특정 컬럼으로만 연결을 시키고 싶을 때 사용
--위에서 내츄럴조인했던거랑 결과가 동일함
SELECT *
FROM emp JOIN dept USING (deptno)

JOIN WITH ON : NATURAL JOIN, JOIN WITH USTING을 대체할 수 있는 보편적인 문법 
조인 컬럼 조건을 개발자가 임의로 지정

FROM 테이블 JOIN 조인할테이블 ON (1번째 테이블.1번째테이블과 조인할컬럼 = 2번째 테이블.2번째테이블과조인할컬럼)

SELECT *
FROM emp JOIN dept ON(emp.deptno = dept.deptno)

--JOIN WITH ON을 이용하여 쿼리 작성

--1. 사원 번호, 사원 이름, 해당사원의 상사 사번, 해당사원의 상사 이름 : JOIN WITH ON을 이용하여 쿼리 작성 
SELECT e.empno, e.ename, m.empno, m.ename 
FROM emp e JOIN emp m ON (e.mgr = m.empno); 

----2.사원 번호, 사원 이름, 해당사원의 상사 사번, 해당사원의 상사 이름 : JOIN WITH ON을 이용하여 쿼리 작성 
--단 사원의 번호가 7369에서 7698인 사원들만 조회

SELECT e.empno, e.ename, m.empno, m.ename 
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE e.empno BETWEEN 7369 AND 7698;

--ORACLE로 바꾸게 되면 
SELECT e.empno, e.ename, m.empno, m.ename 
FROM emp e , emp m
WHERE e.mgr = m.empno 
  AND e.empno BETWEEN 7369 AND 7698;
  
논리적인 조인 형태
1. self join  : 조인 테이블이 같은 경우 
-계층구조 
2. NONEQUI-JOIN  : 조인 조건이 = (equals)가 아닌 조인

********* 시험출제 **********
--42건 출력, 자신과 같지않은거를 조회하기 때문에 하나당 3건씩 나온다생각하면 42건 (ex) emp deptno 20일때 dept 10 30 40 이런식컬럼다 출력)
SELECT *
FROM emp, dept
WHERE emp.deptno != dept.deptno; --연결조건 

*********

SELECT *
FROM salgrade;

--범위를 기준으로 등급매겨줌 

--salgrade를 이용하여 직원의 급여 등급 구하기
--empno, ename, sal, 급여등급
--ansi, ORACLE 두가지 버전으로 

emp.sql > = salgrade.losal 
AND 
emp.sal < = salgrade.hisal

emp.sal BETWEEN salgrade.losal AND salgrade.hisal

----------
--ansi문법
SELECT emp.empno, emp.ename, emp.sal, salgrade.GRADE
FROM emp JOIN salgrade ON(emp.sal between SALGRADE.LOSAL AND SALGRADE.HISAL)
--동일한 컬럼이 없더래도 조인한 컬럼으로 조건을 주는것도 조인의 조건이 됨. ㅐㄱ


--oracle문법
SELECT e.empno, e.ename, sal, s.grade 급여등급
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.LOSAL AND s.HISAL 


-------------------

데이터 결합( 실습 join 0)
-emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요 --(order by 개념 똑바로알기)
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY d.deptno;

데이터 결합( 실습 join 1)
-emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요 (부서번호가 10, 30인 데이터만 조회)
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
  AND d.deptno IN (10,30)
ORDER BY d.deptno;

데이터 결합( 실습 join 2)
-emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요 (급여가 2500 초과 )
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
  AND e.sal > 2500
ORDER BY d.deptno;

데이터 결합( 실습 join 3)
-emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요 (급여가 2500 초과, 사번이 7600보다 큰 직원 )
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
  AND e.sal > 2500
  AND e.empno > 7600
ORDER BY d.deptno;

데이터 결합( 실습 join 4)
-emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요 ( 급여가 2500 초과, 사번이 7600보다 큰 직원, RESEARCH 부서에 속하는직원)
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
  AND e.sal > 2500
  AND e.empno > 7600
  AND d.dname = 'RESEARCH'
ORDER BY d.deptno;


-------------------------------------------
docker 가상화
window-linux설치- 그위에 오라클 설치

가상화가 도입된 이유?
물리적컴퓨터는 동시에 하나의 OS만 실행 가능
성능이 좋은 컴퓨터라도 하드웨어 자원의 활용이 낮음

virtual박스 새로 깔아보기 
