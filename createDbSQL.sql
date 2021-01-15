drop table if exists pasageri cascade;
drop table if exists rezervari cascade;
drop table if exists bagaj cascade;
drop table if exists locuri cascade;
drop table if exists avion cascade;
drop table if exists zboruri cascade;
drop table if exists aeroport cascade;
drop table if exists locatii cascade;
drop table if exists discount cascade;
drop table if exists escale cascade;

create table pasageri (

idpasager smallint not null
	constraint pk_idpasager primary key
	constraint ck_idpasager check(idpasager>0),
nume varchar(50) not null 
	constraint ck_nume check(substr(nume,1,1) = upper(substr(nume,1,1))),
prenume varchar(50) not null 
	constraint ck_prenume check(substr(prenume,1,1) = upper(substr(prenume,1,1))),
tara varchar(50) not null 
	constraint ck_tarapasager check(substr(tara,1,1) = upper(substr(tara,1,1))),
buletinid varchar(10) not null unique,
dataexpbul date not null
	constraint ck_dataexp check (dataexpbul>= current_date),
adresafiz varchar(50) not null,
adresamail varchar(50)
	constraint ck_adresamail check(adresamail like '%_@__%.__%'),
numartelefon int not null
	constraint ck_numartelefon check(numartelefon>0)
);

create table bagaj (
idbagaj smallint not null
	constraint pk_idbagaj primary key
	constraint ck_idbagaj check(idbagaj>0),
numecategorie varchar(50) not null,
limitakg smallint not null
	constraint ck_limitakg check(limitakg>0)
);

create table avion (
idavion smallint not null
	constraint pk_idavion primary key
	constraint ck_idavion check(idavion>0),
numeavion varchar(50) not null,
taraproducator varchar(50)
);

create table locuri (
idloc smallint not null unique
	constraint ck_idloc check (idloc>0),
idavion smallint not null
	constraint fk_idavion_locuri references avion(idavion) on delete restrict on update cascade,
clasa varchar(50) not null,
numarloc smallint not null
	constraint ck_numarloc check (numarloc>0),
constraint pk_locuri primary key (idloc,idavion,clasa)
	
);

create table discount (
iddiscount smallint not null
	constraint pk_iddiscount primary key
	constraint ck_ididdiscount check(iddiscount>0),
numediscount varchar(50) not null,
procentereducere smallint not null
	constraint ck_discount check(procentereducere>0)
);

create table locatii (
idlocatie smallint not null
	constraint pk_idlocatie primary key
	constraint ck_idlocatie check(idlocatie>0),
numelocatie varchar(50) not null,
numeregiune varchar(50)
);

create table aeroport (
idaeroport smallint not null
	constraint pk_idaeroport primary key
	constraint ck_idaeroport check(idlocatie>0),
numeavion varchar(50) not null,
idlocatie smallint not null
	constraint fk_idlocatie_aeroport references locatii(idlocatie) on delete restrict on update cascade,
tipaeroport varchar(50)
);

create table zboruri (
idzbor smallint not null
	constraint pk_idzbor primary key
	constraint ck_idzbor check(idzbor>0),
companie varchar(50) not null,
idaeroportdepartare smallint not null
	constraint fk_idaeroportdecolare references aeroport(idaeroport) on delete restrict on update cascade,
idaeroportaterizare smallint not null
	constraint fk_idaeroportaterizare references aeroport(idaeroport) on delete restrict on update cascade,
idavion smallint not null
	constraint fk_idavion references avion(idavion) on delete restrict on update cascade,
tipzbor varchar(50) not null
);

create table escale(
idescala smallint not null
	constraint ck_idescala check(idescala>0)
	constraint fk_idescala references zboruri(idzbor),
companieintermed varchar(50),
idaeroportescala smallint not null
	constraint fk_idaeroportescala references aeroport(idaeroport) on delete restrict on update cascade,
constraint pk_escale primary key(idescala,companieintermed,idaeroportescala)
);

create table rezervari (
idrezervare smallint not null
	constraint pk_idrezervare primary key
	constraint ck_idrezervare check(idrezervare>0),
idpasager smallint not null
	constraint fk_idpasager_rezervari references pasageri(idpasager) on delete restrict on update cascade,
idzbor smallint not null
	constraint fk_idzbor_rezervari references zboruri(idzbor) on delete restrict on update cascade,
datazbor date not null
	constraint ck_datazbor check (datazbor>= current_date),
durata smallint not null
	constraint ck_durata check(durata>0),
idloc smallint not null
	constraint fk_idloc_rezervari references locuri(idloc) on delete restrict on update cascade,
idbagaj smallint not null
	constraint fk_idbagaj_rezervari references bagaj(idbagaj) on delete restrict on update cascade,
iddiscount smallint
	constraint fk_iddiscount_rezervari references discount(iddiscount) on delete restrict on update cascade
	
);
