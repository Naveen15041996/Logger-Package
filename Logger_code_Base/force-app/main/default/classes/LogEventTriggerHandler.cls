/* @description
 * This Apex class handles the processing of Log_Event__e platform events. It listens for new events and creates corresponding Log__c records in Salesforce to store the details of each log event.
 * The class is designed to be efficient and scalable, allowing for bulk processing of events. It constructs the log name based on the class and method where the error occurred, and captures all relevant information such as the log level, record ID, line number, message, stack trace, and exception type.
 * The logs are inserted into the database in bulk to optimize performance, and the class is marked with "with sharing" to ensure that it respects the organization's sharing rules and security settings.
 * @author Naveen Rathod
 * @date 08-04-2026
 */
public with sharing class LogEventTriggerHandler {
  /**
   * @description This method is triggered when new Log_Event__e platform events are received.
   * It processes each event, constructs a log name, and creates a new Log__c record with the details from the event.
   * The method uses bulk processing to handle multiple events efficiently,
   * and it inserts the new log records into the database in a single operation to optimize performance.
   * @param newEvents A list of Log_Event__e events that have been received and need to be processed.
   */
  public static void handleEvents(List<Log_Event__e> newEvents) {
    List<Log__c> logsToInsert = new List<Log__c>();

    for (Log_Event__e event : newEvents) {
      String logName = 'Error in ' + event.Class__c + '.' + event.Method__c;

      logsToInsert.add(
        new Log__c(
          Class__c = event.Class__c,
          Exception_Type__c = event.Exception_Type__c,
          Level__c = event.Level__c,
          Line_Number__c = event.Line_Number__c,
          Message__c = event.Message__c,
          Method__c = event.Method__c,
          Name = logName.left(80),
          RecordId__c = event.RecordId__c,
          Stack_Trace__c = event.Stack_Trace__c
        )
      );
    }

    if (!logsToInsert.isEmpty()) {
      Database.insert(logsToInsert, false);
    }
  }
}
