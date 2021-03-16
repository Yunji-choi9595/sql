연산자 우선순위 (AND가 OR보다 우선순위가 높다)
==> 헷갈리면 ()를 사용하여 우선순위를 조정하자

SELECT *
FROM emp
WHERE ename = 'SMITH'
   OR (ename = 'ALLEN'
   AND job = 'SALESMAN');
   
   --> 직원의 이름이 allen이면서 job 이 salesman 이거나 
   -- 직원의 이름이 smith인 직원 정보를 조회
   
직원의 이름이 ALLEN이거나 SMITH이면서
job이 SALESMAN인 직원을 조회

SELECT *
FROM emp
WHERE (ename = 'SMITH'
   OR ename = 'ALLEN')
   AND job = 'SALESMAN';
   
   
where14실습)AND,OR
emp테이블에서
1. job이 salesman이거나
2. 사원번호가 78로 시작하면서 입사일자가 1981년 6월 1일 이후인
직원의 정보를 다음과 같이 조회 하세요
(1번 조건 또는 2번 조건을 만족하는 직원)

SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR (empno LIKE '78%' 
   AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD')); 
   
--------------------------------------------

SQL 데이터 정렬
-TABLE 객체에는 데이터를 저장/조회시 순서를 보장하지 않음
-> 보편적으로 데이터가 입력된 순서대로 조회됨
-> 데이터가 항상 동일한 순서로 조회되는 것을 보장하지 않는다.
-> 데이터가 삭제되고, 다른 데이터가 들어 올 수도 있음

데이터 정렬 (ORDER BY)
-ORDER BY 
-> ASC : 오름차순(기본)
-> DESC : 내림차순

ORDER BY {정렬기준 컬럼 OR alias OR 컬럼번호}[ASC OR DESC].

***데이터 정렬이 필요한 이유?
1. table 객체는 순서를 보장하지 않는다
==> 오늘 실행한 쿼리를 내일 실행할 경우 동일한 순서로 조회가 되지 않을 수도 있다. 
==> 입력(장점) : 빈공간에 넣으면 되기 때문에 
2. 현실세계에서는 정렬된 데이터가 필요한 경우가 있다
==> 게시판의 게시글은 보편적으로 가장 최신글이 처음에 나오고, 가장 오래된 글이 맨 밑에 있다

SQL에서 정렬: ORDER BY ==> SELECT -> FROM -> [WHERE] -> ORDER BY
정렬 방법 : ORDER BY 컬럼명 | 컬럼인덱스(순서) | 순서[정렬순서]
정렬 순서: 기본 ASC(오름차순), DESC (내림차순)
SELECT *
FROM emp
ORDER BY job, sal;
--job으로 오름차순 정렬을하고, job 안에서 값이 같은 값은 급여기준으로 다시 정렬하겠다.

SELECT *
FROM emp
ORDER BY job DESC, sal ASC, ename;
--job으로 내림차순 정렬하고, job안에서 값이 같은 값은 급여기준으로 오름차순 정렬 

A -> B -> C -> [D] -> Z
1 -> 2 -> ....100 : (오름차순) (ASC => DEFAULT)
100 -> 99.... -> 1  : (내림차순)DESC(DESC => 명시)

정렬 : 컬럼명이 아니라 select 절의 컬럼 순서 (index)
SELECT *
FROM emp
ORDER BY 2;
--두번째 컬럼인 ename 이 오름차순으로 정렬된다

SELECT ename, empno, job, mgr
FROM emp
ORDER BY 2;
--이 방법을 추천하진않음. 왜냐면 원래 테이블은 empno가 첫번째 컬럼인데 지금은 내가 select절에 empno를 두번째에 오게 출력했기 때문에
--empno가 정렬되고있음. (원래 의도한 바와 다를수가있다) 

SELECT ename, empno, job, mgr AS m
FROM emp
ORDER BY m;
--alias 쓰면 alias 명칭으로도 정렬할수 있다.


데이터정렬(order by 실습 orderby1)
-dept테이블의 모든 정보를 부서이름으로 오름차순 정렬로 조회되도록 쿼리를 작성하세요

SELECT *
FROM dept
ORDER BY dname; 

-dept 테이블의 모든 정보를 부서위치로 내림차순 정렬로 조회되도록 쿼리를 작성하세요

SELECT *
FROM dept 
ORDER BY LOC DESC; 

(order by 실습 orderby2)
-emp테이블에서 상여(comm)정보가 있는 사람들만 조회하고,
상여(comm)를 많이 받는 사람이 먼저 조회되도록 정렬하고,
상여가 같을 경우 사번으로 내림차순 정렬하세요(상여가 0인 사람은 상여가 없는것으로 간주)

SELECT *
FROM emp
WHERE comm IS NOT NULL
  AND comm != 0
-- WHERE comm > 0 (0을 where절에 쓸수없기 때문에 논리적으로보면 똑같음)
ORDER BY comm DESC, empno DESC;

(order by 실습 orderby3)
-emp테이블에서 관리자가 있는 사람들만 조회하고, 직군(job)순으로 오름차순 정렬하고, 
직군이 같을 경우 사번이 큰 사원이 먼저 조회하도록 쿼리를 작성하세요

SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job , empno DESC;

(order by 4) 
emp테이블에서 10번부서(deptno)혹은 30번 부서에 속하는 사람중
급여(sal)이 1500이 넘는 사람들만 조회하고 이름으로 내림차순 정렬되도록
쿼리를 작성하세요

SELECT *
FROM emp
WHERE deptno IN (10,30)
  AND sal > 1500
ORDER BY ename DESC;

페이징 처리: 전체 데이터를 조회하는게 아니라 페이지 사이즈가 정해졌을 때 원하는 페이지의 데이터만 가져오는 방법
(1. 400건을 다 조회하고 필요한 20것만 사용하는 방법 --> 전체조회(400)
 2. 400건의 데이터중 원하는 페이지의 20건만 조회 --> 페이징 처리 (20)**이방법이 배울 방법)
페이징(게시글) ==> 정렬의 기준이 뭔데?? 에 대해 생각하기 (일반적으로는 게시글의 작성일시 역순)
페이징 처리시 고려할 변수 : 페이지 번호, 페이지 사이즈

ROWNUM : 행번호를 부여하는 특수 키워드 (오라클에서만 제공)
  *제약사항
  ROWNUM은 WHERE절에서도 사용 가능하다
  단 ROWNUM의 사용을 1부터 사용하는 경우에만 사용 가능
  WHERE ROWNUM BETWEEN 1 AND 5 ==> O
  WHERE ROWNUM BETWEEN 6 AND 10 ==> X (순차적으로읽지않았기때문에 불가능)
  WHERE ROWNUM = 1; ==> O
  WHERE ROWNUM = 2; ==> X
  WHERE ROWNUM <[=] 10; ==> O (1번부터 순차적으로읽기때문에)
  WHERE ROWNUM > 10; ==> X 
  
  SQL절은 다음의 순서로 실행된다
  FROM => WHERE => SELECT => ORDER BY
  ORDER BY 와 ROWNUM 동시에 사용하면 정렬된 기준으로 ROWNUM이 부여되지 않는다
  (SELECT절이 먼저 실행되므로 ROWNUM이 부여된 상태에서 ORDER BY절에 의해 정렬이 된다)
  
전체 데이터 : 14건
페이지사이즈 : 5건
1번쨰 페이지: 1~5
2번째 페이지: 6~10
3번째 페이지: 11~15(14)

인라인 뷰: 내가 테이블을 임의로 만드는것 
ex) 
SELECT ename
FROM (SELECT empno, ename FROM emp);

SELECT job
FROM (SELECT empno, ename FROM emp); 
--이건에러 왜냐면 존재하지 않는 컬럼 

FROM -> SELECT -> ORDER BY 
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;
--orderby를 넣는순간 rownum순서가 꼬이게됨 
--rownum이 실행된다음에 orderby가 적용이됨 
--아래 sql과 비교

SELECT ROWNUM, empno, ename
FROM (SELECT empno, ename
      FROM emp
      ORDER BY ename)
WHERE ROWNUM BETWEEN 2 AND 10;
--정렬을 먼저하고 rownum을 부여한다
--2부터 10까지 읽으면 읽혀지지 않음 왜냐면 순차적으로 rownum읽기 때문에 

SELECT *
FROM 
(SELECT ROWNUM rn, empno, ename --rownum 붙이기 위해 만든 쿼리 (별칭 만들어준 이유: 6에서 10 출력하기위해) 
   FROM (SELECT empno, ename
           FROM emp
       ORDER BY ename)) --정렬이된상태에서 rownum을 붙이기 위해 데이터집합 만들어줌
WHERE rn BETWEEN (:page-1)*:pageSize +1 AND :page*:pageSize;
--rownum에 별칭을 부여하는 이유: rownum은 행번호를 붙이는건데 rownum을 또 써버리면 새로운게 생성된다. 그래서 별칭을 붙여하는것 
--rownum을 그대로 지칭하면안됨 별칭 부여


SELECT *
FROM 
(SELECT ROWNUM rn, empno, ename 
   FROM (SELECT empno, ename
           FROM emp
       ORDER BY ename))
WHERE rn BETWEEN (:page-1)*:pageSize +1 AND :page*:pageSize;
--pageSize 지정해주고 page 지정해주기 (ex) pageSize 5, page 3 이런식으로 넣을때 공백 (엔터) 이런거 들어가면안됨)

pageSize: 5건
1 page : rn BETWEEN 1 AND 5;
2 page : rn BETWEEN 6 AND 10;
3 page : rn BETWEEN 11 AND 15;
n page : rn BETWEEN (n-1)*pageSize + 1 AND n*pageSize;
rn BETWEEN (page-1)*pageSize +1 AND page*pageSize;

n*pageSize-(pageSize-1)
n*pageSize-pageSize + 1
(n-1)*pageSize + 1

ALIAS (ALIAS 쓰지 않고는 페이징처리가 불가하다)

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 5;
--행의 번호를 컬럼으로 갖는 법 

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM = 15; 
--안됨 순차적으로 읽지 않아서

rownum 실습
emp테이블에서 rownum값이 1~10인 값만 조회하는 쿼리를 작성해보세요

SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;

rownum값이 11~20(11~14)인 값만 조회하는 쿼리를 작성해보세요
SELECT * 
FROM
(SELECT ROWNUM rn, empno, ename
   FROM emp)
WHERE rn between 11 and 20;

emp테이블의 사원 정보를 이름컬럼으로 오름차순 적용 했을 때의 11~14번째 행을
다음과 같이 조회하는 쿼리를 작성해보세요
SELECT a.*
FROM 
(SELECT rownum rn, empno, ename
   FROM
(SELECT empno, ename
   FROM emp
   ORDER BY ename))a
WHERE rn between 11 and 14;
--테이블에 대한 별칭을 줄수 있음 

SELECT ROWNUM, * --*랑 rownum 이렇게는 같이 쓸수없음
FROM emp;

SELECT ROWNUM rn,e.*  --e말고 emp라 치면 오류 
FROM emp e;

SELECT ROWNUM rn, e.empno 
FROM emp e, emp m, dept;