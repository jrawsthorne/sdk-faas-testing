FROM amazonlinux:2.0.20220912.1
RUN yum install -y tar gzip zip
RUN touch ~/.bashrc && chmod +x ~/.bashrc
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
WORKDIR /app
COPY package.json /app/
RUN source ~/.bashrc && \
    nvm install 16.17.1 && \
    npm install
COPY index.js /app/
VOLUME /out