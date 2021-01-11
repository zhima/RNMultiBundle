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
    if (module['path'].indexOf('__prelude__') >= 0) {
        return false;
    }
    if (isInManifest(module['path'])) {
        return false;
    }
    return true;
}

function createModuleIdFactory() {
    return path => {
        let name = '';
        if (path.startsWith(__dirname)) {
            name = path.substr(__dirname.length + 1);
        }
        let regExp = pathSep == '\\' ?
            new RegExp('\\\\',"gm") :
            new RegExp(pathSep,"gm");
        
        return name.replace(regExp,'_');
    };
}


module.exports = {
    serializer: {
        createModuleIdFactory,
        processModuleFilter,
    }
};