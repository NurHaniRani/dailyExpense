import 'package:flutter/material.dart';
import 'package:dailyexpenses/Controller/request_controller.dart';
import 'dailyexpenses.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController apiAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                  FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9lHSoV362a8zPW_fH26GlNUK06V7ghgWhYg&usqp=CAU"),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: apiAddressController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'REST API address',
                  ),
                ),
              ),
              ElevatedButton (
                onPressed: () async {

                  //Implement Login logic here
                  String username = usernameController.text;
                  String password = passwordController.text;
                  String apiAddress = apiAddressController.text;
                  if (username == 'Hani' && password == '1234') {

                    await saveApiAddress(apiAddress);
                    //Navigate to the daily expense screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DailyExpensesApp(username: username),
                      ),
                    );
                  } else {
                    //Show an error message or handle invalid login
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Login Failed'),
                          content: const Text('Invalid username or password.'),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveApiAddress(String apiAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('apiAddress', apiAddress);
  }
}
