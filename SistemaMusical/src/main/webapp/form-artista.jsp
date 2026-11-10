<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="br.com.sistemamusical.modelo.Artista" %>
<%
    Artista artista = (Artista) request.getAttribute("artista");
    boolean editando = artista != null;
    String contexto = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title><%= editando ? "Editar Artista" : "Novo Artista" %></title>
    <style>
        * { box-sizing: border-box; }

        body {
            background: #17171f;
            color: white;
            font-family: Arial, sans-serif;
            padding: 50px 20px;
        }

        .container {
            max-width: 600px;
            margin: auto;
            background: #242430;
            padding: 32px;
            border-radius: 12px;
        }

        h1 { color: #b388ff; }

        label {
            display: block;
            margin: 18px 0 8px;
        }

        input[type="text"],
        input[type="date"],
        textarea {
            width: 100%;
            padding: 12px;
            background: #17171f;
            color: white;
            border: 1px solid #555;
            border-radius: 6px;
            font: inherit;
        }

        textarea {
            min-height: 110px;
            resize: vertical;
        }

        .verificado {
            margin: 20px 0;
        }

        button, .voltar {
            display: inline-block;
            background: #7c3aed;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 6px;
            text-decoration: none;
            cursor: pointer;
            font: inherit;
        }

        .voltar { background: #555; }
    </style>
</head>
<body>
<div class="container">

    <h1><%= editando ? "Editar Artista" : "Cadastrar Artista" %></h1>
    <nav aria-label="Navegação do cadastro"><a class="voltar" href="<%= contexto %>/inicio">Início</a></nav>

    <form action="<%= contexto %>/artistas" method="post">

        <input type="hidden" name="acao"
               value="<%= editando ? "atualizar" : "salvar" %>">

        <% if (editando) { %>
            <input type="hidden" name="id"
                   value="<%= artista.getIdArtista() %>">
        <% } %>

        <label for="nome">Nome artístico</label>
        <input type="text" id="nome" name="nomeArtistico"
               maxlength="150" required
               value="<%= editando ? artista.getNomeArtistico() : "" %>">

        <label for="biografia">Biografia</label>
        <textarea id="biografia" name="biografia"
                  maxlength="1000"><%= editando && artista.getBiografia() != null
                  ? artista.getBiografia() : "" %></textarea>

        <label for="data">Data de criação</label>
        <input type="date" id="data" name="dataCriacao"
               value="<%= editando && artista.getDataCriacao() != null
               ? artista.getDataCriacao() : "" %>">

        <div class="verificado">
            <label>
                <input type="checkbox" name="verificado"
                       <%= editando && artista.isVerificado()
                       ? "checked" : "" %>>
                Artista verificado
            </label>
        </div>

        <button type="submit">
            <%= editando ? "Salvar alterações" : "Cadastrar artista" %>
        </button>

        <a class="voltar" href="<%= contexto %>/artistas">
            Voltar
        </a>

    </form>
</div>
</body>
</html>
