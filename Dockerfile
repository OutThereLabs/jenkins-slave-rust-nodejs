FROM openshift/jenkins-slave-base-centos7

ENV CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.31.1 \
    NODE_VERSION=10 \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable"

COPY scl_enable /usr/local/bin/scl_enable

RUN set -eux; \
    yum install -y file openssl-devel; \
    curl https://static.rust-lang.org/rustup/archive/1.16.0/x86_64-unknown-linux-gnu/rustup-init -sSf > /tmp/rustup-init.sh; \
    echo "2d4ddf4e53915a23dda722608ed24e5c3f29ea1688da55aa4e98765fc6223f71 /tmp/rustup-init.sh" | sha256sum -c -; \
    chmod +x /tmp/rustup-init.sh; \
    /tmp/rustup-init.sh -y --no-modify-path --default-toolchain $RUST_VERSION; \
    chmod -R a+w $CARGO_HOME; \
    rm /tmp/rustup-init.sh; \
    yum groupinstall -y --setopt=tsflags=nodocs 'Development Tools'; \
    yum install -y file make openssl-devel libssl-dev; \
    yum install -y centos-release-scl-rh; \
    INSTALL_PKGS="rh-nodejs$NODE_VERSION rh-nodejs$NODE_VERSION-npm rh-nodejs$NODE_VERSION-nodejs-nodemon nss_wrapper"; \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon; \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS; \
    rpm -V $INSTALL_PKGS; \
    yum install -y epel-release; \
    yum install -y jq

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME
    
USER 1001
