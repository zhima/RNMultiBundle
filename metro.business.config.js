const fs = require('fs');

const pathSep = require('path').sep;
var commonModules = null;

function isInManifest (path) {
    const manifestFile = `./dist/common_manifest_${process.env.PLATFORM}.txt`;

    if (commonModules === null && fs.existsSync(manifestFile)) {
        const lines = String(fs.readFileSync(manifestFile)).split('\n').filter(line => line.length > 0);
        commonModules = new Set(lines);
    } else if (commonModules === null) {
        commonModules = new Set();
    }

    if (commonModules.has(path)) {
        return true;
    }

    return false;
}

function processModuleFilter(module) {
    const path = module['path']
    if (path.indexOf("__prelude__") >= 0 ||
        path.indexOf("/node_modules/react-native/Libraries/polyfills") >= 0 ||
        path.indexOf("source-map") >= 0 ||
        path.indexOf("/node_modules/metro/src/lib/polyfills/") >= 0) {
        return false;
    }
    // if (module['path'].indexOf(pathSep + 'node_modules' + pathSep) > 0) {
    //     if ('js' + pathSep + 'script' + pathSep + 'virtual' == module['output'][0]['type']) {
    //         return true;
    //     }
    // }
    if (isInManifest(module['path'])) {
        return false;
    }
    return true;
}

const randomNum = Math.ceil(Math.random() * 10000) ;

function createModuleIdFactory() {
    return path => {
        let name = '';
        if (path.startsWith(__dirname)) {
            name = path.substr(__dirname.length + 1);
        }
        let regExp = pathSep == '\\' ?
            new RegExp('\\\\',"gm") :
            new RegExp(pathSep,"gm");
        if (/\/ut-src\//.test(path)) {
            return name.replace(regExp,'_') + randomNum;
        }
        return name.replace(regExp,'_');
    };
}


module.exports = {
    serializer: {
        createModuleIdFactory,
        processModuleFilter,
    }
};