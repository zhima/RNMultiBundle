import * as React from 'react';
import { Text, View, StyleSheet, Button } from 'react-native';
import { StackNavigationProp } from '@react-navigation/stack';
import CustomModule from './CustomModule';

interface MainProps {
  navigation: StackNavigationProp<{}>,
}

const Main: React.FC<MainProps> = ({ navigation }) => {

  const buttonPress = () => {
    CustomModule.gotoFirstPage('name');
  }

  return (
    <View style={styles.container}>
      <Button
        title="Press me"
        onPress={buttonPress}
      />
    </View>
  );
};

export default Main;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  }
});

