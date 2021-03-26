INSERT 단건, 여러건

INSERT INTO 테이블명
SELECT ....

UPDATE 테이블명 SET 컬럼명 1 = (스칼라 서브쿼리)
                   컬럼명 2 = (스칼라 서브쿼리)
                   컬럼명 3 = 'TEST'
                   
9999번 사번(empno)을 갖는 brown 직원(ename)을 입력

INSERT INTO emp (empno, ename) VALUES (9999, 'brown');
INSERT INTO emp (enmae, empno) VALUES ('brown' , 9999); --위 쿼리와같음

DESC emp;

SELECT *
FROM emp;

9999번 직원의 deptno와 job 정보를 SMITH사원의 deptno, job 정보로 업데이트 
--smith depno : 20, job : clerk
--모든컬럼을 업데이트하려면 비효율적 
UPDATE emp SET deptno = (SELECT deptno
                           FROM emp
                          WHERE ename = 'SMITH'),
                  job = (SELECT job
                           FROM emp
                          WHERE ename = 'SMITH')
WHERE empno = 9999;

DELETE : 기존에 존재하는 데이터를 삭제
--컬럼에 대한기술이 없고 행을 지우는것 
DELETE 테이블명
WHERE 조건;

DELETE emp;

SELECT *
FROM emp

ROLLBACK;


삭제 테스트를 위한 데이터 입력
INSERT INTO emp (empno, ename) VALUES (9999, 'brown');

DELETE emp
WHERE empno = 9999;

mgr가 7698 사번(BLAKE)인 직원들 모두 삭제
SELECT *
FROM emp
WHERE mgr = 7698;

DELETE emp 
WHERE empno IN (SELECT empno 
                  FROM emp 
                 WHERE mgr = 7698);

ROLLBACK;


DBMS는 DML 문장을 실행하게 되면 LOG를 남긴다
  UNDO(REDO) LOG - 맨마지막에 있는 파일을 저장시킨다 (만약 정전됐을때, undo log에서 불러오는것)
  --함부로하면안된다. 얘는 복구가 안됨
  
로그를 남기지 않고 더 빠르게 데이터를 삭제하는 방법: TRUNCATE 
- DML이 아님 (DDL)
- ROLLBACK이 불가 (복구 불가)
- 주로 테스트 환경에서 사용 

CREATE TABLE emp_test AS
SELECT *
FROM emp;

SELECT *
FROM emp_test;

TRUNCATE TABLE 테이블명;

TRUNCATE TABLE emp_test;

ROLLBACK;


Transaction (트랜잭션)
-논리적인 일의 단위
-아래 사항에서 트랜잭션 발생
-관련된 여러 DML 문장을 하나로 처리하기 위해 사용
-> 첫번쨰 DML 문을 실행함과 동시에 트랜잭션 시작
-> 이후 다른 DML문 실행
-> commit: 트랜잭션을 종료, 데이터를 확정
-> rollback: 트랜잭션을 취소, rollback시 DML 취소

트랜잭션 예시
- 게시글 입력시 (제목, 내용, 복수개의 첨부파일)
- 게시글 테이블, 게시글 첨부파일 테이블
- 1.DML : 게시글 입력
- 2.DML : 게시글 첨부파일입력
- 1번 DML은 정상적으로 실행 후 2번 DML 에러가 나면? 모두 실패하는것이다.

SQL developer 두개 띄워놓으면, dbms에서는 두개의 사용자로 인식 

읽기 일관성 레벨 ( 0 - > 3)
트랜잭션에서 실행한 결과가 다른 트랙잭션에 어떻게 영향을 미치는지
정의한 레벨(단계)

LEVEL 0: READ UNCOMMITED
- dirty(변경이 가해졌다) read
- 커밋을 하지 않은 변경 사항도 다른 트랜잭션에서 확인 가능
- oracle에서는 지원하지 않음

LEVEL 1 : READ COMMITED
-대부분의 DBMS 읽기 일관성 설정 레벨
-커밋한 데이터만 다른 트랜잭션에서 읽을 수 있다
 커밋하지 않은 데이터는 다른 트랜잭션에서 볼 수 없다. 
 
LEVEL 2 : Reapeatable Read
 .선행 트랜잭션에서 읽은 데이터를
  후행 트랜잭션에서 수정하지 못하도록 방지
 .선행 트랜잭션에서 읽었던 데이터를
     트랜잭션의 마지막에서 다시 조회를 해도 동일한 결과가
     나오게끔 유지
     
     (쿼리를 어디서도 읽어도 동일한 결과가 나오게끔 하겠다)
   
   -신규 입력 데이터에 대해서는 막을 수 없음(업데이트를 막을수는 있지만 후행 트랜잭션에서 행을 추가시키면 선행 트랜잭션에서는 막을수가 없다(조회되게됨)
   ==> phantom read( 유령 읽기) - 없던 데이터가 조회되는 현상 
   
   기존 데이터에 대해서는 동일한 데이터가 조회되도록 유지

 .oracle에서는 LEVEL 2에 대해 공식적으로 지원하지 않으나
 FOR UPDATE 구문을 이용하여 효과를 만들어낼 수 있다. ( for update쓰면 다른 트랜잭션에서 수정하지못함)
 SELECT * FROM emp FOR UPDATE; 이런식으로 쓰면 다른 트랜잭션에서 update set 쓰면 그 테이블 수정못함 
 
 LEVEL 3 : Serializable Read 직렬화 하기 
  -후행 트랜잭션에서 수정, 입력 삭제한 데이터가 선행 트랜잭션에 영향을 주지 않음 
  - 선 : 데이터 조회(14)
    후 : 신규에 입력 (15)
    선 : 데이터 조회 (14)

인덱스
. 눈에 안보임 
. 테이블의 일부 컬럼을 사용하여 데이터를 정렬한 객체 (테이블이없는데 인덱스를 만들수는 없음)
  ==> 원하는 데이터를 빠르게 찾을 수 있다. 
  . 일부 컬럼과 함께 그 컬럼의 행을 찾을 수 있는 ROWID가 같이 저장됨 
. ROWID : 테이블의 저장된 행의 물리적 위치, 집 주소 같은 개념 
          주소를 통해서 해당 행의 위치를 빠르게 접근하는 것이 가능 
          데이터가 입력이 될 때 생성 
 
 SELECT ROWID, emp.*
 FROM emp
 WHERE empno = 7369;
 --AAAE5gAAFAAAACLAAA = ROWID 인 행출력 
 
 SELECT ROWID, empno
 FROM emp
 WHERE empno = 7782; --행을 다 읽어본다
 
 SELECT *
 FROM emp
 WHERE ROWID = 'AAAE5gAAFAAAACLAAA';
 
 EXPLAIN PLAN FOR
 SELECT *
 FROM emp
 WHERE empno = 7782;
 
 --전부다 예측값이므로 진짜값은 name까지 이다. 
 --TABLE ACCESS FULL -> 데이터를 다 읽었다 
 --filter empno=7782인걸 제외하고 다 버렸다. 
 SELECT *
 FROM TABLE (DBMS_XPLAN.DISPLAY);
 --rows 는 예측값 (1건이 나올거같다)
 --데이터를 읽기까지byte 를 38만큼 썼다
 --비용을 얼마나 들었는지
 
 오라클 객체 생성
 CREATE 객체 타입 (INDEX, TABLE... ) 객체명
 java :  int 변수명 (이런형식과 같은것)
 
 인덱스 생성
 CREATE INDEX [UNIQUE] 인덱스 이름 ON 테이블명(컬럼1, 컬럼2); 
 
 CREATE UNIQUE INDEX PK_emp ON emp(empno)
 
 <--실행계획이 어떻게 바뀌는지 확인---> 
 EXPLAIN PLAN FOR
 SELECT *
 FROM emp
 WHERE empno = 7782;
 
 SELECT *
 FROM TABLE (DBMS_XPLAN.DISPLAY);
 --2->1->0 순서대로 읽음 (자식부터 읽으니까(자식들은 들여쓰기가 되어있음))
 --filter는 읽은다음 거르는거고, access는 먼저 거른다는거 (데이터한건읽음) 
 
  
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
 
 index가 없다면
 테이블에는 순서가 없기 때문에 테이블의 끝까지 뒤져보고 나서야 찾을수가 있다. 
 index 가 있다면
 index는 정렬되어있음 (empno, rowid 먼저읽음 , empno를 먼저찾고 rowid를 찾아낸 다음 테이블을 찾아감) 
 
 emp테이블이 하나있고 pk_emp는 rowid와 empno를 기준으로 정렬해놓은 특정 테이블이 하나 있는것 
 오라클 ? 인덱스를 경우해서 읽을것이냐/ 테이블만 읽을것이냐 
 
 EXPLAIN PLAN FOR
 SELECT empno
 FROM emp
 WHERE empno = 7782;
 
  SELECT *
 FROM TABLE (DBMS_XPLAN.DISPLAY);
  
-------------------------------------------------------------------------------
| Id  | Operation        | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------
|   0 | SELECT STATEMENT |            |     1 |    13 |     1   (0)| 00:00:01 |
|*  1 |  INDEX RANGE SCAN| IDX_EMP_01 |     1 |    13 |     1   (0)| 00:00:01 |
-------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPNO"=7782)
 
 -
 
 
 DROP INDEX PK_EMP;
 
 UNIQUE -중복이 안되게 하는것 
 CREATE INDEX IDX_emp_01 ON emp (empno);  
 
 EXPLAIN PLAN FOR
 SELECT *
 FROM emp
 WHERE empno = 7782;
 
 SELECT *
 FROM TABLE (DBMS_XPLAN.DISPLAY);
 
 Plan hash value: 4208888661
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN (중복허용)| IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)

SELECT job, rowid
FROM emp
ORDER BY job;

job 컬럼에 인덱스 생성
CREATE INDEX idx_emp_02 ON emp (job);

 EXPLAIN PLAN FOR
 SELECT *
 FROM emp
 WHERE job = 'MANAGER'
 
 SELECT *
 FROM TABLE (DBMS_XPLAN.DISPLAY);
 
 --job, rowid 에서 job=manager인걸 검색해서 결과를 뿌려준것이다. 
 
 | Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     3 |   261 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     3 |   261 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("JOB"='MANAGER')
 
  EXPLAIN PLAN FOR
 SELECT *
 FROM emp
 WHERE job = 'MANAGER'
   AND ename LIKE 'C%' ; 
   
 SELECT *
 FROM TABLE (DBMS_XPLAN.DISPLAY);

--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("JOB"='MANAGER' AND "ENAME" LIKE 'C%')

CREATE INDEX IDX_EMP_03 ON emp (job, ename)

 DROP INDEX IDX_EMP_03;

 SELECT job, ename, rowid
 FROM emp
 WHERE job = 'MANAGER'
   AND ename LIKE 'C%' ;
 
 
 EXPLAIN PLAN FOR
 SELECT *
 FROM emp
 WHERE job = 'MANAGER'
   AND ename LIKE 'C%' ; 

------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')

access- 그위치를 내가 찾아갈때 썼다
filter - 위치를 읽고나서 버렸다. 

 EXPLAIN PLAN FOR
 SELECT *
 FROM emp
 WHERE job = 'MANAGER'
   AND ename LIKE '%C' ; 
   
 SELECT *
 FROM TABLE (DBMS_XPLAN.DISPLAY);
 
 ------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')
       filter("ENAME" IS NOT NULL AND "ENAME" LIKE '%C')

--실제 이 조건을 만족하는 데이터가 없기 때문에 데이터는 없음, 하지만 실행계획은 이렇다 하고 보여준것 
 
 인덱스 생성
 
DAP 네이버카페