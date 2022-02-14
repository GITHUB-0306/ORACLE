--CREATE TARGET TABLE
create table A(id number, name varchar2(50));

--CREATE SOURCE TABLE
create table B(id number, name varchar2(50));

insert into A values(1, 'Reshma');
insert into A values(2, 'Shraddha');
insert into A values(3, 'Aditi');
insert into A values(4, 'Athisha');

select * from A;
select * from B;
truncate table A;
truncate table B;

--INSERT DATA INTO TARGET TABLE FROM SOURCE TABLE
create or replace procedure DataLoading
as
begin
execute immediate 'insert into B (select * from A)';
end;

execute DataLoading;

--UPDATE DATA FROM TARGET TABLE
create or replace procedure DataUpdate
as
begin
update B set name ='Royston' where id = 2;
end;

execute DataUpdate;

select * from All_Tables where table_name='A';
select * from All_Tab_columns where table_name='A';       
select * from All_Constraints where table_name='EMP';
select * from All_Indexes where table_name='A';
select * from All_Ind_Columns where table_name='A';

--Is Minus operator same as left join? if it's then justify with practically.
select A.id, A.name from A
Left Join B
on A.id = B.id;

select B.id, B.name from B
Left Join A
on A.id = B.id;


select * from A
minus
select * from B;

select * from B
minus
select * from A;


--DATA LOADING USING MERGE STATEMENTS
MERGE INTO B as t1 
USING A as s1
ON (t1.id = s1.id)
WHEN MATCHED THEN
    update set t1.name = s1.name
WHEN NOT MATCHED THEN
    insert into (id, name) 
    values(s1.id, s1.name);
 
   
MERGE INTO B t1
USING (select * from A) s1
ON (s1.id = t1.id)
WHEN MATCHED THEN
UPDATE SET t1.name = s1.name
WHEN NOT MATCHED THEN
INSERT (t1.id, t1.name)
Values(s1.id, s1.name);


--FIND DUPLICATE RECORDS 
CREATE TABLE fruits (
        fruit_id   NUMBER ,
        fruit_name VARCHAR2(100),
        color VARCHAR2(20)
);

INSERT INTO fruits VALUES( 1, 'Apple','Red');
INSERT INTO fruits VALUES(2, 'Apple','Red');
INSERT INTO fruits VALUES(2, 'Apple','Red');
INSERT INTO fruits VALUES(3, 'Orange','Orange');
INSERT INTO fruits VALUES(4, 'Orange','Orange');
INSERT INTO fruits VALUES(5, 'Orange','Orange');
INSERT INTO fruits VALUES(6, 'Banana','Yellow');
INSERT INTO fruits VALUES(7, 'Banana','Green');
INSERT INTO fruits VALUES(7, 'Banana','Green');
INSERT INTO fruits VALUES(7, 'Banana','Green');

--select fruit_name, color, count(*) from fruits
--group by fruit_name, color
--
--SELECT f.*,
--    COUNT(*) OVER (PARTITION BY fruit_name, color) 
--FROM fruits f;
--
--select * from fruits
--truncate table fruits;
--
--select max(fruit_id), fruit_name, color
--from fruits group by
--fruit_name, color
--
----DELETE DUPLICATE RECORDS
--delete from fruits
--where fruit_id not in
--(select max(fruit_id)
--from fruits group by
--fruit_name, color

select * from fruits;

select rowid rid,
row_number() over(order by fruit_id) rn , fruit_id, fruit_name, color from fruits;

--select rowid rid,
select row_number() over(partition by fruit_id order by fruit_id) rn , fruit_id, fruit_name, color from fruits;
delete from fruits where rowid in
(
select  rid from
(
select  rowid rid,
row_number() over(partition by fruit_id order by fruit_id) rn , fruit_id, fruit_name, color from fruits
) 
where rn > 1
)
;

select rowid rid,row_number() over(partition by fruit_id order by fruit_id) rn, fruit_id, fruit_name, color from fruits;

delete from fruits 
where rowid in 
(
select rid, rn from
(
select rowid rid,
row_number() over(partition by fruit_id order by fruit_id) rn , fruit_id, fruit_name, color from fruits
) 
where rn > 1
);


--CREATION OF TABLE WITH AND WITHOUT DATA

create table emp(id number constraint e_id primary key, name varchar2(50) not null, 
email varchar2(80) constraint e_email unique, age number constraint e_age check(age > 25), dept_id integer, constraint e_dept foreign key(dept_id)
references dept(dept_id));

insert into emp values(1, 'abc', 'abc@gmail.com', 26, 1);
insert into emp values(2, 'abc', 'abc1@gmail.com', 26, 1);
insert into emp values(3, 'abc', 'abc2@gmail.com', 28, 2);
insert into emp values(4, 'abc', 'abc3@gmail.com', 35, 3);
insert into emp values(5, 'abc', 'abc4@gmail.com', 28, 2);
insert into emp values(6, 'abc', 'abc5@gmail.com', 29, 4);

create table copy_emp_with_data
as
select * from emp;

select * from emp;
select * from copy_emp_with_data;
select * from copy_emp_without_data;
select * from emp_without_data;

create table copy_emp_without_data
as
select * from emp where 1=0;

create table emp_without_data
as
select * from emp where 1=1;

--CREATE USER
create user USER_1 identified by 1234;
create user USER_2 identified by 1234;
--GRANT THE PRIVILLEGE
grant sysdba to shraddha;
grant sysdba to jward;
grant create to USER_1;
grant create session to USER_2;
grant all privileges to USER_2;
grant select on sys.All_Tables to shraddha;
grant select on sys.All_Tables to jward;

--DROP USER
DROP USER shraddha CASCADE;
DROP USER jward CASCADE;


--datefunction
select add_months(sysdate, 1) from dual;
select current_date from dual;
select current_timestamp  from dual;
select dbtimezone from dual;
select extract(month from date '1998-03-07') from dual;
SELECT FROM_TZ(TIMESTAMP '2000-03-28 08:00:00', '3:00') 
   FROM DUAL;
select last_day(sysdate) from dual;
select localtimestamp from dual;
select months_between('02-02-1995', '01-01-1995') from dual;
select new_time('11-10-99', 'PST', 'CST') from dual;
select next_day(sysdate, 'monday') from dual;
select  numtodsinterval(200, 'day') from dual;
select numtoyminterval(1, 'month') from dual;
select round(TO_DATE('01-01-1995'), 'year') from dual;
SELECT ROUND (TO_DATE ('27-OCT-00'),'YEAR')
   "New Year" FROM DUAL;
select sessiontimezone from dual;
SELECT SYS_EXTRACT_UTC(TIMESTAMP '2000-03-28 11:30:00.00 -08:00')
   FROM DUAL;
SELECT TO_TIMESTAMP ('10-Sep-02 14:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')
   FROM DUAL;
   SELECT CURRENT_DATE FROM dual;
set SERVEROUTPUT ON;

--DIFFERNCE BETWEEN TWO DATES
declare
date1 date;
date2 date;
date3 number;
begin
date1 := to_date('2022-01-18', 'YYYY-MM-DD');
date2 := to_date('2022-01-15', 'YYYY-MM-DD');
SELECT (date1 - date2)  into date3 FROM dual;
dbms_output.put_line(date3);
end;

SELECT 
to_date('2022-01-18', 'YYYY-MM-DD')-to_date('2022-01-15', 'YYYY-MM-DD') 
AS DiffDate from dual;
SELECT 
trunc(sysdate)-trunc(to_date('15-01-22')) 
AS DiffDate from dual;

--CREATE DEPT TABLE
create table dept(deptno number, dname  varchar2(20), constraint pk_dept primary key (deptno));

--INSERT THE RECORDS INTO DEPT TABLE
insert into dept
values(10, 'ACCOUNTING');
insert into dept
values(20, 'RESEARCH');
insert into dept
values(30, 'SALES');
insert into dept
values(40, 'OPERATIONS');

--CREATE EMPLOYEES TABLE 
create table employees(empno    number, ename  varchar2(20), job  varchar2(9), date_of_joining date,  salary number, deptno   number, constraint p_emp1 primary key (empno), constraint f_deptno1 foreign key (deptno) references dept (deptno));

--INSERT RECORDS INTO EMPLOYEES TABLE
insert into employees
values(
 7839, 'KING', 'PRESIDENT', to_date('12-4-2000', 'dd-mm-yyyy'), 50000, 10
);
insert into employees
values(
 7698, 'BLAKE', 'MANAGER', to_date('21-1-2000', 'dd-mm-yyyy'), 45000, 30
);
insert into employees
values(
 7782, 'CLARK', 'MANAGER',to_date('2-3-2000', 'dd-mm-yyyy'), 45000, 10
);
insert into employees
values(
 7566, 'JONES', 'MANAGER',to_date('2-4-2000', 'dd-mm-yyyy'), 45000, 20
);
insert into employees
values(
 7788, 'SCOTT', 'ANALYST',to_date('12-1-2000', 'dd-mm-yyyy'), 40000, 20
);
insert into employees
values(
 7902, 'FORD', 'ANALYST', to_date('5-4-2000', 'dd-mm-yyyy'), 43000, 20
);
insert into employees
values(
 7369, 'SMITH', 'CLERK',to_date('12-1-2000', 'dd-mm-yyyy'), 43000, 20
);
insert into employees
values(
 7499, 'ALLEN', 'SALESMAN', to_date('20-5-2000', 'dd-mm-yyyy'), 38000, 30
);
insert into employees
values(
 7521, 'WARD', 'SALESMAN',to_date('22-4-2000', 'dd-mm-yyyy'),  38000, 30
);
insert into employees
values(
 7654, 'MARTIN', 'SALESMAN',to_date('12-6-2000', 'dd-mm-yyyy'),  38000, 30
);
insert into employees
values(
 7844, 'TURNER', 'SALESMAN', to_date('12-12-2000', 'dd-mm-yyyy'), 37000, 30
);

--MONTHLY REPORTS PROCEDURE
create or replace procedure monthly_report(j_date in date)
as
begin
for i in (select ename, date_of_joining from employees where to_date(date_of_joining, 'dd-mm-yy') between trunc(to_date(j_date, 'dd-mm-yy')) and last_day(to_date(j_date, 'dd-mm-yy')))
loop
dbms_output.put_line(i.ename||' '||i.date_of_joining);
end loop;
end;

-------------------------------------------------------DATA_LOADING----------------------------------------------------------------------------
--ODS_TABLE
create table ODS_TAB_COLUMNS(COUNTRY CHAR(2), OWNER VARCHAR2(30) , TABLE_NAME   VARCHAR2(50), SYNONYM_NAME VARCHAR2(50)  , COLUMN_NAME VARCHAR2(30) ,
DATA_TYPE VARCHAR2(106) , DATA_LENGTH NUMBER, DATA_PRECISION NUMBER , COLUMN_ID NUMBER, PRIORITY NUMBER  , PK VARCHAR2(200)  , INCREMENTAL_KEY VARCHAR2(200) ,
SYSTEM  VARCHAR2(20) );
DESC ODS_TAB_COLUMNS;

--INSERT INTO ODS_TAB_COLUMNS
insert into ODS_TAB_COLUMNS (
COUNTRY ,OWNER  ,TABLE_NAME  ,SYNONYM_NAME ,COLUMN_NAME ,DATA_TYPE ,DATA_LENGTH,DATA_PRECISION ,COLUMN_ID ,PRIORITY ,PK ,INCREMENTAL_KEY ,SYSTEM)
select 'IN','DEMO',TABLE_NAME,TABLE_NAME, COLUMN_NAME,DATA_TYPE,DATA_LENGTH,DATA_PRECISION,COLUMN_ID,1,'','','LERNING' from all_tab_columns where table_name='EMPLOYEES' and owner='SYS';

--UPDATE PRIMARY KEY IN ODS_TAB_COLUMNS
UPDATE ODS_TAB_COLUMNS SET pk=COLUMN_NAME 
WHERE COLUMN_NAME IN ('EMPNO');

--CREATE ODS_LOADING_LOG TABLE
CREATE TABLE ODS_LOADING_LOG(BATCH_ID             NUMBER(5),     
                            JOB_ID               NUMBER(5),     
                            COUNTRY              VARCHAR2(2), 
                            BUSINESS_DATE        DATE,          
                            JOB_DESC             VARCHAR2(100) ,
                            START_DATE           DATE,          
                            END_DATE             DATE ,         
                            STATUS               VARCHAR2(50),  
                            SOURCE_COUNT         NUMBER(10),    
                            TARGET_COUNT         NUMBER(10),    
                            LOADING_STATUS       VARCHAR2(10),  
                            ERR_CODE             VARCHAR2(50),  
                            ERROR_DESC           VARCHAR2(200) );
                            
--CREATE SOURCE TABLE NUCSOFT
create table Nucsoft(empno number, ename  varchar2(20), deptName  varchar2(20), date_of_joining date,  salary number,  constraint pk_eno primary key (empno));
--CREATE TARGET TABLE
create table DevDept as select * from Nucsoft where 1=0

select * from dept;
insert into Nucsoft
values(
 100, 'PQR', 'SALES', to_date('2-6-2021', 'dd-mm-yyyy'), 31000
);
insert into Nucsoft
values(
 101, 'ABC', 'DEVELOPEMENT', to_date('12-4-2021', 'dd-mm-yyyy'), 28000
);
insert into Nucsoft
values(
 102, 'XYZ', 'RESEARCH', to_date('20-9-2021', 'dd-mm-yyyy'), 32000
);
insert into Nucsoft
values(
 103, 'LMN', 'SALES', to_date('2-9-2021', 'dd-mm-yyyy'), 30000
);
insert into Nucsoft
values(
 104, 'ABC', 'DEVELOPEMENT', to_date('9-9-2021', 'dd-mm-yyyy'), 31000
);
insert into Nucsoft
values(
 105, 'XYZ', 'RESEARCH', to_date('2-6-2000', 'dd-mm-yyyy'), 25000
);
insert into Nucsoft
values(
 106, 'AAA', 'DEVELOPEMENT', to_date('12-1-2021', 'dd-mm-yyyy'), 28000
);
insert into Nucsoft
values(
 107, 'BBB', 'SALES', to_date('20-6-2021', 'dd-mm-yyyy'), 31000
);
insert into Nucsoft
values(
 108, 'LMN', 'RESEARCH', to_date('12-4-2021', 'dd-mm-yyyy'), 29000
);
insert into Nucsoft
values(
 109, 'PQR', 'DEVELOPEMENT', to_date('5-3-2021', 'dd-mm-yyyy'), 31000
);


SELECT * FROM Nucsoft;
SELECT * FROM DevDept;
                            
--DYNAMIC SQL (USING EXECUTE IMMEDIATE)
declare
dname VARCHAR2(20):= 'SALES';
sqlstr VARCHAR2(4000) ;
sqlstr1 VARCHAR2(4000) ;
begin
sqlstr :=  'select salary from Nucsoft  where deptName = '''||dname||''' AND ENAME = ''PQR''';
--dbms_output.put_line(1);
execute immediate sqlstr INTO sqlstr1;
dbms_output.put_line(sqlstr1);
end;

declare
begin
execute immediate 'update Nucsoft set salary = (salary+1000) where deptName = ''SALES''';
end;

----------------------------------------------------------------SCHEDULER-------------------------------------------------------------------
create or replace procedure Proc_Tran_Nuc_Dev
as
dname varchar2(20):= 'DEVELOPEMENT';
begin
execute immediate 'insert into DevDept select * from Nucsoft where deptName = '''||dname||'''';
end;


begin
dbms_scheduler.create_job(job_name => 'Tran_Nuc_Dev',
job_type => 'STORED_PROCEDURE',
job_action => 'Proc_Tran_Nuc_Dev',
start_date => '24-JAN-2022 11:00:00 AM',
repeat_interval => 'freq=daily' ,
enabled => true);
end;

--MANUALLY EXECUTE JOB
BEGIN
  DBMS_SCHEDULER.run_job (job_name => 'J_SALARY_UPDATION');
END;

--DROP JOB
BEGIN
  DBMS_SCHEDULER.drop_job (job_name=>'J_SALARY_UPDATION'
--  force => TRUE
--  defer => True
);
END;

--DROP PROGRAM
BEGIN
  DBMS_SCHEDULER.drop_program(program_name=>'P_SALARY_UPDATION');
END;

--DROP SCHEDULE
BEGIN
  DBMS_SCHEDULER.drop_schedule (schedule_name =>'DAILY_SCHEDULE');
END;

--DROP PROGRAM ARGUMENTS
BEGIN
PROCEDURE drop_program_argument (
  program_name            => 'P_SALARY_UPDTION',
  argument_position       => 1);
END;

SELECT * FROM dba_scheduler_job_log where JOB_NAME='TRAN_NUC_DEV' ;
SELECT owner, program_name, enabled FROM dba_scheduler_programs where program_name like '&enter_program_name';

------------------------------------------------------------CREATE PROGRAM, SCHEDULE, JOB SEPARATALY----------------------------------------
--CREATE PROCEDURE
create or replace procedure data_updation( sal number)
as
sqlstmt varchar2(4000);
sqlstmt2 varchar2(4000);
salary number;
begin
salary := sal;
execute immediate 'update nucsoft set salary = (salary + '||sal||') where empno = 100';
end;

--CREATE PROGRAM
begin
dbms_scheduler.create_program(
program_name   => 'P_SALARY_UPDATION',
program_type   => 'STORED_PROCEDURE',
program_action => 'data_updation',
number_of_arguments  => 1,
   enabled              => FALSE,
comments             =>  'PROGRAM FOR SALARY UPDATION'
);

-- DEFINE PROGRAM ARGUMENTS
DBMS_SCHEDULER.DEFINE_PROGRAM_ARGUMENT (
   program_name            => 'P_SALARY_UPDATION',
   argument_position       => 1,
   argument_name           => 'SAL',
   argument_type           => 'NUMBER',
   default_value           => 100);
   
   dbms_scheduler.enable('P_SALARY_UPDATION');  
   
--CREATE SCHEDULE   
DBMS_SCHEDULER.create_schedule (
  schedule_name => 'DAILY_SCHEDULE',
  start_date => '04-FEB-2022 12:00:00 AM',
  repeat_interval => 'freq=DAILY; byminute=0',
  end_date => NULL,
  comments => 'RUN EVERY DAY AT 12AM');

--CREATE JOB
DBMS_SCHEDULER.create_job (
  job_name => 'J_SALARY_UPDATION',
  program_name => 'P_SALARY_UPDATION',
  schedule_name => 'DAILY_SCHEDULE',
  enabled => TRUE,
  comments => 'JOB FOR SALARY UPDATION');
END;

---------------------------------------------------------------------CHAIN----------------------------------------------------------------------

CREATE TABLE EMP (empid number primary key, ename varchar2(40), date_of_joining date, salary number);

--CREATE PROCEDURE
create or replace procedure P_INSERT_RECORDS
AS
BEGIN
INSERT INTO EMP VALUES(101, 'abc', '24-04-2020', 32000 );
END;


create or replace procedure P_UPDATE_RECORDS
AS
BEGIN
UPDATE EMP SET SALARY = (SALARY+1000) WHERE EMPID = 101;
END;

--first program
BEGIN
dbms_scheduler.create_program(
program_name   => 'P_FIRST_PROGRAM',
program_type   => 'STORED_PROCEDURE',
program_action => 'P_INSERT_RECORDS',
enabled => TRUE,
comments => 'Program for first link in the chain.');
END;

--SECOND PROGRAM
BEGIN
dbms_scheduler.create_program(
program_name   => 'P_SECOND_PROGRAM',
program_type   => 'STORED_PROCEDURE',
program_action => 'P_UPDATE_RECORDS',
enabled => TRUE,
comments => 'Program for second link in the chain.');
END;

--create chain
BEGIN
DBMS_SCHEDULER.create_chain (
    chain_name => 'chain_1',
    rule_set_name => NULL,
    evaluation_interval => NULL);
END;

--define chain step
BEGIN
DBMS_SCHEDULER.define_chain_step (
    chain_name => 'chain_1', 
    step_name => 'chain_step_1', 
    program_name => 'P_FIRST_PROGRAM');

  DBMS_SCHEDULER.define_chain_step (
    chain_name => 'chain_1',
    step_name => 'chain_step_2',
    program_name => 'P_SECOND_PROGRAM');
END;

--DEFINE STEP RULES
BEGIN
DBMS_SCHEDULER.define_chain_rule (
    chain_name => 'chain_1',
    condition => 'TRUE',
    action => 'START "CHAIN_STEP_1"',
    rule_name => 'chain_rule_1',
    comments => 'First link in the chain.');

  DBMS_SCHEDULER.define_chain_rule (
    chain_name => 'chain_1',
    condition => '"CHAIN_STEP_1" COMPLETED',
    action => 'START "CHAIN_STEP_2"',
    rule_name => 'chain_rule_2',
    comments => 'second link in the chain.');

  DBMS_SCHEDULER.define_chain_rule (
    chain_name => 'chain_1',
    condition => '"CHAIN_STEP_2" COMPLETED',
    action => 'END',
    rule_name => 'chain_rule_3',
    comments => 'End of the chain.');
END; 

BEGIN
  DBMS_SCHEDULER.enable ('chain_1');
END;

--Add chain to job
BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
    job_name => 'chain_1_job',
    job_type => 'CHAIN',
    job_action => 'chain_1',
    repeat_interval => 'freq = daily; interval = 2',
    start_date => '07-FEB-2022 2:49:00 PM',
    enabled => FALSE);
END;

BEGIN
 DBMS_SCHEDULER.ENABLE('chain_1_job');
 END;
select * from ODS_TAB_COLUMNS;

 select * from DBA_SCHEDULER_CHAINS;
select * from dba_scheduler_jobs;

-----------------------------------------AS_XLSX PACKAGE--------------------------------------------------------------

--CREATE DIRECTORY
CREATE DIRECTORY  RESHMA2_DIR AS 'C:\Users\3255\Desktop\sqldeveloper';

grant execute on utl_file to RESHMA;
GRANT READ, WRITE, EXECUTE ON directory RESHMA2_DIR TO RESHMA;

--CHECK ALL_DIRECTORY
select * from all_directories
where  directory_name = 'RESHMA1_DIR';

select * from all_tab_privs
where  table_name = 'RESHMA1_DIR'
and    grantee = user
and    privilege = 'WRITE';