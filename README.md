# blendle/ruby [![Build Status](http://drone.blendle.io/api/badge/github.com/blendle/docker-ruby/status.svg?branch=master)](http://drone.blendle.io/github.com/blendle/docker-ruby)

Ruby image, based off of [blendle/base][]. The image is `105.3` MB in size.

[blendle/base]: https://github.com/blendle/docker-base

## Ruby version

The currently installed Ruby version is: `2.1.3`.

## Changing default version

Ruby is installed using the [ruby-install][] tool. Ruby-install is kept around
on the system, so you can optionally install a newer version if you want:

```dockerfile
FROM blendle/ruby:2.1.3
MAINTAINER Jean Mertz <jean@blendle.com>

ENV RUBY_VERSION 2.1.5

RUN bnl-apk-install-build-deps                                      \
    && apk-install -t ruby-deps libc-dev=0.6-r0 readline-dev=6.3-r3 \
       libffi-dev=3.0.13-r0 "openssl-dev>1.0.1" gdbm-dev=1.11-r0    \
       zlib-dev=1.2.8-r1 bash=4.3.30-r0                             \
    && ruby-install ruby $RUBY_VERSION -- --disable-install-rdoc    \
    && apk del build-deps ruby-deps

ENV PATH /opt/rubies/ruby-${RUBY_VERSION}/bin:$PATH
```

```
$ docker build -t JeanMertz/ruby:2.1.5 .
$ docker run -it --rm JeanMertz/ruby:2.1.5 ruby -v
=> ruby 2.1.5p273 (2014-11-13 revision 48405) [x86_64-linux]
```

Of course, this means you now have two Ruby versions installed. You might as
well create a Pull Request so we can support the new version in `blendle/ruby`.

**NOTE** that you need to (re)install the build dependencies before being able
to install a new Ruby version. We keep our images as simple and lightweight as
possible by removing any temporary dependencies as soon as they are no longer
needed. This has the downside of having to reinstall those dependencies when you
want to make any significant changes to the image.

[ruby-install]: https://github.com/postmodern/ruby-install

## License

MIT - see the accompanying [LICENSE](LICENSE) file for details.
