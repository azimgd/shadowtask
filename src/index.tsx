import Shadowtask from './NativeShadowtask';

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

export const onRecurringTaskUpdate = Shadowtask.onRecurringTaskUpdate;
