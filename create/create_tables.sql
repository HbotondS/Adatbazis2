CREATE TABLE Mufajok
(
    MufajID  number(3) primary key,
    MufajNev varchar2(30)
);

CREATE TABLE Irok
(
    IroID    number(3) primary key,
    Inev     varchar2(20),
    ITelefon varchar2(10)
);

CREATE TABLE Konyvek
(
    KonyvID number(3) primary key,
    Kcim    varchar2(30),
    Kiado   varchar2(30),
    Iro     number(3) references Irok (IroID),
    ISBN    varchar2(13),
    Mufajok   varchar2(60),
    NapiAr  number(3, 1)
);

CREATE TABLE Kolcsonzo
(
    KID     number(3) primary key,
    Nev     varchar2(30),
    Cim     varchar2(30),
    Telefon varchar2(10)
);

CREATE TABLE Kolcsonzesek
(
    KID         number(3) references Kolcsonzo (KID),
    KonyvID     number(3) references Konyvek (KonyvID),
    DatumKi     date,
    DatumVissza date,
    Ertek       int,
    Primary key (KID, KonyvID, DatumKi)
);
