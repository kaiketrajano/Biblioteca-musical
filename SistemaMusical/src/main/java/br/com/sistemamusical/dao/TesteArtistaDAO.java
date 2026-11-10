package br.com.sistemamusical.dao;

import br.com.sistemamusical.modelo.Artista;
import java.sql.SQLException;
import java.util.List;

public class TesteArtistaDAO {

    public static void main(String[] args) {

        ArtistaDAO dao = new ArtistaDAO();

        try {
            List<Artista> artistas = dao.listar();

            System.out.println("=== ARTISTAS CADASTRADOS ===");

            for (Artista artista : artistas) {
                System.out.println(
                    artista.getIdArtista() + " - " +
                    artista.getNomeArtistico()
                );
            }

        } catch (SQLException e) {
            System.out.println(
                "Erro ao listar artistas: " + e.getMessage()
            );
        }
    }
}
