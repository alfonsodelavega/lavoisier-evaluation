USE master;
go

IF EXISTS(select * from sys.databases where name='videoGames')
  DROP DATABASE videoGames;
go

create database videoGames;
go

-- Usar la base de datos creada
use videoGames;
go

create table [group] (
    id int primary key,
    name varchar(40),
    createdAt date
);
go

create table [user] (
    id int primary key,
    name varchar(40)
);
go

create table friend (
    user1 int references [user](id),
    user2 int references [user](id),
    primary key(user1, user2)
)

create table userGroup (
    userId int references [user](id),
    groupId int references [group](id),
    primary key(userId, groupId)
);
go

create table publisher (
    id int primary key,
    name varchar(40)
);
go

create table tag (
    name varchar(40) primary key
);
go

create table language (
    name varchar(40) primary key
);
go

create table videoGame (
    id int primary key,
    name varchar(40),
    price money,
    launchDate datetime,
    publisherId int references publisher(id)
);
go

create table gameTag (
    tag varchar(40) references tag(name),
    videoGameId int references videoGame(id),
    primary key (tag, videoGameId)
);
go

create table textLanguage (
    language varchar(40) references language(name),
    videoGameId int references videoGame(id),
    primary key (language, videoGameId)
);
go

create table voiceLanguage (
    language varchar(40) references language(name),
    videoGameId int references videoGame(id),
    primary key (language, videoGameId)
);
go

create table achievement (
    id int primary key,
    name varchar(40),
    description varchar(200),
    videoGameId int references videoGame(id),
);
go

create table achievementUnlocked (
    achievementId int references achievement(id),
    userId int references [user](id),
    videoGameId int references videoGame(id),
    primary key (achievementId, userId)
);
go

create table purchase (
    id int primary key,
    name varchar(40),
    userId int references [user](id)
);
go

create table purchaseLine (
    purchaseId int references purchase(id),
    videoGameId int references videoGame(id),
    name varchar(40),
    price money,
    primary key(purchaseId, videoGameId)
);
go
