# Enable formatter on IDE

## IntelliJ

### Install the `google-java-format` plugin

1. ctrl+shift+A
2. Type and select `plugins`
3. search and install `google-java-format`

### To enable the plugin on Project:

1. Ctrl+Shift+A
2. Type and select `google-java-format Settings`
3. enable `Enable google-java-format`
4. Ok

### To enable the plugin on All Projects:

1. Ctrl+Shift+A
2. Type and select `Settings for Default Settings`
3. Type and select `google-java-format Settings`
4. Enable `Enable google-java-format`
5. Ok

> Ctrl-Alt-L now formats in the project template

## Eclipse

Install the `google-java-format` plugin

1. Download https://github.com/google/google-java-format/releases/download/google-java-format-1.6/google-java-format-eclipse-plugin_1.6.0.jar
2. Create the directory `${ECLIPSE_HOME}/dropins/eclipse/plugins`
3. Copy the plugin to the directory created in step 2

To enable the plugin:

1. Menu Window > Preferences > Java > Code Style > Formatter
2. In `Formatter Implementation` select `google-java-format`

> Ctrl-Alt-F now formats in the project template
