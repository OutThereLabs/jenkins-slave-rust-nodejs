FROM openshift/jenkins-slave-base-centos7

ENV RUST_VERSION=1.30.0 \
    CARGO_HOME=$HOME/.cargo \
    PATH=$HOME/.cargo/bin:$PATH \
    NODE_VERSION=8 \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable"

COPY scl_enable /usr/local/bin/scl_enable

RUN set -x && \
    yum install -y file make gcc-c++ openssl-devel postgresql-devel && \
    curl -sSf https://static.rust-lang.org/rustup.sh > /tmp/rustup.sh && \
    chmod +x /tmp/rustup.sh && \
    /tmp/rustup.sh  --disable-sudo --yes --revision="1.30.0" && \
    rm /tmp/rustup.sh && \
    yum groupinstall -y --setopt=tsflags=nodocs 'Development Tools' && \
    yum install -y file make openssl-devel libssl-dev && \
    yum install -y centos-release-scl-rh && \
    INSTALL_PKGS="rh-nodejs$NODE_VERSION rh-nodejs$NODE_VERSION-npm rh-nodejs$NODE_VERSION-nodejs-nodemon nss_wrapper" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum install -y epel-release && \
    yum install -y jq && \
    yum clean all -y

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME
    
USER 1001
