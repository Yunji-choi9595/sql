sub6)
SELECT *
FROM cycle 
WHERE cid = 1
AND pid IN (SELECT pid
              FROM cycle
              WHERE cid = 2);
--조인안해줘도 나오는건 비상호 연관 쿼리 
--2번고객이 먹는 제품에대해서만 1번고객이 먹는 애음 정보조회 

sub7)
customer, cycle, product 테이블을 이용하여 cid=1인 고객이 애음하는 제품중
cid=2인 고객도 애음하는 제품의 애음정보를 조회하고 고객명과 제품명까지 포함하는 
쿼리를 작성하세요

SELECT cu.cnm, c.pid, p.pnm, c.day, c.cnt
FROM cycle c, customer cu , product p
WHERE c.cid = 1
AND c.pid = p.pid
AND c.cid = cu.cid
AND c.pid IN (SELECT pid
              FROM cycle
              WHERE cid = 2);



SELECT *
FROM cycle

SELECT *
FROM cycle
WHERE cid = 2;

--둘이 먹는 제품은 100번제품 하나이다. 
SELECT *
FROM product

SELECT *
FROM customer

----------------------------------------------------
연산자 : 몇항
++, --

EXISTS 서브쿼리 연산자 : 단항 
[NOT] IN : WHERE 컬럼 | EXPRESSION IN (값1, 값2, 값3.....)
[NOT] EXISTS : WHERE EXISTS(서브쿼리)
     ===> 서브쿼리의 실행결과로 조회되는 행이 *****하나라도***** 있으면 TRUE, 없으면 FALSE
     EXISTS 연산자와 사용되는 서브쿼리는 상호연관, 비상호연관 서브쿼리 둘다 사용 가능하지만
     행을 제한하기 위해서 상호연관서브쿼리와 사용되는 경우가 일반적이다.
     
     서브쿼리에서 EXISTS 연산자를 만족하는 행을 하나라도 발견을 하면 더이상 진행하지 않고 효율적으로 일을 끊어버린다.
     서브쿼리가 1000건이라도 하더라도 10번째 행에서 EXISTS 연산을 만족하는 행을 발견하면 나머지 9999만건정도의 데이터는 확인 안한다.
     
--매니저가 존재하는 직원
SELECT *
FROM emp 
WHERE mgr IS NOT NULL;

SELECT *
FROM emp e
WHERE EXISTS (SELECT empno  
                FROM emp m 
                WHERE e.mgr = m.empno)

--행이 존재하냐 존재하지 않으냐만 따지고 값이 중요하지 않는다. 

SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X'  --EXISTS의 설렉트절에는 관습적으로 X라는 것을 많이쓴다 
               FROM dual);
--14건조회, 왜냐면 X dual 조회하면 답이나옴 그럼  where절이 참으로 인식되기때문에 14건조회

SELECT COUNT(*) cnt
FROM emp
WHERE deptno = 10;

SELECT *
FROM dual
WHERE EXISTS (SELECT 'X' FROM emp WHERE deptno = 10);
--아래 쿼리문이 훨씬 더 효율적인 쿼리문이다. 

--오라클 칠거지악 (https://bluejini.co.kr/25)
TO_CHAR (hiredate, 'YYYYMMDD') BETWEEN '19810101' AND '19821231'

sub9) cycle, product 테이블을 이용하여 cid=1인 고객이 애음하는 제품을 조회하는 쿼리를 EXISTS 연산자를
사용하여 작성하세요
SELECT *
FROM product p
WHERE EXISTS (SELECT 'X' --select값은 컬럼을 표기를 잘 안한다. x로 쓰기
              FROM cycle c
              WHERE cid = 1
                AND c.pid = p.pid);

SELECT *
FROM product p
WHERE NOT EXISTS (SELECT 'X' 
                    FROM cycle c
                    WHERE cid = 1
                    AND c.pid = p.pid);                

집합연산
UNION : 합집합
INTERSECT : 교집합 (공통된 부분만조회)
MINUS :  차집합(공통된 부분을 빼내고 조회)

UNION : {a, b} U : {a, c} = {a,a,b,c} ==> {a,b,c}
수학에서 이야기하는 일반적인 합집합

UNION ALL : {a,b} U {a,c} = {a,a,b,c}
중복을 허용하는 합집합

집합연산
-데이터를 확장하는 sql의 한 방법
-수학시간에 배운 집합의 개념과 동일
-집합에는 중복, 순서가 없다 
{1,2}, {2,1}은 동일 

집합연산
-행(row)을 확장-> 위 아래
  -> 위 아래 집합의 col의 개수와 타입이 일치해야 한다

-join
 -> 열(col)을 확장 -> 양 옆 
 
 union
 -합집합
 -중복을 제거
 
 union all
 -합집합
 -중복을 제거하지 않음 -> union연산자에 비해 속도가 빠르다
 
 intersect
 -교집합: 두 집합의 공통된 부분 
 
 minus
 차집합: 한 집합에만 속하는 데이터 
 
 UNION: 합집합, 두개의 SELECT 결과를 하나로 합친다, 단 중복되는 데이터는 중복을 제거한다
 => 수학적 집합 개념과 동일
 
 SELECT empno, ename , NULL --컬럼수가 맞지 않을 경우 가짜 컬럼을 넣어서 맞춰주면 출력가능 
 FROM emp
 WHERE empno IN (7369, 7499)
 
 UNION
 
 SELECT empno, ename, deptno --select절에 deptno라는 컬럼을 추가했을경우 위 컬럼고 ㅏ아래 컬럼이 맞지 않기때문에 오류 
 FROM emp
 WHERE empno IN (7369, 7521);
 
 UNION ALL : 중복을 허용하는 합집합
             중복 제거 로직이 없기 때문에 속도가 빠르다
             합집합 하려는 집합간 중복이 없다는 것을 알고 있을 경우 UNION 연산자보다 UNION ALL 연산자가 유리 
 
 
 SELECT empno, ename , NULL --컬럼수가 맞지 않을 경우 가짜 컬럼을 넣어서 맞춰주면 출력가능 
 FROM emp
 WHERE empno IN (7369, 7499)
 
 UNION ALL 
 
 SELECT empno, ename, deptno --select절에 deptno라는 컬럼을 추가했을경우 위 컬럼고 ㅏ아래 컬럼이 맞지 않기때문에 오류 
 FROM emp
 WHERE empno IN (7369, 7521);
 
 INTERSECT 두개의 집합 중 중복되는 부분만 조회 
 
 SELECT empno, ename
 FROM emp
 WHERE empno IN (7369, 7499)
 
INTERSECT
 
 SELECT empno, ename
 FROM emp
 WHERE empno IN (7369, 7521);
 
 MINUS: 한쪽 집합에서 다른 한쪽 집합을 제외한 나머지 요소들을 반환
 
 SELECT empno, ename
 FROM emp
 WHERE empno IN (7369, 7499)
 
 MINUS --위의 집합에서 아래 집합과의 공통된 부분을 뺌 
 
 SELECT empno, ename
 FROM emp
 WHERE empno IN (7369, 7521);
 
 
 교환 법칙
 A U B == B U A (UNION, UNION ALL)
 A ^ B == B ^ A
 A - B != B - A  => 집합의 순서에 따라 결과가 달라질 수 있다 (주의)
 
 집합연산의 특징
 1. 집합연산의 결과로 조회되는 데이터의 컬럼 이름은 첫번째 집합의 컬럼을 따른다
  SELECT empno, ename enm
 FROM emp
 WHERE empno IN (7369, 7499)
 UNION
 SELECT empno, ename
 FROM emp
 WHERE empno IN (7369, 7521);
 
 2.집합연산의 결과를 정렬하고 싶으면 가장 마지막 쿼리 뒤에 ORDER BY를 쓴다. 
 -개별 집합에 ORDER BY를 사용한 경우 에러
 단, ORDER BY를 적용한 인라인뷰를 사용하는것은 가능 
 
-- SELECT *
-- FROM 
-- (
 SELECT empno e, ename enm
 FROM emp
 WHERE empno IN (7369, 7499)
 --ORDER BY e)
 
 UNION
 SELECT empno, ename
 FROM emp
 WHERE empno IN (7369, 7521)
 ORDER BY e;
 
 3.중복된 제거 된다 (예외 UNION ALL)
 
 [4. 9i 이전버전(sql, 우리가 쓰는건 11g) 그룹연산을 하게되면 기본적으로 오름차순으로 정렬되어 나온다
        이후버전 ==> 정렬을 보장하지 않음]

 DML
   .SELECT 
   .데이터 신규 입력 : INSERT
   .기존 데이터 수정 : UPDATE
   .기존 데이터 삭제 : DELETE
   
INSERT 문법
INSERT INTO 테이블명 [({column,})] VALUES ({value, })
INSERT INTO 테이블명 (컬럼명1, 컬럼명2, 컬럼명3.....)
            VALUES (값1, 값2, 값3.......)

만약 테이블에 존재하는 모든 컬럼에 데이터를 입력하는 경우 컬럼명은 생략 가능하고
값을 기술하는 순서를 테이블에 정의된 컬럼 순서와 일치시킨다

INSERT INTO 테이블명 VALUES (값1, 값2, 값3.......);

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
INSERT INTO dept (deptno, dname, loc)
          VALUES (99, 'ddit', 'daejeon');

DESC dept; --테이블정보조회해서 순서대로 넣기 
--조회해보면 널 부분에 아무것도 없는데 그럼 null을 허용한다는 이야기다.

INSERT INTO emp (empno, ename, job) 
           VALUES (9999, 'brown', 'RANGER');
--오류다. 왜냐면 empno 는 null인상태로 들어가려 하는데 DESC emp 를 조회해보면 empno는 not null 조건이기때문 

SELECT *
FROM emp --중복된 데이터 들어간것 확인 

INSERT INTO emp (empno, ename, job, hiredate, sal, comm) 
           VALUES (9998, 'sally', 'RANGER', TO_DATE('2021-03-24','YYYY-MM-DD'), 1000, NULL  );

여러건을 한번에 입력하기
INSERT INTO 테이블명
SELECT 쿼리

INSERT INTO dept
SELECT 99, 'daejeon','DDIT' FROM dual UNION ALL
SELECT 90, 'DDIT', '대전' FROM dual UNION ALL
SELECT 80, 'DDIT8', '대전' FROM dual ;

ROLLBACK;

SELECT *
FROM emp

SELECT *
FROM dept


UPDATE: 테이블에 존재하는 기존 데이터의 값을 변경
UPDATE 테이블명 SET 컬럼명1=값1 , 컬럼명2=값2, 컬럼명3=값3....
WHERE ;

부서번호 99번 부서정보를 부서명= 대덕IT로, loc=영민빌딩 
UPDATE dept SET dname = '대덕IT', loc = '영민빌딩' 
WHERE deptno  = 99;
--WHERE절이 누락되었는지 확인
--WHERE절이 누락 된 경우 테이블의 모든 행에 대해 업데이트를 진행 