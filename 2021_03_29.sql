SELECT ename, job, ROWID
FROM emp
OREDER BY ename, job;

job, ename 컬럼으로 구성된 IDX_emp_03 인덱스 삭제

CREATE 객체타입(INDEX, TABLE, SEQUENCE) 

CREATE 객체타입 객체명
DROP 객체타입 객체명;

DROP INDEX idx_emp_03

CREATE INDEX idx_emp_04 ON emp (ename,job)

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
 AND ename LIKE 'C%';
 
 SELECT *
 FROM TABLE(DBMS_XPLAN.DISPLAY);
 
 
 --non-uique index가 있다면 (동일, 중복 인덱스가 있다면 인덱스 순서가 중요하다)
  
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_04 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("ENAME" LIKE 'C%' AND "JOB"='MANAGER') --먼저 접근하고 
       filter("JOB"='MANAGER' AND "ENAME" LIKE 'C%') --거기서 거른것 
       
--순서에 따라 읽어야하는 인덱스의 수가 다르다 

--테이블에 저장되어있는 정보 
SELECT ROWID, dept.*
FROM dept;

CREATE INDEX idx_dept_01 ON dept (deptno);

 SELECT *
 FROM TABLE(DBMS_XPLAN.DISPLAY);

--인덱스는 테이블을 동시에 못읽음
emp
1.table full access
2.idx_emp_01
3.idx_emp_02
4.idx_emp_04

dept
1.table full access
2.idx_dept_01

순서:
emp(4) => dept(2) : 8
dept (2) => emp (4) : 8

16가지 

EXPLAIN PLAN FOR 
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.empno = 7788;
  
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

 
---------------------------------------------------------------------------------------------
| Id  | Operation                     | Name        | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |             |     1 |    63 |     3   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                 |             |       |       |            |          |
|   2 |   NESTED LOOPS                |             |     1 |    63 |     3   (0)| 00:00:01 |
|   3 |    TABLE ACCESS BY INDEX ROWID| EMP         |     1 |    33 |     2   (0)| 00:00:01 |
|*  4 |     INDEX RANGE SCAN          | IDX_EMP_01  |     1 |       |     1   (0)| 00:00:01 |
|*  5 |    INDEX RANGE SCAN           | IDX_DEPT_01 |     1 |       |     0   (0)| 00:00:01 |
|   6 |   TABLE ACCESS BY INDEX ROWID | DEPT        |     1 |    30 |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("EMP"."EMPNO"=7788) --empno 7788 읽고 rowid를 읽고 emp테이블에 접근 emp에 있는 deptno 20찾고 depno 20이 가지고있는 rowid를 찾고 그에 대한 dept테이블을 접근해서 dname,loc 출력 
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
   
   --인덱스의 단점 
   : 저장공간이 테이블하나만 있으면 되는데 부가적으로 테이블 공간이 더 많이 필요하다.
   
   Index Access
   -소수의 데이터를 조회 할 때 유리(응답속도가 필요할때)
    .Index를 사용하는 Input/Output Single Block I/O 
   .다량의 데이터를 인덱스로 접근할 경우 속도가 느리다.  (2~3000건) 
   .인덱스는 삽입할때 정렬되어있는 인덱스 자기 순서찾아 들어갈텐데 그게 반복되면 과부하
   . 1.테이블의 빈공간을 찾아 데이터 입력
   . 2.인덱스의 구성컬럼을 기준으로 정렬된 위치를 찾아 인덱스 저장
   . 3.인덱스는 balance 트리 구조이고, root node부터 leaf node 까지의 depth가 항상 같도록 밸런스를 유지한다
   . 4.즉 데이터 입력으로 밸런스가 무너질경우 밸런스를 맞추는 추가 작업이 필요 
   
   테이블에 인덱스가 많다면
   -인덱스가 많아질경우, 위 과정이 인덱스 개수만큼반복되기 때문에 UPDATE, INSERT, DELETE 부하가 커진다 (테이블에 행의 변경이나 삭제나 삽입이 있을경우에 index의 순서도 달라지기 때문에 그런게 부하가 커질수 있다)
   -인덱스는 SELECT 실행시 조회 성능개선에 유리하지만 데이터 변경시 부하가 생긴다. 
   -테이블에 과도한 수의 인덱스를 생성하는것은 바람직하지 않음 
   -하나의 쿼리를 위한 인덱스 설계는 쉬움 
   -시스템에서 실행되는 모든 쿼리를 분석하여 적절한 개수의 최적의 인덱스를 설계 하는것이 힘듬
   
   Table Access
  .테이블이 모든 데이터를 읽고서 처리를 해야하는 경우 인덱스를 통해 모든 데이터를 테이블로 접근하는 경우보다 빠름 
   .I/O 기준이 multiblock 
  
  
SELECT dname, loc
FROM dept
WHERE dept.deptno = 20;
--emp1 인덱스로 접근. emp1 인덱스로 접근해서 empno는 상수를 가지고 있기 때문에 먼저 접근 
--dept테이블로 접근(아마도? 오라클은 경우의 개수가 많기때문에 예측하기는 힘들다)
  
응답성: OLTP (Online Transaction Processing)
--오라클은 응답성을 중요시하기 때문에 16가지 방법을 고려한것이다. 
퍼포먼스 : OLAP (Online Anaylysis Processing)
         - 은행이자 계산 
         - 조인을 여러개 하게 되면 접근방법 * 테이블^개수 
 
﻿
달력만들기 쿼리
배우고자 하는것
-데이터의 행을 열로 바꾸는 방법
-레포트 쿼리에서 활용할수 있는 예제 연습
주어진것: 년월 6자리 문자열 ex-202103
만들것: 해당 년월에 해당하는 달력 (7칸 짜리 테이블) 

'202103' ==> 31
SELECT TO_CHAR(LAST_DAY (TO_DATE(:YYYYMM,'YYYYMM')), 'DD')
FROM dual;

--LEVEL은 1부터 시작 
--해당년월의 마지막 일자만 가져온다. 
--주차를 나타내는 문자 : iw 
--주간 요일 : D
SELECT dt, d
FROM
(SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1) dt,
       TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'D')d  --,
--       TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'IW')iw,
FROM dual
CONNECT BY LEVEL  <= TO_CHAR(LAST_DAY (TO_DATE(:YYYYMM,'YYYYMM')), 'DD'));

--화요일이면 dt-아니면 null, 수요일이면 dt-아니면 null,
--목요일이면 dt-아니면 null, 금요일이면 dt-아니면 null,
--토요일이면 dt-아니면 null
--일요일이면 dt-아니면 null, 월요일이면 dt-아니면 null,
--1이 일요일, 월요일 2
--SELECT DECODE( 칼럼명, 조건, 조건이 true일 경우의 값, false일 경우의 값) FROM TABLE;
--min값 뽑는이유: null값이 엄청 많아서 (간단하게 보여주기위해서)

SELECT DECODE(d, 1, iw + 1, iw),  
              MIN(DECODE(d, 1, dt)) sun, MIN(DECODE(d, 2, dt)) mon,  
              MIN(DECODE(d, 3, dt)) tue, MIN(DECODE(d, 4, dt)) wen,
              MIN(DECODE(d, 5, dt)) thu, MIN(DECODE(d, 6, dt)) fri,
              MIN(DECODE(d, 7, dt)) sat
FROM        
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1) dt,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'D') d, 
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'IW') iw 
    FROM dual 
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD'))
GROUP BY DECODE(d, 1, iw + 1, iw) 
ORDER BY DECODE(d, 1, iw + 1, iw); 
--201912일자로 뽑아주기 (주차살릴때랑 안살릴때랑 다르다) -> 1주차라고 뜨는데 30, 31일 그건 2020년 1주차를 말하는것이다.
--우리가 아는 일반적인 달력으로 뽑으려면? group by를 iw로 안해주면 된다. 


계층 쿼리 - 조직도, I BOM(Bill of Material), 게시판 (답변형 게시판) 
         - 데이터의 상하 관계를 나타내는 쿼리 (계층순서대로 나옴) 


사용방법: 1. 시작 위치를 설정
         2. 행과 행의 연결 조건
         
PRIOR - 이전의, 사전의, 이미 읽은 데이터 
CONNECT BY 내가 읽은 행의 사번과 = 앞으로 읽을 행의 MGR 컬럼; 

SELECT empno, ename, mgr
FROM emp
START WITH empno = 7839 
CONNECT BY PRIOR empno = mgr ; 
--내가 읽은 사번이 앞으로 이어서 읽으려고 하는 mgr 컬럼을 연결하겠다 

--jones 밑에 잇는 사람은 누가있는가?
--계층쿼리에서만 특수하게 쓸수있는것 : LEVEL (계층을 말해주는것)
SELECT empno,deptno, LPAD(' ', (LEVEL-1)*4) || ename, mgr , LEVEL
FROM emp
START WITH empno = 7566 
CONNECT BY PRIOR empno = mgr AND deptno = PRIOR deptno ; 
--위치를 바꾸려면 CONNECT BY mgr = PRIOR empno;

    TEST
*****TEST
    TEST
    
SELECT LPAD('TEST',1*10)  
FROM dual;

이미 읽은 데이터              앞으로 읽어야 할 데이터
KING의 사번 = mgr 컬럼의 값이 KING의 사번인 녀석 
empno = mgr

KING (1)
   JONES (2)
      SCOTT (3)
         ADAMS (4)
      FORD (3)
--level에 따라 들여쓰기 조정 


START WITH mgr IS NULL;--(시작위치);


계층쿼리 방향에 따른 분류 
상향식:최하위 노드(leaf node)에서 자신의 부모를 방문하는 형태 
하향식:최상위 노드(root)에서 모든 자식 노드를 방문하는 형태

상향식 쿼리
SMITH(7369)부터 시작하여 노드의 부모를 따라가는 게층형 쿼리 작성
SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename, mgr, LEVEL
FROM emp
START WITH empno = 7369
CONNECT BY prior mgr = empno;
CONNECT BY SMITH의 mgr 컬럼값 = 내 앞으로 읽을 행 empno
;

--실습파일 dept_h 파일 넣기 

SELECT *
FROM dept_h;

최상위 노드부터 리프 노드까지 탐색하는 계층 쿼리 작성
(LPAD를 이용한 시각적 표현까지 포함)

--SELECT deptcd, LPAD(' ',(LEVEL-1)*4) ||deptnm, p_deptcd, LEVEL
--FROM dept_h
--START WITH deptcd = 'dept0'
--CONNECT BY prior deptcd = p_deptcd;

SELECT deptcd, LPAD(' ',(LEVEL-1)*4) ||deptnm, p_deptcd, LEVEL
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd= p_deptcd;

//PSUEDO CODE - 가상코드 
CONNECT BY  현재행의 deptcd = 앞으로 읽을 행의 p_deptcd
CONNECT BY PRIOR deptcd= p_deptcd;

--계층쿼리 실습 h2)
--정부시스템 부 하위 계층 부서계층 구조를 조회해라 
SELECT LEVEL LV, deptcd, LPAD(' ',(LEVEL-1)*4) ||deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptnm = '정보시스템부'
CONNECT BY PRIOR deptcd= p_deptcd;

PRE ORDER - oracle이 계층 쿼리 탐색 순서 

--디자인팀에서 시작하는 상향식 계층 쿼리를 작성하세요
SELECT LEVEL LV, deptcd, LPAD(' ',(LEVEL-1)*4) ||deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptnm = '디자인팀'
--CONNECT BY 현재행의부모(P_DEPT_CD = 앞으로 읽을행의 부서코드 (deptcd))
CONNECT BY PRIOR p_deptcd = deptcd;

--실습파일 계층형 쿼리복습 .sql  생성

SELECT *
FROM h_sum;

h4) 계층형쿼리 복습.sql 을 이용하여 테이블을 생성하고 다음과 같은
결과가 나오도록 쿼리를 작성하시오
s_id : 노드 아이디
ps_id : 부모 노드 아이디
value : 노드 값

DESC h_sum;
이름    널? 유형          
----- -- ----------- 
S_ID     VARCHAR2(4) 
PS_ID    VARCHAR2(3) 
VALUE    NUMBER      

SELECT *
FROM h_sum
START WITH TO_NUMBER(s_id)  =0;
--이런식으로 바꾸게되면 값을 가공한거라 인덱스를 쓰지 못한다. 
--인덱스 컬럼을 변형을 하게되면 (칠거지악)
           문자  = 숫자 ; 

SELECT LEVEL LV, LPAD(' ', (LEVEL-1) *4)|| s_id s_id, value
FROM h_sum
START WITH s_id= '0'
CONNECT BY PRIOR s_id = ps_id;
--CONNECT BY 현재 읽은 행의 s_id = 앞으로 읽을 행의 ps_id