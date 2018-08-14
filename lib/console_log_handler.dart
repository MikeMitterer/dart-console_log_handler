library console_log_handler.console;

import 'dart:html';
import "dart:convert";

import 'package:logging/logging.dart';
import 'package:console_log_handler/shared/log_handler.dart';

export 'package:logging/logging.dart';
export 'package:console_log_handler/shared/log_handler.dart';

final _DEFAULT_HANDLER = new LogConsoleHandler();

/// Ignore stupid decision against lowercase (static) const
const JsonCodec JSON = json;

/// Shows your log-messages in the browser console
///
/// Usage:
///       void configLogging() {
///           Logger.root.level = Level.INFO;
///           Logger.root.onRecord.listen(logToConsole);
///       }
void logToConsole(final LogRecord logRecord,{ TransformLogRecord transformer })
    => _DEFAULT_HANDLER.toConsole(logRecord,transformer: transformer);

/// Logging-Level-Configuration
///
/// Usage:
///
///     main() {
///         final Logger _logger = new Logger("unit.test.Logging");
///         configLogging(show: Level.INFO);
///
///         ...
///     }
///
void configLogging({ final Level show: Level.INFO }) {
    hierarchicalLoggingEnabled = true;
    Logger.root.level = show;
    Logger.root.onRecord.listen(logToConsole);
}

/// Shows log-messages on the Console
/// 
/// Usage:
///       void configLogging() {
///           Logger.root.level = Level.INFO;
///           Logger.root.onRecord.listen(new LogConsoleHandler());
///       }
///
class LogConsoleHandler extends LogHandler {

    final TransformLogRecord _transformer;

    LogConsoleHandler( { final TransformLogRecord transformer: transformerDefault } )
        : _transformer = transformer;

    /// More infos about console output:
    ///      https://developer.chrome.com/devtools/docs/console
    @override
    void toConsole(final LogRecord logRecord,{ TransformLogRecord transformer }) {
        transformer ??= _transformer;
        
        if (logRecord.level <= Level.FINE) {
            window.console.debug(transformer(logRecord));

        }
        else if (logRecord.level <= Level.INFO) {
            window.console.info(transformer(logRecord));

        }
        else {
            window.console.error(transformer(logRecord));
        }

        makeGroup(logRecord);
    }

    @override
    void makeObjectGroup(final String groupName, final LogRecord logRecord) {

        void makeGroupWithString(final String groupName,final String objectAsString) {
            window.console.groupCollapsed(groupName);
            window.console.log(objectAsString);
            window.console.groupEnd();
        }

        if (logRecord.error != null) {
            final Object error = logRecord.error;

            final String groupNameWithType = "$groupName (${error.runtimeType})";
            if (error is Map || error is List) {
                try {
                    makeGroupWithString(groupNameWithType,prettyPrintJson(error));

                } on FormatException {
                    makeGroupWithString(groupNameWithType,error.toString());
                }
            } else {
                try {
                    final decoded = JSON.decode(error.toString());
                    makeGroupWithString(groupNameWithType,prettyPrintJson(decoded));

                } on Exception {
                    makeGroupWithString(groupNameWithType,error.toString());
                }

            }
        }
    }


    @override
    void makeStackTraceGroup(final String groupName, final LogRecord logRecord) {
        if (logRecord.stackTrace != null) {
            window.console.group(groupName);
            window.console.log(logRecord.stackTrace.toString());
            window.console.groupEnd();
        }
    }

    // -- private -------------------------------------------------------------

}


