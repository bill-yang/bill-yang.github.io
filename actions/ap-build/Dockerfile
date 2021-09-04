FROM howardchangadperfect/deployment-tools:latest

RUN packer --version

RUN terraform version

# Packer Build AWS EC2 Instance
ADD example.json /example.json
RUN packer validate /example.json

# pass argument
ARG ACCESS_TOKEN
RUN echo "access token: $ACCESS_TOKEN"

ENV MY_NAME=$MY_NAME
RUN echo "My Name: $MY_NAME"
