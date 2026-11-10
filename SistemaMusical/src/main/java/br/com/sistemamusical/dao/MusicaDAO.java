package br.com.sistemamusical.dao;

import br.com.sistemamusical.conexao.Conexao;
import br.com.sistemamusical.modelo.Musica;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class MusicaDAO {

    // Guarda o ID e o nome de cada opção do formulário.
    public record Genero(int id, String nome) {}

    // Lista todas as faixas ou apenas as do álbum selecionado.
    public List<Musica> listar(Integer idAlbum) throws SQLException {
        String sql = "SELECT * FROM public.musica"
                + (idAlbum == null ? "" : " WHERE id_album = ?")
                + " ORDER BY id_album, numero_faixa";

        List<Musica> musicas = new ArrayList<>();

        try (Connection conexao = Conexao.conectar();
             PreparedStatement comando = conexao.prepareStatement(sql)) {

            if (idAlbum != null) {
                comando.setInt(1, idAlbum);
            }

            try (ResultSet resultado = comando.executeQuery()) {
                while (resultado.next()) {
                    musicas.add(ler(resultado));
                }
            }
        }

        return musicas;
    }

    // Busca a faixa que será aberta para edição.
    public Musica buscar(int id) throws SQLException {
        String sql = "SELECT * FROM public.musica WHERE id_musica = ?";

        try (Connection conexao = Conexao.conectar();
             PreparedStatement comando = conexao.prepareStatement(sql)) {

            comando.setInt(1, id);

            try (ResultSet resultado = comando.executeQuery()) {
                return resultado.next() ? ler(resultado) : null;
            }
        }
    }

    // Insere uma faixa nova ou atualiza uma que já tem ID.
    public boolean salvar(Musica musica) throws SQLException {
        boolean nova = musica.id() == 0;

        String sql = nova
                ? """
                  INSERT INTO public.musica
                      (titulo, numero_faixa, duracao_segundos, id_album, id_genero, imagem_url)
                  VALUES (?, ?, ?, ?, ?, ?)
                  """
                : """
                  UPDATE public.musica
                  SET titulo = ?, numero_faixa = ?, duracao_segundos = ?,
                      id_album = ?, id_genero = ?, imagem_url = ?
                  WHERE id_musica = ?
                  """;

        try (Connection conexao = Conexao.conectar();
             PreparedStatement comando = conexao.prepareStatement(sql)) {

            comando.setString(1, musica.titulo());
            comando.setInt(2, musica.faixa());
            comando.setInt(3, musica.duracaoSegundos());
            comando.setInt(4, musica.idAlbum());

            // Faixas antigas podem estar sem gênero.
            comando.setObject(5, musica.idGenero(), Types.INTEGER);
            comando.setString(6, musica.imagemUrl());

            if (!nova) {
                comando.setInt(7, musica.id());
            }

            return comando.executeUpdate() == 1;
        }
    }

    // Exclui a faixa pelo ID e informa se ela foi encontrada.
    public boolean excluir(int id) throws SQLException {
        String sql = "DELETE FROM public.musica WHERE id_musica = ?";

        try (Connection conexao = Conexao.conectar();
             PreparedStatement comando = conexao.prepareStatement(sql)) {

            comando.setInt(1, id);
            return comando.executeUpdate() == 1;
        }
    }

    // Carrega os gêneros em ordem alfabética para o formulário.
    public List<Genero> listarGeneros() throws SQLException {
        String sql = """
                SELECT id_genero, nome
                FROM public.genero_musical
                ORDER BY nome
                """;

        List<Genero> generos = new ArrayList<>();

        try (Connection conexao = Conexao.conectar();
             PreparedStatement comando = conexao.prepareStatement(sql);
             ResultSet resultado = comando.executeQuery()) {

            while (resultado.next()) {
                generos.add(new Genero(
                        resultado.getInt("id_genero"),
                        resultado.getString("nome")
                ));
            }
        }

        return generos;
    }

    // Monta uma música com os dados de uma linha do banco.
    private Musica ler(ResultSet resultado) throws SQLException {
        return new Musica(
                resultado.getInt("id_musica"),
                resultado.getString("titulo"),
                resultado.getInt("numero_faixa"),
                resultado.getInt("duracao_segundos"),
                resultado.getInt("id_album"),
                resultado.getObject("id_genero", Integer.class),
                resultado.getString("imagem_url"),
                resultado.getString("spotify_single_id"),
                resultado.getString("spotify_capa_url")
        );
    }
}
