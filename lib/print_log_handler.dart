library console_log_handler.print;

import "dart:convert";

import 'package:ansicolor/ansicolor.dart';
import 'package:supports_color/supports_color.dart';
import 'package:logging/logging.dart';
import 'package:console_log_handler/shared/log_handler.dart';

export 'package:logging/logging.dart';
export 'package:console_log_handler/shared/log_handler.dart';

final _DEFAULT_HANDLER = new LogPrintHandler();

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
void configLogging({ final Level show: Level.WARNING }) {
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
class LogPrintHandler extends LogHandler {

    /// Converts [LogRecord] to String
    final TransformLogRecord _transformer;

    final AnsiPen _penInfo = new AnsiPen()..blue();
    final AnsiPen _penWarning = new AnsiPen()..yellow();
    final AnsiPen _penError = new AnsiPen()..red();

    final bool _supportsColor = supportsColor;

    LogPrintHandler( { final TransformLogRecord transformer: defaultTransformer } )
        : _transformer = transformer;

    /// More infos about console output:
    ///      https://developer.chrome.com/devtools/docs/console
    @override
    void toConsole(final LogRecord logRecord,{ TransformLogRecord transformer }) {
        transformer ??= _transformer;

        if (logRecord.level <= Level.FINE || !_supportsColor) {
            print(transformer(logRecord));
        }
        else if (logRecord.level <= Level.INFO) {
            print(_penInfo(transformer(logRecord)));
        }
        else if (logRecord.level <= Level.WARNING) {
            print(_penWarning(transformer(logRecord)));
        }
        else {
            print(_penError(transformer(logRecord)));
        }

        makeGroup(logRecord);
    }

    @override
    void makeObjectGroup(final String groupName, final LogRecord logRecord) {

        void makeGroupWithString(final String groupName,final String objectAsString) {
            print(groupName);
            print(objectAsString);
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
            print(groupName);
            print(logRecord.stackTrace.toString());
        }
    }



    // -- private -------------------------------------------------------------

}


