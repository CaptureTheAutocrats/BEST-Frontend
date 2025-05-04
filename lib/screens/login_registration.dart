import 'package:flutter/material.dart';
import 'package:frontend/api.dart';

final _loginFormKey = GlobalKey<FormState>();
final _registrationFormKey = GlobalKey<FormState>();

class LoginRegistrationPage extends StatefulWidget {
  const LoginRegistrationPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginRegistrationPageState();
}

class LoginRegistrationPageState extends State<LoginRegistrationPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
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
    ),
  );

  Form _buildLoginForm() => Form(
    key: _loginFormKey,
    child: Column(
      spacing: 16,
      children: [
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: "Email",
            hintText: "Enter your email",
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
                  email: _emailController.text,
                  password: _passwordController.text,
                )
                .then(print)
                .catchError(print);
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
          controller: _emailController,
          decoration: InputDecoration(
            labelText: "Email",
            hintText: "Enter your email",
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
                  email: _emailController.text,
                  password: _passwordController.text,
                  studentId: _studentIdController.text,
                )
                .then(print)
                .catchError(print);
          },
          child: Text("Register"),
        ),
      ],
    ),
  );
}
