
select numeregiune,count(numeaeroport)
from aeroport natural join locatii
group by numeregiune


select numeavion,count(*) from avion
natural join zboruri
group by numeavion
having count(*) > (select count(*) from avion
				  natural join zboruri
				  where numeavion='Airbus A330')


with numeavion as ( select numeavion as NumeAvion from avion),
	Zbor1 as(select datazbor,numeavion from (select numeavion, datazbor,row_number() over(partition by numeavion order by datazbor) numar
				from avion
				natural join zboruri natural join rezervari
				order by datazbor)t
			   	where numar = 1),
	Zbor2 as(select datazbor,numeavion as navion2 from (select numeavion, datazbor,row_number() over(partition by numeavion order by datazbor) numar
				from avion
				natural join zboruri natural join rezervari
				order by datazbor)t
			   	where numar = 2),
	Zbor3 as(select datazbor,numeavion as navion3 from (select numeavion, datazbor,row_number() over(partition by numeavion order by datazbor) numar
				from avion
				natural join zboruri natural join rezervari
				order by datazbor)t
			   	where numar = 3)
	select numeavion.numeavion as NumeAvion,Zbor1.datazbor as Zbor1,Zbor2.datazbor as zbor2,Zbor3.datazbor as zbor3 from numeavion
	inner join Zbor1 on numeavion.numeavion=Zbor1.numeavion
	left join Zbor2 on numeavion.numeavion=Zbor2.navion2
	left join Zbor3 on numeavion.numeavion=Zbor3.navion3




with recursive Concatenare AS
(
    SELECT 
        ID, 
        CAST(Name AS varchar(100)) AS ListaOrase, 
        Name, 
        OrdineNume, 
        MarcaRegiune 
    FROM separat
    WHERE OrdineNume = 1

    UNION ALL

    SELECT 
        s.ID, 
        CAST(C.ListaOrase || ', ' || s.Name AS varchar(100)), 
        s.Name, 
        s.OrdineNume, 
        s.MarcaRegiune
    FROM Separat AS s
        INNER JOIN Concatenare AS C 
                ON s.MarcaRegiune = C.MarcaRegiune
                AND s.OrdineNume = C.OrdineNume + 1
),
Separat AS
(
    SELECT 
        idlocatie as ID,
        numelocatie as Name,
        ROW_NUMBER() OVER (PARTITION BY numeregiune ORDER BY numelocatie) AS OrdineNume,
        COUNT(*) OVER (PARTITION BY numeregiune) AS MarcaRegiune
    FROM locatii
)
SELECT 
    ID,
    ListaOrase
FROM Concatenare
WHERE OrdineNume = MarcaRegiune
