FROM openjdk:8
MAINTAINER Steven Wade <steven@stevenwade.co.uk>

ENV GOCD_VERSION 17.4.0-4892
ENV GOCD_DISTR go-server.deb

# Install go.cd server
RUN curl -fSL https://download.gocd.io/binaries/${GOCD_VERSION}/deb/go-server_${GOCD_VERSION}_all.deb -o $GOCD_DISTR \
    && dpkg -i $GOCD_DISTR \
    && rm $GOCD_DISTR

VOLUME /var/lib/go-server

RUN apt-get update && apt-get install -y yum-utils

# Install plugins
RUN mkdir -p /home/go/plugins

RUN curl -fSL "https://github.com/gocd-contrib/script-executor-task/releases/download/0.2/script-executor-0.2.jar" \
    -o /home/go/plugins/script-executor-plugin.jar

RUN curl -fSL "https://github.com/gocd-contrib/gocd-oauth-login/releases/download/v2.3/github-oauth-login-2.3.jar" \
    -o /home/go/plugins/github-oauth-login.jar

RUN curl -fSL "https://github.com/gocd-contrib/gocd-oauth-login/releases/download/v2.3/gitlab-oauth-login-2.3.jar" \
    -o /home/go/plugins/gitlab-oauth-login.jar

RUN curl -fSL "https://github.com/gocd-contrib/gocd-oauth-login/releases/download/v2.3/google-oauth-login-2.3.jar" \
    -o /home/go/plugins/google-oauth-login.jar

RUN curl -fSL "https://github.com/tomzo/gocd-json-config-plugin/releases/download/0.2.0/json-config-plugin-0.2.jar" \
    -o /home/go/plugins/json-config-plugin.jar

RUN chown -R go:go /home/go/plugins/

# Adding the entrypoint script to run GoCD
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# Expose the HTTP (8153) and HTTPS (8154) ports
EXPOSE 8153 8154
CMD ["go-server"]