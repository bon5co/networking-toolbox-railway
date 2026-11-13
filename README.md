# networking-toolbox-railway

Railway wrapper for [Networking Toolbox](https://github.com/Lissy93/networking-toolbox) (MIT). It runs the upstream image unchanged behind an nginx gateway that requires HTTP Basic auth (user `admin`, password from `TOOLBOX_PASSWORD`) on every path except `/health`, and binds Railway's injected `PORT`.

Image: `ghcr.io/bon5co/networking-toolbox-railway:1.6.0`, built from `lissy93/networking-toolbox:1.6.0` pinned by digest.
