SELECT *
FROM emp;


select *
from emp;

----데이터를 조회 방법
----FROM: 데이터를 조회할 테이블 명시
----SELECT : 조회 하고자 하는 컬럼명(테이블에 있는 컬럼명)
-----        테이블의 모든 컬럼을 조회할경우 *를 기술

SELECT empno, ename /* *->아스페리크스*/
FROM EMP; 

------------외우기---------------------------------------
--EMPNO : 직원번호, ENAME: 직원이름, JOB: 담당업무,
--MGR: 상위담당자(그사람을관리하는관리자), HIREDATE: 입사일자, SAL: 급여, 
--COMM: 보너스, DEPTNO: 부서번호 

