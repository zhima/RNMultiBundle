import * as React from 'react';
import { Text, View, StyleSheet } from 'react-native';

interface FirstPageProps {}

const FirstPage = (props: FirstPageProps) => {
  return (
    <View style={styles.container}>
      <Text>FirstPage</Text>
    </View>
  );
};

export default FirstPage;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center'
  }
});
