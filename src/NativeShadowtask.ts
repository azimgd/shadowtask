import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';
import type { EventEmitter } from 'react-native/Libraries/Types/CodegenTypes';

export type TimerUpdate = {
  key: string;
  value: string;
};

export interface Spec extends TurboModule {
  registerRecurringTask(taskId: string, interval: number): boolean;
  registerRandomRecurringTask(
    taskId: string,
    minInterval: number,
    maxInterval: number
  ): boolean;
  unregisterRecurringTask(taskId: string): boolean;
  readonly onRecurringTaskUpdate: EventEmitter<TimerUpdate>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('Shadowtask');
