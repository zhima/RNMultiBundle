/**
 * @format
 */
import {AppRegistry} from 'react-native';
import Root from './Root';
import {name as appName} from '../app.json';

console.log('index.js has been executed!!!!!!!!' + appName);
AppRegistry.registerComponent(appName, () => Root);
