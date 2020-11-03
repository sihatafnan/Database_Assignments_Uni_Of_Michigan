create table candidates ( cid int primary key,
name varchar(20) not null,
age int check ((age>=21) and (age<=100))
);

create table skills (
skill varchar(20) primary key
);

create table candidateSkills (
cid int references candidates(cid) not null,
skill varchar(20) references skills(skill) not null, proficiency int check ((proficiency>0) and (proficiency<=10)), constraint pk primary key (cid, skill)
);

create table openPositions ( pid int primary key,
employer varchar (20) not null, descr varchar(100) not null
);

create table positionRequirements (
pid int references openPositions(pid) not null, skill varchar(20) references skills(skill) not null
);

