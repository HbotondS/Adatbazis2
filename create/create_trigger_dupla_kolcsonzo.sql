create or replace TRIGGER duplikalt_irok
    before INSERT
    on irok
    for each row
begin
    for sorok in (select * from irok)
        loop
            if (sorok.INEV = :new.INEV) then
                RAISE_APPLICATION_ERROR(-20000, 'Ilyen nevu iro mar van');
            end if;
        end loop;
end;