import 'package:grinder/grinder.dart';

main(final List<String> args) => grind(args);

@Task()
@Depends(testUnit)
test() {
}

@Task()
@Depends(analyze)
testUnit() {
    new TestRunner().testAsync(files: "test/unit");

    // Alle test mit @TestOn("content-shell") im header
    // new TestRunner().testAsync(files: "test/unit", platformSelector: "chrome");
}

@Task()
analyze() {
    final List<String> libs = [
        "lib/console_log_handler.dart"
    ];

    libs.forEach((final String lib) => Analyzer.analyze(lib));
    Analyzer.analyze("test");
}

//@DefaultTask()
//@Depends(test)
//build() {
//  Pub.build();
//}

@Task()
clean() => defaultClean();
