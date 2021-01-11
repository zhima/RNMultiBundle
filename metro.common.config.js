const fs = require('fs');
const pathSep = require('path').sep;

function manifest (path) {
    if (path.length) {
        const manifestFile = `./dist/common_manifest_${process.env.PLATFORM}.txt`;
        if (!fs.existsSync(manifestFile)) {
            fs.writeFileSync(manifestFile, path);
        } else {
            fs.appendFileSync(manifestFile, '\n' + path);
        }
    }
}

function processModuleFilter(module) {
    if (module['path'].indexOf('__prelude__') >= 0) {
        return false;
    }
    manifest(module['path']);
    return true;
}

function createModuleIdFactory () {
    return path => {
        let name = '';
        if (path.startsWith(__dirname)) {
            name = path.substr(__dirname.length + 1);
        }
        let regExp = pathSep == '\\' ?
            new RegExp('\\\\', "gm") :
            new RegExp(pathSep, "gm");
        return name.replace(regExp, '_');
    }
}

module.exports = {
    serializer: {
        createModuleIdFactory,
        processModuleFilter
    }
};