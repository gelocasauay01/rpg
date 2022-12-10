// External Dependencies
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// Models
import 'package:rpg/controllers/profile_controller.dart';
import 'package:rpg/models/profile.dart';

// Widgets
import 'package:rpg/screens/main_screen.dart';



class EditProfileScreen extends StatefulWidget {
  static const String routeName = '/edit-character';

  final bool _isEdit;

  const EditProfileScreen(this._isEdit, {super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  File? _file;
  String? _name;
  bool _isInit = false;


  Future _pickImage(ImageSource source) async {
    XFile? image = await ImagePicker().pickImage(source: source);

    if(image != null) {
      File tempImage = File(image.path);
      _setImage(tempImage);
    }
  }

  void _setImage(File image) {
    setState(() {
      _file = image;
    });
  }

  Future<File?> _saveImage() async{
    if(_file == null) return null;

    Directory appDir = await getApplicationDocumentsDirectory();
    String fileName = path.basename(_file!.path);
    File image = File('${appDir.path}/$fileName');

    return File(_file!.path).copy(image.path);
  }

  Future<void> _saveProfile() async {
    if(_file == null && !widget._isEdit || !_formState.currentState!.validate()) return;

    _formState.currentState!.save();

    ProfileController profileController = Provider.of<ProfileController>(context, listen: false);
    NavigatorState navigator = Navigator.of(context);
    File? permanentFile;

    if(_file != null){
      permanentFile = await _saveImage();
    } 

    if(widget._isEdit){
      await profileController.updateProfile(_name!, permanentFile);
      navigator.pop();
    }

    else{
      Profile profile = Profile(name: _name!, imageUrl: permanentFile!.path);
      await profileController.setProfile(profile);
      navigator.pushReplacementNamed(MainScreen.routeName);
    }
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    if(widget._isEdit && !_isInit){
      ProfileController profileController = Provider.of<ProfileController>(context, listen: false);

      if(profileController.profile != null){
        _file = File(profileController.profile!.imageUrl);
        _name = profileController.profile!.name;
      }
      
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._isEdit ? 'Edit Character' : 'New Character'),
      ),
      body: Form(
        key: _formState,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _file != null 
                      ? SizedBox(
                          height: 200,
                          width: 200,
                          child: Image.file(
                            _file!,
                            fit: BoxFit.cover
                          ),
                        )
                      : Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(border: Border.all()),
                        child: const Center(child: Text("Choose an image")),
                      ),
                      
                      Row(    
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: IconButton(
                              onPressed: () => _pickImage(ImageSource.camera), 
                              icon: const Icon(Icons.camera)
                            ),
                          ),
                          IconButton(
                            onPressed: () => _pickImage(ImageSource.gallery), 
                            icon: const Icon(Icons.browse_gallery)
                          ),
                        ],
                      ),
                      
                      TextFormField(
                        validator: (value) {
                          String? result;
  
                          if(value == null) {
                            result = "This field cannot be null";
                          }

                          else if(value.isEmpty) {
                            result = "This field cannot be empty";
                          }

                          else if(value.length < 3 || value.length > 20) {
                            result = "This field must have greater than 3 and less than 20 characters";
                          }

                          return result;
                        },
                        onSaved: (newValue) {
                          _name = newValue;
                        },
                        initialValue: _name,
                        decoration: const InputDecoration(
                          labelText: "Name"
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                   TextButton(
                      onPressed: _saveProfile, 
                      child: const Text("Save")
                    ),
                    if (widget._isEdit) TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      }, 
                      child: const Text("Cancel")
                    )
                  ],
                )
              ],
            ),
          )
        ),
    );
  }
}