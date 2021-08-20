# source-code-docker-build-image-

ssh-keygen
docker build -t builder --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)" .
docker tag XXXX/boxbuilder
docker login XXXX
docker push XXXX/boxbuilder
