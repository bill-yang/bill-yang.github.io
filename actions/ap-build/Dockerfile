FROM howardchangadperfect/deployment-tools:latest

RUN packer --version

# Packer Build AWS EC2 Instance
ADD example.json /example.json
RUN packer validate /example.json
RUN echo "access token $ACCESS_TOKEN  "
RUN echo $(pwd)