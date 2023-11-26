import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dhaba/blocs/vendor_login_bloc.dart'; // Make sure to import the correct file
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dhaba/pages/vendor/vendor_Registration.dart';
import 'package:dhaba/pages/vendor/vendorDashboard.dart';

class VendorLoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VendorLoginBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Vendor Login'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg-1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: BlocConsumer<VendorLoginBloc, VendorLoginState>(
            listener: (context, state) {
              if (state is VendorLoginSuccessState) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => VendorDashboardPage(),
                ));
              }
            },
            builder: (context, state) {
              if (state is VendorLoginLoadingState) {
                return Center(child: CircularProgressIndicator());
              } else {
                return VendorLoginForm(
                  usernameController: _usernameController,
                  passwordController: _passwordController,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class VendorLoginForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  VendorLoginForm({
    required this.usernameController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<VendorLoginBloc>(context);
    const SPACING20px = SizedBox(height: 20);
    return Center(
      child: Container(
        width: 300,
        padding: EdgeInsets.fromLTRB(20, 80, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/FAST.png',
                    width: 200,
                  ),
                  SPACING20px,
                  const Text(
                    'DHAABA 2.0',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SPACING20px,
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Contact No',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SPACING20px,
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SPACING20px,
            ElevatedButton(
              onPressed: () {
                loginBloc.add(VendorLoginButtonPressed(
                  phone: usernameController.text,
                  password: passwordController.text,
                ));
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Login'),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.login,
                    size: 24.0,
                  ),
                ],
              ),
            ),
            SPACING20px,
            BlocBuilder<VendorLoginBloc, VendorLoginState>(
              builder: (context, state) {
                if (state is VendorLoginFailureState) {
                  Future.microtask(() {
                    final snackBar = SnackBar(
                      content: Text(state.error),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                }
                return Container();
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the registration page
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VendorRegistrationPage(),
                ));
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Register'),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.app_registration,
                    size: 24.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
