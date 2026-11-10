package br.com.sistemamusical.servlet;

import br.com.sistemamusical.dao.AlbumDAO;
import br.com.sistemamusical.dao.ArtistaDAO;
import br.com.sistemamusical.modelo.Album;
import br.com.sistemamusical.web.Arte;
import org.postgresql.util.PSQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/albuns")
public class AlbumServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final AlbumDAO albumDAO = new AlbumDAO();
    private final ArtistaDAO artistaDAO = new ArtistaDAO();

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String acao = request.getParameter("acao");

            if ("novo".equals(acao) || "editar".equals(acao)) {

                request.setAttribute(
                    "artistas", artistaDAO.listar()
                );

                if ("editar".equals(acao)) {
                    int id = Integer.parseInt(
                        request.getParameter("id")
                    );

                    Album album = albumDAO.buscar(id);

                    if (album == null) {
                        response.sendError(404,
                            "Álbum não encontrado");
                        return;
                    }

                    request.setAttribute("album", album);
                }

                request.getRequestDispatcher(
                    "/form-album.jsp"
                ).forward(request, response);

            } else {
                request.setAttribute(
                    "albuns", albumDAO.listar()
                );

                request.setAttribute(
                    "artistas", artistaDAO.listar()
                );

                request.getRequestDispatcher(
                    "/albuns.jsp"
                ).forward(request, response);
            }

        } catch (SQLException | IllegalArgumentException e) {
            throw new ServletException(
                "Erro ao consultar álbuns", e
            );
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String acao = request.getParameter("acao");

        try {
            if ("excluir".equals(acao)) {
                int id = Integer.parseInt(
                    request.getParameter("id")
                );

                albumDAO.excluir(id);

            } else {
                Album album = new Album();

                album.setNome(
                    request.getParameter("nome")
                );

                String nota = request.getParameter("nota");

                album.setNota(
                    nota == null || nota.isBlank()
                    ? null : Double.parseDouble(nota)
                );

                album.setIdArtista(
                    Integer.parseInt(
                        request.getParameter("idArtista")
                    )
                );

                boolean editando = "atualizar".equals(acao);
                if (editando) {
                    album.setIdAlbum(
                        Integer.parseInt(
                            request.getParameter("id")
                        )
                    );

                }

                String imagem = request.getParameter("imagemUrl");
                try {
                    album.setImagemUrl(Arte.endereco(imagem));
                } catch (IllegalArgumentException e) {
                    // Mantém os outros campos quando só o endereço da capa precisa de ajuste.
                    album.setImagemUrl(imagem);
                    response.setStatus(400);
                    request.setAttribute("erroImagem", "Use um endereço HTTPS válido para a capa.");
                    request.setAttribute("album", album);
                    request.setAttribute("artistas", artistaDAO.listar());
                    request.getRequestDispatcher("/form-album.jsp").forward(request, response);
                    return;
                }

                if (editando) {
                    albumDAO.editar(album, imagem != null);
                } else {
                    albumDAO.salvar(album);
                }
            }

            response.sendRedirect(
                request.getContextPath() + "/albuns"
            );

        } catch (SQLException | IllegalArgumentException e) {
            // Se o álbum ainda tem músicas, volta para a lista com um aviso.
            if ("excluir".equals(acao)
                    && e instanceof PSQLException erroBanco
                    && erroBanco.getServerErrorMessage() != null
                    && "musica_album_fk".equals(
                            erroBanco.getServerErrorMessage().getConstraint())) {

                response.setStatus(409);
                request.setAttribute("erro",
                        "Este álbum ainda tem músicas. Mova ou exclua as faixas antes de excluir o álbum.");
                doGet(request, response);
                return;
            }

            throw new ServletException("Erro ao salvar ou excluir álbum", e);
        }
    }
}
