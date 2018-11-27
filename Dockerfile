FROM openshift/jenkins-slave-base-centos7

ENV RUST_VERSION=1.26.2 \
    NODE_VERSION=8 \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable"

COPY scl_enable /usr/local/bin/scl_enable

RUN yum groupinstall -y --setopt=tsflags=nodocs 'Development Tools' && \
    yum install -y file make openssl-devel && \
    yum install -y centos-release-scl-rh && \
    INSTALL_PKGS="rh-nodejs$NODE_VERSION rh-nodejs$NODE_VERSION-npm rh-nodejs$NODE_VERSION-nodejs-nodemon nss_wrapper rust-toolset-7-$RUST_VERSION" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y
    
RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME
    
USER 1001
