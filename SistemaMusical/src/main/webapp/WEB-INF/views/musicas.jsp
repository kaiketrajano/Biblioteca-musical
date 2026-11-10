<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.Map, java.util.HashMap" %>
<%@ page import="br.com.sistemamusical.modelo.Album" %>
<%@ page import="br.com.sistemamusical.modelo.Artista" %>
<%@ page import="br.com.sistemamusical.modelo.Musica" %>
<%@ page import="br.com.sistemamusical.dao.MusicaDAO.Genero" %>
<%@ page import="br.com.sistemamusical.web.Arte" %>

<%!
    // Exibe os nomes como texto, mesmo quando têm aspas ou sinais de HTML.
    private String html(Object valor) {
        if (valor == null) {
            return "";
        }

        return valor.toString()
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<%
    String contexto = request.getContextPath();
    Integer filtro = (Integer) request.getAttribute("idAlbum");

    List<Musica> musicas = (List<Musica>) request.getAttribute("musicas");
    List<Album> albuns = (List<Album>) request.getAttribute("albuns");
    List<Artista> artistas = (List<Artista>) request.getAttribute("artistas");
    List<Genero> generos = (List<Genero>) request.getAttribute("generos");

    // A faixa guarda os IDs. Aqui buscamos os nomes que aparecem na tela.
    Map<Integer, Album> albunsPorId = new HashMap<>();
    Map<Integer, String> nomesDosArtistas = new HashMap<>();
    Map<Integer, String> nomesDosGeneros = new HashMap<>();

    for (Album album : albuns) {
        albunsPorId.put(album.getIdAlbum(), album);
    }

    for (Artista artista : artistas) {
        nomesDosArtistas.put(artista.getIdArtista(), artista.getNomeArtistico());
    }

    for (Genero genero : generos) {
        nomesDosGeneros.put(genero.id(), genero.nome());
    }

    String rota = html(contexto) + "/musicas";
    String linkNovo = rota + "?acao=novo";
    String filtroNoLink = "";

    // Mantém o álbum selecionado quando a pessoa abre um formulário.
    if (filtro != null) {
        filtroNoLink = "&amp;album=" + filtro;
        linkNovo += filtroNoLink;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Músicas · Ravenyx</title>
    <link rel="stylesheet" href="<%= html(contexto) %>/css/style.css">
</head>
<body>
<main class="container lista-musicas">
    <h1>Músicas</h1>

    <div class="acoes">
        <a class="secundario" href="<%= html(contexto) %>/inicio">Início</a>
        <a href="<%= linkNovo %>">Nova música</a>
        <a href="<%= html(contexto) %>/albuns">Ver álbuns</a>
    </div>

    <% if (!albuns.isEmpty()) { %>
        <form method="get" action="<%= rota %>">
            <label for="album">Filtrar por álbum</label>

            <select id="album" name="album">
                <option value="">Todos os álbuns</option>

                <% for (Album album : albuns) {
                    int idAlbum = album.getIdAlbum();
                    boolean selecionado = filtro != null && filtro == idAlbum;
                    String artista = nomesDosArtistas.getOrDefault(
                            album.getIdArtista(), "Artista indisponível");
                %>
                    <option value="<%= idAlbum %>" <%= selecionado ? "selected" : "" %>>
                        <%= html(album.getNome()) %> · <%= html(artista) %>
                    </option>
                <% } %>
            </select>

            <button type="submit">Filtrar</button>

            <% if (filtro != null) { %>
                <a href="<%= rota %>">Limpar filtro</a>
            <% } %>
        </form>
    <% } %>

    <% if (musicas.isEmpty()) { %>
        <p><%= filtro == null
                ? "Nenhuma música cadastrada ainda."
                : "Este álbum ainda não tem músicas cadastradas." %></p>
    <% } else { %>
        <div class="tabela" style="overflow-x: auto"
             role="region" aria-label="Lista de músicas" tabindex="0">
            <table>
                <thead>
                    <tr>
                        <th scope="col">Faixa</th>
                        <th scope="col">Título</th>
                        <th scope="col">Álbum</th>
                        <th scope="col">Gênero</th>
                        <th scope="col">Duração</th>
                        <th scope="col">Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Musica musica : musicas) {
                        Album album = albunsPorId.get(musica.idAlbum());
                        String nomeAlbum = album == null ? "Álbum indisponível" : album.getNome();
                        String genero = nomesDosGeneros.getOrDefault(
                                musica.idGenero(), "Sem gênero");
                        String imagem = Arte.imagemSegura(musica.imagemUrl());
                        String spotify = null;

                        // A arte da faixa tem preferência. Quando falta, usamos a capa do álbum.
                        if (imagem == null) {
                            spotify = Arte.spotify(musica.spotifySingleId());
                            if (spotify != null) {
                                imagem = Arte.capaSpotify(musica.spotifyCapaUrl());
                            }
                        }
                        if (imagem == null && album != null) {
                            imagem = Arte.imagemSegura(album.getImagemUrl());
                            spotify = null;
                            if (imagem == null) {
                                spotify = Arte.spotify(album.getSpotifyId());
                                imagem = Arte.capaSpotify(album.getSpotifyCapaUrl());
                            }
                        }
                    %>
                        <tr>
                            <td><%= musica.faixa() %></td>
                            <th scope="row">
                                <span class="titulo-faixa-ravenyx">
                                    <% if (spotify != null && imagem != null) { %>
                                        <a class="capa-faixa-link" href="https://open.spotify.com/album/<%= spotify %>"
                                           aria-label="Ver a capa de <%= html(musica.titulo()) %> no Spotify">
                                            <img class="capa-faixa" src="<%= html(imagem) %>"
                                                 alt="" loading="lazy" referrerpolicy="no-referrer">
                                        </a>
                                    <% } else if (imagem != null) { %>
                                        <img class="capa-faixa" src="<%= html(imagem) %>"
                                             alt="" loading="lazy" referrerpolicy="no-referrer">
                                    <% } %>
                                    <span><%= html(musica.titulo()) %></span>
                                </span>
                            </th>
                            <td><%= html(nomeAlbum) %></td>
                            <td><%= html(genero) %></td>
                            <td><%= musica.duracaoFormatada() %></td>
                            <td>
                                <div class="acoes">
                                    <a href="<%= rota %>?acao=editar&amp;id=<%= musica.id() %><%= filtroNoLink %>"
                                       aria-label="Editar <%= html(musica.titulo()) %>">Editar</a>

                                    <%-- A exclusão usa POST porque altera o banco. --%>
                                    <form method="post" action="<%= rota %>"
                                          onsubmit="return confirm('Excluir esta música?')">
                                        <input type="hidden" name="acao" value="excluir">
                                        <input type="hidden" name="id" value="<%= musica.id() %>">
                                        <input type="hidden" name="filtro" value="<%= html(filtro) %>">
                                        <input type="hidden" name="csrf"
                                               value="<%= html(request.getAttribute("csrf")) %>">
                                        <button type="submit"
                                                aria-label="Excluir <%= html(musica.titulo()) %>">
                                            Excluir
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
</main>
</body>
</html>
