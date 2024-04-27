import 'package:flutter/material.dart';
class HomeContentPage extends StatelessWidget {
  const HomeContentPage({Key key}) : super(key: key);

  Widget searchBar() {
    return Expanded(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text("下拉分类",style: TextStyle(fontSize: 14,color: Colors.black),),
          ),
          const SizedBox(width: 16,),
          Container(
            height: 32,
            width: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                )
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return ListView.builder(itemBuilder: (context, index) {
    //  
    // },
    //   itemCount: 4,
    // );
    return Scaffold(
      body: ListView.builder(itemBuilder: (context, index) {
        if (index == 0) {
          return Row(
            children: [
              searchBar(),
            ],
          );
        } else {
          return Container(
            height: 200,
            color: Colors.pink,
          );
        }
      },
        itemCount: 4,
      ),
    );
  }
}

