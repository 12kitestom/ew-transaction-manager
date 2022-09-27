#!/bin/bash
echo starting!

#build vue in lib mode
#cp .env.kubota-prod.local .env.production.local

BUILDDIR=s3-build
LIBNAME=txmanager
DESTDIR=deploy

npm i
npm run build-lib-prod
RESULT=$?
if [ $RESULT -eq 0 ]; then

    VERSION=$(jq .version ./package.json -r)
    cd $BUILDDIR

    rm -rf package/lib
    mkdir -p package/lib

    cp ../dist/$LIBNAME.umd.js package/lib
    cp ../dist/$LIBNAME.umd.min.js package/lib
    cp ../dist/*.css package/lib
    cp  src/* package/
    touch package/lib/$LIBNAME.css

    #create the scripts.json file, add the content and set the version number?
    rm ./package/feature-spec.json
    cp ./spec-source.json ./package/feature-spec.json
    sed -i '' -e "s/%%VER%%/$VERSION/g" ./package/feature-spec.json

    rm -rf ../$DESTDIR/dev-latest
    rm -rf ../$DESTDIR/$VERSION

    cp -r package ../$DESTDIR/dev-latest
    cp -r package ../$DESTDIR/$VERSION

    cd ../$VUEDIR
    npm run clean

##copy umd and css files over
cd ./s3-server

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
# LOCALTAG="ew-feature-txmanager"
# BASE="ew-feature-txmanager"
# docker build -t $LOCALTAG .
# docker tag $LOCALTAG registry.digitalocean.com/eport/$BASE:dev-latest
# docker push registry.digitalocean.com/eport/$BASE:dev-latest
else
  echo Build failed
fi
