2021-03-12 복습
조건에 맞는 데이터 조회 : WHERE 절 - 기술한 조건을 참(TRUE)으로 만족하는 행들만 조회한다(FILTER) ;

--row  : 14개, col : 8개
SELECT *
FROM emp
WHERE 1 = 1;
//14건조회

SELECT *
FROM emp
WHERE deptno = deptno;
//14건조회

SELECT *
FROM emp
WHERE  deptno != deptno;
WHERE 1!= 1;
//0건출력

--리터럴: 값 자체 / 리터럴 표기법 - 그 문법에 맞는걸로 표기하는거 

int a = 20;
--java : String a = " 20";
'20';

SELECT 'SELECT * FROM ' || table_name || ';'
FROM user_tables;

--SELECT "SELECT * FROM " + table_name + ";"
--FROM user_tables;

'81/03/01'

TO_DATE ('81/03/01', 'YY/MM/DD')

--입사일자가 1982 1월 1일 이후인 모든 직원 조회하는 SELECT 쿼리를 작성하세요

*날짜조회
30 > 20 : 숫자 > 숫자
날짜  > 날짜
2021-03-15 > 2021-03-12

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD');

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('19820101', YYYYMMDD')
WHERE hiredate >= TO_DATE('1982-01-01', YYYY-MM-DD')
WHERE hiredate >= TO_DATE('1982/01/01', YYYY/MM/DD')
--YYMMDD 이렇게 조회하면 안됨 


WHERE절에서 사용 가능한 연산자
(비교 ( =, !=, >, < ..........)

<java> 
a + b ;
a++ ==> a = a + 1;
++a ==> a = a + 1; 

비교대상 BETWEEN AND 비교대상의 허용 시작값 AND 비교대상이 허용 종료값 
ex: 부서번호가 10번에서 20번 사이의 속한 직원들만 조회 
    10, 11, 12.....20
SELECT *
FROM emp
WHERE deptno BETWEEN 10 AND 20;

emp테이블에서 급여(sal)가 1000보다 크거나 같고 2000보다 작거나 같은 직원들만 조회
sal >= 1000
sal <= 2000
SELECT *
FROM emp
WHERE sal BETWEEN 100 AND 2000 ; 

SELECT *
FROM emp
WHERE sal >= 1000
  AND sal <= 2000
  AND deptno = 10; 

and 연산자
true and true ==> true
true and false ==> false
or 연산자
true of false ==> true

-emp 테이블에서 입사 일자가 1982년 1월 1일 이후부터
1983년 1월 1일 이전인 사원의 ename , hiredate 데이터를
조회하는 쿼리를 작성하시오
단 연산자는 between을 사용한다

where1]
SELECT ename, hiredate
FROM emp
WHERE hiredate between TO_DATE ('1982/01/01','YYYY/MM/DD') AND TO_DATE ('1983/01/01','YYYY/MM/DD');

where2]
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE ('1982/01/01','YYYY/MM/DD')
  AND hiredate <= ('1983/01/01','YYYY/MM/DD');

BETWEEN AND : 포함(이상, 이하), 
              초과 미만의 개념을 적용하려면 비교연산자를 사용해야 한다.
              

IN 연산자 (자바에서는 OR 연산자)
대상자 IN (대상자와 비교할 값1, 대상자와 비교할 값2, 대상자와 비교할 값3, .......)
deptno IN (10,20) ==> deptno 값이 10이나 20이면 TRUE 


SELECT *
FROM emp
WHERE deptno IN (10,20);

SELECT *
FROM emp
WHERE deptno = 10
  OR  deptno = 20;

SELECT *
FROM emp
WHERE 10 IN (10,20);
--10은 10과 같거나 10은 20과 같다 
          (TRUE) OR  (FALSE) ==> TRUE 
          

where3 IN 실습)

users 테이블에서 userid가 brown, cony, sally인 데이터를 다음과 같이 조회하시오 . (IN 연산자 사용)

SELECT userid 아이디, usernm 이름, alias 별명
FROM users
WHERE userid IN ('brown', 'cony', 'sally');
--brown이런건 문자열이기때문에 싱글쿼테이션 사용(키워드는 대소문자 가리지 않지만 데이터는 대소문자 가림)
--> userid= 'brown' 이거나 'cony'이거나 'sally' 이다

SELECT userid 아이디, usernm 이름, alias 별명
FROM users
WHERE userid = 'brown'
   OR userid = 'cony'
   OR userid = 'sally';
--from절 다음에 세미콜론쓰지 않게 주의 (오류메세지 기억하기)


LIKE 연산자: 문자열 매칭 조회
게시글 : 제목 검색, 내용 검색
        제목에 [맥북에어]가 들어가는 게시글만 조회

        1. 얼마 안된 맥북에어 팔아요
        2. 맥북에어 팔아요
        3. 팝니다 맥북에어
        
테이블 : 게시글
제목 컬럼 : 제목
내용 컬럼 : 내용

SELECT *
FROM 게시글
WHERE 제목 LIKE '%맥북에어%'
   OR 내용 LIKE '%맥북에어%';

   제목     내용
   1        2
 TRUE  OR  TRUE TRUE
 TRUE  OR FALSE TRUE
 FALSE OR TRUE  TRUE
 FALSE OR FALSE FALSE
 
 제목     내용
   1        2
 TRUE  AND  TRUE TRUE
 TRUE  AND FALSE FALSE
 FALSE AND TRUE  FASLE
 FALSE AND FALSE FALSE

%:0개 이상의 문자  
_:1개의 문자

'%l%' - 문자열의 앞부분이 0개거나 l이라는 문자뒤에 여러개가 올수 있다. 

c???????
c% : c로 시작하는데 0개 이상의 문자가온다.
SELECT *
FROM users
WHERE userid LIKE 'c%';

userid가 c로 시작하면서 c이후에 3개의 글자가 오는 사용자
SELECT *
FROM users
WHERE userid LIKE 'c___';
--c뒤에 언더바 3개붙인것


userid에 l이 들어가는 모든 사용자 조회
SELECT *
FROM users
WHERE userid LIKE '%l%';

where4 실습)LIKE, %, _실습 
member 테이블에서 회원의 성이 [신] 씨인 사람의 mem_id , mem_name 을 조회하는 쿼리를 작성하세요
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

where5 실습)LIKE, %, _실습 
member테이블에서 회원의 이름에 글자 [이]가 들어가는 모든 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하세요
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';


IS, IS NOT (NULL 비교)
where6 실습)
emp 테이블에서 comm 컬럼의 값이 NULL인 사람만 조회
--NULL이라는 연산자는 is이라는것을 꼭 사용 = 동등연산자 사용 x
SELECT *
FROM emp
WHERE comm IS NOT NULL;
      sal = 1000
      sal != 100

emp 테이블에서 매니저가 없는 직원만 조회
SELECT *
FROM emp
WHERE MGR IS NULL;

BETWEEN AND, IN, LIKE, IS 

논리 연산자:  AND, OR, NOT 
AND : 두가지 조건을 동시에 만족시키는지 확인 할때
      조건1 AND 조건2
OR : 두가지 조건중 하나라도 만족 시키는지 확인할 때
     조건1 OR 조건2
NOT : 부정형 논리연산자, 특정 조건을 부정
   mgr IS NULL : mgr 컬럼의 값이 NULL인 사람만 조회
   mgr IS NOT NULL : mgr 컬럼의 값이 NULL이 아닌 사람만 조회 
   
emp 테이블에서 mgr의 사번이 7698이면서
sal 값이 1000보다 큰 직원만 조회
SELECT *
FROM emp
WHERE mgr = 7698 
  AND sal > 1000;
--조건의 순서는 결과와 무관하다 
SELECT *
FROM emp
WHERE sal > 1000   
  AND mgr = 7698;
  
AND 조건이 많아지면 : 조회되는 데이터 건수는 줄어든다
OR 조건이 많아지면 : 조회되는 데이터 건수는 많아진다.

NOT : 부정형 연산자, 다른 연산자와 결합하여 쓰인다.
     IS NOT, NOT IN, NOT LIKE 

--직원의 부서번호가 30번이 아닌 직원들      
SELECT *
FROM emp
WHERE deptno != 30;

SELECT *
FROM emp
WHERE deptno NOT IN (30);

NOT IN 연산자 사용시 주의점 : 비교값중에 NULL이 포함되면
                            데이터가 조회되지 않는다
                            
SELECT *
FROM emp
WHERE mgr IN (7698, 7839, NULL); 
==> 
  mgr = 7698 OR mgr = 7839 OR mgr = NULL

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL); 
 NOT !(mgr = 7698 OR mgr = 7839 OR mgr = NULL)
 ==> mgr != 7698 AND mgr !=7839 AND mgr != NULL (중요한개념)
            TRUE FALSE 의미가 없음 AND FALSE
            
 
 mgr = 7698 ==> mgr != 7698
 OR         ==> AND 
 
 where7 실습 ) OR, AND 실습
 emp테이블에서 job이 SALESMAN이고 입사일자가 1981년 6월 1일인 이후인 직원의 정보를 다음과 같이 조회하세요
 
 SELECT *
 FROM emp
 WHERE job = 'SALESMAN'
   AND hiredate > TO_DATE('1981/06/01', 'YYYY/MM/DD');
 
 where 8 실습) AND, OR
 emp 테이블에서 부서번호가 10번이 아니고 입사일지가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회 하세요
 (IN, NOT IN 연산자 사용금지)
 SELECT *
 FROM emp
 WHERE deptno != 10
   AND hiredate >= TO_DATE ('1981/06/01', 'YYYY/MM/DD');
 
where 9 실습  (NOT IN 연산자 사용)  
 SELECT *
 FROM emp
 WHERE deptno NOT IN ( 10 )
   AND hiredate >= TO_DATE ('1981/06/01', 'YYYY/MM/DD');

where 10 실습
emp테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인
직원의 정보를 다음과 같이 조회하세요
(부서는 10,20,30 만 있다고 가정하고 IN연산자를 사용)

SELECT *
FROM emp
WHERE deptno IN ( 20, 30 )
  AND hiredate >= TO_DATE ('1981/06/01', 'YYYY/MM/DD');
  
where 11 실습
emp 테이블에서 job이 SALESMAN이거나 입사일자가 1981년 6월 1일
이후인 직원의 정보를 다음과 같이 조회 하세요

SELECT *
FROM emp
WHERE job = 'SALESMAN' 
   OR hiredate >= TO_DATE ('1981/06/01', 'YYYY/MM/DD');

where 12 ) 
emp테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회하세요

SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%';
--empno는 숫자만 들어갈수 있음 문자열이 형변환된것 (문자열은 숫자를 포함하기 때문에)

과제 ) emp테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회하세요
(LIKE 연산자를 사용하지 않고 )

SELECT *
FROM emp
WHERE job = 'SALESMAN' 
   OR empno between 7800 AND 7899; 
   


