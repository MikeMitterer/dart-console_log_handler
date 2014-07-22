Shows your log-messages on the Console

This is how it looks like:
![Screenshot][1]


```dart
library unit.test;

import 'package:logging/logging.dart';
import "package:console_log_handler/console_log_handler.dart";

void main() {
    configLogging();
    final Logger _logger = new Logger("test");

    try {
        throw "Sample for exception";
    } on String catch( error, stacktrace) {

        _logger.severe("Caught error",error,stacktrace);
    }

}

void configLogging() {
    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}
```

###If you have problems###
* [Issues][2]

###History ###
* 0.1.2 - Initial release

###License###

    Copyright 2014 Michael Mitterer, IT-Consulting and Development Limited,
    Austrian Branch

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, 
    software distributed under the License is distributed on an 
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
    either express or implied. See the License for the specific language 
    governing permissions and limitations under the License.
    
###Thanks###
    
    I used Chris Buckett's (chrisbuckett@gmail.com) [logging_handler][4]-library for my work.
    Thank's Chris!
    
If this plugin is helpful for you - please [(Circle)](http://gplus.mikemitterer.at/) me.

[1]: https://raw.githubusercontent.com/MikeMitterer/dart-console_log_handler/master/doc/_resources/screenshot.png
[2]: https://github.com/MikeMitterer/dart-console_log_handler/issues
[3]: https://github.com/MikeMitterer/dart-console_log_handler
[4]: https://github.com/chrisbu/logging_handlers  
