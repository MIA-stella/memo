import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memo/model/memo.dart';
import 'package:memo/pages/add_edit_memo_page.dart';
import 'package:memo/pages/memo_detail_page.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key, required this.title});


  final String title;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  final memoCollection = FirebaseFirestore.instance.collection("memo");

  Future<void> deleteMemo(String id) async{
    final doc = FirebaseFirestore.instance.collection("memo").doc(id);
    await doc.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ドキュメント一覧"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: memoCollection.orderBy("createdDate", descending: false).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const CircularProgressIndicator();
          }
          if(!snapshot.hasData) {
            return const Center(child: Text("データがありません"));
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index){
              Map<String, dynamic> data = docs[index].data()as Map<String, dynamic>;

              final Memo fetchMemo = Memo(
                id: docs[index].id,
                title: data["title"],
                detail: data["detail"],
                createdDate: data["createdDate"],
                updatedDate: data["updatedDate"]
              );

              return Container(
                width: 10,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(10, 10),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      blurRadius: 20,
                    ),
                    BoxShadow(
                      offset: Offset(10,10),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(fetchMemo.title),
                  trailing: IconButton(
                    onPressed: (){
                      showModalBottomSheet(context: context, builder: (context){
                        return SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                onTap: (){
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditMemoPage(currentMemo: fetchMemo,)));
                                },
                                leading: Icon(Icons.edit),
                                title: const Text("編集"),
                              ),
                              ListTile(
                                onTap: ()async {
                                  await deleteMemo(fetchMemo.id);
                                  Navigator.pop(context);
                                },
                                leading: Icon(Icons.delete),
                                title: const Text("削除"),
                              )
                           ],
                          ),
                        );
                      });
                      },
                      icon: const Icon(Icons.edit),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute
                      (builder: (context) => MemoDetailPage(fetchMemo)));
                  },
                ),
              );
            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEditMemoPage()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
