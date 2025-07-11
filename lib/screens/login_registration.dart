import 'package:best_frontend/api.dart';
import 'package:best_frontend/screens/home.dart';
import 'package:best_frontend/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final _loginFormKey = GlobalKey<FormState>();
final _registrationFormKey = GlobalKey<FormState>();

class LoginRegistrationPage extends StatefulWidget {
  const LoginRegistrationPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginRegistrationPageState();
}

class _LoginRegistrationPageState extends State<LoginRegistrationPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loginCheckDone = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _navigateHome() {
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await APIService().isLoggedIn();
    setState(() {
      _loginCheckDone = true;
    });
    if (isLoggedIn) _navigateHome();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.lightBlue,
      centerTitle: true,
      title: Text("Login / Registration"),
    ),
    body: Center(
      child: !_loginCheckDone ? CircularProgressIndicator() : _mainView(),
    ),
  );

  Container _mainView() => Container(
    padding: const EdgeInsets.all(20),
    child: DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            dividerColor: Colors.transparent,
            tabs: <Tab>[Tab(text: "Login"), Tab(text: "Registration")],
          ),
          Expanded(
            child: TabBarView(
              children: <Form>[_buildLoginForm(), _buildRegistrationForm()],
            ),
          ),
        ],
      ),
    ),
  );

  Form _buildLoginForm() => Form(
    key: _loginFormKey,
    child: Column(
      spacing: 16,
      children: [
        TextFormField(
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: "Phone",
            hintText: "Enter your phone number",
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        TextFormField(
          obscureText: true,
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: "Password",
            hintText: "Enter your password",
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _loginFormKey.currentState!.validate();

            APIService()
                .loginUser(
                  phone: _phoneController.text,
                  password: _passwordController.text,
                )
                .then((success) {
                  if (!success) {
                    showSnackbar(
                      context: context,
                      color: Colors.red,
                      icon: Icons.error,
                      message: "Registration failed! Kindly review your data.",
                    );
                    return;
                  }
                  _navigateHome();
                })
                .catchError((err) {
                  if (kDebugMode) print(err);
                  showSnackbar(
                    context: context,
                    color: Colors.red,
                    icon: Icons.error,
                    message: "Error: ${err.toString()}",
                  );
                });
          },
          child: Text("Login"),
        ),
      ],
    ),
  );

  Form _buildRegistrationForm() => Form(
    key: _registrationFormKey,
    child: Column(
      spacing: 16,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: "Name",
            hintText: "Enter your name",
          ),
          validator: (name) {
            if (name!.isEmpty) {
              return "Name cannot be empty!";
            }

            return null;
          },
        ),
        TextFormField(
          controller: _studentIdController,
          decoration: InputDecoration(
            labelText: "Student Id",
            hintText: "Enter your student id",
          ),
        ),
        TextFormField(
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: "Phone",
            hintText: "Enter your phone number",
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        TextFormField(
          obscureText: true,
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: "Password",
            hintText: "Enter your password",
          ),
        ),
        TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Confirm Password",
            hintText: "Confirm your password",
          ),
          validator: (password) {
            if (_passwordController.text != password) {
              return "New password and confirm password do not match!";
            }
            return null;
          },
        ),
        ElevatedButton(
          onPressed: () {
            _registrationFormKey.currentState!.validate();

            APIService()
                .registerUser(
                  name: _nameController.text,
                  phone: _phoneController.text,
                  password: _passwordController.text,
                  studentId: _studentIdController.text,
                )
                .then((success) {
                  if (!success) {
                    showSnackbar(
                      context: context,
                      color: Colors.red,
                      icon: Icons.error,
                      message: "Registration failed! Kindly review your data.",
                    );
                    return;
                  }
                  _navigateHome();
                })
                .catchError((err) {
                  if (kDebugMode) print(err);
                  showSnackbar(
                    context: context,
                    color: Colors.red,
                    icon: Icons.error,
                    message: "Error: ${err.toString()}",
                  );
                });
          },
          child: Text("Register"),
        ),
      ],
    ),
  );
}
