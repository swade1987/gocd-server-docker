FROM gocd/gocd-server:v17.6.0
MAINTAINER Steve Wade <steven@stevenwade.co.uk>

ARG git_repository="Unknown"
ARG git_commit="Unknown"
ARG git_branch="Unknown"
ARG built_on="Unknown"

LABEL git.repository=$git_repository
LABEL git.commit=$git_commit
LABEL git.branch=$git_branch
LABEL build.dockerfile=/Dockerfile
LABEL build.on=$built_on

COPY ./Dockerfile /Dockerfile

RUN apk update && apk add apache2-utils

ENV TINI_SUBREAPER=true
ADD custom-boot.sh /usr/local/bin/
CMD ["custom-boot.sh"]