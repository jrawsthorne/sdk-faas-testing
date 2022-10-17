FROM public.ecr.aws/lambda/ruby:2.7 as builder

RUN yum group install -y "Development Tools"
RUN yum install -y openssl11-devel

RUN mkdir /tmp/deploy && \
    curl -L https://cmake.org/files/v3.21/cmake-3.21.4-linux-x86_64.sh -o /tmp/deploy/cmake.sh && \
    (echo y ; echo n) | sh /tmp/deploy/cmake.sh --prefix=/usr/local && \
    rm /usr/local/bin/cmake-gui && \
    rm -rf /tmp/deploy

RUN yum install -y gcc10 gcc10-c++

ENV CC=/usr/bin/gcc10-cc
ENV CXX=/usr/bin/gcc10-c++

COPY Gemfile ${LAMBDA_TASK_ROOT}
RUN bundle config set --local path '${LAMBDA_TASK_ROOT}/vendor/bundle'
RUN bundle install

FROM public.ecr.aws/lambda/ruby:2.7

RUN yum install -y openssl11
COPY --from=builder ${LAMBDA_TASK_ROOT} ${LAMBDA_TASK_ROOT}
COPY app.rb ${LAMBDA_TASK_ROOT}
RUN bundle config set --local path '${LAMBDA_TASK_ROOT}/vendor/bundle'

CMD [ "app.handler" ]