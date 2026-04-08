/**
 * @description Trigger that handles Log_Event__e platform events after insertion.
 *              This trigger is responsible for processing and routing log events
 *              through the LogEventTriggerHandler to ensure proper event handling
 *              and any associated business logic execution.
 * @author [Naveen Rathod]
 * @date [08-04-2026]
 * @version 1.0
 */
trigger LogEventTrigger on Log_Event__e(after insert) {
  LogEventTriggerHandler.handleEvents(Trigger.new);
}
