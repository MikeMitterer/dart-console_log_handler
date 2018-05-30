# console_log_handler
> Shows your log-messages on the Console (Browser + Commandline)

![Screenshot][1]
![Screenshot][2]

## How to use it
```dart
library unit.test;

import 'package:logging/logging.dart';

// Browser
import "package:console_log_handler/console_log_handler.dart";

// Commandline
import "package:console_log_handler/print_log_handler.dart";

void main() {
    configLogging();
    final Logger _logger = new Logger("test");

    try {
        throw "Sample for exception";
    } on String catch( error, stacktrace) {

        _logger.severe("Caught error",error,stacktrace);
    }

}

```

### If you have problems
* [Issues][3]

### License

    Copyright 2018 Michael Mitterer (office@mikemitterer.at), 
    IT-Consulting and Development Limited, Austrian Branch

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, 
    software distributed under the License is distributed on an 
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
    either express or implied. See the License for the specific language 
    governing permissions and limitations under the License.
    
If this plugin is helpful for you - please [(Circle)](http://gplus.mikemitterer.at/) me.

[1]: https://raw.githubusercontent.com/MikeMitterer/dart-console_log_handler/master/doc/_resources/screenshot_browser.png
[2]: https://raw.githubusercontent.com/MikeMitterer/dart-console_log_handler/master/doc/_resources/screenshot_console.png
[3]: https://github.com/MikeMitterer/dart-console_log_handler/issues

