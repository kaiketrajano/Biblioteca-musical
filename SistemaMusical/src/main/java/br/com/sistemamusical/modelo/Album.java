
package br.com.sistemamusical.modelo;

public class Album {

    private int idAlbum;
    private String nome;
    private Double nota;
    private int idArtista;
    private String imagemUrl;
    private String spotifyId;
    private String spotifyCapaUrl;

    public int getIdAlbum() {
        return idAlbum;
    }

    public void setIdAlbum(int idAlbum) {
        this.idAlbum = idAlbum;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public Double getNota() {
        return nota;
    }

    public void setNota(Double nota) {
        this.nota = nota;
    }

    public int getIdArtista() {
        return idArtista;
    }

    public void setIdArtista(int idArtista) {
        this.idArtista = idArtista;
    }

    public String getImagemUrl() {
        return imagemUrl;
    }

    public void setImagemUrl(String imagemUrl) {
        this.imagemUrl = imagemUrl;
    }

    public String getSpotifyId() {
        return spotifyId;
    }

    public void setSpotifyId(String spotifyId) {
        this.spotifyId = spotifyId;
    }

    public String getSpotifyCapaUrl() {
        return spotifyCapaUrl;
    }

    public void setSpotifyCapaUrl(String spotifyCapaUrl) {
        this.spotifyCapaUrl = spotifyCapaUrl;
    }
}
