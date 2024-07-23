FROM node:alpine

RUN apk add --no-cache tini git  \
    && yarn global add git-http-server  \
    && adduser -D -g git git

USER git

WORKDIR /home/git

RUN which git-http-server

RUN git init --bare repository.git \
    && git config --global user.name "FuShaoyu" \
    && git config --global user.email "2201226@sit.singaporetech.edu.sg"

ENTRYPOINT ["tini", "--", "git-http-server", "-p", "3000", "/home/git"]


CMD ["git-http-server", "/home/git/repository.git"]