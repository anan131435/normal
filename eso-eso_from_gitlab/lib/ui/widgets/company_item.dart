import 'package:flutter/material.dart';

class CompanyItem extends StatelessWidget {
  final String entity;
  const CompanyItem({Key key, this.entity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0,right: 20.0,bottom: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.5),
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children:  [
                    Text(entity ?? "",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),),
                    const SizedBox(height: 4,),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
