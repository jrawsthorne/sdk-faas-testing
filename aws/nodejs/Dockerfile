FROM public.ecr.aws/lambda/nodejs:16 as builder

RUN yum group install -y "Development Tools"
RUN yum install -y git python3

RUN mkdir /tmp/deploy && \
    curl -L https://cmake.org/files/v3.21/cmake-3.21.4-linux-x86_64.sh -o /tmp/deploy/cmake.sh && \
    (echo y ; echo n) | sh /tmp/deploy/cmake.sh --prefix=/usr/local && \
    rm /usr/local/bin/cmake-gui && \
    rm -rf /tmp/deploy

RUN yum install -y gcc10 gcc10-c++

ENV CC=/usr/bin/gcc10-cc
ENV CXX=/usr/bin/gcc10-c++
ENV MAKEFLAGS=-j4
ARG COMMIT=master

RUN git clone --recurse-submodules https://github.com/couchbase/couchnode ${LAMBDA_TASK_ROOT}/couchnode && \
    cd ${LAMBDA_TASK_ROOT}/couchnode && \
    git checkout ${COMMIT} && \
    npm install

WORKDIR ${LAMBDA_TASK_ROOT}

COPY package.json .

RUN npm install

FROM public.ecr.aws/lambda/nodejs:16

COPY --from=builder ${LAMBDA_TASK_ROOT} ${LAMBDA_TASK_ROOT}
COPY app.js ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]