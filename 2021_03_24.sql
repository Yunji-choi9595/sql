WHERE, GROUP BY, JOIN 

SMITH 가 속한 부서에 잇는 직원들을 조회하기  => 20번 부서에 속하는 직워들 조회하기
1 .SMITH가 속한 부성 이름 알아낸다
2. 1번에서 알아낸 부서번호 해당 부서에 속하는 직원을 emp 테이블에서 검색한다. 

1.SELECT deptno
FROM emp
WHERE ename = 'SMITH';

2.
SELECT *
FROM emp
WHERE deptno = 20;

--서브쿼리: 쿼리의 결과를 가져다 쓰는것 
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                  FROM emp
                  WHERE ename = 'SMITH')
            
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                  FROM emp
                  WHERE ename = 'SMITH' or  ename = 'ALLEN')
                  
SUBQUERY : 쿼리의 일부로 사용되는 쿼리 
1. 사용위치에 따른 분류
  . SELECT  : 스칼라 서브 쿼리 - 서브쿼리의 실행결과가 하나의 행, 하나의 컬럼을 반환하는 쿼리 
  . FROM : 인라인 뷰 
  . WHERE : 서브쿼리 
            - 메인쿼리의 컬럼을 가져다가 사용할 수 있다
            - 반대로 서브쿼리의 컬럼을 메인쿼리에 가져가서 사용할 수 없다
2. 반환값에 따른 분류 (행, 컬럼의 개수에 따른 분류)
. 행 - 다중행, 단일행, 컬럼- 단일컬럼, 복수 컬럼 
.다중행 단일 컬럼 IN, NOT IN
.다중행 복수 컬럼 (pairwise)
.단일행 단일 컬럼
.단일행 복수 컬럼
<--실습제대로해본건아님---->

3. main - sub query의 관계에 따른 분류
. 상호 연관 서브 쿼리 - 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓴 경우
  ==> 메인쿼리가 없으면 서브쿼리만 독자적으로 실행 불가능  (main->sub)
  
. 비상호 연관 서브 쿼리(non-correlated subquery) - 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓰지 않은 경우 
  ==> 메인쿼리가 없어도 서브쿼리만 실행가능 (main-> sub, sub->main)
  
평균급여보다 높은 급여를 받는 직원의 수를 조회

1. 평균급여 계산
SELECT avg(sal)
FROM emp;

SELECT count(*)
FROM emp
WHERE sal >=2073;

2. 평균급여랑 비교하여 높은 급여 받는 사람 수 조회
SELECT count(*)
FROM emp
WHERE sal >= (SELECT avg(sal)
                FROM emp);
                
2. 평균급여랑 비교하여 높은 급여 받는 사람 조회
 SELECT *
FROM emp
WHERE sal >= (SELECT avg(sal)
                FROM emp);               

3. SMITH와 WARd 사원이 속한 부서의 모든 사원 정보를 조회하는 쿼리를 다음과 같이 작성하세요
SELECT *
FROM emp
WHERE ename IN ('SMITH', 'WARD')

SELECT *
FROM emp m
WHERE m.deptno IN (SELECT s.deptno
                     FROM emp s
                    WHERE s.ename IN ('SMITH', 'WARD'));
--헷갈릴때는 두개로 나눠서 쿼리써서 생각해보기 


MULTI ROW 연산자
IN : = + OR
비교 연산자 ANY
비교 연산자 ALL



직원중에 급여값이 SMITH(800)나 WARD(1250)의 급여보다 작은 직원을 조회 
    ==> 직원중에 급여값이 1250보다 작은 직원 조회 

SELECT *
FROM emp e
WHERE sal < ANY(
                SELECT s.sal
                FROM   emp s
                WHERE s.ename IN ('SMITH', 'WARD')
                )

SELECT *
FROM emp m
WHERE m.sal < (
                SELECT MAX (s.sal)
                FROM   emp s
                WHERE s.ename IN ('SMITH', 'WARD')
                )

직원중에 급여값이 SMITH(800)나 WARD(1250)의 급여보다 작은 직원을 조회 
==> 직원중에 급여값이 800보다 작은 직원 조회 
SELECT *
FROM emp m
WHERE m.sal < ALL (SELECT (s.sal)
                     FROM emp s
                    WHERE s.ename IN ('SMITH', 'WARD'))

SELECT *
FROM emp m
WHERE m.sal < (SELECT MIN(s.sal)
                     FROM emp s
                    WHERE s.ename IN ('SMITH', 'WARD'))
                    
subquery 사용시 주의점 NULL값
IN ()
NOT IN ()

SELECT *
FROM emp 
WHERE deptno IN (10,20,NULL);
==> deptno = 10 OR depno = 20 OR deptno = NULL 
                                   FALSE

SELECT *
FROM emp 
WHERE deptno NOT IN (10,20,NULL);   
--null값을 넣은것
==> !(deptno = 10 OR depno = 20 OR deptno = NULL)
  ===> deptno != 10 OR depno != 20 OR deptno != NULL)                               
                                      FALSE
                                      
TRUE AND TRUE AND TRUE ==> TRUE
TRUE AND TRUE AND FALSE ==> FALSE

--누군가의 상사가 아닌사람들 
SELECT *
FROM emp
WHERE empno NOT IN (SELECT NVL(mgr,9999) --null처리를해야한다 (**시험출제**) 
                      FROM emp);

SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr
                      FROM emp);
--null값이 있기 때문에 나오지않는다. 


PAIR WISE : 순서쌍

SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
                FROM emp
               WHERE empno IN (7499,7782))
  AND deptno IN (SELECT deptno
                   FROM emp
                  WHERE empno IN (7499,7782)));

-- ALLEN (30,7698), CLARK(10,7839)
SELECT ename, mgr, deptno
FROM emp
WHERE empno IN (7499,7782);


SELECT *
FROM emp
WHERE mgr IN (7698,7839)
  AND deptno IN (10,30);

mgr, deptno
(7698,10) , (7698,30), (7839,10), (7839,30)

요구사항: ALLEN 또는 CLERK의 소속 부서번호가 같으면서 상사도 같은 직원들을 조회 
SELECT *
FROM emp

SELECT *
FROM emp
WHERE (mgr, deptno) IN 
                    (SELECT mgr, deptno
                    FROM emp
                    WHERE ename IN ('ALLEN', 'CLARK'))

페어와이즈 / 논페어와이즈 개념 차이 알아두기 

DISTINCT - 
1. 설계가 잘못된 경우 
2. 개발자가 sql을 잘 작성하지 못하는 사람인 경우
3. 요구사항이 이상한 경우 

스칼라 서브쿼리 :  SELECT 절에 사용된 쿼리, 하나의 행 하나의 컬럼을 반환하는 서브쿼리 (스칼라서브쿼리)
하나의 행 하나의 컬럼을반환 ****

SELECT empno, ename, SYSDATE 
FROM emp

SELECT empno, ename, SYSDATE 
FROM emp

SELECT SYSDATE
FROM dual;

SELECT empno, ename, (SELECT SYSDATE FROM dual)
FROM emp;

--다같은 결과가 나오는 쿼리
--서브쿼리만 단독으로 실행했을때 실행되면 비상호연관쿼리 

emp 테이블에는 해당 직원이 속한 부서번호는 관리하지만 해당 부서명 정보는 dept테이블에만 있다
해당 직원이 속한 부서 이름을 알고 싶으면 dept테이블과 조인을 해야 한다. 


상호 연관 서브쿼리는 항상 메인쿼리가 먼저 실행된다.
SELECT *
FROM emp

SELECT empno, ename, deptno, --1건
       (SELECT dname FROM dept WHERE dept.deptno = emp.deptno)--14건
FROM emp;
--조인을 하지 않고서도 결과를 가져옴 

인라인 뷰: SELECT QUERY 
-inline : 해당 위치에 직접 기술 함
-inline view : 해당 위치에 직접 기술한 view
   ***기억하기***   view: QUERY ==> view table(x)

비상호연관 서브쿼리는 메인쿼리가 먼저 실행 될 수 있고
                   서브쿼리가 먼저 실행 될 수도 있다
                ==> 성능 측면에서 유리한 쪽으로 오라클이 선택 

SMITH : SELECT dname FROM dept WHERE deptno = 20;
ALLEN : SELECT dname FROM dept WHERE deptno = 30;
CLARK : SELECT dname FROM dept WHERE deptno = 10;

SELECT *
FROM 
(SELECT deptno, ROUND(AVG(sal), 2) avg_sal
FROM emp
GROUP BY deptno)


실습1)
--둘이 차이점을 잘 비교하여 생각해보기 
전체 직원의 평균급여랑 비교하여 높은 급여 받는 사람 조회
SELECT *
FROM emp
WHERE sal >= (SELECT avg(sal)
                FROM emp); 
                
직원이 속한 부서의 급여 평균보다 높은 급여를 받는 직원을 조회
--이건 20번 부서 평균보다 높은 직원 조회 

SELECT empno, ename, sal, deptno
FROM emp e
WHERE e.sal >= (SELECT avg(sal)
                FROM emp a
                WHERE deptno = 20)

--a.avg(sal)을 가져오려 하면 에러
--메인쿼리에 서브쿼리 가져다쓰는건 되지만 , 메인쿼리를 서브쿼리에 가져다쓰는건 안됨                 
SELECT e.empno, e.ename, e.sal, e.deptno
FROM emp e
WHERE e.sal >= (SELECT avg(sal)
                FROM emp a
                WHERE a.deptno = e.deptno)


--20번 부서의 급여 평균 
SELECT avg(sal)
FROM emp e
WHERE deptno = 20

--20번 급여평균(2175) / 30번 급여평균(1566) / 10번 급여평균 ( 2916) 

--부서별로 급여평균
SELECT deptno, avg(sal)
FROM emp e
GROUP BY deptno;

deptno, dname, loc 
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

SELECT *
FROM dept

--dept테이블에는 신규 등록된 99번 테이블에 속한 사람은 없음
--직원이 속하지 않은 부서를 조회하는 쿼리를 작성해보세요

--empno 의 데이터와 deptno가 불일치하는 부서 이름을 조회 하면됨 
--우리가 알수 있는건 직원이 속한 부서 

SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                    FROM emp);
--이해안감....ㅋ 

SELECT deptno, dname, loc
FROM 
(SELECT *
FROM dept d, emp e
WHERE e.deptno != d.deptno);

sub5) cycle, product 테이블을 이용하여 cid=1인 고객이 애음하지 않는 제품을 
조회하는 쿼리를 작성하세요
SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                    FROM cycle
                    WHERE cid = 1);
                    
(SELECT c.cid, p.pid, p.pname
FROM cycle c, product p
WHERE c.pid = p.pid 
  AND NOT IN (cid=1))

SELECT *
FROM product;
SELECT *
FROM cycle;

--programmers 라는 프로그램 사이트 
--sql 고득점 kit 가면 연습할수있음