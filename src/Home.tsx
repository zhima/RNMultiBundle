import React from 'react';
import { Text, View, StyleSheet,Button  } from 'react-native';
import { StackNavigationProp } from '@react-navigation/stack';
import codePush from "react-native-code-push";

interface HomeProps {
  navigation: StackNavigationProp<{}>,
}

const Home: React.FC<HomeProps> = ({ navigation }) => {
  const buttonPress = () => {
    // navigation.navigate('FirstPage');
    // throw new Error('This is a test javascript crash!');
    codePush.sync({
      updateDialog: {title: 'update dialog'},
      installMode: codePush.InstallMode.IMMEDIATE
    });
  };

  const nextPagePress = () => {
    navigation.navigate('SecondPage');
  }

  return (
    <View style={styles.container}>
      <Text>Home</Text>
      <Button
        title="Press me"
        onPress={buttonPress}
      />
      <Button
        title="Next Page"
        onPress={nextPagePress}
      />
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
