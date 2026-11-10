package br.com.sistemamusical.servlet;

import br.com.sistemamusical.dao.AlbumDAO;
import br.com.sistemamusical.dao.ArtistaDAO;
import br.com.sistemamusical.modelo.Album;
import br.com.sistemamusical.modelo.Artista;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@WebServlet({"/inicio", "/Index.html"})
public class InicioServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ArtistaDAO artistaDAO = new ArtistaDAO();
    private final AlbumDAO albumDAO = new AlbumDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String busca = request.getParameter("q");
        busca = busca == null ? "" : busca.strip();

        if (busca.length() > 100) {
            response.sendError(400, "A busca aceita até 100 caracteres.");
            return;
        }

        String termo = normalizar(busca);

        try {
            List<Artista> artistas = artistaDAO.listar();

            // Cada álbum guarda o ID do artista. A página precisa mostrar o nome.
            Map<Integer, String> nomesDosArtistas = new HashMap<>();
            for (Artista artista : artistas) {
                nomesDosArtistas.put(artista.getIdArtista(), artista.getNomeArtistico());
            }

            // Assim, buscar "HIM" também encontra os álbuns do HIM.
            List<Album> albunsEncontrados = albumDAO.listar().stream()
                    .filter(album -> normalizar(album.getNome()).contains(termo)
                            || normalizar(nomesDosArtistas.get(album.getIdArtista()))
                                    .contains(termo))
                    .toList();

            // Na página inicial, os artistas verificados aparecem primeiro.
            List<Artista> destaques = artistas.stream()
                    .filter(artista -> normalizar(artista.getNomeArtistico()).contains(termo))
                    .sorted(Comparator.comparing(Artista::isVerificado).reversed())
                    .limit(termo.isEmpty() ? 3 : 6)
                    .toList();

            // O ID ajuda a mostrar primeiro os álbuns cadastrados por último.
            List<Album> recentes = albunsEncontrados.stream()
                    .sorted(Comparator.comparingInt(Album::getIdAlbum).reversed())
                    .limit(6)
                    .toList();

            // Álbuns sem nota ficam fora do ranking.
            List<Album> avaliados = albunsEncontrados.stream()
                    .filter(album -> album.getNota() != null)
                    .sorted(Comparator.comparingDouble(Album::getNota).reversed())
                    .limit(3)
                    .toList();

            request.setAttribute("busca", busca);
            request.setAttribute("destaques", destaques);
            request.setAttribute("recentes", recentes);
            request.setAttribute("avaliados", avaliados);
            request.setAttribute("nomesDosArtistas", nomesDosArtistas);

            request.getRequestDispatcher("/WEB-INF/views/inicio.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Erro ao carregar a página inicial.", e);
        }
    }

    // Permite encontrar o mesmo resultado digitando "HIM" ou "him".
    private String normalizar(String texto) {
        return texto == null ? "" : texto.toLowerCase(Locale.ROOT);
    }
}
