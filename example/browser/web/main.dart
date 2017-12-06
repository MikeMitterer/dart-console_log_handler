import 'package:logging/logging.dart';
import "package:console_log_handler/console_log_handler.dart";

main() async {
    final Logger _logger = new Logger("unit.test.Logging");
    configLogging(show: Level.FINE);

    _logger.fine("Show this debug message");

    _logger.info("This is a log message!");

    final Map<String, dynamic> map = {
        "firstname" : "Mike", "lastname" : "Mitterer {{var}}", "family" : {
            "daughter" : "Sarah", "age" : 18
        }
    };

    _logger.info("Hallo", map);

    _logger.warning("I warned you...");

    try {
        throw "Sample for exception";
    } on String catch( error, stacktrace) {

        _logger.severe("Caught error",error,stacktrace);
    }
}




