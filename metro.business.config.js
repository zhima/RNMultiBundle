const fs = require('fs');
const md5 = require('js-md5');
//是否对moduleId哈希
const isEncrypt = true;

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
    if (module['path'].indexOf(pathSep + 'node_modules' + pathSep) > 0) {
        /*
        但输出类型为js/script/virtual的模块不能过滤，一般此类型的文件为核心文件，
        如InitializeCore.js。每次加载bundle文件时都需要用到。
        */
        if ('js' + pathSep + 'script' + pathSep + 'virtual' == module['output'][0]['type']) {
            return true;
        }
    }
    if (isInManifest(module['path'])) {
        return false;
    }
    return true;
}

const randomNum = Math.ceil(Math.random() * 10000) ;

function createModuleIdFactory() {
    const projectRootPath = __dirname;
    return path => {
        let name = '';
        if (path.indexOf('node_modules'+pathSep+'react-native'+pathSep+'Libraries'+pathSep)>0) {
            name = path.substr(path.lastIndexOf(pathSep)+1);
        } else if (path.indexOf(projectRootPath)==0) {
            name = path.substr(projectRootPath.length+1);
        }
        name = name.replace('.js', '');
        name = name.replace('.png', '');
        let regExp = pathSep == '\\' ?
            new RegExp('\\\\',"gm") :
            new RegExp(pathSep,"gm");
        if (/\/ut-src\//.test(path)) {//只对自己的业务代码模块加随机数，避免影响到可能的用到基础包的模块modulId与基础包中的不一致导致出错
            name = name.replace(regExp,'_') + randomNum;
        } else {
            name = name.replace(regExp,'_');
        }
        //名称哈希
        if (isEncrypt) {
            name = md5(name);
        }
        return name;
    };
}


module.exports = {
    serializer: {
        createModuleIdFactory,
        processModuleFilter,
    }
};