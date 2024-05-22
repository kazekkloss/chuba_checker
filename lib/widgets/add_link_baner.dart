import 'package:flutter/material.dart';
import 'package:huba_checker/models/website_model.dart';
import 'package:sizer/sizer.dart';

import '../database/repository.dart';

class AddLinkBaner extends StatefulWidget {
  final VoidCallback onSuccess;
  const AddLinkBaner({super.key, required this.onSuccess});

  @override
  State<AddLinkBaner> createState() => _AddLinkBanerState();
}

class _AddLinkBanerState extends State<AddLinkBaner> {
  final _linkForm = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final DatabaseRepository _repository = DatabaseRepository();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _linkForm,
        child: SizedBox(
          height: 80.w,
          width: 80.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Nazwa strony', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              SizedBox(
                  height: 15.w,
                  child: TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "nazwa jest pusta";
                      }
                      return null;
                    },
                  )),
              SizedBox(height: 8.w),
              Text('Link do strony', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              SizedBox(
                  height: 15.w,
                  child: TextFormField(
                    controller: _urlController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "adres jest pusty";
                      }
                      return null;
                    },
                  )),
              SizedBox(height: 2.w),
              SizedBox(
                width: 70.w,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: const Color.fromARGB(255, 0, 155, 118)),
                    child: IconButton(
                      onPressed: () async {
                        if (_linkForm.currentState!.validate()) {
                          var success = await _repository.saveWebToCache(Website(name: _nameController.text, url: _urlController.text));
                          if (success) {
                            _nameController.clear();
                            _urlController.clear();
                            widget.onSuccess();
                          }
                        }
                      },
                      icon: Icon(Icons.add_outlined, size: 10.w),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
