library console_log_handler.print;

import "dart:convert";
import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:logging/logging.dart';
import 'package:console_log_handler/shared/log_handler.dart';

export 'package:logging/logging.dart';
export 'package:console_log_handler/shared/log_handler.dart';

final _DEFAULT_HANDLER = new LogPrintHandler();

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
void configLogging({ final Level show: Level.INFO,
        final TransformLogRecord transformer = transformerDefault }) {

    hierarchicalLoggingEnabled = true;

    Logger.root.level = show;
    Logger.root.onRecord.listen((final LogRecord event)
        => logToConsole(event,transformer: transformer));

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

    final bool _supportsColor = stdout.supportsAnsiEscapes;

    LogPrintHandler( { final TransformLogRecord transformer: transformerDefault } )
        : _transformer = transformer;

    /// More infos about console output:
    ///      https://developer.chrome.com/devtools/docs/console
    @override
    void toConsole(final LogRecord logRecord,{ TransformLogRecord transformer }) {
        transformer ??= _transformer;

        if (logRecord.level <= Level.FINE) {
            print(transformer(logRecord));
        }
        else if (logRecord.level <= Level.INFO) {
            if(_supportsColor) {
                print(_penInfo(transformer(logRecord)));
            } else {
                print(transformer(logRecord));
            }
        }
        else if (logRecord.level <= Level.WARNING) {
            if(_supportsColor) {
                print(_penWarning(transformer(logRecord)));
            } else {
                print(transformer(logRecord));
            }
        }
        else {
            if(_supportsColor) {
                print(_penError(transformer(logRecord)));
            } else {
                print(transformer(logRecord));
            }
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


