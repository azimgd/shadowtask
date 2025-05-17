# shadowtask

shadowtask

## Installation

```sh
npm install shadowtask
```

## Usage


```js
import * as shadowtask from 'shadowtask';

const listenerSubscription = useRef<null | EventSubscription>(null);

useEffect(() => {
  shadowtask.registerRecurringTask('recurringOne', 1000);
  shadowtask.registerRandomRecurringTask('recurringOne', 1000, 2000);

  listenerSubscription.current = shadowtask.onRecurringTaskUpdate((pair) => console.log(`New key added: ${pair.key} with value: ${pair.value}`));

  return  () => {
    shadowtask.unregisterRecurringTask('recurringOne');
    shadowtask.unregisterRecurringTask('recurringTwo');

    listenerSubscription.current?.remove();
    listenerSubscription.current = null;
  }
}, []);
```


## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
