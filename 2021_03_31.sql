
SELECT empno, ename, deptno,
      COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;


해당부서가 속한 급여 평균을 구해보세요 
해당부서의 가장 낮은 급여
해당부서의 가장 높은 급여 
해당부서의 합계
해당부서의 직원수 
SELECT empno, ename, sal deptno,
      ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) avg_sal, --deptno가 까지가 하나이다.
      MIN(sal) OVER (PARTITION BY deptno) min_sal,
      MAX(sal) OVER (PARTITION BY deptno) max_sal,
      SUM(sal) OVER (PARTITION BY deptno) sum_sal,
      COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

분석함수/window 함수 (그룹내 행의 순서)

LAG(col)
-파티션별 윈도우에서 이전행의 컬럼값

LEAD(col)
-파티션별 윈도우에서 이후 행의 컬럼값 

자신보다 급여 순위가 한단계 낮은 사람의 급여를 5번째 컬럼으로 생성
--lead, 이후행 컬럼값을 현재로 가져온다. 
SELECT empno, ename, hiredate, sal,
       LEAD(sal) OVER (ORDER BY sal DESC, hiredate)  --sal 내림차순된 기준으로 이후행 컬럼값 
FROM emp

--모든 사원에 대해 사원번호, 사원이름, 입사일자, 급여, 전체 사원중 급여 순위가 1단계 높은 사람의 급여를 조회하는 쿼리를 작성하세요
--(급여가 같을 경우 입사일자 빠른사람이 높은순위)

SELECT empno, ename, hiredate, sal , 
   LAG(sal) OVER (ORDER BY sal DESC, hiredate) LAG_SAL
FROM emp

-- 위의 쿼리를 분석함수를 사용하지 않고 쿼리짜기
--SELECT DECODE(SAL, 5000, NULL, 

--rownum 추가하기 

SELECT a.*, rownum rn
FROM
    (SELECT empno, ename, hiredate, sal 
     FROM emp
     ORDER BY sal DESC, hiredate) a
ORDER BY rn

--rownum까지 있는 테이블을 from절에 한번 똑같은테이블을 하나 더만든다 
--연결할값: rn과 rn-1을 조인하면 된다 
SELECT a.empno, a.ename, a.hiredate, a.sal, b.sal
FROM 
(SELECT a.*, rownum rn
FROM
    (SELECT empno, ename, hiredate, sal 
     FROM emp
     ORDER BY sal DESC, hiredate) a) a,
(SELECT a.*, rownum rn
FROM
    (SELECT empno, ename, hiredate, sal 
     FROM emp
     ORDER BY sal DESC, hiredate) a) b
WHERE a.rn-1 = b.rn(+)
ORDER BY a.sal DESC, hiredate;


--실습6)모든 사원에 대해 사원번호, 사원이름, 입사일자, 직군(job) , 급여정보와 담당업무(job)별 급여 순위가 1단계 높은 사람의
--급여를 조회하는 쿼리를 작성하세요
--급여가 같을 경우 입사일이 빠른 사람 높은 순위

SELECT empno, ename, hiredate, job, sal , 
   LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) LAG_SAL
FROM emp



--LAG, LEAD 함수의 두번째 인자 : 이전, 이후 몇번째 행을 가져올지 표기 
SELECT empno, ename, hiredate, sal , 
   LAG(sal, 2) OVER (ORDER BY sal DESC, hiredate) LAG_SAL
FROM emp

--자신의 급여에 한단계 낮은 급여의 값을 누적해서 출력하기
1.ROWNUM
2.INLINE VIEW
3.NON-EQUI-JOIN
4.GROUP BY 

SELECT a.empno, a.ename, a.sal, SUM(b.sal)
FROM 
(SELECT rownum rn, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal, empno)a )a,

(SELECT rownum rn, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal, empno)a )b
where a.rn >= b.rn --a의 rn3일때 b의 rn이 3까지 범위지정 
GROUP BY a.empno, a.sal, a.ename
ORDER BY a.sal , a.empno 

분석함수() OVER ( [PARTITION] [ORDER] [WINDOWING] )
WINDOWING  : 윈도우 함수의 대상이 되는 행을 지정
UNBOUNDED PRECEDING : 특정 행을 기준으로 모든 이전행 (LAG)
    n PRECEDING  : 특정 행을 기준으로 N행 이전행 (LAG)
CURRENT ROW  : 현재행 
UNBOUNDED FOLLOWING : 특정 행을 기준으로 모든 이후행(LEAD)
   n FOLLOWING : 특정 행을 기준으로 N행 이후행 (LEAD)

--내가 짠 코드
SELECT empno, ename, sal, SUM(sal) OVER (ORDER BY sal, empno ) c_sum
FROM 
(
SELECT empno, ename, sal, LEAD(sal) OVER (ORDER BY sal, empno ) c_LAG
FROM emp
)

--선생님이 짠코드 
분석함수() OVER ( [] [ORDER] [WINDOWING] ) --여기서는 partition by를 쓰지 않으니까 
SELECT empno, ename, sal, 
       sum(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) c_sum,
       sum(sal) OVER (ORDER BY sal, empno ROWS UNBOUNDED PRECEDING ) c_sum
FROM emp

--본인 기준 위, 아래의 합계 
SELECT empno, ename, sal, 
       sum(sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING ) c_sum
FROM emp

--사원번호, 사원이름, 부서번호, 급여 정보를 부서별로 급여, 사원번호, 오름차순으로 정렬했을때,
--자신의 급여와 선행하는 사원들의 급여 합을 조회하는 쿼리를 작성하세요 (window 함수사용)

SELECT empno, ename, deptno, sal,
    --sum(sal) OVER ([PARTITION BY deptno] [ORDER BY sal, empno] [ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW]) c_sum
    sum(sal) OVER (PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp

범위설정 - rows 와 range

ROWS와 RANGE의 차이 
SELECT empno, ename, deptno, sal,
    sum(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING )rows_c_sum, --자기자신 선행하는 모든 행 포함
    sum(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING )range_c_sum, --sal이 같은 행이있을경우, ward 와 martion은 같은 값을 가지고 있는건데 그것을 같은 값으로 인식해서 그 두번행을 합친결과값이 나오는것 
    sum(sal) OVER (ORDER BY sal, empno) no_win_c_sum, --ORDER BY 뒤에 윈도윙 없을 경우 : RANGE UNBOUNDED PRECEDING 들어감 
    sum(sal) OVER () no_win_c_sum --전체합 출력 
FROM emp
ORDER BY sal, empno;

전문가로가는지름길(오라클실습)
불친절한 SQL 프로그래밍
관계형 데이터 모델링 

RATIO_TO_RePORT
PERCENT _RANK
CUME_DIST
NTILE