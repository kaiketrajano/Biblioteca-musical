<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="br.com.sistemamusical.modelo.Artista" %>


<%
    @SuppressWarnings("unchecked")
    List<Artista> artistas =
        (List<Artista>) request.getAttribute("artistas");
%>


<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Artistas - Sistema Musical</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    
</head>

<body>
<div class="container">

    <h1>Artistas cadastrados</h1>

    <p>Gerenciamento de artistas do Sistema Musical</p>

    

<div class="menu">
    <a class="secundario" href="<%= request.getContextPath() %>/inicio">Início</a>
    <a href="<%= request.getContextPath() %>/form-artista.jsp">
        + Novo Artista
    </a>

    <a href="<%= request.getContextPath() %>/albuns"
       class="btn-albuns">
        Ver Álbuns
    </a>
</div>



    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Artista</th>
                <th>Verificado</th>
                <th>Ações</th>
            </tr>
        </thead>

        <tbody>
        <% if (artistas != null) {
            for (Artista artista : artistas) { %>

            <tr>
                <td><%= artista.getIdArtista() %></td>
                <td><%= artista.getNomeArtistico() %></td>
                <td><%= artista.isVerificado() ? "Sim" : "Não" %></td>
                <td>
                    <div class="acoes">
                        <a href="<%= request.getContextPath() %>/artistas?acao=editar&id=<%= artista.getIdArtista() %>">
                            Editar
                        </a>

                        <form action="<%= request.getContextPath() %>/artistas"
                              method="post"
                              onsubmit="return confirm('Deseja excluir este artista?');">

                            <input type="hidden" name="acao" value="excluir">
                            <input type="hidden" name="id"
                                   value="<%= artista.getIdArtista() %>">

                            <button type="submit" class="excluir">
                                Excluir
                            </button>
                        </form>
                    </div>
                </td>
            </tr>

        <%  }
           } %>
        </tbody>
    </table>

</div>
</body>
</html>
