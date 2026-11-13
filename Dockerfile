# Networking Toolbox for Railway.
#
# Networking Toolbox (github.com/Lissy93/networking-toolbox, MIT) is a SvelteKit app of 100+ networking tools (subnet and CIDR
# maths, IP conversion, DNS, DNSSEC, RDAP, TLS, CT log) with a JSON API under /api. This wrapper keeps the upstream image and
# application unchanged and adds what a public Railway deploy driven by an agent needs.
#
# 1. Upstream has no authentication at all. Its /api/internal/diagnostics routes make the server dial out on the caller's behalf
#    (DNS queries, TCP port checks, HTTP pings, zone-transfer attempts), so a bare public domain is an open probing relay on the
#    deployer's bill. An nginx gateway on Railway's port requires HTTP Basic auth on every path except /health, with a password
#    generated per deploy (TOOLBOX_PASSWORD). The entrypoint refuses to start without one.
# 2. The app listens on its own PORT (3000); the gateway owns the injected PORT and the app is bound to 127.0.0.1.
# 3. The app is stateless (settings and bookmarks live in the browser), so there is no volume.
#
# upstream: Lissy93/networking-toolbox newest release v1.6.0 (2025-11-16), checked 2026-11-13
FROM lissy93/networking-toolbox:1.6.0@sha256:4e97330fb310e1a5fbe185b1bf859270902ddef7934b88cecc6b3def98d21eaa

USER root
RUN apk add --no-cache nginx
COPY nginx.conf.template /etc/nginx-railway.conf.template
COPY railway-entrypoint.sh /usr/local/bin/railway-entrypoint.sh
RUN chmod +x /usr/local/bin/railway-entrypoint.sh
USER sveltekit

EXPOSE 8080
ENTRYPOINT ["/sbin/tini","--","/usr/local/bin/railway-entrypoint.sh"]
