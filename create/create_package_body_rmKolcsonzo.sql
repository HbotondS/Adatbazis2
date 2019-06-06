create or replace package body rmKolcsonzoPackage as
    -- Visszateritesi ertekek: 1 ha sikerult a torles, hanem 0
    function remove(pKId Kolcsonzo.KId%TYPE) return number
    is
    begin
        savepoint removeSavePoint;
        if (ellenorizKolcsonzo(pKId) = 0) then
            dbms_output.put_line('Nincs ilyen kolcsonzo: ' || pKId);
            return 0;
        end if;
        rmKolcsonzesek(pKId);
        rmKolcsonzo(pKId);

        commit;
        return 1;
    exception
        when others then
            -- Rollback a savepointra
            rollback to removeSavePoint;
            return 0;
    end remove;

    -- Ellenorzi, hogy letezik-e az adott kolcsonzo
    function ellenorizKolcsonzo(pKId Kolcsonzo.KId%TYPE) return number
    is
        lLetezikKolcsonzo number;
    begin
        select count(*) into lLetezikKolcsonzo from Kolcsonzo where KId = pKId;
        if lLetezikKolcsonzo > 0 then
            return 1;
        else
            return 0;
        end if;
    end ellenorizKolcsonzo;

    -- Letorli a kolcsonzo kolcsonzeseit
    procedure rmKolcsonzesek(pKId Kolcsonzo.KId%TYPE)
    is
    begin
        DELETE FROM KOLCSONZESEK WHERE KId = pKId;
        dbms_output.put_line('Letorolte a kolcsonzeseket: ' || pKId);
    end rmKolcsonzesek;

    -- Letorli a kolcsonzot
    procedure rmKolcsonzo(pKId Kolcsonzo.KId%TYPE)
    is
    begin
        DELETE FROM KOLCSONZO WHERE KId = pKId;
        dbms_output.put_line('Letorolte a kolcsonzot: ' || pKId);
    end;
end rmKolcsonzoPackage;
