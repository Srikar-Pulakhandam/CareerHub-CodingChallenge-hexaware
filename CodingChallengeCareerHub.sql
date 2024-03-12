-- 1 & 4
create database if not exists CareerHub;
use CareerHub;

-- 2 , 3 , 4
create table if not exists Companies(
CompanyID int primary key,
CompanyName varchar(255) not null,
Location varchar(255) not null);

create table if not exists Jobs(
JobID int primary key,
CompanyID int,
JobTitle varchar(255) not null,
JobDescription text,
Salary decimal(10,2) not null,
JobType varchar(255) not null,
PostedDate datetime not null,
constraint Jobs_Fk foreign key(CompanyID) references Companies(CompanyID));

create table if not exists Applicants(
ApplicantID int primary key,
FirstName varchar(255) not null,
LastName varchar(255) not null,
Email varchar(255) not null,
Phone varchar(20) not null,
Resume text not null);

create table if not exists Applications(
ApplicationID int primary key,
JobID int,
ApplicantID int,
ApplicaitonDate datetime not null,
CoverLetter text,
constraint Applications_Job_Fk foreign key(JobID) references Jobs(JobID),
constraint Applications_Applicant_Fk foreign key(ApplicantID) references Applicants(ApplicantID));


insert into Companies values
(1101,'Hexaware','Chennai'),
(1102,'TCS','Hyderabad'),
(1103,'Salesforce','Bangalore'),
(1104,'Infosys','Pune'),
(1105,'Google','Mumbai'),
(1106,'Microsoft','Hyderabad'),
(1107,'Meta','Hyderabad'),
(1108,'Netflix','Chennai'),
(1109,'Apple','Bangalore'),
(1110,'AWS','Hderabad');


update Jobs set JobLocation='Bangalore' where JobID=2107;

insert into Jobs values
(2101,1102,'Systems Engineer','We are hiring a skilled systems engineer','Hyderabad',500000,'Full Time','2024-02-15'),
(2102,1104,'Software Developer','Hiring Java developers','Pune',310000,'Full Time','2023-12-30'),
(2103,1106,'Marketing Manager','Join our marketing team','Hyderabad',2800000,'Full Time','2024-03-01'),
(2104,1101,'Associate Software Engineer','Recruiting Associate Engineers','Chennai',400000,'Full Time','2023-12-20'),
(2105,1103,'Marketing Manager','Join our marketing team','Bangalore',1700000,'Full Time','2024-02-15'),
(2106,1109,'Research Intern','Join the R&D at Apple Inc.','Bangalore',900000,'Internship','2024-01-30'),
(2107,1110,'Summer Intern','Join the AWS office','Bangalore',1700000,'Internship','2024-03-10'),
(2108,1102,'Software Engineer','We are hiring a skilled software engineer','Hyderabad',1500000,'Part Time','2023-12-15')
(2109,1104,'Software Developer','Hiring Java developers',710000,'Full Time','2023-12-30','Hyderabad');


insert into Applicants values 
(3101,'Ram','Dev','ram12@example.in','7584211478','Resume'),
(3102,'Nayan','Kumar','nayan99@dummy.net','8745126975','My resume'),
(3103,'Narang','Russ','russiankid56@example.com','9412573698','Job Resume'),
(3104,'Deepak','Chauhan','deepch@nerd.co','6587412017','Ultimate Resume'),
(3105,'Swamy','Nathan','swanynath@company.in','9120140058','My Resume'),
(3106,'Guru','Nanak','nanakji@yahoo.com','7469855412','Resume_nanak'),
(3107,'Srivali','Devi','srivalli@example.com','8445736105','Sri_Resume'),
(3108,'Nalini','Chowdary','chnalini@outlook.com','9877417586','Nalini_updated_Resume'),
(3109,'Ram','Raj','raju19@gmail.com',9988774587,'MyResume21');

insert into Applications values (4101,2102,3102,'2024-01-10','Cover letter'),
(4102,2102,3104,'2024-02-04','CCL'),
(4103,2101,3105,'2024-01-16','Letter'),
(4104,2106,3108,'2024-02-07','Cover'),
(4105,2107,3102,'2024-03-11','My cover letter'),
(4106,2106,3101,'2024-02-14','Cover Letter 1'),
(4107,2104,3106,'2024-02-16','Cover'),
(4108,2101,3108,'2024-01-17','Letter22');
insert into applications (ApplicationId,JobID,ApplicantID,ApplicaitonDate)
values (4109,2105,3107,'2024-02-18'),
(4110,2101,3106,'2024-01-29'),
(4111,2107,3103,'2024-03-12');




-- 5
select j.JobTitle, count(A.ApplicationID) ApplicationCount from Jobs j
left join Applications A on j.JobID = A.JobID
group by j.JobID;

-- 6
set @MinSalary = 600000;
set @MaxSalary = 8000000;
select j.JobTitle, c.CompanyName, j.JobLocation, j.Salary from Jobs j
inner join Companies c on j.CompanyID = c.CompanyID
where j.Salary between @MinSalary and @MaxSalary;

-- 7
set  @ApplicantID = 3106;
select j.JobTitle, c.CompanyName, a.ApplicaitonDate from Applications a
inner join Jobs j on a.JobID = j.JobID
inner join Companies c on j.CompanyID = c.CompanyID where a.ApplicantID = @ApplicantID;

-- 8
select avg(salary) from jobs where salary<>0;

-- 9
select c.companyName,count(jobID) jobposts from Jobs j inner join Companies c on j.CompanyID=c.CompanyID group by j.CompanyID order by jobposts desc,c.companyID desc limit 1;

-- 10
select * from applicants;
alter table Applicants add Experience int;
update Applicants set Experience = 1 where ApplicantID =3107;

select distinct ap.FirstName, ap.LastName from Applicants ap
join Applications  on ap.ApplicantID = Applications.ApplicantID
join Jobs j on Applications.JobID = j.JobID
join Companies c on j.CompanyID = c.CompanyID
where c.location = 'Hyderabad' and ap.Experience >= 3;

-- 11 
select distinct(JobTitle) from jobs where salary between 600000 and 800000;

-- 12
select * from jobs where JobID not in (select distinct(JobID) from applications);

-- 13
SELECT a.applicantId,a.firstName,a.LastName,j.*,c.companyname from applicants a
join applications on a.applicantId=applications.applicantId
join jobs j on j.jobid=applications.jobid
join companies c on j.companyId=c.companyId
order by applicantId;

-- 14
select c.companyid,c.companyName,count(j.jobid) from companies c
join  jobs j on j.companyId = c.companyId group by c.companyID;

-- 15
select apl.*,c.CompanyName,j.JobTitle from applicants apl
left outer join applications aps on aps.applicantId = apl.applicantId
left outer join jobs j on j.jobid=aps.jobid
left outer join companies c on j.CompanyId=c.CompanyId;

-- 16
select c.*,j.salary from companies c join
jobs j on c.companyId=j.companyId
where j.salary > (select avg(salary) from jobs);

-- 17
select concat(Firstname,' ',LastName,' ',city,' ',state) from applicants;

-- 18
select distinct(jobtitle) from Jobs
where JobTitle like '%Developer%' or JobTitle like '%Engineer%';


-- 19
select  apl.FirstName, apl.LastName, j.JobTitle,j.jobId, c.CompanyName from Applicants apl
left outer join Applications aps ON apl.ApplicantID = aps.ApplicantID
left outer join Jobs j  ON Aps.JobID = J.JobID
left outer join Companies c ON j.CompanyID = c.CompanyID
union
select  apl.FirstName, apl.LastName, j.JobTitle,j.jobId, c.CompanyName  from Applicants apl
right outer join Applications aps on apl.ApplicantID = aps.ApplicantID
right outer join Jobs j  on Aps.JobID = J.JobID
right outer join Companies c on j.CompanyID = c.CompanyID;

-- 20
select apl.* , c.*from applicants apl
cross join companies c 
where c.Location = 'Bangalore, Karnataka' and apl.Experience_yrs >2;
