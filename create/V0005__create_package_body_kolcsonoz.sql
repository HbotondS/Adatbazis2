create or replace package body kolcsonozPackage as
  --Elvegez egy kolcsonzest az elejetol a vegeig
  function kolcsonoz(
    pKonyvID Konyvek.KonyvId%TYPE,
    pKolcsonzoNev Kolcsonzo.Nev%TYPE,
    pKCim Kolcsonzo.Cim%TYPE,
    pKTel Kolcsonzo.Telefon%TYPE,
    pDatumKi Kolcsonzesek.DatumKi%TYPE,
    pDatumVissza Kolcsonzesek.DatumVissza%TYPE
  ) return number
  is
    lKolcsonzoCount number;
    lKolcsonzoId kolcsonzo.KId%TYPE;
    type tKonyvIdk is table of Konyvek.KonyvId%TYPE;
    lKonyvIdk tKonyvIdk;
    lSzabadKonyvek int;
  begin
    -- Savepoint letrehozasa
    
    set TRANSACTION isolation level read committed;
    select count(*) into lKolcsonzoCount from Kolcsonzo where nev = pKolcsonzoNev;
    if (lKolcsonzoCount = 0) then --Ha nincs mar ilyen kliens, beszurja
      beszurKolcsonzo(pKolcsonzoNev, pKCim, pKTel, lKolcsonzoId);
    else --Ha mar van, akkor lekeri az ID-jat
      select kid into lKolcsonzoId from kolcsonzo where nev = pKolcsonzoNev;
    end if;
    --Kivalaszt egy szabad DVD-t
    select szabadKonyvek(pKonyvId, pDatumKi, pDatumVissza) into lSzabadKonyvek from dual;
    if (lSzabadKonyvek = -1) then --Nincs szabad DVD
      --Keres hasonlo filmet
      dbms_output.put_line('Nincs szabad konyv!');
      select KonyvId bulk collect into lKonyvIdk
      from Konyvek where mufajId = (select mufajId from Konyvek where KonyvId = pKonyvId) AND KonyvId != pKonyvId;
      if (lKonyvIdk.count = 0) then
        dbms_output.put_line('Nincs hasonlo mufaju film.');
        return 2;
      end if;
      for i in 1 .. lKonyvIdk.count
      loop
        lSzabadKonyvek := szabadKonyvek(lKonyvIdk(i), pDatumKi, pDatumVissza);
        if (lSzabadKonyvek != -1) then
          dbms_output.put_line('Kapott hasonlo mufaju filmet.');
          dbms_output.put_line(lSzabadKonyvek);
          return -1;
        end if;
      end loop;
    else
      kolcsonozPackage.beszurKolcsonzes(lKolcsonzoId, lSzabadKonyvek, pDatumKi, pDatumVissza);
      dbms_output.put_line('Sikerult kolcsonozni');
      return 0;
    end if;
    -- Valtoztatasok elmentese
--    commit;
--    exception when others then
--      -- Rollback a savepointra
--      rollback to savepoint kolcsonozSavePoint;
  end kolcsonoz;

  --Megnezi, hogy ket datumintervallum metszi-e egymast. 1 ha igen, 0 ha nem.
	function datumMetszet(
	  pElsoKezd Kolcsonzesek.DatumKi%TYPE,
	  pElsoVeg Kolcsonzesek.DatumVissza%TYPE,
	  pMasodikKezd Kolcsonzesek.DatumKi%TYPE,
	  pMasodikVeg Kolcsonzesek.DatumVissza%TYPE
	) return number
  is
  begin
    if pElsoKezd <= pMasodikVeg AND pMasodikKezd <= pElsoVeg then 
				return 1; --metszi
		else return 0; --nem metszi
		end if;
  end datumMetszet;

  --Visszaterit egy szabad DVD-t, amin rajta van az adott film és nincs kikolcsonozve az adott periodusban
  function szabadKonyvek(
    pFilmId Konyvek.KonyvId%TYPE,
    pDatumKi Kolcsonzesek.DatumKi%TYPE,
    pDatumVissza Kolcsonzesek.DatumVissza%TYPE
  ) return number
  is
    type tKonyvId is table of Konyvek.KonyvId%TYPE;
    lSzabadKonyvek tKonyvId;
  begin
    select KonyvId bulk collect into lSzabadKonyvek
    from(
    	select KonyvId from Konyvek
    	minus
    	select KonyvId from kolcsonzesek k
    	where kolcsonozPackage.datumMetszet(k.datumki, k.datumvissza, pDatumKi, pDatumVissza) = 1);
		if (lSzabadKonyvek.count = 0) then
			return -1;
		else
			return lSzabadKonyvek(1);
		end if;
  end szabadKonyvek;

  --Beszur egy Kolcsonzot a Kolcsonzo tablaba
  procedure beszurKolcsonzo(
    pNev Kolcsonzo.Nev%TYPE,
    pCim Kolcsonzo.Cim%TYPE,
    pTelefon Kolcsonzo.Telefon%TYPE,
    outKId out Kolcsonzo.Kid%TYPE
  )
  is
  begin
    insert into kolcsonzo values((select max(KId)+1 from kolcsonzo), pNev, pCim, pTelefon) returning Kid into outKId;
  end;

  --Beszur egy kolcsonzest
  procedure beszurKolcsonzes (
    pKId Kolcsonzo.Kid%TYPE,
    pKonyvId Konyvek.KonyvId%TYPE,
    pDatumKi Kolcsonzesek.DatumKi%TYPE,
    pDatumVissza Kolcsonzesek.DatumVissza%TYPE
  )
  is
    lErtek Kolcsonzesek.Ertek%TYPE;
  begin
    select (pDatumVissza - pDatumKi) * napiar into lErtek from Konyvek where Konyvid = pKonyvId;
    insert into kolcsonzesek values(pKId, pKonyvId, pDatumKi, pDatumVissza, lErtek);
    dbms_output.put_line('Sikeresen beszurt a kolcsonzes tablaba');
  end beszurKolcsonzes;
end kolcsonozPackage;