FROM amazonlinux:2.0.20220912.1

RUN yum install -y tar gzip zip

RUN curl -LO https://go.dev/dl/go1.18.6.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.18.6.linux-amd64.tar.gz

ENV PATH=$PATH:/usr/local/go/bin

WORKDIR /app

COPY go.mod go.sum main.go ./
RUN go build main.go

VOLUME /out