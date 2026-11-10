package br.com.sistemamusical.servlet;

import br.com.sistemamusical.dao.AlbumDAO;
import br.com.sistemamusical.dao.ArtistaDAO;
import br.com.sistemamusical.dao.MusicaDAO;
import br.com.sistemamusical.modelo.Musica;
import br.com.sistemamusical.web.Arte;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;

@WebServlet("/musicas")
public class MusicaServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String CHAVE_TOKEN = "ravenyx.csrf.musicas";

    private final MusicaDAO musicaDAO = new MusicaDAO();
    private final AlbumDAO albumDAO = new AlbumDAO();
    private final ArtistaDAO artistaDAO = new ArtistaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // O filtro vem preenchido quando a pessoa clica em "Ver músicas" num álbum.
            Integer idAlbum = lerFiltro(request.getParameter("album"));

            if (idAlbum != null && albumDAO.buscar(idAlbum) == null) {
                response.sendError(404, "Álbum não encontrado.");
                return;
            }

            request.setAttribute("idAlbum", idAlbum);
            String acao = request.getParameter("acao");

            if ("editar".equals(acao)) {
                int id = inteiroPositivo(request.getParameter("id"));
                Musica musica = musicaDAO.buscar(id);

                if (musica == null) {
                    response.sendError(404, "Música não encontrada.");
                    return;
                }

                request.setAttribute("musica", musica);
                mostrarFormulario(request, response);
            } else if ("novo".equals(acao)) {
                mostrarFormulario(request, response);
            } else {
                carregarCatalogo(request);
                request.setAttribute("musicas", musicaDAO.listar(idAlbum));

                request.getRequestDispatcher("/WEB-INF/views/musicas.jsp")
                        .forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            response.sendError(400, "O identificador informado é inválido.");
        } catch (SQLException e) {
            throw new ServletException("Erro ao consultar músicas.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Só aceita alterações enviadas com o código gerado para esta sessão.
        HttpSession sessao = request.getSession(false);
        Object token = sessao == null ? null : sessao.getAttribute(CHAVE_TOKEN);

        if (token == null || !token.equals(request.getParameter("csrf"))) {
            response.sendError(403, "Reabra a página de músicas e tente novamente.");
            return;
        }

        String acao = request.getParameter("acao");

        try {
            Integer idAlbum = lerFiltro(request.getParameter("filtro"));
            request.setAttribute("idAlbum", idAlbum);

            if ("excluir".equals(acao)) {
                int id = inteiroPositivo(request.getParameter("id"));

                if (!musicaDAO.excluir(id)) {
                    response.sendError(404, "Música não encontrada.");
                    return;
                }
            } else if ("salvar".equals(acao) || "atualizar".equals(acao)) {
                // O DAO usa o ID zero para saber que a faixa é nova.
                int id = "atualizar".equals(acao)
                        ? inteiroPositivo(request.getParameter("id"))
                        : 0;

                request.setAttribute("idEdicao", id);

                if (!salvarMusica(request, response, id)) {
                    return;
                }

                // Se a pessoa estava vendo um álbum, mostra onde a faixa ficou.
                if (idAlbum != null) {
                    idAlbum = inteiroPositivo(request.getParameter("idAlbum"));
                }
            } else {
                response.sendError(400, "Ação inválida.");
                return;
            }

            // Depois de salvar, atualizar a página só recarrega a lista.
            String destino = request.getContextPath() + "/musicas";

            if (idAlbum != null) {
                destino += "?album=" + idAlbum;
            }

            response.sendRedirect(destino);
        } catch (IllegalArgumentException e) {
            response.sendError(400, "O identificador informado é inválido.");
        } catch (SQLException e) {
            throw new ServletException("Erro ao salvar ou excluir música.", e);
        }
    }

    private boolean salvarMusica(
            HttpServletRequest request, HttpServletResponse response, int id)
            throws SQLException, ServletException, IOException {

        String erro;
        int status;

        String imagem;
        try {
            imagem = Arte.endereco(request.getParameter("imagemUrl"));
        } catch (IllegalArgumentException e) {
            response.setStatus(400);
            request.setAttribute("erro", "Use um endereço HTTPS válido para a imagem da faixa.");
            mostrarFormulario(request, response);
            return false;
        }

        try {
            // A tela ajuda a preencher, mas o servidor também precisa conferir os dados.
            String titulo = request.getParameter("titulo");
            titulo = titulo == null ? "" : titulo.strip();

            if (titulo.isEmpty() || titulo.codePointCount(0, titulo.length()) > 150
                    || titulo.indexOf('\0') >= 0) {
                throw new IllegalArgumentException();
            }

            Musica musica = new Musica(
                    id,
                    titulo,
                    inteiroPositivo(request.getParameter("faixa")),
                    inteiroPositivo(request.getParameter("duracao")),
                    inteiroPositivo(request.getParameter("idAlbum")),
                    inteiroPositivo(request.getParameter("idGenero")),
                    imagem,
                    null,
                    null
            );

            if (!musicaDAO.salvar(musica)) {
                response.sendError(404, "Música não encontrada.");
                return false;
            }

            return true;
        } catch (IllegalArgumentException e) {
            status = 400;
            erro = "Informe um título de até 150 caracteres, uma faixa e uma "
                    + "duração maiores que zero. Selecione também o álbum e o gênero.";
        } catch (SQLException e) {
            // O banco impede faixa repetida no mesmo álbum e vínculos que deixaram de existir.
            status = 409;

            if ("23505".equals(e.getSQLState())) {
                erro = "Esse número de faixa já está em uso neste álbum.";
            } else if ("23503".equals(e.getSQLState())) {
                erro = "O álbum ou o gênero selecionado não está mais disponível.";
            } else {
                throw e;
            }
        }

        // Abre o mesmo formulário para a pessoa corrigir o que digitou.
        response.setStatus(status);
        request.setAttribute("erro", erro);
        mostrarFormulario(request, response);
        return false;
    }

    private void carregarCatalogo(HttpServletRequest request) throws SQLException {
        request.setAttribute("albuns", albumDAO.listar());
        request.setAttribute("artistas", artistaDAO.listar());
        request.setAttribute("generos", musicaDAO.listarGeneros());

        // Usa o mesmo código nas páginas de músicas abertas durante a sessão.
        HttpSession sessao = request.getSession();

        synchronized (sessao) {
            Object token = sessao.getAttribute(CHAVE_TOKEN);

            if (token == null) {
                token = UUID.randomUUID().toString();
                sessao.setAttribute(CHAVE_TOKEN, token);
            }

            request.setAttribute("csrf", token);
        }
    }

    private void mostrarFormulario(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        carregarCatalogo(request);

        request.getRequestDispatcher("/WEB-INF/views/form-musica.jsp")
                .forward(request, response);
    }

    private Integer lerFiltro(String valor) {
        return valor == null || valor.isBlank() ? null : inteiroPositivo(valor);
    }

    private int inteiroPositivo(String valor) {
        int numero = Integer.parseInt(valor);

        if (numero <= 0) {
            throw new IllegalArgumentException();
        }

        return numero;
    }
}
