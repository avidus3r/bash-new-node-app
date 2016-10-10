#!/bin/sh

#create a project
echo Enter a project name
read NAME

echo "What HTTP framework would you like to use? (type a number or enter for none)
1. express
2. hapi
3. node http"
read HTTPCHOICE

echo "What view/presentation framework would you like to use? (type a number or enter for none)
1. backbone
2. jade
3. swig"
read VIEWCHOICE

echo "What build system would you like to use? (type a number or enter for none)
1. grunt
2. gulp"
read BUILDCHOICE

echo "Use jQuery? (y/n)"
read USEJQUERY

echo "Use a node monitor? (type a number or enter for none)
1. forever
2. nodemon
3. pm2"
read USENODEMON

echo "Entry file (press enter to use 'index.js')"
read ENTRYFILE

dependencies=""
indexrequires=""
indexcontent=""

if [[ -z "$HTTPCHOICE" ]]; then

else
    if [[ "$HTTPCHOICE" = 1 ]]; then
      dependencies+="\"express\":\"latest\",
          "

      dependencies+="\"http\":\"latest\",
          "

      indexrequires+="var http = require('http');
        "

      indexrequires+="var express = require('express');
      var app = express();
        "

      indexcontent+="app.set('port', process.env.PORT || 3000);
        "

    fi

    if [[ "$HTTPCHOICE" = 2 ]]; then
      dependencies+="\"hapi\":\"latest\",
          "

      indexrequires+="var hapi = require('hapi');
        "

    fi

    if [[ "$HTTPCHOICE" = 3 ]]; then
      dependencies+="\"http\":\"latest\",
          "

      indexrequires+="var http = require('http');
        "

    fi
fi

if [[ -z "$VIEWCHOICE" ]]; then

else
    if [[ "$VIEWCHOICE" = 3 ]]; then
      dependencies+="\"swig\":\"latest\",
          "

      indexrequires+="var swig = require('swig');
        "

    fi

    if [[ "$VIEWCHOICE" = 2 ]]; then
      dependencies+="\"jade\":\"latest\",
          "

      indexrequires+="var jade = require('jade');
        "

      indexcontent+="app.set('view engine', 'jade');
        "

    fi

    if [[ "$VIEWCHOICE" = 1 ]]; then
      dependencies+="\"backbone\":\"latest\",
          "

      indexrequires+="var backbone = require('backbone');
        "

      indexcontent+="app.set('view engine', 'backbone');
        "

    fi
fi

if [[ -z "$BUILDCHOICE" ]]; then

else
    if [[ "$BUILDCHOICE" = 2 ]]; then
      dependencies+="\"gulp\":\"latest\",
          "

      touch gulpfile.js
    fi

    if [[ "$BUILDCHOICE" = 1 ]]; then
      dependencies+="\"grunt\":\"latest\",
          \"grunt-cli\":\"latest\",
              "

      touch Gruntfile.js
    fi
fi

if [[ -z "$USENODEMON" ]]; then

else
    if [[ "$USENODEMON" = 3 ]]; then
      dependencies+="\"pm2\":\"latest\""
    fi

    if [[ "$USENODEMON" = 2 ]]; then
      dependencies+="\"nodemon\":\"latest\""
    fi

    if [[ "$USENODEMON" = 1 ]]; then
      dependencies+="\"forever\":\"latest\""
    fi
fi

if [[ "$HTTPCHOICE" = 1 ]]; then
    indexcontent+="http.createServer(app).listen(app.get('port'), function(){
        console.log('app listening on port ' + app.get('port'));
    });
        "

fi

deps=${dependencies::${#dependencies}-1}

# try to create directory
cd '../projects'
mkdir $NAME
cd $NAME

if [[ -z "$ENTRYFILE" ]]; then
    touch index.js
else
    touch $ENTRYFILE
fi

cat <<EOT >> index.js
$indexrequires

$indexcontent
EOT

touch package.json
cat <<EOT >> package.json
{
  "name": "$NAME",
  "dependencies":{
      $deps
  }
}
EOT

if [[ "$BUILDCHOICE" = 2 ]]; then

cat <<EOT >> gulpfile.js
    var gulp = require('gulp');

    gulp.task('default', function() {
      // place code for your default task here
    });
EOT

fi

npm install; node $ENTRYFILE
