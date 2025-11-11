import 'package:flutter/material.dart';
import 'package:money_app/data/model/transaction.dart';
import 'package:money_app/data/repository/money_repository.dart';
import 'package:money_app/presentation/edit_page.dart';
import 'package:money_app/presentation/home_screen.dart';

class DetailPage extends StatelessWidget {
  final Transaction ts;
  DetailPage({super.key, required this.ts});

  final _repo = MoneyRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Page")),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Type = ${ts.type}"),
            Text("Category = ${ts.category}"),
            Text("Description = ${ts.description}"),
            Text("Amount = ${ts.amount}"),
            Text("Date = ${ts.date}"),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 30,
              children: [
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      _repo.deleteTransaction(ts.id!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Berhasil dihapus"),
                          backgroundColor: Colors.blue,
                        ),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Text("Delete"),
                  ),
                ),

                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPage(ts: ts),
                        ),
                      );
                    },
                    child: Text("Update"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
