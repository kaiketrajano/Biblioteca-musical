BEGIN;

-- A chave junta artista e álbum, sem depender dos IDs da instalação.
CREATE TEMP TABLE edicoes_ravenyx (
    chave text PRIMARY KEY, artista text, album text, genero text,
    spotify_id text, capa text
) ON COMMIT DROP;

INSERT INTO edicoes_ravenyx VALUES
    ('dark', 'HIM', 'Dark Light', 'Metal', '1D2SnMTuy2faToruV0yzwJ', 'https://image-cdn-fa.spotifycdn.com/image/ab67616d00001e02c9ceb861d99f6c7685496146'),
    ('love', 'HIM', 'Love Metal', 'Metal', '61WyXkBtxdBd9mKmg2NQpk', 'https://image-cdn-ak.spotifycdn.com/image/ab67616d00001e02712be93db120a976a1beaaf9'),
    ('fallen', 'Evanescence', 'Fallen', 'Rock', '6ADPL1ztfju7cpsze2tjqb', 'https://image-cdn-fa.spotifycdn.com/image/ab67616d00001e02ba0a638cde6863cb0a22ca12'),
    ('door', 'Evanescence', 'The Open Door', 'Rock', '0TbPPyYmNoRHEgom5JdAdf', 'https://image-cdn-ak.spotifycdn.com/image/ab67616d00001e0256d93f34917ee4b92f9bf01f'),
    ('meteora', 'Linkin Park', 'Meteora', 'Rock', '4Gfnly5CzMJQqkUFfoHaP3', 'https://image-cdn-ak.spotifycdn.com/image/ab67616d00001e025f1f51d14e8bea89484ecd1b'),
    ('hybrid', 'Linkin Park', 'Hybrid Theory', 'Rock', '6NnXXuGYvLlzhBQDI0duqJ', 'https://image-cdn-ak.spotifycdn.com/image/ab67616d00001e02d198bc2c63a691f80cf52416'),
    ('once', 'Nightwish', 'Once', 'Metal', '2wM6svkNOCsYP8sr9gP2zc', 'https://image-cdn-ak.spotifycdn.com/image/ab67616d00001e02c7190a75bf05ad902f52c7a2'),
    ('century', 'Nightwish', 'Century Child', 'Metal', '44kzDmMHJn474wrwDd3pCi', 'https://image-cdn-ak.spotifycdn.com/image/ab67616d00001e023cfa7689ec9ea9b0856a195b'),
    ('adele21', 'Adele', '21', 'Pop', '5duyQokC4FMcWPYTV9Gpf9', 'https://image-cdn-ak.spotifycdn.com/image/ab67616d00001e02e63ac9f24aab9acc90f81960'),
    ('adele25', 'Adele', '25', 'Pop', '3AvPX1B1HiFROvYjLb5Qwi', 'https://image-cdn-ak.spotifycdn.com/image/ab67616d00001e0247ce408fb4926d69da6713c2');

CREATE TEMP TABLE faixas_ravenyx (
    chave text REFERENCES edicoes_ravenyx, faixa integer, titulo text,
    segundos integer, spotify_single_id text, capa text, PRIMARY KEY (chave, faixa)
) ON COMMIT DROP;

INSERT INTO faixas_ravenyx VALUES
    ('dark', 1, 'Vampire Heart', 285, NULL, NULL),
    ('dark', 2, 'Wings of a Butterfly', 210, NULL, NULL),
    ('dark', 3, 'Under the Rose', 289, NULL, NULL),
    ('dark', 4, 'Killing Loneliness', 269, NULL, NULL),
    ('dark', 5, 'Dark Light', 270, NULL, NULL),
    ('dark', 6, 'Behind the Crimson Door', 277, NULL, NULL),
    ('dark', 7, 'The Face of God', 274, NULL, NULL),
    ('dark', 8, 'Drunk on Shadows', 229, NULL, NULL),
    ('dark', 9, 'Play Dead', 276, NULL, NULL),
    ('dark', 10, 'In the NightSide of Eden', 339, NULL, NULL),
    ('love', 1, 'Buried Alive By Love', 301, NULL, NULL),
    ('love', 2, 'The Funeral Of Hearts', 270, NULL, NULL),
    ('love', 3, 'Beyond Redemption', 268, NULL, NULL),
    ('love', 4, 'Sweet Pandemonium', 345, NULL, NULL),
    ('love', 5, 'Soul On Fire', 239, NULL, NULL),
    ('love', 6, 'The Sacrament', 269, NULL, NULL),
    ('love', 7, 'This Fortress Of Tears', 346, NULL, NULL),
    ('love', 8, 'Circle Of Fear', 323, NULL, NULL),
    ('love', 9, 'Endless Dark', 332, NULL, NULL),
    ('love', 10, 'The Path', 462, NULL, NULL),
    ('love', 11, 'Love''s Requiem', 515, NULL, NULL),
    ('fallen', 1, 'Going Under', 214, NULL, NULL),
    ('fallen', 2, 'Bring Me to Life', 235, NULL, NULL),
    ('fallen', 3, 'Everybody''s Fool', 195, NULL, NULL),
    ('fallen', 4, 'My Immortal', 262, NULL, NULL),
    ('fallen', 5, 'Haunted', 185, NULL, NULL),
    ('fallen', 6, 'Tourniquet', 278, NULL, NULL),
    ('fallen', 7, 'Imaginary', 256, NULL, NULL),
    ('fallen', 8, 'Taking Over Me', 228, NULL, NULL),
    ('fallen', 9, 'Hello', 220, NULL, NULL),
    ('fallen', 10, 'My Last Breath', 247, NULL, NULL),
    ('fallen', 11, 'Whisper', 327, NULL, NULL),
    ('door', 1, 'Sweet Sacrifice', 185, NULL, NULL),
    ('door', 2, 'Call Me When You''re Sober', 214, NULL, NULL),
    ('door', 3, 'Weight Of The World', 217, NULL, NULL),
    ('door', 4, 'Lithium', 224, NULL, NULL),
    ('door', 5, 'Cloud Nine', 262, NULL, NULL),
    ('door', 6, 'Snow White Queen', 261, NULL, NULL),
    ('door', 7, 'Lacrymosa', 215, NULL, NULL),
    ('door', 8, 'Like You', 256, NULL, NULL),
    ('door', 9, 'Lose Control', 290, NULL, NULL),
    ('door', 10, 'The Only One', 280, NULL, NULL),
    ('door', 11, 'Your Star', 283, NULL, NULL),
    ('door', 12, 'All That I''m Living For', 227, NULL, NULL),
    ('door', 13, 'Good Enough', 331, NULL, NULL),
    ('meteora', 1, 'Foreword', 13, NULL, NULL),
    ('meteora', 2, 'Don''t Stay', 187, NULL, NULL),
    ('meteora', 3, 'Somewhere I Belong', 213, NULL, NULL),
    ('meteora', 4, 'Lying from You', 175, NULL, NULL),
    ('meteora', 5, 'Hit the Floor', 164, NULL, NULL),
    ('meteora', 6, 'Easier to Run', 204, NULL, NULL),
    ('meteora', 7, 'Faint', 162, NULL, NULL),
    ('meteora', 8, 'Figure.09', 197, NULL, NULL),
    ('meteora', 9, 'Breaking the Habit', 196, NULL, NULL),
    ('meteora', 10, 'From the Inside', 175, NULL, NULL),
    ('meteora', 11, 'Nobody''s Listening', 178, NULL, NULL),
    ('meteora', 12, 'Session', 144, NULL, NULL),
    ('meteora', 13, 'Numb', 187, NULL, NULL),
    ('hybrid', 1, 'Papercut', 184, NULL, NULL),
    ('hybrid', 2, 'One Step Closer', 155, NULL, NULL),
    ('hybrid', 3, 'With You', 203, NULL, NULL),
    ('hybrid', 4, 'Points Of Authority', 200, NULL, NULL),
    ('hybrid', 5, 'Crawling', 208, NULL, NULL),
    ('hybrid', 6, 'Runaway', 183, NULL, NULL),
    ('hybrid', 7, 'By Myself', 189, NULL, NULL),
    ('hybrid', 8, 'In The End', 216, NULL, NULL),
    ('hybrid', 9, 'A Place For My Head', 184, NULL, NULL),
    ('hybrid', 10, 'Forgotten', 194, NULL, NULL),
    ('hybrid', 11, 'Cure For The Itch', 157, NULL, NULL),
    ('hybrid', 12, 'Pushing Me Away', 191, NULL, NULL),
    ('hybrid', 13, 'My December', 259, NULL, NULL),
    ('hybrid', 14, 'High Voltage', 225, NULL, NULL),
    ('hybrid', 15, 'Papercut - Recorded Live At BBC1', 189, NULL, NULL),
    ('once', 1, 'Dark Chest of Wonders', 268, NULL, NULL),
    ('once', 2, 'Wish I Had an Angel', 245, NULL, NULL),
    ('once', 3, 'Nemo', 276, '2QEpfyfmbWna642EiWojPU', 'https://image-cdn-fa.spotifycdn.com/image/ab67616d00001e02b0d26148eb40b8f5ef4ead98'),
    ('once', 4, 'Planet Hell', 278, NULL, NULL),
    ('once', 5, 'Creek Mary''s Blood', 509, NULL, NULL),
    ('once', 6, 'The Siren', 285, NULL, NULL),
    ('once', 7, 'Dead Gardens', 268, NULL, NULL),
    ('once', 8, 'Romanticide', 298, NULL, NULL),
    ('once', 9, 'Ghost Love Score', 602, NULL, NULL),
    ('once', 10, 'Kuolema Tekee Taiteilijan', 238, NULL, NULL),
    ('once', 11, 'Higher Than Hope', 334, NULL, NULL),
    ('century', 1, 'Bless The Child', 372, NULL, NULL),
    ('century', 2, 'End Of All Hope', 233, NULL, NULL),
    ('century', 3, 'Dead To The World', 259, NULL, NULL),
    ('century', 4, 'Ever Dream', 282, NULL, NULL),
    ('century', 5, 'Slaying The Dreamer', 271, NULL, NULL),
    ('century', 6, 'Forever Yours', 230, NULL, NULL),
    ('century', 7, 'Ocean Soul', 254, NULL, NULL),
    ('century', 8, 'Feel For You', 234, NULL, NULL),
    ('century', 9, 'The Phantom Of The Opera', 248, NULL, NULL),
    ('century', 10, 'Beauty Of The Beast', 622, NULL, NULL),
    ('adele21', 1, 'Rolling in the Deep', 228, NULL, NULL),
    ('adele21', 2, 'Rumour Has It', 223, NULL, NULL),
    ('adele21', 3, 'Turning Tables', 250, NULL, NULL),
    ('adele21', 4, 'Don''t You Remember', 243, NULL, NULL),
    ('adele21', 5, 'Set Fire to the Rain', 242, NULL, NULL),
    ('adele21', 6, 'He Won''t Go', 278, NULL, NULL),
    ('adele21', 7, 'Take It All', 228, NULL, NULL),
    ('adele21', 8, 'I''ll Be Waiting', 241, NULL, NULL),
    ('adele21', 9, 'One And Only', 348, NULL, NULL),
    ('adele21', 10, 'Lovesong', 316, NULL, NULL),
    ('adele21', 11, 'Someone Like You', 285, NULL, NULL),
    ('adele25', 1, 'Hello', 295, NULL, NULL),
    ('adele25', 2, 'Send My Love (To Your New Lover)', 223, NULL, NULL),
    ('adele25', 3, 'I Miss You', 348, NULL, NULL),
    ('adele25', 4, 'When We Were Young', 290, NULL, NULL),
    ('adele25', 5, 'Remedy', 245, NULL, NULL),
    ('adele25', 6, 'Water Under the Bridge', 240, NULL, NULL),
    ('adele25', 7, 'River Lea', 225, NULL, NULL),
    ('adele25', 8, 'Love In The Dark', 285, NULL, NULL),
    ('adele25', 9, 'Million Years Ago', 227, NULL, NULL),
    ('adele25', 10, 'All I Ask', 271, NULL, NULL),
    ('adele25', 11, 'Sweetest Devotion', 251, NULL, NULL);

LOCK TABLE public.album, public.artista, public.genero_musical, public.musica
    IN SHARE ROW EXCLUSIVE MODE;

CREATE TEMP TABLE catalogo_ravenyx ON COMMIT DROP AS
SELECT edicao.*, album.id_album, genero.id_genero
FROM edicoes_ravenyx edicao
JOIN public.artista artista ON lower(artista.nome_artistico) = lower(edicao.artista)
JOIN public.album album ON album.id_artista = artista.id_artista AND lower(album.nome) = lower(edicao.album)
JOIN public.genero_musical genero ON lower(genero.nome) = lower(edicao.genero);

DO $$
BEGIN
    IF EXISTS (
        SELECT edicao.chave FROM edicoes_ravenyx edicao
        LEFT JOIN catalogo_ravenyx catalogo USING (chave)
        GROUP BY edicao.chave HAVING count(catalogo.id_album) <> 1
    ) THEN
        RAISE EXCEPTION 'Confira os álbuns e gêneros antes de importar as faixas.';
    END IF;
END $$;

-- A faixa de teste fica no mesmo álbum, depois da última faixa oficial.
UPDATE public.musica musica
SET numero_faixa = (
    SELECT greatest(max(numero_faixa), 11) + 1 FROM public.musica
    WHERE id_album = musica.id_album
)
FROM catalogo_ravenyx catalogo
WHERE catalogo.chave = 'love'
    AND musica.id_album = catalogo.id_album AND musica.numero_faixa = 2
    AND musica.titulo = 'oi' AND musica.duracao_segundos = 200;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM faixas_ravenyx faixa
        JOIN catalogo_ravenyx catalogo USING (chave)
        JOIN public.musica musica ON musica.id_album = catalogo.id_album
            AND musica.numero_faixa = faixa.faixa
        WHERE lower(musica.titulo) <> lower(faixa.titulo)
    ) THEN
        RAISE EXCEPTION 'Há faixas cadastradas nas mesmas posições. A importação foi cancelada.';
    END IF;
END $$;

UPDATE public.album album
SET spotify_id = catalogo.spotify_id, spotify_capa_url = catalogo.capa
FROM catalogo_ravenyx catalogo
WHERE album.id_album = catalogo.id_album;

-- Em uma segunda execução, a mesma faixa não é cadastrada de novo.
INSERT INTO public.musica
    (titulo, numero_faixa, duracao_segundos, id_album, id_genero, spotify_single_id, spotify_capa_url)
SELECT faixa.titulo, faixa.faixa, faixa.segundos, catalogo.id_album, catalogo.id_genero,
       faixa.spotify_single_id, faixa.capa
FROM faixas_ravenyx faixa
JOIN catalogo_ravenyx catalogo USING (chave)
ORDER BY catalogo.id_album, faixa.faixa
ON CONFLICT (id_album, numero_faixa) DO NOTHING;

SELECT count(*) AS faixas_oficiais
FROM faixas_ravenyx faixa
JOIN catalogo_ravenyx catalogo USING (chave)
JOIN public.musica musica ON musica.id_album = catalogo.id_album
    AND musica.numero_faixa = faixa.faixa;

COMMIT;
