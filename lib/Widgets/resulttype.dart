import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ResultType extends StatefulWidget {
  final bool isPhone;
  final bool isUrl;
  final bool isContact;
  final bool isWifi;
  final bool isInstagram;
  final bool isFacebook;
  final bool isYoutube;
  final bool isWhatsapp;
  final bool isEmail;
  final bool isTwitter;
  const ResultType({Key? key,required this.isPhone,required this.isUrl,required this.isContact,required this.isWifi, required this.isInstagram, required this.isFacebook,required this.isYoutube,required this.isWhatsapp,required this.isEmail,required this.isTwitter}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ResultTypeState createState() => _ResultTypeState();
}

class _ResultTypeState extends State<ResultType> {
  bool isText = false;
  Widget icon = Container();
  String name = "";
  Color color = const Color(0xffffffff);
  @override
  void initState() {
    // TODO: implement initState
    isText = !widget.isPhone && !widget.isUrl && !widget.isContact && !widget.isWifi && !widget.isInstagram && !widget.isFacebook && !widget.isYoutube && !widget.isWhatsapp;
    super.initState();
  }

  // ignore: non_constant_identifier_names
  Widget FinalResult(){
    if(widget.isPhone){
      icon = const Icon(Icons.phone,color: Colors.white);
      name = "Phone";
      color = Colors.green;
    }
    else if(widget.isUrl){
      icon = const Icon(Icons.link,color: Colors.white);
      name = "URL";
      color = Colors.black45;
    }
    else if(widget.isContact){
      icon = const Icon(Icons.person,color: Colors.white);
      name = "Contact";
      color = Colors.blueGrey;
    }
    else if(widget.isWifi){
      icon = const Icon(Icons.wifi,color: Colors.white);
      name = "WI-FI";
      color = Colors.grey;
    }
    else if(widget.isInstagram){
      icon = const FaIcon(FontAwesomeIcons.instagram,color: Colors.white,);
      name = "Instagram";
      color = const Color(0xffdd2a7b);
    }
    else if(widget.isFacebook){
      icon = const FaIcon(FontAwesomeIcons.facebook,color: Colors.white);
      name = "Facebook";
      color = const Color(0xff3b5998);
    }
    else if(widget.isYoutube){
      icon = const FaIcon(FontAwesomeIcons.youtube,color: Colors.white);
      name = "Youtube";
      color = const Color(0xffFF0000);
    }
    else if(widget.isWhatsapp){
      icon = const FaIcon(FontAwesomeIcons.whatsapp,color: Colors.white);
      name = "Whatsapp";
      color = const Color(0xff128c7e);
    }
    else if(widget.isTwitter){
      icon = const FaIcon(FontAwesomeIcons.twitter,color: Colors.white);
      name = "Twitter";
      color = const Color(0xff00acee);
    }
    else if(widget.isEmail){
      icon = const Icon(Icons.email,color: Colors.white);
      name = "E-mail";
      color = Colors.black45;
    }
    else{
      icon = const Icon(Icons.text_format,color: Colors.white);
      name = "Text";
      color = Colors.orange;
    }
    return Padding(
        padding: const EdgeInsets.only(top:8.0,bottom:20),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    CircleAvatar(backgroundColor: color,child: icon),
    Padding(padding: const EdgeInsets.only(left:10),child: Text(name,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),)
    ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return FinalResult();
  }
}
