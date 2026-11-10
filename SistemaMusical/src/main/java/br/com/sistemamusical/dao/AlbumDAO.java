package br.com.sistemamusical.dao;

import br.com.sistemamusical.conexao.Conexao;
import br.com.sistemamusical.modelo.Album;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AlbumDAO {

    // CADASTRAR ÁLBUM
    public void salvar(Album album) throws SQLException {
        String sql = """
            INSERT INTO album (nome, nota, id_artista, imagem_url)
            VALUES (?, ?, ?, ?)
            """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, album.getNome());

            if (album.getNota() != null) {
                ps.setDouble(2, album.getNota());
            } else {
                ps.setNull(2, Types.DOUBLE);
            }

            ps.setInt(3, album.getIdArtista());
            ps.setString(4, album.getImagemUrl());
            ps.executeUpdate();
        }
    }

    // LISTAR ÁLBUNS
    public List<Album> listar() throws SQLException {
        List<Album> albuns = new ArrayList<>();

        String sql = "SELECT * FROM album ORDER BY id_album";

        try (Connection conn = Conexao.conectar();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                albuns.add(converter(rs));
            }
        }

        return albuns;
    }

    // BUSCAR ÁLBUM PELO ID
    public Album buscar(int id) throws SQLException {
        String sql = "SELECT * FROM album WHERE id_album = ?";

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

    // EDITAR ÁLBUM
    public void editar(Album album) throws SQLException {
        editar(album, false);
    }

    public void editar(Album album, boolean alterarImagem) throws SQLException {
        String sql = """
            UPDATE album
            SET nome = ?, nota = ?, id_artista = ?,
                imagem_url = CASE WHEN ? THEN ? ELSE imagem_url END
            WHERE id_album = ?
            """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, album.getNome());

            if (album.getNota() != null) {
                ps.setDouble(2, album.getNota());
            } else {
                ps.setNull(2, Types.DOUBLE);
            }

            ps.setInt(3, album.getIdArtista());
            ps.setBoolean(4, alterarImagem);
            ps.setString(5, album.getImagemUrl());
            ps.setInt(6, album.getIdAlbum());

            ps.executeUpdate();
        }
    }

    // EXCLUIR ÁLBUM
    public void excluir(int id) throws SQLException {
        String sql = "DELETE FROM album WHERE id_album = ?";

        try (Connection conn = Conexao.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    // CONVERTER RESULTADO DO BANCO EM OBJETO JAVA
    private Album converter(ResultSet rs) throws SQLException {
        Album album = new Album();

        album.setIdAlbum(rs.getInt("id_album"));
        album.setNome(rs.getString("nome"));

        double nota = rs.getDouble("nota");
        album.setNota(rs.wasNull() ? null : nota);

        album.setIdArtista(rs.getInt("id_artista"));
        album.setImagemUrl(rs.getString("imagem_url"));
        album.setSpotifyId(rs.getString("spotify_id"));
        album.setSpotifyCapaUrl(rs.getString("spotify_capa_url"));

        return album;
    }
}
