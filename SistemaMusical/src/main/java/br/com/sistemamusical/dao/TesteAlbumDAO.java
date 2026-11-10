package br.com.sistemamusical.dao;

import br.com.sistemamusical.modelo.Album;
import br.com.sistemamusical.modelo.Artista;
import java.sql.SQLException;
import java.util.List;

public class TesteAlbumDAO {

    public static void main(String[] args) {

        AlbumDAO albumDAO = new AlbumDAO();
        ArtistaDAO artistaDAO = new ArtistaDAO();

        try {
            List<Album> albuns = albumDAO.listar();

            System.out.println("=== ÁLBUNS CADASTRADOS ===");

            for (Album album : albuns) {

                Artista artista = artistaDAO.buscar(
                    album.getIdArtista()
                );

                String nomeArtista = artista != null
                    ? artista.getNomeArtistico()
                    : "Artista não encontrado";

                System.out.println(
                    album.getIdAlbum() + " - " +
                    album.getNome() + " | " +
                    nomeArtista + " | Nota: " +
                    album.getNota()
                );
            }

        } catch (SQLException e) {
            System.out.println(
                "Erro ao listar álbuns: " + e.getMessage()
            );
        }
    }
}

