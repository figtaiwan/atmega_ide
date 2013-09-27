DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
cd ..
node_webkit/osx-ia32/node-webkit.app/Contents/MacOS/node-webkit atmega_ide --remote-debugging-port=9222 
