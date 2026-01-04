import 'package:flutter/material.dart';
import 'package:looply/model/revision_cycle.dart';
import 'package:looply/model/tag.dart';
import 'package:looply/service/revision_cycle_service.dart';
import 'package:looply/service/topic_service.dart';
import 'package:looply/ui/app/app_bottom_app_bar.dart';
import 'package:looply/ui/core/app_state.dart';
import 'package:looply/ui/pages/account_page.dart';
import 'package:looply/ui/pages/add_topic_page/add_topic_page.dart';
import 'package:looply/ui/pages/calendar_page.dart';
import 'package:looply/ui/pages/home_page.dart';
import 'package:looply/ui/pages/topics_page.dart';
import 'package:provider/provider.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  void initState() {
    super.initState();

    RevisionCycleService.instance.create("Custom1", [1, 7, 30, 90]);

    TopicService.instance.create(
      name: "programação",
      revisionCycle: RevisionCycle('default', [1, 7, 30, 60]),
      tags: [Tag(1, "geral"), Tag(2, "dev")],
      studiedOn: DateTime.now(),
    );

    /*TopicService.instance.create(
      name: "Matemática Discreta",
      studiedOn: DateTime.now(),
      revisionCycle: RevisionCycleService.instance.get(1),
      tags: [Tag(1, "Geral"/*, Colors.deepOrange.toARGB32()*/)],
    );

    TopicService.instance.create(
      name: "MD",
      studiedOn: DateTime.now(),
      revisionCycle: RevisionCycleService.instance.get(2),
      tags: [Tag(2, "Exame"/*, Colors.deepPurpleAccent.toARGB32()*/)],
    );

    TopicService.instance.create(
      name: "AM II",
      studiedOn: DateTime.now(),
      revisionCycle: RevisionCycleService.instance.get(1),
      tags: [Tag(3, "Geral"/*, Colors.amber.toARGB32()*/)],
    );

    TopicService.instance.create(
      name: "Fisica",
      studiedOn: DateTime.now(),
      revisionCycle: RevisionCycleService.instance.get(2),
      tags: [Tag(4, "Home"/*, Colors.blue.toARGB32()*/)],
    );*/

  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      body: <Widget>[
        HomePage(title: "fe"),
        TopicsPage(),
        CalendarPage(),
        AccountPage()
      ][appState.currentPageIndex],
      bottomNavigationBar: AppBottomAppBar(),
      floatingActionButton: FloatingActionButton(
        
        onPressed: () => {
          Navigator.push(context, 
            MaterialPageRoute(builder: (context) => const AddTopicPage())
          )
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}