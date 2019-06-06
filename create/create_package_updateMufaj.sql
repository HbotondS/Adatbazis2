create type konyvekLista as table of number;
/

create or replace package updateMufaj as
    -- Beszur egy uj mufajt, ha meg nem letezik, es updateli a megadott konyveket
    -- Visszateritesi ertekek: 1 ha sikerult, hanem 0
    function updateKonyvek(pMufajNev Mufajok.MufajNev%TYPE,
                           konyvIDs konyvekLista) return number;

    -- Beszur egy uj mufajt
    procedure insertMufaj(pMufajNev Mufajok.MufajNev%TYPE,
                          outMufajID out Mufajok.MufajID%TYPE);

    -- Ellenorzi, hogy letezik-e az adott konyv
    function ellenorizKonyv(pKonyvID Konyvek.KonyvID%TYPE) return number;
end updateMufaj;
