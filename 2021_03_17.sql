연산자 우선순위 : AND -> OR
OR을 먼저하고싶으면 괄호로 우선순위지정

WHERE 조건1: 10건 일때
WHERE 조건1
  AND 조건2: 10건을 넘을 수 없음(왜냐하면 첫번째 조건이 10건이기때문에)
  
ex)
WHERE deptno = 10
  AND sal > 500;
  
table 객체의 특징: 순서가없다 -> 들어올때 순서가 없고 조회될때 순서가 없다.


ORDER BY
-
SELECT *
FROM emp
WHERE comm IS NOT NULL
  AND comm != 0
-- WHERE comm > 0 (0을 where절에 쓸수없기 때문에 논리적으로보면 똑같음)
ORDER BY comm DESC, empno DESC; 

* rownum , rownum 제약사항

인라인뷰: 쿼리를 괄호로 감싼거

페이징:
SELECT *
FROM 
(SELECT ROWNUM rn, empno, ename 
   FROM (SELECT empno, ename
           FROM emp
       ORDER BY ename))
WHERE rn BETWEEN (:page-1)*:pageSize +1 AND :page*:pageSize; --Size이런식으로 표기하는거: 낙타표기법 
--pageSize 지정해주고 page 지정해주기 (ex) pageSize 5, page 3 이런식으로 넣을때 공백 (엔터) 이런거 들어가면안됨)

ROWNUM 유의점: 
select -> order by 실행되기때문에 
select rownum 쓰고 바로 order by 출력해보면 뒤죽박죽으로 나옴

시험에 나오는거:
트랜잭션
NOT IN
페이징 

Fuction : 다 외우지 않아도 되지만, 이름을 보면 알수 있도록 한다. 
-Single row function
:단일행을 기준으로 작업하고, 행당 하나의 결과를 반환
:특정 컬럼의 문자열 길이: length(name)
:오라클에서 제공하는 함수가 있음 (내가만들수도 있는데 잘안씀)

-Multi row function
:여러행을 기준으로 작업하고, 하나의 결과를 반환
: 그룹함수 - count(행의건수를카운팅해줌), sum, avg 

(연습)
함수명을 보고
1. 파라미터가 어떤게 들어갈까?
2. 몇개의 파라미터가 들어갈까?
3. 반환되는 값은 무엇일까?

-Function
character 

-대소문자
입력값은 문자고, 반환되는 값 문자 
-LOWER : 인자가 소문자
-UPPER : 인자가 대문자 
-INITCAP : 첫글자를 대문자로 바꿔주는것(별로안씀)

SELECT * | {column | expression } 함수라는것도 expression의 한 종류 

SELECT ename, LOWER (ename), UPPER(ename), INITCAP (ename)
FROM emp;

--Single row 함수
SELECT ename, LOWER (ename), LOWER ('TEST')
FROM emp;

-charaction
-문자열조작
--CONCAT(연쇄) : 인자가 두개 , 반환: 결합된 문자열 하나
--***SUBSTR : SELECT SUBSTR(ename, 1, 3) -> ename을 1번째문자부터 3번째 문자까지 출력, (ename, 2) 하면 두번째문자부터출력
--length: 

--instr : 
--lpad |  rpad
--trim (공백제거)
--REPLAC : ename, 's' 't' 이라고 했을때 s-> t로 바뀜 

DUAL table
-sys계정에 있는 테이블
-누구나 사용 가능
-DUMMY 컬럼 하나만 존재하며 값은 'X'이며 데이터는 한 행만 존재

ex)
SELECT *
FROM dual;

사용용도
-데이터와 관련없이
-> 함수실행
-> 시퀀스 실행
-merge문에서
-데이터 복제시(connect by level)

(행의영향을 주는건 where절밖에없음)
SELECT LENGTH('TEST')
FROM dual;
--하나만 출력, 왜냐면 dual은 행 하나밖에 안가지고 있음

SINGLE ROW FUNCTION : WHERE 절에서도 사용 가능
emp 테이블에 등록된 직원들 중에 직원들 이름의 길이가 5글자를 초과하는 직원만 조회

SELECT *
FROM emp
WHERE LENGTH(ename) >5; -- multirow에서는 이게 불가능하다 

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith'; 
--권장하지 않는것, 왜냐면 ename 에 있는걸 모두다 소문자로 적용

SELECT *
FROM emp
WHERE ename = UPPER('smith'); 
--smith 를 대문자로 적용 (smith 는 상수이다)



ORACLE 문자열 함수

SELECT 'HELLO' || ',' || 'WORLD', 
       CONCAT('HELLO', CONCAT(',','WORLD')) CONCAT,
       SUBSTR('HELLO, WORLD', 1,5) SUBSTR,
       LENGTH('HELLO, WORLD') LENGTH,
       INSTR('HELLO, WORLD', 'O') INSTR,
       INSTR('HELLO, WORLD', 'O', 6) INSTR2,
       --('XX회사-개발본부-개발부-개발팀-개발파트')
       LPAD('HELLO, WORLD', 15, '-') LPAD,
       RPAD('HELLO, WORLD', 15, '-') RPAD,
       REPLACE('HELLO,WORLD', 'O','X') REPLACE,
       --TRIM -- 공백을 제거, 문자열의 앞고, 뒷부분에 있는 공백만 
       TRIM('    HELLO,WORLD   ') TRIM,
       TRIM('D' FROM 'HELLO,WORLD') TRIM
FROM dual;

Fuction
number 
-숫자조작
round : 반올림
trunc : 내림
mod : 나눗셈의 나머지

피제수, 제수 
java: 10%3 => 1;
SELECT MOD(10,3) --10이 피제수, 3이 제수
FROM dual;

SELECT
ROUND(105.54, 1)round1, --반올림 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째자리에서 반올림 : 105.5
ROUND(105.55, 1)round2, --반올림 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째자리에서 반올림 : 105.6
ROUND(105.55, 0)round3, --반올림 결과가 첫번째 자리까지 나오도록 : 소수점 첫째자리에서 반올림 : 106 --가장 많이 쓰는 형태
ROUND(105.55, -1)round4,--반올림 결과가 두번째 자리(십의자리)까지 나오도록 : 정수 첫째자리에서 반올림:110
ROUND(105.55) round5 : 106
FROM dual;

SELECT
TRUNC(105.54, 1)trunc1, --반올림 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째자리에서 절삭 : 105.5
TRUNC(105.55, 1)trunc2, --반올림 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째자리에서 절삭 : 105.5
TRUNC(105.55, 0)trunc3, --반올림 결과가 첫번째 자리까지 나오도록 : 소수점 첫째자리에서 절삭 : 105 --가장 많이쓰는 형태 
TRUNC(105.55, -1)trunc4, --반올림 결과가 두번째 자리(십의자리)까지 나오도록 : 정수 첫째자리에서 절삭 : 1000
TRUNC(105.55) trunc5 -- 소수점 첫째 자리에서 절삭 :105
FROM dual;

--이클립스에서 alt+shift+a 하면 한번에 바꿀수 있음 

--ex: 7499, ALLEN, 1600, 1, 600
SELECT empno, ename, sal, sal을 1000으로 나눴을때의 몫, sal을 1000으로 나눴을때의 나머지
FROM emp;

SELECT empno, ename, sal, TRUNC(sal/1000, 0) tr, MOD(sal,1000)
FROM emp;

날짜 <==> 문자
서버의 현재 시간 : SYSDATE
LENGTH('TEST')
SYSDATE 

SELECT SYSDATE
FROM dual;

SELECT SYSDATE + 1 -- 하루가 더해진다.
FROM dual;

SELECT SYSDATE, SYSDATE + 1/24/60
FROM dual;
--1초 추가
--도구-환경설정-데이터베이스-NIS-YYYY/MM/DD HH24:MI:SS 바꿔주기 

Fuction (date 실습 fn1)
1.2019년 12월 31일을 date 형으로 표현
SELECT TO_DATE('2019/12/31','YYYY/MM/DD')LASTDAY
FROM dual;
2.2019년 12월 31일을 date형으로 표현하고 5일 이전 날짜
SELECT TO_DATE('2019/12/31','YYYY/MM/DD')-5 LASTDAY_BEFORE5
FROM dual;
3.현재날짜
SELECT SYSDATE NOW
FROM dual;
4.현재 날짜에서 3일전 값
SELECT SYSDATE -3 NOW_BEFORE3
FROM dual;

문자를 날짜로 바꾸는것 : TO_DATE : 인자-문자, 문자의 형식
날짜를 문자로 바꾸는것  : TO_CHAR : 인자-날짜, 문자의 형식

--52~53
--0-일요일, 1-월요일, 2-화요일......6-토요일 

문자<=>날짜

날짜를 문자로 바꾸는것:
SELECT SYSDATE, TO_CHAR (SYSDATE, 'YYYY-MM-DD')
FROM dual

SELECT SYSDATE, TO_CHAR (SYSDATE, 'IW'),  TO_CHAR (SYSDATE, 'D') --IW는 주차, D는 요일 
FROM dual

date 
-Format (외우기)
YYYY: 4자리년도
MM: 2자리 월
DD : 2자리 일자
d : 주간일자(1~7)
IW : 주차(1~53)
HH, HH12 : 2자리 시간(12시간표현)
HH24: 2자리 시간(24시간 표현)
MI : 2자리 분
SS : 2자리 초 

과제: youtube에 grit  764만회 다음 동영상을 보고 느낀점
노마드 코더 : 누구나 코딩을 할수 있다? 보고 느낀점 

function (date 실습 fn2)
오늘 날짜를 다음과 같은 포맷으로 조회하는 쿼리를 작성하세요
1. 년 - 월 - 일
2. 년 - 월 - 일 시간(24) - 분 -초
3. 일 - 월 - 년
DT DASH
 DT_DASH_WITH_TIME,
 DT_DD_MM_YYYY
 
SELECT  TO_CHAR (SYSDATE, 'YYYY-MM-DD') ,
        TO_CHAR (SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
        TO_CHAR (SYSDATE, 'DD-MM-YYYY')
FROM dual;

TO_DATE (문자열, 문자열 포맷)
TO_DATE (TO_CHAR (SYSDATE, 'YYYY-MM-DD'), 'YYYY-MM-DD')

'2021-03-17' ==> '2021-03-17 12:41:00'
TO_CHAR (날짜, 포맷팅 문자열)
--아래 쿼리문 익숙해지기
SELECT TO_CHAR(TO_DATE('2021-03-17', 'YYYY-MM-DD'), 'YYYY-MM-DD HH24:MI:SS')
FROM dual;


SELECT SYSDATE, TO_DATE(TO_CHAR(SYSDATE -5, 'YYYYMMDD'), 'YYYYMMDD')
FROM dual;