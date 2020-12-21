import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bookdepo/Book.dart';
import 'package:bookdepo/detailscreen.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    title: 'Books',
      home: Scaffold(
        body: Container(
          child: MainScreen(),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final Book book;

  const MainScreen({Key key, this.book}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List bookList;
  double screenWidth, screenHeight;
  String titlecenter = "no_data";

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('BookDepo'),
      ),
      body: Column(
        children: [
          bookList == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ))))
              : Flexible(
                  child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: (screenWidth / screenHeight) / 0.22,
                  children: List.generate(bookList.length, (index) {
                    return Padding(
                      padding: EdgeInsets.all(1),
                      child: Card(
                        child: InkWell(
                          onTap: () => _loadDetail(index),
                          child: Row(
                            children: [
                              Container(
                                  height: screenHeight / 0.5,
                                  width: screenWidth / 3,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "http://slumberjer.com/bookdepo/bookcover/${bookList[index]['cover']}.jpg",
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        new CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        new Icon(
                                      Icons.broken_image,
                                      size: screenWidth / 2,
                                    ),
                                  )),
 
                          //listing happens
                          
                              SizedBox(height: 5),
                              Expanded(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          bookList[index]['booktitle'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ]),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ))
        ],
      ),
    );
  }

  void _loadBooks() {
    http.post("http://slumberjer.com/bookdepo/php/load_books.php").then((res) {
      print(res.body);
      if (res.body == "no data") {
        bookList = null;
        setState(() {
          titlecenter = "No Book Available";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          bookList = jsondata["books"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadDetail(int index) {
    print(bookList[index]['booktitle']);
    Book book = new Book(
        bookid: bookList[index]['bookid'],
        booktitle: bookList[index]['booktitle'],
        author: bookList[index]['author'],
        price: bookList[index]['price'],
        description: bookList[index]['description'],
        rating: bookList[index]['rating'],
        publisher: bookList[index]['publisher'],
        isbn: bookList[index]['isbn'],
        cover: bookList[index]['cover']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DetailScreen(
                  book: book,
                )));
  }
}
