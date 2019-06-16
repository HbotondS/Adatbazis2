create or replace package body kolcsonozPackage as
    -- Elvegez egy kolcsonzest az elejetol a vegeig
    function kolcsonoz(pKonyvID Konyvek.KonyvId%TYPE,
                       pKolcsonzoNev Kolcsonzo.Nev%TYPE,
                       pKCim Kolcsonzo.Cim%TYPE,
                       pKTel Kolcsonzo.Telefon%TYPE,
                       pDatumKi Kolcsonzesek.DatumKi%TYPE,
                       pDatumVissza Kolcsonzesek.DatumVissza%TYPE) return number
    is
        lKolcsonzoCount number;
        lKolcsonzoId kolcsonzo.KId%TYPE;
        type tKonyvIdk is table of Konyvek.KonyvId%TYPE;
        lKonyvIdk tKonyvIdk;
        lSzabadKonyvek int;
    begin
        select count(*) into lKolcsonzoCount from Kolcsonzo where nev = pKolcsonzoNev;
        if (lKolcsonzoCount = 0) then -- Ha nincs mar ilyen kliens, beszurja
            beszurKolcsonzo(pKolcsonzoNev, pKCim, pKTel, lKolcsonzoId);
        else -- Ha mar van, akkor lekeri az ID-jat
            select kid into lKolcsonzoId from kolcsonzo where nev = pKolcsonzoNev;
        end if;
        -- Kivalaszt egy szabad Konyvet
        select szabadKonyvek(pKonyvId, pDatumKi, pDatumVissza) into lSzabadKonyvek from dual;
        if (lSzabadKonyvek = -1) then -- Nincs szabad Konyv
        -- Keres hasonlo konyvet
            dbms_output.put_line('Nincs szabad konyv!');
            select KonyvId bulk collect into lKonyvIdk
            from Konyvek
            where mufajId = (select mufajId from Konyvek where KonyvId = pKonyvId)
              AND KonyvId != pKonyvId;
            if (lKonyvIdk.count = 0) then
                dbms_output.put_line('Nincs hasonlo mufaju könyv.');
                return 2;
            end if;
            for i in 1 .. lKonyvIdk.count
                loop
                    lSzabadKonyvek := szabadKonyvek(lKonyvIdk(i), pDatumKi, pDatumVissza);
                    if (lSzabadKonyvek != -1) then
                        dbms_output.put_line('Kapott hasonlo mufaju könyvet.');
                        dbms_output.put_line(lSzabadKonyvek);
                        return -1;
                    end if;
                end loop;
        else
            kolcsonozPackage.beszurKolcsonzes(lKolcsonzoId, lSzabadKonyvek, pDatumKi, pDatumVissza);
            dbms_output.put_line('Sikerult kolcsonozni');
            return 0;
        end if;
    end kolcsonoz;

    -- Megnezi, hogy ket datumintervallum metszi-e egymast. 1 ha igen, 0 ha nem.
    function datumMetszet(pElsoKezd Kolcsonzesek.DatumKi%TYPE,
                          pElsoVeg Kolcsonzesek.DatumVissza%TYPE,
                          pMasodikKezd Kolcsonzesek.DatumKi%TYPE,
                          pMasodikVeg Kolcsonzesek.DatumVissza%TYPE) return number
    is
    begin
        if pElsoKezd <= pMasodikVeg AND pMasodikKezd <= pElsoVeg then
            return 1; -- metszi
        else
            return 0; -- nem metszi
        end if;
    end datumMetszet;

    -- Visszaterit egy szabad könyvet, amin rajta van az adott könyv és nincs kikolcsonozve az adott periodusban
    function szabadKonyvek(pKonyvId Konyvek.KonyvId%TYPE,
                           pDatumKi Kolcsonzesek.DatumKi%TYPE,
                           pDatumVissza Kolcsonzesek.DatumVissza%TYPE) return number
    is
        type tKonyvId is table of Konyvek.KonyvId%TYPE;
        lSzabadKonyvek tKonyvId;
    begin
        select KonyvId bulk collect into lSzabadKonyvek
        from (
                 select KonyvId
                 from Konyvek
                 minus
                 select KonyvId
                 from kolcsonzesek k
                 where kolcsonozPackage.datumMetszet(k.datumki, k.datumvissza, pDatumKi, pDatumVissza) = 1);
        if (lSzabadKonyvek.count = 0) then
            return -1;
        else
            return lSzabadKonyvek(1);
        end if;
    end szabadKonyvek;

    -- Beszur egy Kolcsonzot a Kolcsonzo tablaba
    procedure beszurKolcsonzo(pNev Kolcsonzo.Nev%TYPE,
                              pCim Kolcsonzo.Cim%TYPE,
                              pTelefon Kolcsonzo.Telefon%TYPE,
                              outKId out Kolcsonzo.Kid%TYPE)
    is
    begin
        insert into kolcsonzo
        values ((select max(KId) + 1 from kolcsonzo), pNev, pCim, pTelefon) returning Kid into outKId;
    end;

    -- Beszur egy kolcsonzest
    procedure beszurKolcsonzes(pKId Kolcsonzo.Kid%TYPE,
                               pKonyvId Konyvek.KonyvId%TYPE,
                               pDatumKi Kolcsonzesek.DatumKi%TYPE,
                               pDatumVissza Kolcsonzesek.DatumVissza%TYPE)
    is
        lErtek Kolcsonzesek.Ertek%TYPE;
    begin
        select (pDatumVissza - pDatumKi) * NapiAr into lErtek from Konyvek where Konyvid = pKonyvId;
        insert into kolcsonzesek values (pKId, pKonyvId, pDatumKi, pDatumVissza, lErtek);
        dbms_output.put_line('Sikeresen beszurt a kolcsonzes tablaba');
    end beszurKolcsonzes;

    -- Kiirja a kovetkezo konyvet, ha letezik
    procedure nextKonyv(pKid Kolcsonzo.Kid%TYPE) 
    is
        vKonyvCount number;
        vNextKNev varchar2(30);
    begin
        -- ellenorzi hogy a megadott id utan van-e sor az adatbazisban
        -- ha nincs hibaval kilep
        select count(*) into vKonyvCount from konyvek where KonyvID = (pKid + 1);
        if (vKonyvCount = 0) then 
            RAISE_APPLICATION_ERROR(-20000, 'nincs ilyen konyv');
        end if;

        -- lekri a kovetkezo konyvet es kiirja
        select Kcim into vNextKNev from konyvek where KonyvId = (pKid + 1);
        dbms_output.put_line(vNextKNev);
    end nextKonyv;
end kolcsonozPackage;
