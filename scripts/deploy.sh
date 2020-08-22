
git config --global user.email "builds@travis-ci.org"
git config --global user.name "Travis CI"
export GIT_TAG=v0.1.$TRAVIS_BUILD_NUMBER
git tag $GIT_TAG -a -m "Generated tag from TravisCI for build $TRAVIS_BUILD_NUMBER"
git push -q https://github.com/ducminhle/node-hello.git --tags

docker login -u $DOCKER_USER -p $DOCKER_PASSWORD
docker tag node-hello $DOCKER_USER/node-hello:$GIT_TAG
docker push $DOCKER_USER/node-hello:$GIT_TAG
docker tag node-hello $DOCKER_USER/node-hello:latest
docker push $DOCKER_USER/node-hello:latest

echo $PEM_FILE >> ssh.pem
chmod 600 ssh.pem
ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i ssh.pem ubuntu@$SERVER 'docker stop $(docker ps -a -q)'
ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -i ssh.pem ubuntu@$SERVER 'docker run -itd -e "ENV=prod" -e "VERSION=${GIT_TAG}" --network host minhducle/node-hello:${GIT_TAG}'