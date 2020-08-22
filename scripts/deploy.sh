
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