<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="br.com.sistemamusical.modelo.Artista" %>
<%@ page import="br.com.sistemamusical.modelo.Album" %>
<%@ page import="br.com.sistemamusical.web.Arte" %>

<%!
    // Mantém o texto da busca e os nomes do catálogo seguros na página.
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
    String contexto = html(request.getContextPath());
    String busca = (String) request.getAttribute("busca");
    boolean pesquisando = busca != null && !busca.isEmpty();

    List<Artista> destaques = (List<Artista>) request.getAttribute("destaques");
    List<Album> recentes = (List<Album>) request.getAttribute("recentes");
    List<Album> avaliados = (List<Album>) request.getAttribute("avaliados");
    Map<Integer, String> nomesDosArtistas =
            (Map<Integer, String>) request.getAttribute("nomesDosArtistas");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Ravenyx · Sua biblioteca musical</title>
    <link rel="stylesheet" href="<%= contexto %>/css/style.css">
</head>
<body class="ravenyx-inicio">

<aside class="inicio-lateral">
    <a class="inicio-marca" href="<%= contexto %>/inicio">Ravenyx</a>

    <nav aria-label="Menu principal">
        <a href="<%= contexto %>/inicio" aria-current="page">Início</a>
        <a href="<%= contexto %>/artistas">Artistas</a>
        <a href="<%= contexto %>/albuns">Álbuns</a>
        <a href="<%= contexto %>/musicas">Músicas</a>
    </nav>
</aside>

<main class="inicio-conteudo">
    <header class="inicio-topo">
        <form class="inicio-busca" role="search" method="get"
              action="<%= contexto %>/inicio">
            <label for="busca">Buscar na biblioteca</label>
            <input id="busca" name="q" type="search" maxlength="100"
                   placeholder="Artista ou álbum" value="<%= html(busca) %>">
            <button type="submit">Buscar</button>

            <% if (pesquisando) { %>
                <a class="secundario" href="<%= contexto %>/inicio">Limpar</a>
            <% } %>
        </form>
    </header>

    <%-- Quando a pessoa busca, os resultados ganham espaço no topo. --%>
    <% if (!pesquisando) { %>
        <section class="inicio-banner">
            <p class="inicio-rotulo">Sua biblioteca musical</p>
            <h1>O som é seu.</h1>
            <p>Explore seus artistas, álbuns e músicas favoritas.</p>
            <a href="<%= contexto %>/musicas">Abrir biblioteca de músicas</a>
        </section>
    <% } else { %>
        <h1>Resultados da busca</h1>
    <% } %>

    <section class="inicio-secao" aria-labelledby="titulo-artistas">
        <div class="inicio-titulo">
            <h2 id="titulo-artistas">
                <%= pesquisando ? "Artistas encontrados" : "Artistas em destaque" %>
            </h2>
            <a class="secundario" href="<%= contexto %>/artistas">Ver artistas</a>
        </div>

        <% if (destaques.isEmpty()) { %>
            <p>Nenhum artista encontrado.</p>
        <% } else { %>
            <div class="inicio-grade">
                <% for (Artista artista : destaques) {
                    String foto = Arte.foto(artista.getNomeArtistico());
                %>
                    <article class="inicio-card">
                        <% if (foto != null) { %>
                            <img class="inicio-arte" src="<%= contexto %>/img/<%= html(foto) %>"
                                 alt="" loading="lazy">
                        <% } else { %>
                            <span class="inicio-arte" aria-hidden="true">♪</span>
                        <% } %>
                        <h3><%= html(artista.getNomeArtistico()) %></h3>

                        <% if (artista.isVerificado()) { %>
                            <p>Artista verificado</p>
                        <% } %>
                    </article>
                <% } %>
            </div>
        <% } %>
    </section>

    <section class="inicio-secao" aria-labelledby="titulo-albuns">
        <div class="inicio-titulo">
            <h2 id="titulo-albuns">
                <%= pesquisando ? "Álbuns encontrados" : "Álbuns recentes" %>
            </h2>
            <a class="secundario" href="<%= contexto %>/albuns">Ver álbuns</a>
        </div>

        <% if (recentes.isEmpty()) { %>
            <p>Nenhum álbum encontrado.</p>
        <% } else { %>
            <div class="inicio-grade">
                <% for (Album album : recentes) {
                    String imagem = Arte.imagemSegura(album.getImagemUrl());
                    String spotify = Arte.spotify(album.getSpotifyId());
                    String capaSpotify = Arte.capaSpotify(album.getSpotifyCapaUrl());
                %>
                    <article class="inicio-card">
                        <% if (imagem != null) { %>
                            <img class="inicio-arte capa-ravenyx" src="<%= html(imagem) %>"
                                 alt="" loading="lazy" referrerpolicy="no-referrer">
                        <% } else if (spotify != null && capaSpotify != null) { %>
                            <a class="capa-spotify-inicio" href="https://open.spotify.com/album/<%= spotify %>"
                               aria-label="Abrir <%= html(album.getNome()) %> no Spotify">
                                <img class="inicio-arte capa-ravenyx" src="<%= html(capaSpotify) %>"
                                     alt="" loading="lazy" referrerpolicy="no-referrer">
                            </a>
                        <% } else if (spotify != null) { %>
                            <iframe class="spotify-ravenyx"
                                    src="https://open.spotify.com/embed/album/<%= spotify %>"
                                    title="Spotify · <%= html(album.getNome()) %>"
                                    loading="lazy" allow="encrypted-media; fullscreen; picture-in-picture"></iframe>
                        <% } else { %>
                            <span class="inicio-arte" aria-hidden="true">◎</span>
                        <% } %>
                        <h3><%= html(album.getNome()) %></h3>
                        <p><%= html(nomesDosArtistas.get(album.getIdArtista())) %></p>

                        <%-- O link já abre a lista com o álbum selecionado. --%>
                        <a class="secundario"
                           href="<%= contexto %>/musicas?album=<%= album.getIdAlbum() %>">
                            Ver músicas
                        </a>
                    </article>
                <% } %>
            </div>
        <% } %>
    </section>

    <% if (!pesquisando && !avaliados.isEmpty()) { %>
        <section class="inicio-secao" aria-labelledby="titulo-ranking">
            <h2 id="titulo-ranking">Mais bem avaliados</h2>

            <ol class="inicio-ranking">
                <% for (Album album : avaliados) { %>
                    <li>
                        <a href="<%= contexto %>/musicas?album=<%= album.getIdAlbum() %>">
                            <%= html(album.getNome()) %>
                        </a>
                        <span>Nota <%= html(album.getNota()) %></span>
                    </li>
                <% } %>
            </ol>
        </section>
    <% } %>
</main>

</body>
</html>
