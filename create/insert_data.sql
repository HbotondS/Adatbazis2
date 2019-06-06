----------------------------------Mufajok-----------------------------------

INSERT INTO Mufajok
VALUES (1, 'drama');
INSERT INTO Mufajok
VALUES (2, 'regeny');
INSERT INTO Mufajok
VALUES (3, 'Sci-fi');
INSERT INTO Mufajok
VALUES (4, 'fantasy');
INSERT INTO Mufajok
VALUES (5, 'krimi');
INSERT INTO Mufajok
VALUES (6, 'mese');

----------------------------------IROK----------------------------------

INSERT INTO Irok
VALUES (1, 'Kis Jeno', '0732067895');
INSERT INTO Irok
VALUES (2, 'Rejto Jeno', '0732456455');
INSERT INTO Irok
VALUES (3, 'G. R. R. Martin', '0732064546');

--------------------------------Konyvek----------------------------------

INSERT INTO Konyvek
VALUES (1, 'Vajak', 'Play ON', 1, '3658123654798', 'fantasy', 3);
INSERT INTO Konyvek
VALUES (2, 'Tronok harca', 'Alexandra', 2, '3658123654468', 'fantasy', 5);
INSERT INTO Konyvek
VALUES (3, 'Az Ehezok Viadala', 'Agave', 3, '4568646156024', 'Sci-fi', 4);
INSERT INTO Konyvek
VALUES (4, 'Az Utveszto', 'Cartaphilus', 1, '4548424548228', 'regeny', 4);
INSERT INTO Konyvek
VALUES (5, 'Galaxis utikalauz stopposoknak', 'Gabo ', 3, '3658456488853', 'Sci-fi', 5);

----------------------------------Kolcsonzo---------------------------------

INSERT INTO Kolcsonzo
VALUES (1, 'Szilagyi Jeno', 'Kolozsvar, Scortarilor 79', '0732067895');
INSERT INTO Kolcsonzo
VALUES (2, 'Andras Mihaly', 'Marosvasarhely, Tudor 5', '0264435672');
INSERT INTO Kolcsonzo
VALUES (3, 'Kiraly Lorand', 'Marosvasarhely, Unirii 1', '0264789678');
INSERT INTO Kolcsonzo
VALUES (4, 'Csizmar Karoly', 'Nagyvarad, Closca 90', '0260361739');
INSERT INTO Kolcsonzo
VALUES (5, 'Balogh Imre', 'Kolozsvar, Paris 3', '0728345678');
INSERT INTO Kolcsonzo
VALUES (6, 'Andras Hannah', 'Nagyvarad, Gr. Alexandrescu 5', '0264435672');
INSERT INTO Kolcsonzo
VALUES (7, 'Andor Zoltan', 'Sepsiszentgyorgy, Fantanele 34', '0780345678');
INSERT INTO Kolcsonzo
VALUES (8, 'Nagy Ildiko', 'Csikszereda, Motilor 2', '0751234786');
INSERT INTO Kolcsonzo
VALUES (9, 'Kollo Ingrid', 'Szatmarnemeti, Somesul 67', '0261868685');
INSERT INTO Kolcsonzo
VALUES (10, 'Petok Ilona', 'Nagykaroly, Agoston 52', '0728798789');


--------------------------------Kolcsonzesek--------------------------------

INSERT INTO Kolcsonzesek
VALUES (2, 1, to_date('2011-06-15', 'YYYY-MM-DD'), to_date('2011-06-20', 'YYYY-MM-DD'), 250);
INSERT INTO Kolcsonzesek
VALUES (1, 1, to_date('2011-06-20', 'YYYY-MM-DD'), to_date('2011-06-25', 'YYYY-MM-DD'), 250);
INSERT INTO Kolcsonzesek
VALUES (1, 1, to_date('2011-06-30', 'YYYY-MM-DD'), to_date('2011-07-02', 'YYYY-MM-DD'), 10);
INSERT INTO Kolcsonzesek
VALUES (3, 1, to_date('2011-07-02', 'YYYY-MM-DD'), to_date('2011-07-12', 'YYYY-MM-DD'), 100);
INSERT INTO Kolcsonzesek
VALUES (3, 1, to_date('2011-07-12', 'YYYY-MM-DD'), to_date('2011-07-15', 'YYYY-MM-DD'), 15);
INSERT INTO Kolcsonzesek
VALUES (4, 1, to_date('2011-07-20', 'YYYY-MM-DD'), to_date('2011-07-22', 'YYYY-MM-DD'), 10);
INSERT INTO Kolcsonzesek
VALUES (10, 1, to_date('2011-07-27', 'YYYY-MM-DD'), to_date('2011-07-30', 'YYYY-MM-DD'), 15);
INSERT INTO Kolcsonzesek
VALUES (5, 1, to_date('2011-08-05', 'YYYY-MM-DD'), to_date('2011-08-15', 'YYYY-MM-DD'), 100);
INSERT INTO Kolcsonzesek
VALUES (3, 1, to_date('2011-09-01', 'YYYY-MM-DD'), to_date('2011-09-12', 'YYYY-MM-DD'), 20);
INSERT INTO Kolcsonzesek
VALUES (2, 2, to_date('2011-06-15', 'YYYY-MM-DD'), to_date('2011-06-20', 'YYYY-MM-DD'), 250);
INSERT INTO Kolcsonzesek
VALUES (1, 2, to_date('2011-06-20', 'YYYY-MM-DD'), to_date('2011-06-25', 'YYYY-MM-DD'), 250);
INSERT INTO Kolcsonzesek
VALUES (1, 2, to_date('2011-06-30', 'YYYY-MM-DD'), to_date('2011-07-02', 'YYYY-MM-DD'), 10);
INSERT INTO Kolcsonzesek
VALUES (3, 2, to_date('2011-07-02', 'YYYY-MM-DD'), to_date('2011-07-12', 'YYYY-MM-DD'), 100);
INSERT INTO Kolcsonzesek
VALUES (3, 2, to_date('2011-07-12', 'YYYY-MM-DD'), to_date('2011-07-15', 'YYYY-MM-DD'), 15);
INSERT INTO Kolcsonzesek
VALUES (4, 2, to_date('2011-07-20', 'YYYY-MM-DD'), to_date('2011-07-22', 'YYYY-MM-DD'), 10);
INSERT INTO Kolcsonzesek
VALUES (10, 2, to_date('2011-07-27', 'YYYY-MM-DD'), to_date('2011-07-30', 'YYYY-MM-DD'), 15);
INSERT INTO Kolcsonzesek
VALUES (5, 2, to_date('2011-08-05', 'YYYY-MM-DD'), to_date('2011-08-15', 'YYYY-MM-DD'), 100);
INSERT INTO Kolcsonzesek
VALUES (3, 2, to_date('2011-09-01', 'YYYY-MM-DD'), to_date('2011-09-12', 'YYYY-MM-DD'), 20);
INSERT INTO Kolcsonzesek
VALUES (2, 3, to_date('2011-06-15', 'YYYY-MM-DD'), to_date('2011-06-20', 'YYYY-MM-DD'), 250);
INSERT INTO Kolcsonzesek
VALUES (1, 3, to_date('2011-06-20', 'YYYY-MM-DD'), to_date('2011-06-25', 'YYYY-MM-DD'), 250);
