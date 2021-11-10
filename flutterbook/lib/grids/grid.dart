import 'package:flutter/material.dart';
import 'package:flutterbook/grids/grid_entry.dart';
import 'package:flutter/cupertino.dart';

final List<String> _items = ['assets/images/tv.png','assets/images/clothes.png','assets/images/phones.png'];
final List<String> _networkItems = ['https://dummyimage.com/400x400/000/f44336&text=water','https://dummyimage.com/400x400/000/f44336&text=clothes','https://dummyimage.com/400x400/000/fff&text=phones'];
//https://dummyimage.com/600x400/000/fff&text=fire
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
                          GridEntry(_networkItems[index]),)
                    );
                },

                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const <Widget>[/*Text('Something something')*/],
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image:
                      // AssetImage('lock.png', package: 'images')
                      //   AssetImage(_items[index])
                        // AssetImage('assets/images/lock.png')
                        NetworkImage(_networkItems[index])
                    ),
                  ),
                ),
              );
            })
    );
  }

}