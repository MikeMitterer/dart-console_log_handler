/*
 * Copyright (c) 2017, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 *
 * All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

library console_log_handler.shared;

import "dart:convert";
import 'package:logging/logging.dart';
import 'dart:math';
import "package:intl/intl.dart";

part 'transformer.dart';

/// Is called after the console output is done
typedef void MakeConsoleGroup(final LogRecord logRecord);

/// prettyPrint for JSON
const JsonEncoder PRETTYJSON = const JsonEncoder.withIndent('   ');

abstract class LogHandler {
    static const String GROUP_STACK_TRACE = '  ○ StackTrace';
    static const String GROUP_OBJECT = '  ○ Dart-Object';
    
    void toConsole(final LogRecord logRecord,{ TransformLogRecord transformer });
    void call(final LogRecord logRecord) => toConsole(logRecord);

    /// [groupName] is for example [GROUP_STACK_TRACE]
    void makeStackTraceGroup(final String groupName, final LogRecord logRecord);

    /// [groupName] is for example [GROUP_OBJECT]
    void makeObjectGroup(final String groupName, final LogRecord logRecord);

    /// Called after console output is done (via makeGroup - can be overwritten)
    void makeGroup(final LogRecord logRecord) {
        makeStackTraceGroup(GROUP_STACK_TRACE,logRecord);
        makeObjectGroup(GROUP_OBJECT,logRecord);
    }
}

String prettyPrintJson(final json) {
    return PRETTYJSON.convert(json);
}

