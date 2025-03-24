import 'dart:io';

import 'package:flutter/material.dart';

import 'package:better_dynamic_icon/better_dynamic_icon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _betterDynamicIconPlugin = BetterDynamicIcon();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            FutureBuilder(
                future: _betterDynamicIconPlugin.getAllIcons(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<IconAndActivityName> iconAndActivityName = [];
                    snapshot.data?.forEach((value) {
                      iconAndActivityName.add(IconAndActivityName(
                        value: value,
                        betterDynamicIcon: _betterDynamicIconPlugin,
                      ));
                    });

                    return Expanded(
                        child: ListView(
                      children: iconAndActivityName,
                    ));
                  }
                  return Text('Fetching');
                }),
          ],
        ),
      ),
    );
  }
}

class IconAndActivityName extends StatelessWidget {
  const IconAndActivityName(
      {super.key, required this.value, required this.betterDynamicIcon});
  final IconDetails value;
  final BetterDynamicIcon betterDynamicIcon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.memory(
        value.iconData,
        height: 24,
        width: 24,
      ),
      title: Row(
        children: [
          Text(value.label),
          ColoredBox(
            color: value.enabled ? Colors.green : Colors.grey,
            child: SizedBox(
              height: 10,
              width: 10,
            ),
          ),
        ],
      ),
      subtitle: Text(value.accessName),
      trailing: value.enabled
          ? null
          : FilledButton(
              onPressed: () {
                betterDynamicIcon.changeAppIcon(value.accessName).then((value) {
                  print(value);
                });
              },
              child: Text('Use')),
    );
  }
}
