import React, { useState, useRef, useEffect, useCallback, useLayoutEffect, useMemo } from 'react';
import { Text, View, StyleSheet } from 'react-native';
import { NavigationContainer, NavigationContainerRef } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import Home from './Home';
import FirstPage from './FirstPage';
import SecondPage from './SecondPage';
// import ThirdPage from './ThirdPage';
import codePush from "react-native-code-push";
import * as Sentry from "@sentry/react-native";
Sentry.init({
  dsn: "https://cec134d159f74713af12b772b30b8b87@o500656.ingest.sentry.io/5580838",
});

interface RootProps {}

const Stack = createStackNavigator();

const Root = (props: RootProps) => {
  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName="Home">
        <Stack.Screen name="Home" component={Home} />
        <Stack.Screen name="FirstPage" component={FirstPage} />
        <Stack.Screen name="SecondPage" component={SecondPage} />
        {/* <Stack.Screen name="ThirdPage" component={ThirdPage} /> */}
      </Stack.Navigator>
  </NavigationContainer>
  );
};

// let codePushOptions = { checkFrequency: codePush.CheckFrequency.MANUAL };
// const CodePushRoot = codePush(codePushOptions)(Root);

export default Root;

const styles = StyleSheet.create({
  container: {}
});
