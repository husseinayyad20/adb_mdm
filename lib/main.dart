// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:process_run/process_run.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'adb Winners MDM',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'adb Winners MDM'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FilePickerResult? result;
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(19.0),
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            //
            // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
            // action in the IDE, or press "p" in the console), to see the
            // wireframe for each widget.

            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Steps:',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                '''1-  Install ADB: https://theflutterist.medium.com/setting-up-adb-path-on-windows-android-tips-5b5cdaa9084b
 2- Enable USB Debugging on your Android device:
Go to Settings > About Phone.
Tap on "Build Number" seven times to enable Developer Options.
Go back to the main Settings menu, and now you should see "Developer Options" or "Developer Settings."
Open Developer Options and enable USB Debugging.
Connect your phone to your computer:
Use a USB cable to connect your Android device to your computer.
If prompted on your phone, allow USB debugging. 

             
               ''',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 240,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['zip'],
                    );
                    setState(() {});
                  },
                  style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.all(18))),
                  icon: const Icon(Icons.upload_file),
                  label: Text(result == null
                      ? "upload update.zip file"
                      : result?.files.first.name ?? ''),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              _testAdb(context),
              const SizedBox(
                height: 40,
              ),
              _adb(context)
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  SizedBox _testAdb(BuildContext context) {
    return SizedBox(
      width: 240,
      child: ElevatedButton.icon(
        onPressed: () async {
          //_runAdbReboot();

          var shell = Shell(
              runInShell: true,
              includeParentEnvironment: true,
              options: ShellOptions(
                  includeParentEnvironment: true,
                  runInShell: true,
                  commandVerbose: true));

          try {
            String mac = '''

     adb devices
        
        ''';
            String win = '''

        
      adb devices 
        
        
        ''';
            await shell.run(Platform.isMacOS ? mac : win).then((value) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("adb devices"),
                  content: Text(value.outText.toString()),
                  actions: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"))
                  ],
                ),
              );
            });
            //var result = await shell.run('adb devices');
            // Process the result
          } catch (e) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Error"),
                content: Text(e.toString()),
                actions: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text("OK"))
                ],
              ),
            );
            print('Error: $e');
          }
        },
        style: const ButtonStyle(
            padding: MaterialStatePropertyAll(EdgeInsets.all(18))),
        icon: const Icon(Icons.phonelink_setup),
        label: const Text("Verify the connection"),
      ),
    );
  }

  SizedBox _adb(BuildContext context) {
    return SizedBox(
      width: 240,
      child: ElevatedButton.icon(
        onPressed: () async {
          //_runAdbReboot();

          var shell = Shell(
              runInShell: true,
              includeParentEnvironment: true,
              options: ShellOptions(
                  includeParentEnvironment: true,
                  runInShell: true,
                  commandVerbose: true));

          try {
            var name = await getUserPath();
            if (name != null) {
              print(' name: $name');
            } else {
              print('Failed to retrieve name ');
            }
            String mac = '''

 
       adb push  /Users/$name/Downloads/update.zip /sdcard/

        adb shell am broadcast -a com.telpo.syh.upgradeservice.BROADCAST -f 0x01000000

        
        
        ''';
            String win = '''

        
      adb push ${result?.files.first.path}  /sdcard/

        
        
adb shell am broadcast -a com.telpo.syh.upgradeservice.BROADCAST -f 0x01000000

        
        
        ''';

            await shell
                .run(Platform.isMacOS ? mac : win)
                .then((value) => print(value.outText));
            //var result = await shell.run('adb devices');
            // Process the result
          } catch (e) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Error"),
                content: Text(e.toString()),
                actions: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text("OK"))
                ],
              ),
            );
            print('Error: $e');
          }
        },
        style: const ButtonStyle(
            padding: MaterialStatePropertyAll(EdgeInsets.all(18))),
        icon: const Icon(Icons.adb_outlined),
        label: const Text("run adb commands"),
      ),
    );
  }

  Future<String> getUserPath() async {
    var shell = Shell();

    try {
      var result = await shell.run('whoami');
      if (result.first.exitCode == 0) {
        return result.first.stdout.toString().trim();
      } else {
        throw Exception('Failed to get Downloads path');
      }
    } catch (e) {
      print('An error occurred: $e');
      return "";
    }
  }

  void _runAdbReboot() async {
    // This works on Windows/Linux/Mac

    var shell = Shell();

    await shell.run('''

# Display some text
echo Hello

# Display dart version
dart --version

# Display pub version
pub --version

  ''');

    shell = shell.pushd('example');

    await shell.run('''

# Listing directory in the example folder
dir

  ''');
    shell = shell.popd();
  }
}
