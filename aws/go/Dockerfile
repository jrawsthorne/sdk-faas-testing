FROM golang:1.18 as builder

WORKDIR /app

COPY main.go go.mod go.sum ./

RUN go build main.go

FROM public.ecr.aws/lambda/go:1

COPY --from=builder /app/main ${LAMBDA_TASK_ROOT}

CMD [ "main" ]