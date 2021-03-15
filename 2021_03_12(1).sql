kk계정에 있는 prod 테이블의 모든 컬럼을 조회하는 SELECT 쿼리 (SQL) 작성
SELECT *
FROM prod;

kk계정에 있는 prod 테이블의 prod_id, prod_name 두개의 컬럼만 조회하는 SELECT 쿼리 (SQL) 작성
SELECT prod_id, prod_name
FROM prod;

--//prod mane 라고 썼을때 ORA-000904 라고 나오면 오라클에서 정한 에러코드
--//잘못된 식별자 에러코드 (인식을 할수 없다) FROM절에 테이블 아니면 뷰가 올수있음 
--컬럼에 문제가 생겼을때, 테이블에 문제가 생겼을때 에러메세지를 보고 해석해라 

SELECT (실습 select1)

-LPROD 테이블에서 모든 데이터를 조회하는 쿼리를 작성
SELECT *
FROM LPROD;

-buyer테이블에서 buyer_id, buyer_name 컬럼만 조회하는 쿼리를 작성
SELECT buyer_id, buyer_name
FROM buyer;

-cart 테이블에서 모든 데이터를 조회하는 쿼리 작성
SELECT *
FROM cart; 

-memeber 테이블에서 mem_id, mem_pass, mem_name 컬럼만 조회하는 쿼리를 작성
SELECT mem_id, mem_pass, mem_name
FROM member; 

컬럼 정보를 보는 방법
1. SELECT *  ==> 컬럼의 이름을 알 수 있다. 
2. sql DEVELOPER의 테이블 객체를 클릭하여 정보확인 (NUMBER 숫자 NUMBER(4,0) 전체길이는 4자리고 소숫점은 0자리까지 올수 있다) 
VARCHAR2 (문자열) 10byte라고 되어있으면 10바이트까지 담을수있다 , 
숫자, 날짜에서 사용가능한 연산자
일반적인 사칙연산 +-/*, 우선순위 연산자()
3.DESC 테이블명; //DESCRIBE 설명하다 

SELECT *
FROM emp; 

DESC emp; 


 숫자는 number 날짜 date 문자 varchar2(db에서 기억해야할것)

empno: number ;
empno + 10 ==> expression
(정확하게 각각 10의값이 더해짐 자바에서 a= a+10 하는 의미와 같음)
(hiredate + 10하면 그 날짜에서 일수가 10더해짐)

SELECT empno empno, empno + 10 AS empno_plus
FROM emp; 

SELECT empno "emp no", empno + 10 AS empno_plus
FROM emp; 

NULL: 아직 모르는 값 
0과 공백은 NULL과 다르다
***NULL을 포함한 연산은 결과가 항상 NULL****
==> NULL값을 다른 값으로 치환해주는 함수 

SELECT ename, sal, comm, sal+comm, comm+ 100
FROM emp; 



SELECT empno, emp_number, empno+ 10 emp_plus, 10,
       hiredate, hiredate - 10
FROM emp;



column alias (실습 select2)
-prod 테이블에서 prod_id, prod_name 두 컬럼을 조회하는 쿼리를 작성하시오
(단 prod_id -> id, prod_name-> name 으로 컬럼 별칭을 지정)

SELECT prod_id "id", prod_name AS "name"
FROM prod;

-lprod 테이블에서 lprod_gu, lprod_nm 두컬럼을 조회하는 쿼리를 작성하시오
(단 lprod_gu-> gu, lprod_nm-> nm으로 컬럼 별칭을 지정)

SELECT lprod_gu gu, lprod_nm AS nm
FROM lprod;

더블쿼테이션 쓰면 소문자로도 저장이 됨 
근데 안쓰면 무조건 대문자로 

-buyer테이블에서 buyer_id, buyer_name 두 컬럼을 조회하는 쿼리를 작성하시오
(단 buyer_id-> 바이어아이디, buyer_name->이름으로 컬럼 별칭을 지정 

SELECT buyer_id "바이어아이디", buyer_name AS "이름"
FROM buyer; 

더블쿼테이션안써도 됨! 

literal :값 자체
literal 표기법: 값을 표현하는 방법 
java 정수 값을 어떻게 표현할까 (10) ?
int a = 10;
float f = 10f;
long l = 10L;
String s = "Hello World;"


* | (컬럼 | 표현식 [AS] [ALIAS], .... }
언어마다 리터럴을 표현하는 방법이 다르다
SELECT empno, 10, 'Hello World'
FROM emp; 

문자열 연산 
java : String msg = "Hello" + ", World";

SELECT empno+ 10, ename || ',World',
       CONCAT(ename, ', World')
       
--  결합할 두개의 문자열을 입력받아 결합하고 결합된 문자열을 반환 해준다        
--    //결합할수 있는방법, 수직바 두개 아니면 concat 쓰면 됨
--    //empno+ 10 , ename || 'Hello' ||', World', (이런식으로는 쓸수있음)

       
FROM emp;

DESC emp;

SELECT *
FROM users;

아이디: brown 
아이디: apeach

SELECT '아이디 :' || userid,
       CONCAT ('아이디: ', userid)
FROM users;

--user_tables 오라클이 내부적으로 관리하는 테이블, 해당 사용자가 가지고있는 테이블 목록을 뜻함 
--concat은 두개의 문자열밖에 반환못하기때문
CONCAT (문자열1, 문자열2, 문자열3)
--> CONCAT (문자열1과 문자열2가 결합된 문자열, 문자열3)
   ---> CONCAT(CONCAT(문자열1, 문자열2), 문자열3)


중간과제 ) 세개의 문자열 결합, SELECT * FROM BONUS; 이런식으로 출력될수 있도록 만드시오
SELECT 'SELECT * FROM ' || table_name || ';',
       CONCAT(CONCAT('SELECT * FROM ',table_name), ';'),
       CONCAT('SELECT * FROM ' || table_name, ';')
FROM user_tables;

--부서번호가 10인 직원들만 조회
--부서번호: deptno
SELECT *
FROM emp
WHERE deptno = 10;

--users 테이블에서 userid 컬럼의 값이 brown인 사용자만 조회
***SQL 키워드는 대소문자를 가리지 않지만 데이터 값은 대소문자를 가린다. 

SELECT *
FROM users
WHERE userid = 'brown';

--emp테이블에서 부서번호가 20번보다 큰 부서에 속한 직원 조회
SELECT *
FROM emp
WHERE deptno >20; 

--emp테이블에서 부서번호가 20번 부서에 속하지 않은 모든 직원 조회 
SELECT *
FROM emp
WHERE deptno != 20;

WHERE : 기술한 조건을 참(true)으로 만족하는 행들만 조회한다. (FILTER)

SELECT *
FROM emp
WHERE 1=1;

//WHERE 1=1 했을대 14건이 나옴 왜냐면 조건이 참이기 때문에 전체결과가 나오는것 반면에 1=2 하면 결과값이 나오지 않음 결과가 참이 아니기때문에

SELECT empno, ename, hiredate
FROM emp
WHERE hiredate >= '81/03/01'; 81년 3월 1일 날짜 값을 표기하는 방법 
yyyy-mm-dd
mm/dd/yy

문자열을 날짜 타입으로 변환하는 방법
TO_DATE(날짜 문자열, 날짜 문자열의 포맷팅)
TO_DATE('1981/03/01','YYYY/MM/DD') 
날짜 표현할땐 이런식으로 꼭 쓰기 
년도쓸때는 항상 네자릿수로 표현하기 

SELECT empno, ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1981/03/01', 'YYYY/MM/DD'); 


