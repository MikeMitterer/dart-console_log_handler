library console_log_handler;

import 'dart:html';
import 'dart:math';
import "dart:convert";
import "package:intl/intl.dart";

import 'package:logging/logging.dart';

/// Is called after the console output is done
typedef void MakeConsoleGroup(final LogRecord logRecord);

/// Converts [LogRecord] to String
typedef String TransformLogRecord(final LogRecord logRecord);

final LogConsoleHandler _DEFAULT_HANDLER = new LogConsoleHandler();

/// Shows your log-messages in the browser console
///
/// Usage:
///       void configLogging() {
///           Logger.root.level = Level.INFO;
///           Logger.root.onRecord.listen(logToConsole);
///       }
void logToConsole(final LogRecord logRecord,{ TransformLogRecord transformer })
    => _DEFAULT_HANDLER.toConsole(logRecord,transformer: transformer);

/// Shows log-messages on the Console
/// 
/// Usage:
///       void configLogging() {
///           Logger.root.level = Level.INFO;
///           Logger.root.onRecord.listen(new LogConsoleHandler());
///       }
///
class LogConsoleHandler {

    /// prettyPrint for JSON
    static const JsonEncoder PRETTYJSON = const JsonEncoder.withIndent('   ');

    final TransformLogRecord _transformer;

    final MakeConsoleGroup _groupMaker;

    LogConsoleHandler( { final TransformLogRecord transformer: defaultTransformer,
        final MakeConsoleGroup groupMaker: _defaultGroupMaker } )
        : _transformer = transformer, _groupMaker = groupMaker;

    /// More infos about console output:
    ///      https://developer.chrome.com/devtools/docs/console
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

        _groupMaker(logRecord);
    }

    void call(final LogRecord logRecord) => toConsole(logRecord);

    static void makeObjectGroup(final String groupName, final LogRecord logRecord) {

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

    static void makeStackTraceGroup(final String groupName, final LogRecord logRecord) {
        if (logRecord.stackTrace != null) {
            window.console.group(groupName);
            window.console.log(logRecord.stackTrace.toString());
            window.console.groupEnd();
        }
    }

    static String prettyPrintJson(final json) {
        return PRETTYJSON.convert(json);
    }

    // -- private -------------------------------------------------------------

    /// Called after console output is done (via makeGroup - can be overwritten)
    static void _defaultGroupMaker(final LogRecord logRecord) {

        makeStackTraceGroup("  ○ StackTrace",logRecord);
        makeObjectGroup("  ○ Dart-Object",logRecord);
    }
}

String defaultTransformer(final LogRecord logRecord,{ final int nameWidth = 20 }) {
    final dateFormat = new DateFormat("HH:mm:ss.SSS");

    String loggerName = logRecord.loggerName.substring(max(0,logRecord.loggerName.length - nameWidth));
    String shortLoggerName = logRecord.loggerName.replaceAll(new RegExp('^.+\\.'), "");

    String time;
    if (logRecord.time != null) {
        time = dateFormat.format(logRecord.time);
    } else {
        time = dateFormat.format(new DateTime.now());
    }

    if(loggerName.length > nameWidth) {
        loggerName = shortLoggerName;
    }
    loggerName += ":";
    loggerName = loggerName.padRight(nameWidth);
    
    if (logRecord.error != null) {
        return "$time [${logRecord.level}] ${loggerName} ${logRecord.message} / ${logRecord.error}";

    } else {
        return "$time [${logRecord.level}] ${loggerName} ${logRecord.message}";
    }
}

