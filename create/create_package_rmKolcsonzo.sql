create or replace package rmKolcsonzoPackage as
    -- Visszateritesi ertekek: 1 ha sikerult a torles, hanem 0
    function remove(pKId Kolcsonzo.KId%TYPE) return number;

    -- Ellenorzi, hogy letezik-e az adott kolcsonzo
    function ellenorizKolcsonzo(pKId Kolcsonzo.KId%TYPE) return number;

    -- Letorli a kolcsonzo kolcsonzeseit
    procedure rmKolcsonzesek(pKId Kolcsonzo.KId%TYPE);

    -- Letorli a kolcsonzot
    procedure rmKolcsonzo(pKId Kolcsonzo.KId%TYPE);
end rmKolcsonzoPackage;