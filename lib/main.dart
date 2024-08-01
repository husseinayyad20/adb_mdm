// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
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
        primaryColor: const Color.fromARGB(255, 9, 41, 65),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 9, 41, 65),
        ),
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
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _logo(),
              const Text(
                'Steps:',
                style: TextStyle(fontSize: 16),
              ),
              _linkText(),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _uploadFile(context),
                    _space(),
                    _testAdb(context),
                    _space(),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _adb(context),
                    _space(),
                    apkIsLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _apk(context),
                    _space(),
                    apkIsLoadingDev
                        ? const Center(child: CircularProgressIndicator())
                        : _apkDev(context),
                    _space(),

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

  SizedBox _space() {
    return const SizedBox(
      height: 30,
    );
  }

  SizedBox _uploadFile(BuildContext context) {
    return SizedBox(
      width: 260,
      child: ElevatedButton(
        onPressed: () async {
          result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['zip'],
          );
          setState(() {});
        },
        style: ButtonStyle(
            iconColor: const MaterialStatePropertyAll(Colors.white),
            backgroundColor:
                MaterialStatePropertyAll(Theme.of(context).primaryColor),
            padding: const MaterialStatePropertyAll(EdgeInsets.all(18))),
        child: Row(
          children: [
            const Icon(Icons.upload_file),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                result == null
                    ? "Upload Update.zip File"
                    : result?.files.first.name ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _logo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
          child: SvgPicture.asset(
        "assets/images/logowinners.svg",
        height: 100,
      )),
    );
  }

  LinkText _linkText() {
    return const LinkText(
      ''' 1- Install OTA Package and than rename file to update, please note the file must be on download folder  https://drive.google.com/file/d/1xkk8eryG_5uFsiPNW_rHEemx2ETNsQeQ/view?usp=sharing
 2- Install ADB: https://theflutterist.medium.com/setting-up-adb-path-on-windows-android-tips-5b5cdaa9084b
 3- Enable USB Debugging on your Android device:
 Go to Settings > About Phone.
 Tap on "Build Number" seven times to enable Developer Options.
 Go back to the main Settings menu, and now you should see "Developer Options" or "Developer Settings."
 Open Developer Options and enable USB Debugging.
 Connect your phone to your computer:
 Use a USB cable to connect your Android device to your computer.
 If prompted on your phone, allow USB debugging. 
 4- After Ota Package Installed the next step is Install Apk To M1 Device Dev Or Prod

           
             ''',
      linkStyle: TextStyle(
          color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w500),
      textStyle: TextStyle(fontSize: 12),
    );
  }

  SizedBox _testAdb(BuildContext context) {
    return SizedBox(
      width: 260,
      child: ElevatedButton(
        onPressed: () async {
          await _testCabel(context);
        },
        style: ButtonStyle(
            iconColor: const MaterialStatePropertyAll(Colors.white),
            backgroundColor:
                MaterialStatePropertyAll(Theme.of(context).primaryColor),
            padding: const MaterialStatePropertyAll(EdgeInsets.all(18))),
        child: const Row(
          children: [
            Icon(Icons.phonelink_setup),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                "Verify the connection",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testCabel(BuildContext context) async {
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
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  bool isLoading = false;
  SizedBox _adb(BuildContext context) {
    return SizedBox(
      width: 260,
      child: ElevatedButton(
        onPressed: () async {
          //_runAdbReboot();
          await _installOTA(context);
        },
        style: ButtonStyle(
            iconColor: const MaterialStatePropertyAll(Colors.white),
            backgroundColor:
                MaterialStatePropertyAll(Theme.of(context).primaryColor),
            padding: const MaterialStatePropertyAll(EdgeInsets.all(18))),
        child: const Row(
          children: [
            Icon(Icons.adb_outlined),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                "Install OTA Package to M1",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _installOTA(BuildContext context) async {
    //_runAdbReboot();
    setState(() {
      isLoading = true;
    });
    var shell = Shell(
        runInShell: true,
        includeParentEnvironment: true,
        options: ShellOptions(
            includeParentEnvironment: true,
            runInShell: true,
            commandVerbose: true));

    try {
      var name = await getUserPath();
      if (kDebugMode) {
        print(' name: $name');
      }
      String mac = '''
    
     
           adb push  /Users/$name/Downloads/update.zip /sdcard/
    
            adb shell am broadcast -a com.telpo.syh.upgradeservice.BROADCAST -f 0x01000000
    
            
            
            ''';
      String win = '''
    
            
          adb push ${result?.files.first.path}  /sdcard/
    
            
            
    adb shell am broadcast -a com.telpo.syh.upgradeservice.BROADCAST -f 0x01000000
    
            
            
            ''';

      await shell.run(Platform.isMacOS ? mac : win).then((value) {
        setState(() {
          isLoading = false;
        });
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
        if (kDebugMode) {
          print(value.outText);
        }
      });
      //var result = await shell.run('adb devices');
      // Process the result
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isMacOS || Platform.isWindows) {
      return await getApplicationDocumentsDirectory();
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }

  bool apkIsLoading = false;
  bool apkIsLoadingDev = false;
  SizedBox _apk(BuildContext context) {
    return SizedBox(
      width: 260,
      child: ElevatedButton(
        onPressed: () async {
          await _installProdApk(context);
        },
        style: ButtonStyle(
            iconColor: const MaterialStatePropertyAll(Colors.white),
            backgroundColor:
                MaterialStatePropertyAll(Theme.of(context).primaryColor),
            padding: const MaterialStatePropertyAll(EdgeInsets.all(18))),
        child: const Row(
          children: [
            Icon(Icons.apps),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                "Install apk (Prod) to M1",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _apkDev(BuildContext context) {
    return SizedBox(
      width: 260,
      child: ElevatedButton(
        onPressed: () async {
          await _installDevApk(context);
        },
        style: ButtonStyle(
            iconColor: const MaterialStatePropertyAll(Colors.white),
            backgroundColor:
                MaterialStatePropertyAll(Theme.of(context).primaryColor),
            padding: const MaterialStatePropertyAll(EdgeInsets.all(18))),
        child: const Row(
          children: [
            Icon(Icons.apps),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                "Install apk (Dev) to M1",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _installProdApk(BuildContext context) async {
    setState(() {
      apkIsLoading = true;
    });
    String apkUrl =
        'https://fr.winners.com.lr/api/general/Files/Enterprise/Version/app-release-ent.apk'; // Replace with your APK URL

    final dir = await _getDownloadDirectory();
    final savePath =
        '${dir.path}/${apkUrl.substring(apkUrl.length - 6, apkUrl.length)}';
    try {
      await Dio(BaseOptions(
        connectTimeout: const Duration(minutes: 3),
        sendTimeout: const Duration(minutes: 5),
        receiveTimeout: const Duration(minutes: 5),
      )).download(apkUrl, savePath).then((value) {
        log(value.data.toString());
      }).catchError((error) {
        setState(() {
          apkIsLoading = false;
        });
        if (kDebugMode) {
          print("Download Failed.\n\n$error");
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text(error.toString()),
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
      if (kDebugMode) {
        print("Download Completed.");
      }
      // Define the shell command for pushing and installing the APK
      String command = '''
            adb push "$savePath" /sdcard/ 
            adb install $savePath
          ''';

      var shell = Shell(
          runInShell: true,
          includeParentEnvironment: true,
          options: ShellOptions(
              includeParentEnvironment: true,
              runInShell: true,
              commandVerbose: true));

      // Execute the shell command
      await shell.run(command).then((result) {
        setState(() {
          apkIsLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("ADB Command Result"),
            content: Text(result.outText.toString()),
            actions: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ],
          ),
        );
        if (kDebugMode) {
          print(result.outText);
        }
      });
    } catch (e) {
      setState(() {
        apkIsLoading = false;
      });
      if (kDebugMode) {
        print("Download Failed.\n\n$e");
      }
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
    }
  }

  Future<void> _installDevApk(BuildContext context) async {
    setState(() {
      apkIsLoadingDev = true;
    });
    String apkUrl =
        'https://dev-fr.winners.com.lr/api/general/Files/Enterprise/Version/app-release-ent.apk'; // Replace with your APK URL

    final dir = await _getDownloadDirectory();
    final savePath =
        '${dir.path}/${apkUrl.substring(apkUrl.length - 6, apkUrl.length)}';
    try {
      await Dio(BaseOptions(
        connectTimeout: const Duration(minutes: 3),
        sendTimeout: const Duration(minutes: 5),
        receiveTimeout: const Duration(minutes: 5),
      )).download(apkUrl, savePath).then((value) {
        log(value.data.toString());
      }).catchError((error) {
        setState(() {
          apkIsLoadingDev = false;
        });
        if (kDebugMode) {
          print("Download Failed.\n\n$error");
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text(error.toString()),
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
      if (kDebugMode) {
        print("Download Completed.");
      }
      // Define the shell command for pushing and installing the APK
      String command = '''
            adb push "$savePath" /sdcard/ 
            adb install $savePath
          ''';

      var shell = Shell(
          runInShell: true,
          includeParentEnvironment: true,
          options: ShellOptions(
              includeParentEnvironment: true,
              runInShell: true,
              commandVerbose: true));

      // Execute the shell command
      await shell.run(command).then((result) {
        setState(() {
          apkIsLoadingDev = false;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("ADB Command Result"),
            content: Text(result.outText.toString()),
            actions: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ],
          ),
        );
        if (kDebugMode) {
          print(result.outText);
        }
      });
    } catch (e) {
      setState(() {
        apkIsLoadingDev = false;
      });
      if (kDebugMode) {
        print("Download Failed.\n\n$e");
      }
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
    }
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
      if (kDebugMode) {
        print('An error occurred: $e');
      }
      return "";
    }
  }
}
