날짜관련_함수
MONTHS_BETWEEN : (이거만 숫자를 반환)
인자 - start date, end date, 반환값: 두 일자 사이의 개월수 


ADD_MONTHS(***)
인자: date, number 더할 개월수 : date로 부터 x개월 뒤의 날짜 

date + 90 
1/15 3개월 뒤의 날짜 

NEXT_DAY(***)
인자: date, number(weekday, 주간일자)
date 이후의 가장 첫번째 주간일자에 해당하는 date를 반환 

LAST_DAY(***)
인자: date : date가 속한 월의 마지막 일자를 date로 반환 

MONTHS_BETWEEN 
SELECT ename, TO_CHAR(hiredate, 'yyyy/mm/dd HH24:mi:ss') hiredate,
       MONTHS_BETWEEN(sysdate,hiredate) month_between, --근속년도 따질때 
       ADD_MONTHS(SYSDATE, 5) ADD_MONTHS,--현재 날짜에 5개월 더한거 
       ADD_MONTHS(TO_DATE('2021-03-05','YYYY-MM-DD'), 5)  ADD_MONTHS2,
       NEXT_DAY(SYSDATE, 1) NEXT_DAY,
       LAST_DAY(SYSDATE) LAST_DAY, --3월 31일 출력
       TO_DATE(TO_CHAR(SYSDATE, 'YYYYMM') || '01', 'YYYYMMDD') FIRST_DAY
--       SYSDATE를 이용해서 sysdate가 속한 월의 첫번째 날짜 구하기
--       sysdate를 이용해서 년월까지 문자로 구하기 + || '01'
--       '202103' || '01' ==> 20210301'
--       TO_DATE('20210301', YYYYMMDD') 
FROM emp;

SELECT TO_DATE('2021', 'YYYY')
FROM dual; 
--서버의 현재 시간의 월 (시분초 날려버리고 싶을때 YYYY-MM-DD 이런식으로 표기)

SELECT TO_DATE('2021' || '0101', 'YYYYMMDD')
FROM dual; 

Fuction (date 종합 실습 fn3)
-파라미터로 yyyymm형식의 문자열을 사용하여 (ex : yyyymm = 201912)
해당 년월에 해당하는 일자 수를 구해보세요
yyyymm = 201912 -> 31
yyyymm = 201911 -> 30
yyyymm = 201602 -> 29

fn3) LAST_DAY (날짜) 
우리에게 주어진건 문자
SELECT :YYYYMM, --:이 변수를 만드는것, 만든값들이 들어온다. 
       TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD') DT 
FROM dual;

형변환
-명시적 형변환
  TO_DATE, TO_CHAR, TO_NUMBER 
-묵시적 형변환 

1-0
실행 계획 읽는방법
1.위에서 아래로
2.단, 들여쓰기 되어있을 경우 (자식 노드) 자식노드부터 읽는다 

EXPLAIN FOR 
SELECT *
FROM emp
WHERE  TO_CHAR(empno) = '7369';
--7369가 문자로 묵시적인 형변환, 읽어들일땐 숫자로 읽음(explain을 이용해서)

SELECT TO_DATE ('201912' , 'YYYYMM'), LAST_DAY(TO_DATE ('201912' , 'DD'))
FROM DUAL;

Function (NUMBER)
-NUMBER

FORMAT
9: 숫자
0: 강제로 0표시
, : 1000자리 표시
.: 소수점
L : 화폐단위
$: 달러 화폐 표시 


형변환(NUMBER-> CHARACTER) --참고로만
SELECT ename , sal, TO_CHAR(sal, 'L0009,999.00') fm_sal
FROM emp

NULL 처리 함수 : 4가지
***NVL (expr1, expr2) : expr1이 NULL값이 아니면 expr1을 사용하고, expr1이 NULL값이면 expr2로 대체해서 사용한다 

java =
if(expr 1 == null)
  System.out.println(expr2)
else
 system.out.println(expr1)
 
 emp테이블에서 comm 컬럼의 값이 NULL일 경우 0으로 대체해서 조회하기
 SELECT empno, comm, NVL(comm,0)
 FROM emp;
 
 SELECT empno, sal, comm,
        sal, NVL(comm, 0) nvl_sal_comm, -- comm null인 값이 0으로 출력
        NVL(sal+comm, 0) nvl_sal_comm2 --sal_comm인 값이 0으로 출력
FROM emp;

NVL2(expr1, expr2, expr3)
if(expr1! = null)
 system.out.println(expr2);
else
 system.out.println(expr3);
 
comm 이 null이 아니면 sal_comm을 반환,
comm 이 null이면 sal을 반환
SELECT empno, sal, comm, 
        NVL2(comm, sal+comm, sal) nvl2, --comm값이 있으면 sal+comm , comm값이 없으면 sal만 내보내라
        sal+ NVL(comm, 0)
FROM emp;

NULLIF(expr1, expr2)
if(expr1 == expr2)
  system.out.println(NULL);
else
 system.out.println(expr1);
 
SELECT empno, sal, NULLIF(sal, 1250)
FROM emp;

--null이 아닌것을 조회 
COALESCE(exp1, expr2, expr3 ....)
인자들중에 가장먼저 등장하는 null이 아닌 인자를 반환 
if(expr1 != null)
  system.out.println(expr1);
else
 COALESCE(expr2, expr3....); --재귀함수 호출 (자기자신을 호출한다)
 
 SELECT empno, sal, comm, COALESCE(
 FROM emp; 
 
 Fuction (null 실습 fn4)
 -emp테이블의 정보를 다음과 같이 조회도도록 쿼리를 작성하세요
 (nvl1, nvl2,coalesce)
 
 SELECT empno, ename, mgr, NVL(mgr,9999) AS nvl, 
        NVL2(mgr, mgr, 9999) AS MGR_N_1,
        COALESCE(mgr,9999) AS MGR_N_2 
 FROM emp;
 
 
 Fuction (null 실습 fn5)
 -user테입ㄹ의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요
 reg_dt가 null인 경우 sysdate를 적용
 SELECT userid, usernm, reg_dt, NVL(reg_dt, TO_CHAR(TO_DATE(sysdate),'YYYY/mm/dd')) N_REG_DT
 FROM users 
 WHERE userid IN('cony', 'sally', 'james', 'moon');
 
 
 조건분기
 1. CASE절
     CASE expr1 (컬럼이나 수식) 비교식 (참거짓을 판단 할수 있는 수식) THEN 사용할 값 -> if
     CASE expr2 (컬럼이나 수식) 비교식 (참거짓을 판단 할수 있는 수식) THEN 사용할 값2 -> else if
     CASE expr3 (컬럼이나 수식) 비교식 (참거짓을 판단 할수 있는 수식) THEN 사용할 값3 -> else if
     ELSE 사용할 값4                                                            -> else
    END 
    
 2.DECODE 함수 => COALESCE 함수 처럼 가변 인자 사용
 DECODE ( expr1, search1, return1, search2, return2,search3, return3,.....[,defalt]}
  DECODE ( expr1, 
             search1, return1, 
             search2, return2,
             search3, return3,
             .....[,defalt]}
 if(expr1 == search1) --대소비교가아니라 무조건 동등 비교 >  <, 이런거 아니라 == 동등 비교
    System.out.println(retur1)
 else if(expr1 == search2)
    System.out.println(retur2)
else if(expr1 == search3)
    System.out.println(retur3)
else
    System.out.println(expr2); 
 
 직원들의 급여를 인상하려고 한다
 job이 SALESMAN이면 현재 급여에서 5%를 인상
 job이 MANAGER이면 현재 급여에서 10%를 인상
 job이 PRESIDENT이면 현재 급여에서 20%를 인상
 그 이외의 직군은 현재 급여를 유지
 
 SELECT ename, job, sal , 
        CASE
           WHEN job = 'SALESMAN' THEN sal*1.05 
           WHEN job = 'MANAGER' THEN sal*1.10 
           WHEN job = 'PRESIDENT' THEN sal*1.20
           ELSE sal * 1.0
        END sal_bonus,
        DECODE(job, 
               'SALESMAN',sal *1.05,
               'MANAGER', sal *1.10,
               'PRESIDENT', sal*1.20,
               sal *1.0)sal_bonus_decode 
 FROM emp;
 
 
 condition 실습 cond1
 -emp테이블을 이용하여 deptno에 따라 부서명으로 변경해서 다음과 같이 조회되는 쿼리를 작성하세요
 10 -> 'ACCONTING'
 20 -> 'RESEARCH'
 30 -> 'SALES'
 40 -> 'OPERATIONS'
 기타 다른 값 -> 'DDIT'
 
 SELECT empno, ename, deptno,
        CASE
           WHEN deptno = 10 THEN 'ACCONTING'
           WHEN deptno = 20 THEN 'RESEARCH'
           WHEN deptno = 30 THEN 'SALES'
           WHEN deptno = 40 THEN 'OPERATIONS'
           ELSE 'DDIT'
           END dname,
           DECODE(deptno, 10, 'ACCONTING', 20, 'RESEARCH', 30, 'SALES', 40,  'OPERATIONS','DDIT') dname_decode 
FROM emp


condition 실습 cond2 
-emp테이블을 이용하여 hiredate에 따라 올해 건강보험 검진 대상자인지 조회하는 쿼리를 작성하세요
(생년을 기준으로 하나 여기서는 입사년도를 기준으로 한다)

--직원의 입사일자가 홀수냐짝수냐
--올해가 짝수냐 짞수냐 
2=> 0, 1
SELECT MOD(TO_CHAR(hiredate, 'yyyy') 


SELECT empno, ename, hiredate, 
       MOD(TO_CHAR(hiredate,'YYYY'),2), 
FROM emp;

SELECT empno, ename, hiredate, 
    CASE
    WHEN
      MOD(TO_CHAR(hiredate,'YYYY'),2) =   
      MOD(TO_CHAR(SYSDATE,'YYYY'),2) THEN '건강검진 대상자' --1 THEN '건강검진대상자'
    ELSE '건강검진 비대상자'
    END CONTACT_TO_DOCTOR
    --DECODE( MOD(TO_CHAR(hiredate,'YYYY'),2) ,
      --                   MOD(TO_CHAR(SYSDATE+365,'YYYY'),2), '건강검진 대상자' 
        --                                                       '건강검진 비대상자') CONTACT_TO_DOTOR_DECODE
FROM emp;


users테이블을 이용하여 reg_dt에 따라 올해 건강보험 검진
대상자인지 조회하는 쿼리를 작성하세요
(생년을 기준으로 하나 여기서는 reg_dt를 기준으로한다)
 
 SELECT userid, usernm, reg_dt, 
    CASE
    WHEN
      MOD(TO_CHAR(reg_dt,'YYYY'),2) =   
      MOD(TO_CHAR(SYSDATE,'YYYY'),2) THEN '건강검진 대상자' --1 THEN '건강검진대상자'
    ELSE '건강검진 비대상자'
    END CONTACT_TO_DOCTOR
FROM users
WHERE userid IN ('brown', 'cony', 'moon', 'sally', 'james');
 
 
GROUP FUNCTION : 여러행을 그룹으로 하여 결과를 반환하는 함수 
ex) 부서별 조직원수 , 부서별 가장 높은 급여, 부서별 급여 평균 
--뭘 기준으로 하나로 묶을건지 생각하기 

***GRoup function
-avg: 평균
-count : 건수
-max:  최대값
-min: 최소값
-sum : 합 

-Group function
SELECT[컬럼] , group function(컬럼)
from table
[where]
[group by 컬럼]

 10, 5000
 20, 3000
 30, 2850
 
 SELECT deptno, MAX(sal), MIN(sal), ROUND(AVG(sal),2),
                SUM(sal), 
                COUNT(sal), --그룹핑된 행중에 sal 컬럼의 값이 NULL이 아닌 행의 건수 ,
                COUNT(mgr), --그룹핑된 행중에 mgr 컬럼의 값이 NULL이 아닌 행의 건수 ,
                COUNT(*) --그룹핑된 행의 건수 
 FROM emp
 GROUP BY deptno;
 --부서번호를 같은 행을 기준으로 묶었다는 게 핵심 
 --부서번호같은 사람들끼리 묶음, 제일 높은 급여 
 --round는 소숫점 둘째짜리까지 
 --select에 empno을 추가해서 출력하면 논리적으로 맞지가않음 deptno묶어주는데 empno는 각각출ㄹ력될수 없으
 --group by절에 나온 컬럼이 select절에 그룹함수가 적용되지 않은채로 기술되면 에러 (윗줄과 동등한의미)
 --empno값과 deptno값을 묶어주면 그룹핑이 되지않는다. 
 --하지만, max(empno)이런식으로 기술해주면 출력이된다. 건수가 하나이기 때문
 
 
 --전체직원수 조회 (전체행을 대상으로 ) 
 --Group by 를 사용하지 않을 경우 테이블의 모든 행을 하나의 행으로 그룹핑한다. 
 SELECT COUNT(*) ,MAX(sal), MIN (sal), ROUND(AVG(sal),2), SUM(sal)
 FROM emp
--deptno쓰면 select줄 에서 쓰면 에러 왜냐면 14개를 하나로 묶어줬기때문에 

 SELECT max(deptno), COUNT(*) ,MAX(sal), MIN (sal), ROUND(AVG(sal),2), SUM(sal)
 FROM emp
 
  SELECT deptno, 'TEST', 100,  --고정된 상수는 문제없이 나온다. 
                MAX(sal), MIN(sal), ROUND(AVG(sal),2),
                SUM(sal), 
                COUNT(sal), --그룹핑된 행중에 sal 컬럼의 값이 NULL이 아닌 행의 건수 ,
                COUNT(mgr), --그룹핑된 행중에 mgr 컬럼의 값이 NULL이 아닌 행의 건수 ,
                COUNT(*),
                SUM(comm), --30번 부서번호 그룹은 null 을 포함하고 있는데도 그룹함수가 알아서 제외하고 연산해줌
                SUM(NVL(comm, 0)),
                NVL(SUM(comm), 0)--밑에께 나은 연산  
 FROM emp
 --WHERE count(*) > 4 안됨. 이거는 having절에 써줘야한다. 
 GROUP BY deptno
 HAVING count(*) >= 4;
 
 
*** group function 
 -그룹 함수에서 null컬럼은 계산에서 제외된다
 -group by절에 작성된 컬럼 이외에 컬럼이 select절에 올수 없다
 -where절에 그룹 함수를 조건으로 사용할수 없다
 -> having절 사용
 where sum(sal) > 3000 x
 having sum(sal) > 3000 o 
 
 
 function (group function 실습 grp1)
 -emp테이블을 이용하여 다음을 구하시오
 직원중 가장 높은 급여 max_sal
 
SELECT max(sal)
FROM emp;
 
 직원중 가장 낮은 급여 min_sal
 SELECT min(sal)
 FROM emp;
 
 직원의 급여 평균(소수점 두자리까지 나오도록 반올림) avg_sal
 
 SELECT ROUND(avg(sal),2)
 FROM emp
 
 
 직원의 급여합 sum_sal
 
 SELECT sum(sal)
 FROM emp
 
 직원중 급여가 있는 직원의 수 (null제외) count_sal
 
 SELECT COUNT(sal)
 FROM emp
 
 직원중 상급자가 있는 직원의 수 (null제외) count_mgr

SELECT COUNT(mgr)
FROM emp
 
 전체 직원의 수 count_all

SELECT COUNT(*)
FROM emp 

부서번호 별로 다시 정렬 
 
 if()
 else if
 else if
 .
 .
 else 