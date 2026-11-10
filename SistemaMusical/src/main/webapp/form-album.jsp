<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, br.com.sistemamusical.modelo.*" %>

<%!
    String escapar(String texto) {
        if (texto == null) return "";
        return texto.replace("&", "&amp;").replace("<", "&lt;")
                    .replace(">", "&gt;").replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    Album album = (Album) request.getAttribute("album");

    @SuppressWarnings("unchecked")
    List<Artista> artistas = (List<Artista>) request.getAttribute("artistas");

    boolean editando = album != null && album.getIdAlbum() > 0;
    String caminho = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%= editando ? "Editar álbum" : "Novo álbum" %></title>
    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            background: #17171f;
            color: #fff;
            font-family: Arial, sans-serif;
            padding: 50px 20px;
        }

        .container {
            max-width: 550px;
            margin: auto;
            padding: 32px;
            background: #242430;
            border-radius: 12px;
        }

        h1 { color: #b388ff; }

        label {
            display: block;
            margin: 20px 0 8px;
        }

        input, select {
            width: 100%;
            padding: 12px;
            border: 1px solid #555;
            border-radius: 6px;
            background: #17171f;
            color: white;
            font: inherit;
        }

        .botoes {
            display: flex;
            gap: 12px;
            margin-top: 25px;
            flex-wrap: wrap;
        }

        button, .voltar {
            padding: 12px 18px;
            border: 0;
            border-radius: 6px;
            color: white;
            font: inherit;
            text-decoration: none;
            cursor: pointer;
        }

        button { background: #7c3aed; }
        .voltar { background: #444454; }
    </style>
</head>
<body>
    <main class="container">
        <h1><%= editando ? "Editar álbum" : "Cadastrar álbum" %></h1>
        <nav aria-label="Navegação do cadastro"><a class="voltar" href="<%= caminho %>/inicio">Início</a></nav>
        <% if (request.getAttribute("erroImagem") != null) { %>
            <p role="alert"><%= escapar((String) request.getAttribute("erroImagem")) %></p>
        <% } %>

        <form action="<%= caminho %>/albuns" method="post">
            <input type="hidden" name="acao"
                   value="<%= editando ? "atualizar" : "salvar" %>">

            <% if (editando) { %>
                <input type="hidden" name="id"
                       value="<%= album.getIdAlbum() %>">
            <% } %>

            <label for="nome">Nome do álbum</label>
            <input id="nome" name="nome" type="text" maxlength="150"
                   value="<%= album != null ? escapar(album.getNome()) : "" %>"
                   required>

            <label for="nota">Nota (0 a 10)</label>
            <input id="nota" name="nota" type="number"
                   min="0" max="10" step="0.1"
                   value="<%= album != null && album.getNota() != null ? album.getNota() : "" %>">

            <label for="artista">Artista</label>
            <select id="artista" name="idArtista" required>
                <option value="">Selecione um artista</option>
                <% if (artistas != null) {
                    for (Artista artista : artistas) { %>
                    <option value="<%= artista.getIdArtista() %>"
                        <%= album != null && album.getIdArtista() == artista.getIdArtista()
                            ? "selected" : "" %>>
                        <%= escapar(artista.getNomeArtistico()) %>
                    </option>
                <%  }
                   } %>
            </select>

            <%-- O endereço é opcional. A edição oficial continua disponível quando existe. --%>
            <label for="imagemUrl">Imagem do álbum</label>
            <input id="imagemUrl" name="imagemUrl" type="url" maxlength="2048"
                   placeholder="https://..." aria-describedby="dica-capa"
                   value="<%= album == null ? "" : escapar(album.getImagemUrl()) %>">
            <small id="dica-capa">Cole o endereço HTTPS de uma imagem que você pode usar.</small>

            <div class="botoes">
                <button type="submit">
                    <%= editando ? "Salvar alterações" : "Cadastrar álbum" %>
                </button>
                <a class="voltar" href="<%= caminho %>/albuns">Voltar</a>
            </div>
        </form>
    </main>
</body>
</html>
