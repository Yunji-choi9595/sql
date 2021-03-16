--과제 ) emp테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회하세요
--(LIKE 연산자를 사용하지 않고 )
--data type 대해서 고민 

SELECT *
FROM emp
WHERE job = 'SALESMAN' 
   OR empno between 7800 AND 7899 
   OR empno between 780 AND 789
   OR empno = 78;
   
