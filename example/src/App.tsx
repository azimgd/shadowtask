import { useEffect, useRef } from 'react';
import { Text, View, StyleSheet, type EventSubscription } from 'react-native';
import * as shadowtask from 'shadowtask';

export default function App() {
  const listenerSubscription = useRef<null | EventSubscription>(null);

  useEffect(() => {
    shadowtask.registerRecurringTask('recurringOne', 1000);
    shadowtask.registerRandomRecurringTask('recurringOne', 1000, 2000);

    listenerSubscription.current = shadowtask.onRecurringTaskUpdate(
      'recurringOne',
      (pair) => console.log(`New task: ${pair.taskId}`)
    );

    return () => {
      shadowtask.unregisterRecurringTask('recurringOne');
      shadowtask.unregisterRecurringTask('recurringTwo');

      listenerSubscription.current?.remove();
      listenerSubscription.current = null;
    };
  }, []);

  return (
    <View style={styles.container}>
      <Text>Result: {321}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
