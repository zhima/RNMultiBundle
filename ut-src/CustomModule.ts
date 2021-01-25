import { NativeModules } from 'react-native';
const { CustomModule } = NativeModules
interface CustomModuleInterface {
  updateScript(name: string): Promise<string>;
  gotoFirstPage(name: string): Promise<string>;
}
export default CustomModule as CustomModuleInterface;