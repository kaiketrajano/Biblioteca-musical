package br.com.sistemamusical.modelo;

// Representa uma faixa cadastrada na biblioteca do Ravenyx.
public record Musica(
        int id,
        String titulo,
        int faixa,
        int duracaoSegundos,
        int idAlbum,

        // Pode ser nulo em faixas cadastradas antes de o gênero ser incluído.
        Integer idGenero,
        String imagemUrl,
        String spotifySingleId,
        String spotifyCapaUrl
) {
    // Converte a duração em segundos para o formato minutos:segundos.
    public String duracaoFormatada() {
        int minutos = duracaoSegundos / 60;
        int segundos = duracaoSegundos % 60;

        return "%d:%02d".formatted(minutos, segundos);
    }
}
