FROM blendle/base:latest
MAINTAINER Jean Mertz <jean@blendle.com>

CMD ["irb"]

ONBUILD RUN bundle config --global jobs $(grep processor /proc/cpuinfo | tail -n1 | awk -F: '{ print $2 + 1 }')

RUN apk-install ca-certificates=20141019-r0

ENV RUBY_VERSION 2.1.3

RUN bnl-apk-install-download-deps                                                               \
    && bnl-apk-install-build-deps                                                               \
    && bnl-download-and-verify B9515E77                                                         \
       https://raw.github.com/postmodern/ruby-install/master/pkg/ruby-install-0.5.0.tar.gz.asc  \
       https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz                         \
    && cd ruby-install-0.5.0/                                                                   \
    && make install                                                                             \
    && cd ..                                                                                    \
    && rm -r /home/ruby-install-0.5.0/                                                          \
    && apk-install -t ruby-deps libc-dev=0.6-r0 readline-dev=6.3-r3 libffi-dev=3.0.13-r0        \
       "openssl-dev>1.0.1" gdbm-dev=1.11-r0 zlib-dev=1.2.8-r1 bash=4.3.30-r0                    \
    && ruby-install ruby $RUBY_VERSION -- --disable-install-rdoc                                \
    && apk del download-deps build-deps ruby-deps                                               \
    && rm -r /usr/local/src/ruby-${RUBY_VERSION}*

RUN mkdir -p /opt/rubies/ruby-${RUBY_VERSION}/etc \
    && echo 'gem: --no-document' > /opt/rubies/ruby-${RUBY_VERSION}/etc/gemrc

ENV PATH /opt/rubies/ruby-${RUBY_VERSION}/bin:$PATH
ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$PATH

RUN gem install bundler                           \
    && bundle config --global path "$GEM_HOME"    \
    && bundle config --global bin "$GEM_HOME/bin" \
    && bundle config --global frozen 1            \
    && bundle config --global retry 3             \

ENV BUNDLE_APP_CONFIG $GEM_HOME
