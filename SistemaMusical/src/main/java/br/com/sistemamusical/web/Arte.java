package br.com.sistemamusical.web;

import java.net.URI;
import java.util.Map;

public final class Arte {
    private static final Map<String, String> FOTOS = Map.of(
            "him", "him.jpg",
            "evanescence", "evanescence.jpg",
            "linkin park", "linkin-park.jpg"
    );

    private Arte() {}

    // A imagem abre no navegador. O servidor só guarda o endereço.
    public static String endereco(String valor) {
        if (valor == null || valor.isBlank()) {
            return null;
        }

        String endereco = valor.strip();
        URI uri = URI.create(endereco);
        if (endereco.length() > 2048 || !"https".equalsIgnoreCase(uri.getScheme())
                || uri.getHost() == null || uri.getRawUserInfo() != null) {
            throw new IllegalArgumentException("Use um endereço HTTPS válido para a imagem.");
        }

        return endereco;
    }

    public static String imagemSegura(String valor) {
        try {
            return endereco(valor);
        } catch (IllegalArgumentException e) {
            return null;
        }
    }

    public static String spotify(String id) {
        return id != null && id.matches("[a-zA-Z0-9]{22}") ? id : null;
    }

    public static String capaSpotify(String url) {
        String imagem = imagemSegura(url);
        if (imagem == null) {
            return null;
        }
        String host = URI.create(imagem).getHost();
        return host.equalsIgnoreCase("i.scdn.co") || host.equalsIgnoreCase("image-cdn-ak.spotifycdn.com")
                || host.equalsIgnoreCase("image-cdn-fa.spotifycdn.com") ? imagem : null;
    }

    public static String foto(String nome) {
        return nome == null ? null : FOTOS.get(nome.strip().toLowerCase(java.util.Locale.ROOT));
    }
}
