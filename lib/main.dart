// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:link_text/link_text.dart';
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
      title: 'ADB Winners MDM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'ADB Winners MDM'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FilePickerResult? result;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Steps:',
                style: TextStyle(fontSize: 16),
              ),
              const LinkText(
                ''' 1- install otapackage-v1.1.4 and than rename file to update, please note the file must be on download folder  https://drive.google.com/file/d/1gsTlVaMjFUNv2yLPP8sy0kzXzLFiDV_D/view
 2-  Install ADB: https://theflutterist.medium.com/setting-up-adb-path-on-windows-android-tips-5b5cdaa9084b
 3- Enable USB Debugging on your Android device:
 Go to Settings > About Phone.
 Tap on "Build Number" seven times to enable Developer Options.
 Go back to the main Settings menu, and now you should see "Developer Options" or "Developer Settings."
 Open Developer Options and enable USB Debugging.
 Connect your phone to your computer:
 Use a USB cable to connect your Android device to your computer.
 If prompted on your phone, allow USB debugging. 

             
               ''',
                linkStyle: TextStyle(
                    color: Colors.blue,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
                textStyle: TextStyle(fontSize: 12),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                            padding:
                                MaterialStatePropertyAll(EdgeInsets.all(18))),
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
                    _adb(context),
                  ],
                ),
              )
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
            print(' name: $name');
            String mac = '''

 
       adb push  /Users/$name/Downloads/update.zip /sdcard/

        adb shell am broadcast -a com.telpo.syh.upgradeservice.BROADCAST -f 0x01000000

        
        
        ''';
            String win = '''

        
      adb push ${result?.files.first.path}  /sdcard/

        
        
adb shell am broadcast -a com.telpo.syh.upgradeservice.BROADCAST -f 0x01000000

        
        
        ''';

            await shell.run(Platform.isMacOS ? mac : win).then((value) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("adb"),
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
              print(value.outText);
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
