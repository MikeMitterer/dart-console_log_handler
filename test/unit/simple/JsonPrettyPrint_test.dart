/*
 * Copyright (c) 2015, Michael Mitterer (office@mikemitterer.at),
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


import 'package:test/test.dart';
import 'dart:convert';
import 'package:console_log_handler/shared/log_handler.dart';

/// Ignore stupid decision against lowercase (static) const
const JsonCodec JSON = json;

main() {
    // final Logger _logger = new Logger("unit.test.JsonPrettyPrint");
    // configLogging();

    group('JsonPrettyPrint', () {
        setUp(() {
        });


        test('> Indent', () {
            final obj = { "hello": [], "goodbye": { "hallo" : "test", "noch" : 1 } };

            expect(PRETTYJSON.convert(obj),
"""{
   "hello": [],
   "goodbye": {
      "hallo": "test",
      "noch": 1
   }
}"""
            );
            //expect(, equals(0));
        }); // end of 'Indent' test

        test('> with Map', () {
            final Map<String,dynamic> map = { "firstname" : "Mike", "lastname" : "Mitterer {{var}}", "family" : { "daughter" : "Sarah", "age" : 18}};

            expect(PRETTYJSON.convert(map),
"""{
   "firstname": "Mike",
   "lastname": "Mitterer {{var}}",
   "family": {
      "daughter": "Sarah",
      "age": 18
   }
}"""
            );
        }); // end of 'with Map' test

        test('> String', () {
            final Map<String,dynamic> map = { "firstname" : "Mike", "lastname" : "Mitterer {{var}}", "family" : { "daughter" : "Sarah", "age" : 18}};
            final String jsonString = PRETTYJSON.convert(map);

            expect(map["family"]["age"],18);

            final Map<String,dynamic> mapDecoded = JSON.decode(jsonString) as Map<String,dynamic>;
            expect(mapDecoded,new isInstanceOf<Map<String,dynamic>>());

            expect(mapDecoded.length,map.length);
            expect(mapDecoded["family"]["age"],18);
        }); // end of 'String' test

    });
    // end 'JsonPrettyPrint' group
}

