FROM ruby:2.5-stretch

RUN gem install pdk

COPY . /usr/src/puppet-modules
WORKDIR /usr/src/puppet-modules/modules

CMD for module in */; do cd $module && echo ${module%*/} && pdk validate && cd ..; done
