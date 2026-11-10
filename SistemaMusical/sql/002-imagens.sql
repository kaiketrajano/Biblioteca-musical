BEGIN;

-- O endereço da imagem é opcional para os cadastros que já existem.
ALTER TABLE public.album
    ADD COLUMN IF NOT EXISTS imagem_url varchar(2048),
    ADD COLUMN IF NOT EXISTS spotify_id varchar(22),
    ADD COLUMN IF NOT EXISTS spotify_capa_url varchar(2048);

ALTER TABLE public.musica
    ADD COLUMN IF NOT EXISTS imagem_url varchar(2048),
    ADD COLUMN IF NOT EXISTS spotify_single_id varchar(22),
    ADD COLUMN IF NOT EXISTS spotify_capa_url varchar(2048);

COMMIT;
