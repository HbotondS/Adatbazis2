create or replace package body updateMufaj as
    function updateKonyvek(pMufajNev Mufajok.MufajNev%TYPE,
                           konyvIDs konyvekLista) return number
    is
        lMufajCount number;
        lMufajID Mufajok.MufajID%TYPE;
    begin
        savepoint updateSavePoint;

        select count(*) into lMufajCount from Mufajok where MufajNev = pMufajNev;
        if (lMufajCount = 0) then -- Ha nincs mar ilyen mufaj, beszurja
            insertMufaj(pMufajNev, lMufajID);
        end if;

        for i in 1..konyvIDs.count
            loop
                if (ellenorizKonyv(konyvIDs(i)) = 0) then
                    dbms_output.put_line('Nincs ilyen konyv: ' || konyvIDs(i));
                    return 0;
                else
                    update Konyvek
                    set Mufajok = Mufajok || ', ' || pMufajNev
                    where KonyvID = konyvIDs(i);
                end if;
            end loop;
        commit;
        return 1;

    exception
        when others then
            -- Rollback a savepointra
            rollback to updateSavePoint;
            return 0;
    end updateKonyvek;

    procedure insertMufaj(pMufajNev Mufajok.MufajNev%TYPE,
                          outMufajID out Mufajok.MufajID%TYPE)
    is
    begin
        insert into Mufajok
        values ((select max(MufajID) + 1 from Mufajok), pMufajNev) returning MufajID into outMufajID;
    end insertMufaj;

    function ellenorizKonyv(pKonyvID Konyvek.KonyvID%TYPE) return number
    is
        lLetezikKonyv number;
    begin
        select count(*) into lLetezikKonyv from Konyvek where KonyvID = pKonyvID;
        if lLetezikKonyv > 0 then
            return 1;
        else
            return 0;
        end if;
    end ellenorizKonyv;
end updateMufaj;
