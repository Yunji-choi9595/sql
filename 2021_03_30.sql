FROM -> [START WITH] -> WHERE -> GROUP BY -> SELECT -> ORDER BY

SELECT
FROM 
WHERE
START WITH
CONNECT BY
GROUP BY
ORDER BY

가지치기: pruning branch 
--mgr이 null아닌거 나오고 anaylst가 아닌 조건 넣어짐 
SELECT empno, LPAD(' ', (LEVEL-1) *4 )|| ename ename, mgr, job
FROM emp
WHERE job != 'ANALYST'
START WITH mgr IS null
CONNECT BY PRIOR empno = mgr ;

--connect by 기술하는건 계층쿼리에 대한 조건 where절에 썻을때랑 connect by 기술 했을때 비교해보기 
SELECT empno, LPAD(' ', (LEVEL-1) *4 )|| ename ename, mgr, job
FROM emp
START WITH mgr IS null
CONNECT BY PRIOR empno = mgr AND job != 'ANALYST';


계층 쿼리와 관련된 특수 함수 ***
1. CONNECT_BY_ROOT(컬럼) : 최상위 노드의 해당 컬럼값
2. SYS_CONNECT_BY_PATH(컬럼, '구분자문자열') : 최상위 행부터 현재 행까지의 해당 컬럼의 값을 구분자로 연결한 문자열 
--어떤값을 타고 내려왔는지 볼 수 있음 
3. CONNECT_BY_ISLEAF : CHILD가 없는 leaf node 여부 0 - false(no leaf node) / 1 -true (leaf node)

SELECT empno, LPAD(' ', (LEVEL-1) *4 )|| ename ename,
       CONNECT_BY_ROOT(ename) root_ename,
       LTRIM(SYS_CONNECT_BY_PATH(ename,'-'),'-') path_ename,
       INSTR('TEST', 'T', 2), --TEST SAMPLE CODE'라는 구분에서 'E'를 찾는데 1부터 시작을 해서 1번째 찾아지는 'E'의 위치는 어디인가?
       INSTR('TEST', 'T'),
       CONNECT_BY_ISLEAF isleaf --자식이없는 애들만 1로 출력됨 
       
       
FROM emp
START WITH mgr IS null
CONNECT BY PRIOR empno = mgr ;

--게시글쿼리.sql삽입
SELECT *
FROM board_test

-- 루트가 3개인것 만들기
--start with를 parent_seq부터 했으므로 null인것부터 새로 시작 
SELECT LEVEL lv,seq, parent_seq, LPAD(' ', (LEVEL-1) *4) ||title title
FROM board_test
START WITH parent_seq IS NULL --(IN 함수xx 언제든추가할수있으니가) 
CONNECT BY PRIOR seq = parent_seq

--게시판은 최근글부터 나와야하기때문에 내림차순했지만, 그러면 계층구조가 깨지게 된다. 
--최상위노드가 위로 가야한다는 의미 
SELECT LEVEL lv,seq, parent_seq, LPAD(' ', (LEVEL-1) *4) ||title title
FROM board_test
START WITH parent_seq IS NULL --(IN 함수xx 언제든추가할수있으니가) 
CONNECT BY PRIOR seq = parent_seq
ORDER BY SEQ desc; --계층구조가 깨졌음 

--oracle 기본 노드: pre order 노드 방식
--부모노드 -왼쪽노드 -왼쪽 노드의 자식노드 - 오른쪽노드 - 오른쪽노드의 자식노드 
SELECT LEVEL lv,seq, parent_seq, LPAD(' ', (LEVEL-1) *4) ||title title
FROM board_test
START WITH parent_seq IS NULL --(IN 함수xx 언제든추가할수있으니가) 
CONNECT BY PRIOR seq = parent_seq
--ORDER BY SEQ desc; --계층구조가 깨졌음 
ORDER siblings by SEQ desc; --계층구조 유지 

시작(ROOT)글은 작성 순서의 역순으로
답글은 작성 순서대로 정렬

--게시판의 쿼리 형태 
--gn 컬럼과 root_seq 값이 똑같다. 
--gn을 쓰지않았을때 
SELECT *
FROM
(
SELECT CONNECT_BY_ROOT(seq) root_seq,
LEVEL lv,seq, parent_seq, LPAD(' ', (LEVEL-1) *4) ||title title
FROM board_test
START WITH parent_seq IS NULL 
CONNECT BY PRIOR seq = parent_seq)
ORDER BY root_seq DESC, seq ASC;

--사실은 이렇게 짜는게 맞다. 계층한번 더 타야함 
SELECT *
FROM
(
SELECT CONNECT_BY_ROOT(seq) root_seq,
LEVEL lv,seq, parent_seq, LPAD(' ', (LEVEL-1) *4) ||title title
FROM board_test
START WITH parent_seq IS NULL 
CONNECT BY PRIOR seq = parent_seq)
START WITH parent_seq IS NULL 
CONNECT BY PRIOR seq = parent_seq
ORDER BY root_seq DESC, seq ASC;



SELECT gn, CONNECT_BY_ROOT(seq) root_seq,
LEVEL lv,seq, parent_seq, LPAD(' ', (LEVEL-1) *4) ||title title
FROM board_test
START WITH parent_seq IS NULL 
CONNECT BY PRIOR seq = parent_seq
--ORDER siblings by SEQ desc
ORDER SIBLINGS BY gn DESC, seq ASC;
--connect_by_root( seq)를 order 절에서 쓰려면 오류 (order절에서 쓸수없다)

시작글부터 관련 답글까지 그룹번호를 부여하기 위해 새로운컬럼 추가
ALTER TABLE board_test ADD(gn NUMBER);
DESC board_test;
--그룹번호 이름 : gn, number 값으로 넣음)

UPDATE board_test SET gn = 1
WHERE seq IN (1,9);

UPDATE board_test SET gn = 2
WHERE seq IN (2,3);

UPDATE board_test SET gn = 4
WHERE seq NOT IN (1,2,3,9);

--페이징처리--
SELECT *
FROM
(SELECT ROWNUM rn, a.*
FROM
  (SELECT empno, ename --이 인라인뷰에다 페이징처리하고 싶은 쿼리를 갖다넣으면 페이징처리가 된다. 
     FROM emp
     ORDER BY ename)a ) 
WHERE rn BETWEEN 11 AND 14;

--아까짯던 쿼리를 갖다넣으면 페이징처리완성
--헷갈리지말기 : 게시판을 만든순서대로 rownum을 부여하는것이기 때문에 seq는 오름차순으로 있는게 맞다 .
--rownum은 그대로 쓰면안되기때문에 인라인뷰로 감싸서 rownum 부여
--rownum 조건을 부여하려면 거기다 직접 조건을 주면 안되고(where절 바로) 인라인뷰를 감싸서 rownum에다 where에다 조건을줌
SELECT *
FROM
(SELECT ROWNUM rn, a.*
FROM
  (SELECT gn, CONNECT_BY_ROOT(seq) root_seq,
        seq, parent_seq, LPAD(' ', (LEVEL-1) *4) ||title title
        FROM board_test
        START WITH parent_seq IS NULL 
        CONNECT BY PRIOR seq = parent_seq
        --ORDER siblings by SEQ desc
        ORDER SIBLINGS BY gn DESC, seq ASC)a ) 
WHERE rn BETWEEN 6 AND 10;

SELECT ename
FROM emp
WHERE sal = (SELECT MAX(sal)
              FROM emp
              WHERE deptno = 10)

분석함수(window 함수)
    SQL 에서 행간 연산 지원하는 함수
    해당 행의 범위를 넘어서 다른 행과 연산이 가능
    -sql의 약점 보완
    -이전행의 특정 컬럼을 참조
    -특정 범위의 행들의 컬럼의 합 
    -특정 범위의 행중 특정 컬럼을 기준으로 순위, 행번호 부여
    
    -SUM, COUNT, AVG, MAX, MIN
    -RANK, LEAD, LAG....

사원의 부서별 급여(sal)별 순위 구하기

--초기만들기 
SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal DESC;

--로우넘 부여
SELECT  a.*, rownum rn
FROM 
(SELECT ename, sal, deptno 
FROM emp
ORDER BY deptno)a

--rn에 따른 rank 를 만들어야함
(SELECT rownum, rank
FROM 
(SELECT a.rn rank
FROM 
(SELECT ROWNUM rn --행부여 
FROM emp)a,

(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno
ORDER BY deptno) b --인라인뷰: 부서별 몇명있나 계산 
WHERE a.rn <= b.cnt --a는 카운트만큼만 가져다 쓸거임 
--a.rn = b.cnt 로 생각해보기 
--그룹으로 묶어서 행번호 부여 (cnt 3일때 rn도 1부터 3인걸 출력 해줘야함) 
ORDER BY b.deptno, a.rn);


--rn이 cnt 값보다 작거나 같을때 

--정답 (window 함수 쓰지않고)
SELECT a.ename, a.sal, a.deptno, b.rank
FROM 
(SELECT a.*, ROWNUM rn
FROM 
(SELECT ename, sal, deptno
 FROM emp
 ORDER BY deptno, sal DESC) a ) a,

(SELECT ROWNUM rn, rank
FROM 
(SELECT a.rn rank
FROM
    (SELECT ROWNUM rn
     FROM emp) a,
     
    (SELECT deptno, COUNT(*) cnt
     FROM emp
     GROUP BY deptno
     ORDER BY deptno) b
 WHERE a.rn <= b.cnt
ORDER BY b.deptno, a.rn)) b
WHERE a.rn = b.rn;



SELECT ename, sal, deptno, RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) sal_rank--부서같은 애들 묶기
--rank()over (PARTITION BY Deptno ORDER BY sal desc) sal_rank
--PARTITION BY Deptno : 같은 부서코드를 갖는 row를 그룹으로 묶는다
--order by sal : 그룹내에서 sal로 row의 순서를 정한다
--rank() : 파티션 단위안에서 정렬 순서대로 순위를 부여한다. 
FROM emp
--ORDER BY deptno, sal DESC


window 함수
SELECT window_fuction([arg])
OVER ([PARTITION BY columns] [ORDER BY columns] [WINDOWING])


순위 관련된 함수 (중복값을 어떻게 처리하는가)
RANK : 동일 값에 대해 동일 순위 부여하고, 후순위는 동일값만 건너뛴다 
       1등 2명이면 그 다음 순위는 3위
       
DENSE_RANK : 동일 값에 대해 동일 순위 부여하고, 후순위는 이어서 부여한다.
             1등이 2명이면 그 다음 순위는 2위 
ROW_NUMBER : 중복없이 행에 순차적인 번호를 부여 (rownum이랑 비슷)

SELECT ename, sal, deptno,
       RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) sal_rank, --중복된 값 다음에 그 중복값까지 쳐서 다음번호로 순서부여
       DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) sal_dense_rank, --중복된값 다음에 그 다음번호로 순서부여
       ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal DESC) sal_row_rank
FROM emp

SELECT WINDOW_FUNCTION([인자]) OVER ( [PARTITION BY 컬럼 | expression] [ORDER BY 컬럼])
FROM ....

PARTITION BY  : 영역 설정
ORDER BY  (ASC/DESC) : 영역 안에서의 순서 정하기 



--전체행을 대상으로 부서별로 급여가 높은사람들로 정렬하여 출력 , 급여가 같은 경우 empno로 desc 정렬 
SELECT empno, ename, sal, deptno, 
       RANK() OVER(ORDER BY sal DESC, empno ) sal_rank,--전체행을 대상으로 순위를 매길것이므로 파티션바이 안씀 
       DENSE_RANK() OVER(ORDER BY sal DESC, empno ) sal_dense_rank,--전체행을 대상으로 순위를 매길것이므로 파티션바이 안씀 
       ROW_NUMBER() OVER(ORDER BY sal DESC, empno ) sal_ROW_NUMBER--전체행을 대상으로 순위를 매길것이므로 파티션바이 안씀 
FROM emp

--기존의 배운 내용을 활용하여
--모든 사원에 대해 사원번호, 사원이름, 해당사원이 속한 부서의 사원수를 조회하는 쿼리를 작성하세요
SELECT count(*) cnt
FROM emp e
GROUP BY deptno;

--empno, ename, deptno 테이블과 depno, cnt 테이블을 조인해주면된다.

SELECT emp.empno, emp.ename, emp.deptno, b.cnt
FROM emp,
    (SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno) b
WHERE emp.deptno = b.deptno
ORDER BY emp.deptno;

SELECT empno, ename, deptno,
      COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

SELECT empno, ename, sal, deptno,
