🚀 Logger Package (Salesforce)
📌 Overview

The Logger Package is a scalable and enterprise-grade logging framework built on Salesforce using Platform Events. It enables asynchronous, bulkified, and secure logging for applications and integrations.

This framework helps capture errors, debug information, and business logs efficiently without impacting transaction performance.

🏗️ Architecture
Application code invokes the Logger class
Logger publishes Log_Event__e (Platform Event)
Trigger processes event via LogEventTriggerHandler
Logs are stored in Log__c
✨ Features
⚡ Asynchronous logging using Platform Events
📦 Bulkified and scalable design
🔐 Secure permission model (User, Integration, Admin)
🧩 Extensible LogContext wrapper
🛠️ Supports ERROR, INFO, DEBUG levels
📊 Centralized log storage (Log__c)
📁 Components
🔹 Apex Classes
Logger – Main logging utility
LogContext – Wrapper for log data
LogEventTriggerHandler – Handles platform events
🔹 Objects
Log__c – Stores log records
Log_Event__e – Platform Event for async logging
🔧 Usage
✅ Log an Error
try {
    // some logic
} catch (Exception e) {
    Logger.error('AccountService', 'createAccount', e);
}
✅ Log Info
Logger.info('AccountService', 'createAccount', 'Account created successfully');
✅ Custom Logging
Logger.log(
    new Logger.LogContext('MyClass', 'myMethod')
        .withMessage('Custom log message')
        .withLevel('INFO')
);
🔐 Permission Model
Permission Set	Purpose
Logger_Integration_PS	For integrations (publish events, create logs)
Logger_User_PS	Basic logging access
Logger_Admin_PS	Full control and troubleshooting
Logger_ReadOnly_PS	View-only access for monitoring
🧠 Best Practices
Avoid logging sensitive data (passwords, tokens)
Use appropriate log levels (INFO, DEBUG, ERROR)
Implement log filtering for performance
Use correlation IDs for tracing
🧪 Testing
Test error logging scenarios
Test bulk logging
Validate event publishing
Ensure trigger inserts logs correctly
🚀 Future Enhancements
📊 Logging dashboard (LWC + Reports)
🔁 Retry mechanism for failed logs
⚙️ Configurable logging via Custom Metadata
🔍 Advanced monitoring & alerting
👨‍💻 Author

Developed as part of a scalable Salesforce logging solution for enterprise applications.

📜 License

This project can be customized and extended as per organizational needs.
