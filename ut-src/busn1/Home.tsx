import React, {useState} from 'react';
import { Text, View, StyleSheet,Button, TouchableOpacity  } from 'react-native';
import { StackNavigationProp } from '@react-navigation/stack';
// import codePush from "react-native-code-push";
import * as Sentry from "@sentry/react-native";
import CustomModule from '../CustomModule';

interface HomeProps {
  navigation: StackNavigationProp<{}>,
}

const Home: React.FC<HomeProps> = ({ navigation }) => {
  const [tip, setTip] = useState('initial state');
  const buttonPress = () => {
    setTip('buttonPress baidu success');
    // navigation.navigate('FirstPage');
    // throw new Error('This is a test javascript crash!');
    // codePush.sync({
    //   updateDialog: {title: 'update dialog'},
    //   installMode: codePush.InstallMode.IMMEDIATE
    // }).catch((error) => {
    //   setTip('codepush sync err failed' + JSON.stringify(error, null, 2));
    // });
  };

  const nextPagePress = () => {
    navigation.navigate('FirstPage');
  }

  const secondPagePress = () => {
    navigation.navigate('SecondPage');
  }

  const btnPress = () => {
    throw new Error("My first Sentry error!");
    
  }

  const newBtnPress = () => {
    // CustomModule.bundleName('HomeScript').then((value) => {
    //   console.log('get value from native:' + value);
    //   setTip('get value from native:' + value);
    // });
    fetch('https://www.baidu.com').then((res) => {
      console.log('fetch baidu success'+ JSON.stringify(res, null, 2));
      setTip('fetch baidu success')
    }).catch((error) => {
      setTip('fetch baidu err failed' + JSON.stringify(error, null, 2));
    });
  }

  return (
    <View style={styles.container}>
      <Text>Home</Text>
      <Button
        title="Press me"
        onPress={buttonPress}
      />
      <Button
        title="Go to First Page"
        onPress={nextPagePress}
      />
      <Button
        title="Throw Errorrrrrr"
        onPress={btnPress}
      />
      <Button
        title="Go to Second Page"
        onPress={secondPagePress}
      />
      <Button
        title="fetch Baidu Test Press"
        onPress={newBtnPress}
      />
      <Text>{tip}</Text>
    </View>
  );
};

export default Home;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center'
  }
});
