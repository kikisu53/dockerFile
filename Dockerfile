FROM ghcr.io/mileschou/php-tester@sha256:c8a192435e9aa62ad3e2885c0c733d1916a8c286849fdbfd4813ade221fe4b77

ARG GITHUB_ACCESS_TOKEN

WORKDIR /var/www/html

RUN composer config -g github-oauth.github.com ${GITHUB_ACCESS_TOKEN}

ENTRYPOINT ["./scripts/entry"]

CMD ["start"]