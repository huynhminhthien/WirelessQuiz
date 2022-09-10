import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Wireless Quiz'),
        backgroundColor: Colors.cyan.shade700,
        actions: [
          PopupMenuButton(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            onSelected: (value) async {
              if (value == 1) {
                Routemaster.of(context).push('/logs');
              } else if (value == 2) {
                var result = await _showTextInputDialog(context);
                if (result != null) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('addr', result);
                }
              }
            },
            itemBuilder: (context) => [
              // const PopupMenuItem(
              //   value: 1,
              //   child: Text("Logs"),
              // ),
              const PopupMenuItem(
                value: 2,
                child: Text("Cấu hình IP"),
              ),
            ],
          ),
        ],
      ),
      body: ColoredBox(
        color: Colors.cyan.shade600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/postImage.png'),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 253, 180, 59),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              onPressed: () {
                Routemaster.of(context).replace('/answer_quiz');
              },
              child: Container(
                width: 30.w,
                margin: const EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text(
                  'BẮT ĐẦU',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 50, 81, 103),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showTextInputDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    String value = '';
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Địa chỉ IP'),
          content: Form(
            key: formKey,
            child: TextFormField(
              validator: (value) {
                String pattern =
                    r'^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$';
                RegExp regExp = RegExp(pattern);
                if (value == null || value.isEmpty) {
                  return 'Hãy nhập địa chỉ IP';
                } else if (!regExp.hasMatch(value)) {
                  return 'Địa chỉ IP chưa hợp lệ';
                }
                return null;
              },
              onSaved: (newValue) => value = newValue ?? '',
              decoration: const InputDecoration(hintText: addr),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("Hủy bỏ"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('Chấp nhận'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  Navigator.pop(context, value);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
