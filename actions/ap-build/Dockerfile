FROM howardchangadperfect/deployment-tools:latest

RUN packer --version

RUN terraform version

# Packer Build AWS EC2 Instance
ADD example.json /example.json
RUN packer validate /example.json

# pass argument
RUN echo "access token: ${ACCESS_TOKEN}"

RUN echo "access token: ${ACCESS_TOKEN}"

RUN echo "My Name: ${MY_NAME}"

RUN echo "My Full Name: $MY_FULL_NAME"

# Code file to execute when the docker container starts up (`entrypoint.sh`)
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]