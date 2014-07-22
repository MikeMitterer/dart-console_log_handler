library unit.test;

//import 'dart:html';
//import 'dart:mirrors';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

//---------------------------------------------------------
// Extra packages (piepag) (http_utils, validate, signer)
//---------------------------------------------------------

import "package:console_log_handler/console_log_handler.dart";

//---------------------------------------------------------
// WebApp-Basis (piwab) - webapp_base_dart
//---------------------------------------------------------

//---------------------------------------------------------
// UI-Basis (pibui) - webapp_base_ui
//---------------------------------------------------------

// __ interfaces
// __ tools
//   __ conroller
//   __ decorators
//   __ services
//   __ component

//---------------------------------------------------------
// MobiAd UI (pimui) - mobiad_rest_ui
//---------------------------------------------------------

// __ interfaces
// __ tools
//   __ conroller
//   __ decorators
//   __ services
//   __ component

//---------------------------------------------------------
// Testimports (nur bei Unit-Tests)
//

part 'simple/JsonPrettyPrint_test.dart';


//-----------------------------------------------------------------------------
// Test-Imports (find . -mindepth 2 -iname "*.dart" | sed "s/\.\///g" | sed "s/\(.*\)/part '\1';/g")

part 'logging/Logging_test.dart';



// Mehr Infos: http://www.dartlang.org/articles/dart-unit-tests/
void main() {
    final Logger logger = new Logger("test");

    useHtmlEnhancedConfiguration();
    configLogging();
    //startQuickLogging();

    testJsonPrettyPrint();
    testLogging();
}

// Weitere Infos: https://github.com/chrisbu/logging_handlers#quick-reference

void configLogging() {
    //hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}
