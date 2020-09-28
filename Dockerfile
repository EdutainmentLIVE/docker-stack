FROM amazonlinux:2.0.20200722.0

# GHC version should match the LTS version, otherwise the path will not have the correct ghc version
ARG GHC_VERSION=8.8.4
ARG LTS_VERSION=lts-16.15
ARG STACK_VERSION=2.5.0.1

ARG ITPROTV_ROOT=/home/itprotv
ARG STACK_ROOT=$ITPROTV_ROOT/.stack

ENV LANG=C.UTF-8 \
  LC_ALL=C.UTF-8 \
  PATH=$STACK_ROOT/programs/x86_64-linux/ghc-$GHC_VERSION/bin:$PATH \
  STACK_ROOT=$STACK_ROOT

RUN yum update -y \
  && yum install -y \
    gcc \
    git \
    gmp-devel \
    gzip \
    make \
    nc \
    ncurses-devel \
    netcat-openbsd \
    perl \
    postgresql-client-11 \
    postgresql-devel \
    procps \
    tar \
    wget \
    xz \
    xz-devel \
    zip \
    zlib-devel \
  && yum clean all \
  && rm -rf /var/cache/yum

RUN mkdir -p $STACK_ROOT \
  && echo "system-ghc: true" >$STACK_ROOT/config.yaml \
  && echo "recommend-stack-upgrade: false" >>$STACK_ROOT/config.yaml \
  && echo "allow-different-user: true" >>$STACK_ROOT/config.yaml \
  && echo "local-bin-path: /usr/bin" >>$STACK_ROOT/config.yaml \
  && mkdir -p $ITPROTV_ROOT/tmp \
  && cd $ITPROTV_ROOT/tmp \
  && wget --output-document stack.tgz --no-verbose "https://github.com/commercialhaskell/stack/releases/download/v$STACK_VERSION/stack-$STACK_VERSION-linux-x86_64.tar.gz" \
  && tar --extract --file stack.tgz --strip-components 1 --wildcards '*/stack' \
  && rm stack.tgz \
  && mv stack /usr/local/bin/ \
  && cd .. && rm -r $ITPROTV_ROOT/tmp

# Install ghc/lts
RUN stack setup --resolver=$LTS_VERSION

# Cache hackage index
RUN stack update

# The cached dependencies are done in a hopefully hierarchichal way:
# - Common haskell libraries that may not necessarily be used by our application are installed first
# - The dependencies that will almost never change or require hacking are installed first
# - Some known dependencies that take a long time will be built separately to avoid recompiling a
#   lot of stuff.
# - The custom stack yaml is added after the common libraries are install so that modifying it does
#   not rebuild the common libraries. Beware that if the stack.yaml overrides one of these libraries
#   the cache will duplicate them and some space will be lost.
# - The application libraries will be installed in one gulp. Changing one will cause a full rebuild
#   but there's no easy way to cache this correctly otherwise.
# - The commonly used binaries for development are installed last (so we can add new tools without
#   rebuilding everything)

# Common Haskell libraries
RUN stack build \
      alex \
      base \
      fsnotify \
      happy \
      hscolour \
      say

# Common Application dependencies
RUN stack build \
      async \
      bytestring \
      directory \
      exceptions \
      filepath \
      network \
      network-uri \
      process \
      random \
      scientific \
      template-haskell \
      text \
      time \
      uuid \
      vector

# Known slow dependencies
RUN stack build \
      ghc-lib-parser \
      haskell-src-exts \
      tls

# Copy stack.yaml with overriden packages and extra-deps
COPY stack.yaml $ITPROTV_ROOT/stack.yaml.partial

# Clone extra dependencies
RUN cat $ITPROTV_ROOT/stack.yaml.partial >> $ITPROTV_ROOT/.stack/global-project/stack.yaml \
  && rm $ITPROTV_ROOT/stack.yaml.partial \
  && stack update

# Prebuild application dependencies. You may see precache contain these dependencies, that's fine.
RUN stack build \
      aeson \
      aeson-pretty \
      aeson-qq \
      AesonBson \
      amazonka \
      amazonka-cloudwatch \
      amazonka-cloudwatch-events \
      amazonka-core \
      amazonka-lambda \
      amazonka-s3 \
      amazonka-sns \
      amazonka-sqs \
      amazonka-sts \
      async \
      attoparsec \
      autoexporter \
      base-noprelude \
      base64-bytestring \
      bcrypt \
      brittany \
      bson \
      bytestring \
      case-insensitive \
      cassava \
      conduit \
      conduit-combinators \
      containers \
      convertible \
      cryptonite \
      csv-conduit \
      deepseq \
      directory \
      dlist \
      either \
      esqueleto \
      exceptions \
      filepath \
      happstack-server \
      hashable \
      haskell-src-exts \
      HDBC \
      HDBC-postgresql \
      hedis \
      hlint \
      hpack \
      HPDF \
      hslogger \
      hspec \
      hspec-core \
      hspec-expectations-pretty-diff \
      http-api-data \
      http-client \
      http-client-tls \
      http-conduit \
      http-media \
      http-types \
      insert-ordered-containers \
      JuicyPixels \
      JuicyPixels-extra \
      jwt \
      lens \
      lens-aeson \
      memory \
      monad-control \
      monad-logger \
      mongoDB \
      mono-traversable \
      mtl \
      neat-interpolation \
      network \
      network-uri \
      orville \
      parsec \
      persistent \
      persistent-mongoDB \
      persistent-postgresql \
      persistent-template \
      pretty-simple \
      process \
      prolude \
      QuickCheck \
      quickcheck-instances \
      random \
      resource-pool \
      resourcet \
      safe-exceptions \
      safe-money \
      scientific \
      servant \
      servant-server \
      servant-swagger \
      servant-swagger-ui \
      silently \
      stm \
      stringsearch \
      swagger2 \
      template-haskell \
      text \
      time \
      transformers \
      transformers-base \
      unliftio-core \
      unordered-containers \
      uuid \
      vector \
      wai \
      warp \
      xml-conduit \
      xml-conduit-writer \
      xml-lens \
      xml-types

# Commonly used dev tools
RUN stack install \
      brittany \
      ghcid \
      hlint \
      hoogle \
      hasktags
