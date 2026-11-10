package br.com.sistemamusical.dao;

import br.com.sistemamusical.conexao.Conexao;
import br.com.sistemamusical.modelo.Artista;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ArtistaDAO {

    // Cadastrar artista
    public void salvar(Artista artista) throws SQLException {
        String sql = """
            INSERT INTO artista
            (nome_artistico, biografia, data_criacao, verificado)
            VALUES (?, ?, ?, ?)
            """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, artista.getNomeArtistico());
            ps.setString(2, artista.getBiografia());
            ps.setObject(3, artista.getDataCriacao());
            ps.setBoolean(4, artista.isVerificado());
            ps.executeUpdate();
        }
    }

    // Listar artistas
    public List<Artista> listar() throws SQLException {
        List<Artista> artistas = new ArrayList<>();

        String sql = "SELECT * FROM artista ORDER BY id_artista";

        try (Connection conn = Conexao.conectar();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                artistas.add(converter(rs));
            }
        }

        return artistas;
    }

    // Buscar artista pelo ID
    public Artista buscar(int id) throws SQLException {
        String sql = "SELECT * FROM artista WHERE id_artista = ?";

        try (Connection conn = Conexao.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return converter(rs);
                }
            }
        }

        return null;
    }

    // Editar artista
    public void editar(Artista artista) throws SQLException {
        String sql = """
            UPDATE artista
            SET nome_artistico = ?,
                biografia = ?,
                data_criacao = ?,
                verificado = ?
            WHERE id_artista = ?
            """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, artista.getNomeArtistico());
            ps.setString(2, artista.getBiografia());
            ps.setObject(3, artista.getDataCriacao());
            ps.setBoolean(4, artista.isVerificado());
            ps.setInt(5, artista.getIdArtista());
            ps.executeUpdate();
        }
    }

    // Excluir artista
    public void excluir(int id) throws SQLException {
        String sql = "DELETE FROM artista WHERE id_artista = ?";

        try (Connection conn = Conexao.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    // Transformar resultado SQL em objeto Java
    private Artista converter(ResultSet rs) throws SQLException {
        Artista artista = new Artista();

        artista.setIdArtista(rs.getInt("id_artista"));
        artista.setNomeArtistico(rs.getString("nome_artistico"));
        artista.setBiografia(rs.getString("biografia"));
        artista.setDataCriacao(
            rs.getObject("data_criacao", java.time.LocalDate.class)
        );
        artista.setVerificado(rs.getBoolean("verificado"));

        return artista;
    }
}
