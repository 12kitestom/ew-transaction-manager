#!/bin/bash
echo starting!

#build vue in lib mode
#cp .env.kubota-prod.local .env.production.local

npm i
npm run build-lib-prod
VERSION=$(jq .version ./package.json -r)


##copy umd and css files over
cd ./nginx-server

rm -rf files/files
mkdir -p files/files

cp ../dist/txmanager.umd.js files/files
cp ../dist/txmanager.umd.min.js files/files
cp ../dist/*.css files/files
touch files/files/txmanager.css

#create the scripts.json file, add the content and set the version number?
rm ./files/feature-spec.json
cp ./spec-source.json ./files/feature-spec.json
sed -i '' -e "s/%%VER%%/$VERSION/g" ./files/feature-spec.json

#build docker image
LOCALTAG="ew-feature-txmanager"
BASE="ew-feature-txmanager"
docker build -t $LOCALTAG .
docker tag $LOCALTAG registry.digitalocean.com/eport/$BASE:dev-latest
docker push registry.digitalocean.com/eport/$BASE:dev-latest
