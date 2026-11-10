<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.Map, java.util.HashMap" %>
<%@ page import="br.com.sistemamusical.modelo.Album" %>
<%@ page import="br.com.sistemamusical.modelo.Artista" %>
<%@ page import="br.com.sistemamusical.modelo.Musica" %>
<%@ page import="br.com.sistemamusical.dao.MusicaDAO.Genero" %>

<%!
    // Faz títulos com aspas e outros símbolos aparecerem como texto na página.
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
    Musica musica = (Musica) request.getAttribute("musica");
    Integer idEnviado = (Integer) request.getAttribute("idEdicao");
    Integer filtro = (Integer) request.getAttribute("idAlbum");
    String erro = (String) request.getAttribute("erro");

    List<Album> albuns = (List<Album>) request.getAttribute("albuns");
    List<Artista> artistas = (List<Artista>) request.getAttribute("artistas");
    List<Genero> generos = (List<Genero>) request.getAttribute("generos");

    // Mostrar o artista ajuda a distinguir álbuns com o mesmo nome.
    Map<Integer, String> nomesDosArtistas = new HashMap<>();
    for (Artista artista : artistas) {
        nomesDosArtistas.put(artista.getIdArtista(), artista.getNomeArtistico());
    }

    int id = musica == null ? 0 : musica.id();
    if (idEnviado != null) {
        id = idEnviado;
    }

    boolean editando = id > 0;
    String tituloPagina = editando ? "Editar música" : "Nova música";
    String voltar = contexto + "/musicas" + (filtro == null ? "" : "?album=" + filtro);

    Object titulo = null;
    Object faixa = null;
    Object duracao = null;
    Object albumEscolhido = filtro;
    Object generoEscolhido = null;
    String imagemUrl = null;

    // Se o banco recusar o cadastro, a pessoa pode corrigir sem digitar tudo de novo.
    if (idEnviado != null) {
        titulo = request.getParameter("titulo");
        faixa = request.getParameter("faixa");
        duracao = request.getParameter("duracao");
        albumEscolhido = request.getParameter("idAlbum");
        generoEscolhido = request.getParameter("idGenero");
        imagemUrl = request.getParameter("imagemUrl");
    } else if (musica != null) {
        titulo = musica.titulo();
        faixa = musica.faixa();
        duracao = musica.duracaoSegundos();
        albumEscolhido = musica.idAlbum();
        generoEscolhido = musica.idGenero();
        imagemUrl = musica.imagemUrl();
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%= tituloPagina %> · Ravenyx</title>
    <link rel="stylesheet" href="<%= html(contexto) %>/css/style.css">
</head>
<body>
<main class="container form-musica">
    <h1><%= tituloPagina %></h1>
    <nav aria-label="Navegação do cadastro"><a class="voltar" href="<%= html(contexto) %>/inicio">Início</a></nav>

    <% if (erro != null) { %>
        <p class="aviso" role="alert"><%= html(erro) %></p>
    <% } %>

    <% if (albuns.isEmpty()) { %>
        <p>Cadastre um álbum antes de adicionar músicas.</p>
        <a href="<%= html(contexto) %>/albuns?acao=novo">Cadastrar álbum</a>
    <% } else if (generos.isEmpty()) { %>
        <p>Cadastre um gênero musical antes de salvar uma faixa.</p>
    <% } else { %>
        <form class="formulario" method="post" action="<%= html(contexto) %>/musicas">
            <%-- O servlet usa esses campos para identificar a ação e manter o filtro. --%>
            <input type="hidden" name="csrf" value="<%= html(request.getAttribute("csrf")) %>">
            <input type="hidden" name="filtro" value="<%= html(filtro) %>">
            <input type="hidden" name="acao" value="<%= editando ? "atualizar" : "salvar" %>">

            <% if (editando) { %>
                <input type="hidden" name="id" value="<%= id %>">
            <% } %>

            <div>
                <label for="titulo">Título da música</label>
                <input id="titulo" name="titulo" type="text" maxlength="150"
                       value="<%= html(titulo) %>" required>
            </div>

            <div>
                <label for="idAlbum">Álbum</label>
                <select id="idAlbum" name="idAlbum" required>
                    <option value="">Selecione um álbum</option>

                    <% for (Album album : albuns) {
                        String idAlbum = String.valueOf(album.getIdAlbum());
                        boolean selecionado = idAlbum.equals(String.valueOf(albumEscolhido));
                        String artista = nomesDosArtistas.getOrDefault(
                                album.getIdArtista(), "Artista indisponível");
                    %>
                        <option value="<%= idAlbum %>" <%= selecionado ? "selected" : "" %>>
                            <%= html(album.getNome()) %> · <%= html(artista) %>
                        </option>
                    <% } %>
                </select>
            </div>

            <div>
                <label for="idGenero">Gênero musical</label>
                <select id="idGenero" name="idGenero" required>
                    <option value="">Selecione um gênero</option>

                    <% for (Genero genero : generos) {
                        String idGenero = String.valueOf(genero.id());
                        boolean selecionado = idGenero.equals(String.valueOf(generoEscolhido));
                    %>
                        <option value="<%= idGenero %>" <%= selecionado ? "selected" : "" %>>
                            <%= html(genero.nome()) %>
                        </option>
                    <% } %>
                </select>
            </div>

            <div>
                <label for="faixa">Número da faixa</label>
                <input id="faixa" name="faixa" type="number" min="1" max="2147483647"
                       value="<%= html(faixa) %>" required>
            </div>

            <div>
                <label for="duracao">Duração em segundos</label>
                <input id="duracao" name="duracao" type="number" min="1" max="2147483647"
                       value="<%= html(duracao) %>" aria-describedby="dica-duracao" required>
                <small id="dica-duracao">Por exemplo, 3 minutos e 20 segundos são 200 segundos.</small>
            </div>

            <div>
                <label for="imagemUrl">Imagem da música</label>
                <input id="imagemUrl" name="imagemUrl" type="url" maxlength="2048"
                       placeholder="https://..." value="<%= html(imagemUrl) %>"
                       aria-describedby="dica-imagem">
                <small id="dica-imagem">Cole o endereço HTTPS de uma imagem autorizada. Se deixar vazio, a faixa usa a capa do álbum.</small>
            </div>

            <button type="submit"><%= editando ? "Salvar alterações" : "Cadastrar música" %></button>
        </form>
    <% } %>

    <a href="<%= html(voltar) %>">Voltar para músicas</a>
</main>
</body>
</html>
