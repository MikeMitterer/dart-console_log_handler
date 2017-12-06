import "package:console_log_handler/console_log_handler.dart";
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

main() async {
    final Logger _logger = new Logger("unit.test.Logging");
    configLogging();

    final Map<String, dynamic> map = {
        "firstname" : "Mike", "lastname" : "Mitterer {{var}}", "family" : {
            "daughter" : "Sarah", "age" : 18
        }
    };

    _logger.info("Hallo", map);

    try {
        throw "Sample for exception";
    } on String catch( error, stacktrace) {

        _logger.severe("Caught error",error,stacktrace);
    }
}

String myTransformer(final LogRecord logRecord) {
    final shortLoggerName = logRecord.loggerName.replaceAll(new RegExp('^.+\\.'), "");
    final dateFormat = new DateFormat("HH:mm:ss.SSS");

    String time;
    if (logRecord.time != null) {
        time = dateFormat.format(logRecord.time);
    } else {
        time = dateFormat.format(new DateTime.now());
    }
    if (logRecord.error != null) {
        return "$time ${logRecord.level} ${shortLoggerName.padRight(10)} ${logRecord.message} / ${logRecord.error}";

    } else {
        return "$time ${logRecord.level} ${shortLoggerName.padRight(10)} ${logRecord.message}";
    }
}

void configLogging() {
    hierarchicalLoggingEnabled = true;
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(logToConsole);
}



