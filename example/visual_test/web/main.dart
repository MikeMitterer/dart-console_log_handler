import "package:console_log_handler/console_log_handler.dart";
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

main() async {
    final Logger _logger = new Logger("unit.test.Logging");
    configLogging();

    _logger.info("This is a log message!");
    
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

void configLogging() {
    hierarchicalLoggingEnabled = true;
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(logToConsole);
}



