// // Copyright 2024 Pepe Tiebosch (byme.dev). All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.
// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_adb/adb_stream.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'dart:async';
// import 'dart:math';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_adb/adb_connection.dart';
// import 'package:flutter_adb/adb_crypto.dart';
// import 'package:flutter_adb/adb_stream.dart';
// import 'package:flutter_adb/flutter_adb.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final StateProvider<AdbConnection> adbConnectionProvider = StateProvider((ref) {
//   final crypto = AdbCrypto();
//   final connection = AdbConnection('127.0.0.1', 5555, crypto, verbose: true);
//   return connection;
// });

// final FutureProvider<AdbStream> adbStreamProvider = FutureProvider((ref) async {
//   final connection = ref.watch(adbConnectionProvider);
//   await connection.connect();
//   return await connection.openShell();
// });

// void main() {
//   final ProviderContainer container = ProviderContainer();
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Adb Example',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends ConsumerStatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   ConsumerState<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends ConsumerState<MyHomePage> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _ipController = TextEditingController();
//   final TextEditingController _portController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//           title: StreamBuilder(
//             stream: ref.read(adbConnectionProvider).onConnectionChanged,
//             initialData: false,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 if (snapshot.data ?? false) {
//                   return Text(
//                     'ADB Flutter Example, Connected to: ${ref.watch(adbConnectionProvider).ip}:${ref.watch(adbConnectionProvider).port}',
//                     style: const TextStyle(fontSize: 32),
//                   );
//                 } else {
//                   return const Text(
//                     'ADB Flutter Example, Not connected',
//                     style: TextStyle(fontSize: 32),
//                   );
//                 }
//               } else {
//                 return const CircularProgressIndicator();
//               }
//             },
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Form(
//                 key: _formKey,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const Spacer(),
//                     IntrinsicWidth(
//                       child: TextFormField(
//                         controller: _ipController,
//                         decoration: InputDecoration(
//                           border: const OutlineInputBorder(),
//                           hintText: ref.watch(adbConnectionProvider).ip,
//                         ),
//                         //validates valid ipv4 address
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Invalid IP';
//                           }
//                           if (!RegExp(r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$').hasMatch(value)) {
//                             return 'Invalid IP';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     IntrinsicWidth(
//                       child: TextFormField(
//                         controller: _portController,
//                         decoration: InputDecoration(
//                           border: const OutlineInputBorder(),
//                           hintText: ref.watch(adbConnectionProvider).port.toString(),
//                         ),
//                         // Validates valid port
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Invalid Port';
//                           }
//                           if (int.tryParse(value) == null || int.tryParse(value)! < 0 || int.tryParse(value)! > 65535) {
//                             return 'Invalid Port';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () async {
//                         if (_formKey.currentState!.validate()) {
//                           await ref.read(adbConnectionProvider).disconnect();
//                           ref.read(adbConnectionProvider.notifier).state = AdbConnection(
//                             _ipController.text,
//                             int.parse(_portController.text),
//                             AdbCrypto(),
//                           );
//                         }
//                       },
//                       child: const Text('Connect'),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: 700),
//                   child: ref.watch(adbStreamProvider).maybeWhen(
//                       data: (adbStream) {
//                         return AdbTerminal(stream: adbStream);
//                       },
//                       loading: () => const CircularProgressIndicator(),
//                       error: (error, stack) {
//                         return Text('Error: $error');
//                       },
//                       orElse: () => const SizedBox()),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () async {
//             final result = await Adb.sendSingleCommand(
//                 'monkey -p com.google.android.googlequicksearchbox 1;sleep 3;input keyevent KEYCODE_HOME');
//             debugPrint('Result: $result');
//           },
//           tooltip: 'Send single command',
//           child: const Icon(Icons.send),
//         ));
//   }
// }
// // Copyright 2024 Pepe Tiebosch (byme.dev). All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.

// final StateProvider<String> shellBufferProvider = StateProvider((ref) => '');

// final Provider<List<String>> shellOutput = Provider((ref) {
//   List<String> shellLines = ref.watch(shellBufferProvider).split('\n');
//   return shellLines.sublist(max(0, shellLines.length - 101), shellLines.length - 1);
// });

// final Provider<String> shellCurLine = Provider((ref) {
//   List<String> shellLines = ref.watch(shellBufferProvider).split('\n');
//   return shellLines[shellLines.length - 1];
// });

// class AdbTerminal extends ConsumerStatefulWidget {
//   const AdbTerminal({super.key, required this.stream});

//   final AdbStream stream;

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _AdbTerminalState();
// }

// class _AdbTerminalState extends ConsumerState<AdbTerminal> {
//   final TextEditingController _controller = TextEditingController();

//   bool isClosed = false;

//   late StreamSubscription<Uint8List> _shellSubscription;

//   @override
//   void initState() {
//     super.initState();
//     _shellSubscription = widget.stream.onPayload.listen(
//         (value) => ref.read(shellBufferProvider.notifier).state += utf8.decode(value),
//         onDone: () => setState(() => isClosed = true));
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (ref.watch(shellBufferProvider).isEmpty) {
//       widget.stream.writeString('\n');
//     }
//   }

//   @override
//   void dispose() {
//     _shellSubscription.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: SingleChildScrollView(
//             reverse: true,
//             child: SelectableText(
//               ref.watch(shellOutput).join('\n'),

//             ),
//           ),
//         ),
//         Row(
//           children: [
//             Text(
//               ref.watch(shellCurLine),

//             ),
//             Expanded(
//               child: TextField(
//                 controller: _controller,
//                 enabled: !isClosed,
//                 decoration: InputDecoration(
//                   border: const UnderlineInputBorder(),
//                   hintText: isClosed ? 'Shell closed' : 'echo Hello, world!',

//                 ),
//                 onSubmitted: (value) {
//                   widget.stream.writeString('$value\n');
//                   _controller.clear();
//                 },
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.send),
//               onPressed: isClosed
//                   ? null
//                   : () {
//                       widget.stream.writeString('${_controller.text}\n');
//                       _controller.clear();
//                     },
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
