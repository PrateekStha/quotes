import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../db/category.dart';
import '../admin/add_carousel.dart';
import '../admin/add_post.dart';
import '../admin/showCategory.dart';
import '../admin/showPost.dart';
import '../admin/showCarousel.dart';
import '../admin/showMessage.dart';
import '../db/post.dart';
import '../db/carousel.dart';
import '../db/category.dart';
import '../db/message.dart';

//enumeration ie constant for check
enum Page { dashboard, manage }

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  PostService _postService = PostService();
  CategoryService _categoryService = CategoryService();
  CarouselService _carouselService = CarouselService();
  MessageService _messageService = MessageService();
  int _postLength ;
  int _categoryLength;
  int _carouselLength;
  int _messageLength;
  @override
  void initState(){

    _postService.totalLength().then((result){
      setState(() {
        _postLength = result;
        print("levhfhffhfdh");
        print(result);
      });
    });
    _categoryService.totalLength().then((result){
      setState(() {
        _categoryLength = result;
        print("levhfhffhfdh");
        print(result);
      });
    });
    _carouselService.totalLength().then((result){
      setState(() {
        _carouselLength = result;
        print("levhfhffhfdh");
        print(result);
      });
    });
    _messageService.totalLength().then((result){
      setState(() {
        _messageLength = result;
        print("levhfhffhfdh");
        print(result);
      });
    });
  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.dashboard);
                      },
                      icon: Icon(
                        Icons.dashboard,
                        color: _selectedPage == Page.dashboard
                            ? active
                            : notActive,
                      ),
                      label: Text('Dashboard'))),
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.manage);
                      },
                      icon: Icon(
                        Icons.sort,
                        color:
                            _selectedPage == Page.manage ? active : notActive,
                      ),
                      label: Text('Manage'))),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: _loadScreen());
  }

  Widget _loadScreen() {
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          children: <Widget>[
            ListTile(
              subtitle: FlatButton.icon(
                onPressed: null,
                icon: Icon(
                  Icons.message,
                  size: 30.0,
                  color: Colors.black,
                ),
                label: Text('Nepal',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0, color: Colors.grey)),
              ),
              title: Text(
                'Quotes',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0, color: Colors.grey),
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: <Widget>[
                  
                  
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>showMessage()));
                              },
                              icon: Icon(Icons.message),
                              label: Text("Messages")),
                          subtitle: Text(
                            _messageLength.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>showPost()));
                              },
                              icon: Icon(Icons.local_post_office),
                              label: Text("Posts")),
                          subtitle: Text(
                            _postLength.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: (){},
                              icon: Icon(Icons.people_outline),
                              label: Text("Users")),
                          subtitle: Text(
                            '7',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>showCategory()));
                              },
                              icon: Icon(Icons.category),
                              label: Text("Categories")),
                          subtitle: Text(
                            _categoryLength.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>showCarousel()));
                              },
                              icon: Icon(Icons.image),
                              label: Text("Carousel")),
                          subtitle: Text(
                            _carouselLength.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: (){},
                              icon: Icon(Icons.close),
                              label: Text("Return")),
                          subtitle: Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        break;
      case Page.manage:
        return ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
              child: Text('Carousel manage'),
            ),
            ListTile(
              leading: Icon(Icons.add_photo_alternate),
              title: Text("Add Carausel Image"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => AddCarousel()));
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text("Carousel Images"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => showCarousel()));
              },
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
              child: Text('Image manage'),
            ),
            ListTile(
              leading: Icon(Icons.add_to_photos),
              title: Text("Add Post"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => AddPost()));
              },
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text("Posts list"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => showPost()));
              },
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
              child: Text('Category manage'),
            ),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text("Add category"),
              onTap: () {
                _categoryAlert();
              },
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text("Category list"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => showCategory()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.message),
              title: Text("Messages"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => showMessage()));
              },
            ),
          ],
        );
        break;
      default:
        return Container();
    }
  }

  void _categoryAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _categoryFormKey,
        child: TextFormField(
          controller: categoryController,
          validator: (value) {
            if (value.isEmpty) {
              return 'category cannot be empty';
            }
          },
          decoration: InputDecoration(hintText: "type category here"),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            if (categoryController.text != null) {
              _categoryService.createCategory(categoryController.text);
            }
            Fluttertoast.showToast(msg: 'category created');
            Navigator.pop(context);
          },
          child: Text('Add', style: TextStyle(color: Colors.green)),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(color: Colors.red)),
        )
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }

  //category list

}
