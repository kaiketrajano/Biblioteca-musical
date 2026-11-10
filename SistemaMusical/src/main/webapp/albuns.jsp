
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="br.com.sistemamusical.modelo.Album" %>
<%@ page import="br.com.sistemamusical.modelo.Artista" %>
<%@ page import="br.com.sistemamusical.web.Arte" %>

<%!
    public String escapar(String texto) {
        if (texto == null) return "";
        return texto.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>


<%
    @SuppressWarnings("unchecked")
    List<Album> albuns =
        (List<Album>) request.getAttribute("albuns");

    @SuppressWarnings("unchecked")
    List<Artista> artistas =
        (List<Artista>) request.getAttribute("artistas");

    String contexto = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Álbuns - Sistema Musical</title>

    <style>
        * { box-sizing: border-box; }

        body {
            background: #17171f;
            color: white;
            font-family: Arial, sans-serif;
            padding: 40px 20px;
        }

        .container {
            max-width: 1050px;
            margin: auto;
        }

        h1 { color: #b388ff; }

        .menu {
            display: flex;
            gap: 12px;
            margin: 25px 0;
            flex-wrap: wrap;
        }

        a, button {
            background: #7c3aed;
            color: white;
            border: none;
            padding: 11px 16px;
            border-radius: 6px;
            text-decoration: none;
            cursor: pointer;
            font: inherit;
        }

        a:hover, button:hover {
            opacity: 0.85;
        }

        .secundario { background: #444454; }
        .excluir { background: #b91c1c; }

        table {
            width: 100%;
            border-collapse: collapse;
            background: #242430;
            margin-top: 25px;
        }

        th, td {
            padding: 16px;
            border-bottom: 1px solid #444;
            text-align: left;
        }

        th { color: #c4a1ff; }

        .acoes {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .acoes form { margin: 0; }

        .tabela {
            overflow-x: auto;
        }

        /* A miniatura mantém a capa inteira ao lado do nome do álbum. */
        .album-com-capa {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .album-com-capa a {
            display: inline-flex;
            padding: 0;
            background: transparent;
        }

        .album-com-capa img {
            width: 48px;
            height: 48px;
            border-radius: 8px;
            object-fit: contain;
        }

        
		        /* A confirmação e o aviso usam a mesma caixa. */
		.janela-album {
		    width: min(440px, calc(100% - 32px));
		    box-sizing: border-box;
		    padding: 24px;
		    border: 1px solid #5c466e;
		    border-radius: 16px;
		    background: #242130;
		    color: #f5f5f7;
		    box-shadow: 0 16px 48px rgba(0, 0, 0, 0.4);
		}
		
		/* Escurece a página sem esconder a lista de álbuns. */
		.janela-album::backdrop {
		    background: rgba(8, 6, 13, 0.7);
		}
		
		.janela-album h2 {
		    margin: 0 0 12px;
		}
		
		.janela-album p {
		    margin: 0 0 20px;
		    color: #ddd5e6;
		    line-height: 1.5;
		    overflow-wrap: anywhere;
		}
		
		.janela-album .acoes {
		    justify-content: flex-end;
		    flex-wrap: wrap;
		    gap: 12px;
		}
		
		.janela-album button:focus-visible {
		    outline: 2px solid #e5bdff;
		    outline-offset: 3px;
		}
    </style>
</head>

<body>
<div class="container">

    <h1>Álbuns cadastrados</h1>
    <p>Gerenciamento de álbuns do Sistema Musical</p>
	<%-- Só abre esta caixa quando o banco bloqueia a exclusão do álbum. --%>
	<%
	    String aviso = (String) request.getAttribute("erro");
	    if (aviso != null) {
	%>
	    <dialog id="aviso-exclusao-album" class="janela-album"
	            aria-labelledby="titulo-aviso-album"
	            aria-describedby="mensagem-aviso-album">
	        <h2 id="titulo-aviso-album">Álbum não excluído</h2>
	        <p id="mensagem-aviso-album"><%= escapar(aviso) %></p>
	
	        <form method="dialog" class="acoes">
	            <button type="submit" autofocus>Concluido</button>
	        </form>
	    </dialog>
	
	    <script>
	        // Abre o aviso assim que a lista volta.
	        document.getElementById("aviso-exclusao-album").showModal();
	    </script>
	<% } %>
    <div class="menu">
        <a class="secundario" href="<%= contexto %>/inicio">Início</a>
        <a href="<%= contexto %>/albuns?acao=novo">
            + Novo Álbum
        </a>

        <a class="secundario"
           href="<%= contexto %>/artistas">
            Ver Artistas
        </a>
    </div>

    <div class="tabela">
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Álbum</th>
                <th>Artista</th>
                <th>Nota</th>
                <th>Ações</th>
            </tr>
        </thead>

        <tbody>
        <% if (albuns != null) {
            for (Album album : albuns) {

                String nomeArtista = "Desconhecido";
                String imagem = Arte.imagemSegura(album.getImagemUrl());
                String spotify = null;
                if (imagem == null) {
                    spotify = Arte.spotify(album.getSpotifyId());
                    imagem = Arte.capaSpotify(album.getSpotifyCapaUrl());
                }

                if (artistas != null) {
                    for (Artista artista : artistas) {
                        if (artista.getIdArtista()
                                == album.getIdArtista()) {
                            nomeArtista = artista.getNomeArtistico();
                            break;
                        }
                    }
                }
        %>

            <tr>
                <td><%= album.getIdAlbum() %></td>
                <td>
                    <span class="album-com-capa">
                        <% if (imagem != null && spotify != null) { %>
                            <a href="https://open.spotify.com/album/<%= spotify %>"
                               aria-label="Abrir <%= escapar(album.getNome()) %> no Spotify">
                                <img src="<%= escapar(imagem) %>" alt="" loading="lazy" referrerpolicy="no-referrer">
                            </a>
                        <% } else if (imagem != null) { %>
                            <img src="<%= escapar(imagem) %>" alt="" loading="lazy" referrerpolicy="no-referrer">
                        <% } %>
                        <span><%= escapar(album.getNome()) %></span>
                    </span>
                </td>
                <td><%= escapar(nomeArtista) %></td>
                <td>
                    <%= album.getNota() != null
                        ? album.getNota() : "Sem nota" %>
                </td>

                <td>
                    <div class="acoes">

                        <a href="<%= contexto %>/albuns?acao=editar&id=<%= album.getIdAlbum() %>">
                            Editar
                        </a>
                        
                        <%-- Abre a lista de músicas com este álbum já selecionado. --%>
						<a class="secundario"
						   href="<%= contexto %>/musicas?album=<%= album.getIdAlbum() %>">
						    Ver músicas
						</a>

                        <form action="<%= contexto %>/albuns"
						      method="post"
						      data-album="<%= escapar(album.getNome()) %>"
						      onsubmit="return abrirConfirmacaoAlbum(this)">

                            <input type="hidden"
                                   name="acao" value="excluir">

                            <input type="hidden"
                                   name="id"
                                   value="<%= album.getIdAlbum() %>">

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

</div>
<%-- A mesma caixa de confirmação é usada para todos os álbuns. --%>
<dialog id="confirmar-album" class="janela-album"
        aria-labelledby="titulo-confirmacao"
        aria-describedby="texto-confirmacao">
    <h2 id="titulo-confirmacao">Excluir álbum?</h2>
    <p id="texto-confirmacao">
        Você quer excluir <strong id="album-escolhido"></strong>?
    </p>

    <form method="dialog" class="acoes">
        <button type="submit" value="cancelar" class="secundario" autofocus>
            Cancelar
        </button>
        <button type="submit" value="excluir" class="excluir">
            Excluir álbum
        </button>
    </form>
</dialog>

<script>
    const caixaDeConfirmacao = document.getElementById("confirmar-album");
    let formularioDoAlbum = null;

    function abrirConfirmacaoAlbum(formulario) {
        formularioDoAlbum = formulario;

        // Mostra o nome como texto, mesmo que ele tenha aspas ou outros sinais.
        document.getElementById("album-escolhido").textContent =
                formulario.dataset.album;

        caixaDeConfirmacao.returnValue = "cancelar";
        caixaDeConfirmacao.showModal();

        return false;
    }

    caixaDeConfirmacao.addEventListener("close", function () {
        // Cancelar ou apertar Esc fecha a caixa sem enviar o formulário.
        if (caixaDeConfirmacao.returnValue === "excluir" && formularioDoAlbum) {
            formularioDoAlbum.submit();
        }

        formularioDoAlbum = null;
    });
</script>
</body>
</html>
