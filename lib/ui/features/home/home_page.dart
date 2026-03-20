import 'package:flutter/material.dart';
import 'package:looply/ui/core/widgets/app_top_bar.dart';
import 'package:looply/ui/features/home/widgets/revisions_overdue_tab.dart';
import 'package:looply/ui/features/home/widgets/revisions_today_tab.dart';
import 'package:looply/ui/features/home/widgets/revisions_up_coming_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppTopBar(
          title: "Início",
          bottom: const TabBar(
            tabs: [
              Tab(child: Text("HOJE")),
              Tab(child: Text("PERDIDO")),
              Tab(child: Text("POR VIR")),
            ],
          ),
        ) ,
        body: const TabBarView(
          children: [
            RevisionsTodayTab(), 
            RevisionsOverdueTab(), 
            RevisionsUpComingTab()
          ],
        ),
      ),
    );
  }
}

