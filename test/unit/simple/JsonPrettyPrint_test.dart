part of unit.test;

testJsonPrettyPrint() {
    final Logger _logger = new Logger("unit.test.JsonPrettyPrint");

    const JsonEncoder PRETTYJSON = const JsonEncoder.withIndent('   ');

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

            final Map<String,dynamic> mapDecoded = JSON.decode(jsonString);
            expect(mapDecoded,new isInstanceOf<Map<String,dynamic>>());

            expect(mapDecoded.length,map.length);
            expect(mapDecoded["family"]["age"],18);
        }); // end of 'String' test

    });
    // end 'JsonPrettyPrint' group
}

//------------------------------------------------------------------------------------------------
// Helper
//------------------------------------------------------------------------------------------------
