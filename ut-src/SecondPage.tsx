import * as React from 'react';
import { Text, View, StyleSheet } from 'react-native';

interface SecondPageProps {}

const SecondPage = (props: SecondPageProps) => {
  return (
    <View style={styles.container}>
      <Text>SecondPageeeeeeeSSSSSS</Text>
    </View>
  );
};

export default SecondPage;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center'
  }
});
