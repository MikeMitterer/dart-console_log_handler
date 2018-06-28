// Copyright (c) 2017, Mike Mitterer. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import "package:console_log_handler/print_log_handler.dart";

main() async {
    final Logger _logger = new Logger("unit.test.Logging");
    configLogging(show: Level.FINE, transformer: transformerMessageOnly);

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


