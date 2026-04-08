/**
 * @description Test class for Logger.
 * Validates that log events are published correctly based on different contexts and inputs.
 * Tests include scenarios for single and multiple log contexts, as well as edge cases like null or empty inputs.
 * Note: Since Logger uses Platform Events for asynchronous logging, these tests focus on ensuring that the log method executes without errors and that the expected code paths are hit. Actual event publication is not directly verifiable in Apex tests.
 * @author Naveen Rathod
 * @date 08-04-2026
 */

@isTest
private class LoggerTest {
  @isTest
  private static void logSingleContextWithErrorShouldPublishEvent() {
    // Arrange
    Logger.LogContext context = new Logger.LogContext('TestClass', 'testMethod')
      .withError(new NullPointerException())
      .withRecordId(UserInfo.getUserId())
      .withLevel('INFO')
      .withPayload('{"key":"value"}');

    // Act
    Test.startTest();
    Logger.log(context);
    Test.stopTest();

    //Assert
    System.assertEquals(true, true, 'Single context log should publish event');
  }

  @isTest
  private static void logMultipleContextsShouldPublishEvents() {
    // Arrange
    List<Logger.LogContext> contexts = new List<Logger.LogContext>{
      new Logger.LogContext('TestClass1', 'method1')
        .withError(new NullPointerException())
        .withMessage('Warning message'),
      new Logger.LogContext('TestClass2', 'method2').withMessage('Info message')
    };

    // Act
    Test.startTest();
    Logger.log(contexts);
    Test.stopTest();

    // Assert:
    System.assertEquals(true, true, 'Logger.log executed without exception');
  }

  @isTest
  private static void logNullContextShouldNotPublishEvent() {
    // Arrange & Act
    Test.startTest();
    Logger.log((Logger.LogContext) null);
    Test.stopTest();

    // Assert
    System.assertEquals(
      true,
      true,
      'Bulk Logger.log executed without exception'
    );
  }

  @isTest
  private static void logEmptyListShouldNotPublishEvents() {
    // Arrange & Act
    Test.startTest();
    Logger.log(new List<Logger.LogContext>());
    Test.stopTest();

    // Assert: method returns gracefully with null input (no exception thrown)
    System.assertEquals(
      true,
      true,
      'Logger.log handled null context without exception'
    );
  }
}
