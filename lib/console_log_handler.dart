library console_log_handler;

import 'dart:html';
import "dart:convert";
import "package:intl/intl.dart";

import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';

/// Is called after the cosole output is done
typedef void MakeConsoleGroup(final LogRecord logRecord);

/**
 * Shows log-messages on the Console
 *
 * Format:
 *      %p = Outputs LogRecord.level
 *      %m = Outputs LogRecord.message
 *      %n = Outputs the Logger.name
 *      %r | %<width>r = Short Logger.name - padded with space if width is given
 *      %t = Outputs the timestamp according to the Date Time Format specified
 *      %s = Outputs the logger sequence
 *      %x = Outputs the exception
 *      %e = Outputs the exception message
 *
 * Sample für einen LogConsoleHandler mit vollem Logger-Name:
 *
 *      void configLogging() {
 *          Logger.root.level = Level.INFO;
 *          Logger.root.onRecord.listen(new LogConsoleHandler());
 *      }
 */
class LogConsoleHandler implements BaseLoggingHandler {

    /// prettyPrint for JSON
    static const JsonEncoder PRETTYJSON = const JsonEncoder.withIndent('   ');

    LogRecordTransformer transformer;

    final String messageFormat;
    final String timestampFormat;

    final MakeConsoleGroup groupMaker;

    LogConsoleHandler( { this.messageFormat: ConsolStringTransformer.DEFAULT_MESSAGE_FORMAT,
                        this.timestampFormat: ConsolStringTransformer.DEFAULT_DATE_TIME_FORMAT,
                        this.groupMaker: _defaultGroupMaker } ) {

        transformer = new ConsolStringTransformer(messageFormat: messageFormat, timestampFormat: timestampFormat);
    }

    /**
     * More infos about console output:
     *      https://developer.chrome.com/devtools/docs/console
     */
    void call(final LogRecord logRecord) {
        if (logRecord.level <= Level.FINE) {
            window.console.debug(transformer.transform(logRecord));

        }
        else if (logRecord.level <= Level.INFO) {
            window.console.info(transformer.transform(logRecord));

        }
        else {
            window.console.error(transformer.transform(logRecord));
        }

        groupMaker(logRecord);
    }

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

    /// Called after cosole output is done (via makeGroup - can be overwritten)
    static void _defaultGroupMaker(final LogRecord logRecord) {

        makeStackTraceGroup("  ○ StackTrace",logRecord);
        makeObjectGroup("  ○ Dart-Object",logRecord);
    }
}

/// Format a log record according to a string pattern
class ConsolStringTransformer implements LogRecordTransformer {

    /// Outputs [LogRecord.level]
    static const LEVEL = "%p";

    /// Outputs [LogRecord.message]
    static const MESSAGE = "%m";

    /// Outputs the [Logger.name]
    static const NAME = "%n";

    /// Outputs the short version of [Logger.name]
    static const NAME_SHORT = '(?:%\\d{1,2}r|%r)';

    /// Outputs the timestamp according to the Date Time Format specified in
    /// [timestampFormatString]
    static const TIME = "%t";

    /// Outputs the logger sequence
    static const SEQ = "%s";

    /// logger exception
    static const EXCEPTION = "%x";

    /// logger exception message
    static const EXCEPTION_TEXT = "%e";

    /// Default format for a log message that does not contain an exception.
    static const DEFAULT_MESSAGE_FORMAT = "%r: (%t) %m";

    /// Default date time format for log messages
    static const DEFAULT_DATE_TIME_FORMAT = "HH:mm:ss.SSS";

    /// Contains the standard message format string
    final String messageFormat;

    /// Contains the timestamp format string
    final String timestampFormat;

    /// Contains the date format instance
    DateFormat dateFormat;

    /// Contains the regexp pattern
    static final _regexp = new List<RegExp>.from([new RegExp(LEVEL), new RegExp(MESSAGE), new RegExp(NAME), new RegExp(NAME_SHORT), new RegExp(TIME), new RegExp(SEQ), new RegExp(EXCEPTION), new RegExp(EXCEPTION_TEXT)]);

    ConsolStringTransformer({String this.messageFormat : StringTransformer.DEFAULT_MESSAGE_FORMAT, String this.timestampFormat : StringTransformer.DEFAULT_DATE_TIME_FORMAT}) {
        dateFormat = new DateFormat(this.timestampFormat);
    }

    /**
     * Transform the log record into a string according to the [messageFormat]
     * and [timestampFormat] pattern.
     */
    String transform(LogRecord logRecord) {
        String formatString = messageFormat;

        int lengthInPattern(final String pattern) {
            final String digits = pattern.replaceAll(new RegExp('[^\\d]'),'');
            return int.parse(digits,onError: (_) => 0);
        }

        _regexp.forEach((final RegExp regexp) {
            switch (regexp.pattern) {

                case LEVEL:
                    formatString = formatString.replaceAll(regexp, logRecord.level.name);
                    break;

                case MESSAGE:
                    formatString = formatString.replaceAll(regexp, logRecord.message);
                    break;

                case NAME:
                    formatString = formatString.replaceAll(regexp, logRecord.loggerName);
                    break;

                case NAME_SHORT:
                    final String shortLoggerName = logRecord.loggerName.replaceAll(new RegExp('^.+\\.'), "");

                    formatString = formatString.replaceAllMapped(regexp, (final Match match) {
                        final int length = lengthInPattern(match.group(0));
                        return shortLoggerName.padRight(length);
                    });
                    break;

                case TIME:
                    if (logRecord.time != null) {
                        try {
                            formatString = formatString.replaceAll(regexp, dateFormat.format(logRecord.time));
                        }
                        on UnimplementedError {
                            // at time of writing, dateFormat.format seems to be unimplemented.
                            // so just return the time.toString()
                            formatString = formatString.replaceAll(regexp, logRecord.time.toString());
                        }
                    }

                    break;
                case SEQ:
                    formatString = formatString.replaceAll(regexp, logRecord.sequenceNumber.toString());
                    break;

                case EXCEPTION:case EXCEPTION_TEXT:
                    if (logRecord.error != null) formatString = formatString.replaceAll(regexp, logRecord.error.toString());
                    break;
            }
        });

        return formatString;
    }
}