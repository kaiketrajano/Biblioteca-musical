package br.com.sistemamusical.servlet;

import br.com.sistemamusical.dao.ArtistaDAO;
import br.com.sistemamusical.modelo.Artista;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/artistas")
public class ArtistaServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ArtistaDAO dao = new ArtistaDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String acao = request.getParameter("acao");

            if ("editar".equals(acao)) {
                int id = Integer.parseInt(
                    request.getParameter("id")
                );

                Artista artista = dao.buscar(id);
                request.setAttribute("artista", artista);

                request.getRequestDispatcher(
                    "/form-artista.jsp"
                ).forward(request, response);

            } else {
                List<Artista> artistas = dao.listar();
                request.setAttribute("artistas", artistas);

                request.getRequestDispatcher(
                    "/artistas.jsp"
                ).forward(request, response);
            }

        } catch (SQLException | NumberFormatException e) {
            throw new ServletException(
                "Erro ao consultar artistas", e
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String acao = request.getParameter("acao");

        try {
            if ("excluir".equals(acao)) {
                int id = Integer.parseInt(
                    request.getParameter("id")
                );
                dao.excluir(id);

            } else {
                Artista artista = new Artista();

                artista.setNomeArtistico(
                    request.getParameter("nomeArtistico")
                );

                artista.setBiografia(
                    request.getParameter("biografia")
                );

                String data = request.getParameter(
                    "dataCriacao"
                );

                if (data != null && !data.isBlank()) {
                    artista.setDataCriacao(
                        LocalDate.parse(data)
                    );
                }

                artista.setVerificado(
                    "on".equals(
                        request.getParameter("verificado")
                    )
                );

                if ("atualizar".equals(acao)) {
                    artista.setIdArtista(
                        Integer.parseInt(
                            request.getParameter("id")
                        )
                    );

                    dao.editar(artista);
                } else {
                    dao.salvar(artista);
                }
            }

            response.sendRedirect(
                request.getContextPath() + "/artistas"
            );

        } catch (SQLException |
                 IllegalArgumentException e) {
            throw new ServletException(
                "Erro ao salvar ou excluir artista", e
            );
        }
    }
}
