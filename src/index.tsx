import Shadowtask from './NativeShadowtask';
import type { RecurringTaskUpdate } from './NativeShadowtask';

export function registerRecurringTask(
  taskId: string,
  interval: number
): boolean {
  return Shadowtask.registerRecurringTask(taskId, interval);
}

export function registerRandomRecurringTask(
  taskId: string,
  minInterval: number,
  maxInterval: number
): boolean {
  return Shadowtask.registerRandomRecurringTask(
    taskId,
    minInterval,
    maxInterval
  );
}

export function unregisterRecurringTask(taskId: string): boolean {
  return Shadowtask.unregisterRecurringTask(taskId);
}

export function onRecurringTaskUpdate(
  taskId: string,
  callback: (payload: RecurringTaskUpdate) => void
) {
  return Shadowtask.onRecurringTaskUpdate((payload) => {
    if (payload.taskId === taskId) callback(payload);
  });
}
