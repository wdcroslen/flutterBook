import 'package:flutter/material.dart';
import 'package:flutterbook/charts/sliders.dart';
import 'package:flutter/cupertino.dart';

final List<String> _items = ['assets/images/lock.png','assets/images/lock.png','assets/images/lock.png'];

class GridPage extends StatelessWidget {

  // GridPage(){}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              crossAxisCount: 3,
            ),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Sliders(_items[index]),)
                    );
                },

                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const <Widget>[Text('test')],
                  ),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                        // AssetImage('icons/heart.png', package: 'my_icons')

                      image:
                      // AssetImage('lock.png', package: 'images')
                        AssetImage('assets/images/lock.png')
                        // NetworkImage('http://pngimg.com/uploads/simpsons/simpsons_PNG3.png')
                    ),
                  ),
                ),
              );
            })
    );
  }

}