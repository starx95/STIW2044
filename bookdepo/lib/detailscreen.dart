import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bookdepo/Book.dart';
 
class DetailScreen extends StatefulWidget {
  final Book book;

  const DetailScreen({Key key, this.book}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  double screenHeight = 0.00, screenWidth = 0.00;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.booktitle),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: screenHeight / 2.5,
                    width: screenWidth / 0.5,
                    child: SingleChildScrollView(
                      child: CachedNetworkImage(
                        imageUrl:
                            "http://slumberjer.com/bookdepo/bookcover/${widget.book.cover}.jpg",
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, error) => new Icon(
                          Icons.broken_image,
                          size: screenWidth / 2,
                        ),
                      ),
                    )),


                Divider(color: Colors.grey),
                Text('Description'),
                SizedBox(height: 5),
                Text(widget.book.description),
                Divider(color: Colors.grey),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0),
                      child:Text("Book Title")
                    ),
                    Container(
                      child:Text(widget.book.booktitle)
                    ),
                  ],
                ),
                Divider(color: Colors.grey),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(5.0, 5.0, 42.0, 5.0),
                      child:Text("Author")
                    ),
                    Container(
                      child:Text(widget.book.author)
                    ),
                  ],
                ),
              ]),
          ),
        ),
      ),
    );
  }
}