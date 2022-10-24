FROM public.ecr.aws/lambda/python:3.9

RUN yum install -y openssl11 zip tar

WORKDIR /app

RUN mkdir lib
RUN cp /usr/lib64/libssl.so.1.1 /usr/lib64/libcrypto.so.1.1 ./lib

COPY requirements.txt .
RUN pip3 install -r requirements.txt --target ./package

COPY app.py .

VOLUME /out

ENTRYPOINT [ ]