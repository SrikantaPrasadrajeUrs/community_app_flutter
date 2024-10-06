import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
void showSnackBar(BuildContext context,String text){
  ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(text,)));
}
// SizedBox reusableSizedBox(BuildContext context,bool height,bool width,double heightRatio,double widthRatio,Widget? child){
//   Size size=MediaQuery.of(context).size;
//   if(height&&width&&child!=null){
//     return SizedBox(
//       height: size.height*heightRatio,
//       width: size.width*widthRatio,
//       child: child,
//     );
//   }else if(height&&width){
//     return SizedBox(
//       height: size.height*heightRatio,
//       width: size.width*widthRatio,
//     );
//   }else if(height){
//     return SizedBox(
//       height: size.height*heightRatio,
//     );
//   }else{
//     return SizedBox(
//       width: size.width*widthRatio,
//     );
//   }
// }
Widget giveExpandedButton(BuildContext context,String text,String navigationPath){
  return Row(
    children: [
      Expanded(
        child: ElevatedButton(onPressed: (){
          Routemaster.of(context).push(navigationPath);
        }, child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(text),
        )),
      ),
    ],
  );
}

Future<FilePickerResult?> pickImage()async=> await FilePicker.platform.pickFiles(type: FileType.any);