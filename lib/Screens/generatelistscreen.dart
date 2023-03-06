import 'package:senior_barcode/Screens/CreateScreens/create_email_screen.dart';
import 'package:senior_barcode/Screens/CreateScreens/create_facebook_screen.dart';
import 'package:senior_barcode/Screens/CreateScreens/create_instagram_screen.dart';
import 'package:senior_barcode/Screens/CreateScreens/create_twitter_screen.dart';
import 'package:senior_barcode/Screens/CreateScreens/create_url_screen.dart';
import 'package:senior_barcode/Screens/CreateScreens/create_whatsapp_screen.dart';
import 'package:senior_barcode/Screens/CreateScreens/create_youtube_screen.dart';
import 'package:senior_barcode/Widgets/generatelistitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'CreateScreens/create_text_screen.dart';

class GenerateListScreen extends StatefulWidget {
  const GenerateListScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GenerateListScreenState createState() => _GenerateListScreenState();
}

class _GenerateListScreenState extends State<GenerateListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Barcode"),),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StaggeredGrid.count(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: const [
              GenerateListItem(
                  color: Colors.black38,
                  text: "Url",
                  icon: Icon(Icons.link,size: 35,),
                  onclick: CreateURLScreen()),
              GenerateListItem(
                  color: Colors.orange,
                  text: "Text",
                  icon: Icon(Icons.font_download,size: 35,),
                  onclick: CreateTextScreen()),
              // GenerateListItem(
              //     color: Colors.green,
              //     text: "WIFI",
              //     icon: Icon(Icons.wifi,size: 35,),
              //     onclick: CreateTextScreen()),
              GenerateListItem(
                  color: Colors.blueGrey,
                  text: "E-mail",
                  icon: Icon(Icons.email,size: 35,),
                  onclick: CreateEmailScreen()),
              // GenerateListItem(
              //     color: Colors.blueAccent,
              //     text: "Contact",
              //     icon: Icon(Icons.person,size: 35,),
              //     onclick: CreateTextScreen()),
              GenerateListItem(
                  color: Color(0xffdd2a7b),
                  text: "Instagram",
                  icon: FaIcon(FontAwesomeIcons.instagram,size: 35,),
                  onclick: CreateInstagramScreen()),
              GenerateListItem(
                  color: Color(0xff3b5998),
                  text: "Facebook",
                  icon: FaIcon(FontAwesomeIcons.facebook,size: 35,),
                  onclick: CreateFacebookScreen()),
              GenerateListItem(
                  color: Color(0xff128c7e),
                  text: "Whatsapp",
                  icon: FaIcon(FontAwesomeIcons.whatsapp,size: 35,),
                  onclick: CreateWhatsappScreen()),
              GenerateListItem(
                  color: Color(0xff00acee),
                  text: "Twitter",
                  icon: FaIcon(FontAwesomeIcons.twitter,size: 35,),
                  onclick: CreateTwitterScreen()),
              GenerateListItem(
                  color: Color(0xffFF0000),
                  text: "Youtube",
                  icon: FaIcon(FontAwesomeIcons.youtube,size: 35,),
                  onclick: CreateYoutubeScreen()),
            ],
          ),
        ),
      ]),
    );
  }
}
