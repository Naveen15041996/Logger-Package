/**
 * @description
 * Utility class responsible for publishing logging events using the Log_Event__e Platform Event.
 * This class centralizes logging for exceptions and informational messages across the system.
 * Supports both single and bulk logging with structured context using the LogContext wrapper.
 * @author Naveen Rathod
 * @date 08-04-2026
 */
global with sharing class Logger {
  private static final String ERROR_LEVEL = 'ERROR';

  /**
   * @description Publishes a single log event.
   * @param context LogContext object containing logging details such as class name, method name, and exception/message.
   */
  global static void log(LogContext context) {
    if (context == null)
      return;
    log(new List<LogContext>{ context });
  }

  /**
   * @description Publishes multiple log events in bulk using Platform Events.
   * @param contexts List of LogContext objects representing multiple log entries.
   */
  global static void log(List<LogContext> contexts) {
    if (contexts == null || contexts.isEmpty())
      return;

    List<Log_Event__e> eventsToPublish = new List<Log_Event__e>();

    for (LogContext context : contexts) {
      if (context != null && context.error != null) {
        eventsToPublish.add(buildEventFromContext(context));
      }
    }

    if (!eventsToPublish.isEmpty()) {
      // Publishes events asynchronously (fire-and-forget logging)
      EventBus.publish(eventsToPublish);
    }
  }

  /**
   * @description  Converts LogContext into a Log_Event__e Platform Event record.
   * @param context LogContext instance containing log data.
   * @return Log_Event__e Platform Event ready for publishing.
   */
  private static Log_Event__e buildEventFromContext(LogContext context) {
    return new Log_Event__e(
      Class__c = context.className,
      Exception_Type__c = context.error?.getTypeName(),
      Level__c = context.level,
      Line_Number__c = context.error?.getLineNumber(),
      Message__c = (context.message != null)
        ? context.message
        : context.error?.getMessage(),
      Method__c = context.methodName,
      RecordId__c = context.recordId,
      Stack_Trace__c = context.error?.getStackTraceString()
    );
  }

  /**
   * @description  Wrapper class representing structured logging data.
   * Encapsulates all necessary information required to publish a log event.
   */
  global class LogContext {
    private Exception error;
    private Id recordId;
    private String className;
    private String level;
    private String message;
    private String methodName;
    private String payload;

    /**
     * @description Constructor for error-based logging.
     * @param className Name of the class where the exception occurred.
     * @param methodName Name of the method where the exception occurred.
     */
    global LogContext(String className, String methodName) {
      this.className = className;
      this.methodName = methodName;
    }

    /**
     * @description Setter for exception details in the log context.
     * Automatically sets the log level to ERROR when an exception is provided.
     * @param error Exception instance to be logged.
     * @return Updated LogContext instance (supports method chaining).
     */
    global LogContext withError(Exception error) {
      this.error = error;
      this.level = ERROR_LEVEL;
      return this;
    }

    /**
     * @description Setter for log level (e.g., INFO, ERROR, DEBUG).
     * @param level Log level as a string.
     * @return Updated LogContext instance (supports method chaining).
     */
    global LogContext withLevel(String level) {
      this.level = level;
      return this;
    }

    /**
     * @description Constructor for message-based logging.
     * @param className Name of the class where the log is being recorded.
     * @param methodName Name of the method where the log is being recorded.
     * @param message Informational message to be logged.
     */
    global LogContext withMessage(String message) {
      this.message = message;
      return this;
    }

    /**
     * @description Adds payload data (JSON/debug information) to the log context.
     * @param payload JSON string or debug data.
     * @return Updated LogContext instance (supports method chaining).
     */
    global LogContext withPayload(String payload) {
      this.payload = payload;
      return this;
    }

    /**
     * @description Adds a related record Id to the log context.
     * @param recordId Salesforce record Id associated with the log.
     * @return Updated LogContext instance (supports method chaining).
     */
    global LogContext withRecordId(Id recordId) {
      this.recordId = recordId;
      return this;
    }
  }
}
