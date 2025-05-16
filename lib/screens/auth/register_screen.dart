import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../home/home_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'login_screen.dart';
import '../../utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  double _buttonScale = 1.0;

  void _animateButton() async {
    setState(() => _buttonScale = 0.95);
    await Future.delayed(const Duration(milliseconds: 80));
    setState(() => _buttonScale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('register'.tr())),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: DropdownButton<Locale>(
                value: context.locale,
                icon: const Icon(Icons.language),
                onChanged: (Locale? locale) {
                  if (locale != null) {
                    context.setLocale(locale);
                  }
                },
                items: const [
                  DropdownMenuItem(
                    value: Locale('en'),
                    child: Text('EN'),
                  ),
                  DropdownMenuItem(
                    value: Locale('ru'),
                    child: Text('RU'),
                  ),
                  DropdownMenuItem(
                    value: Locale('kk'),
                    child: Text('KK'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is Authenticated) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(labelText: 'name'.tr()),
                          validator: (value) => value == null || value.isEmpty
                              ? 'name'.tr() + ' is required'
                              : null,
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'email'.tr()),
                          validator: Validators.validateEmail,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration:
                              InputDecoration(labelText: 'password'.tr()),
                          obscureText: true,
                          validator: Validators.validatePassword,
                        ),
                        const SizedBox(height: 24),
                        state is AuthLoading
                            ? const CircularProgressIndicator()
                            : AnimatedScale(
                                scale: _buttonScale,
                                duration: const Duration(milliseconds: 100),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _animateButton();
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthBloc>().add(
                                            SignUpRequested(
                                              email:
                                                  _emailController.text.trim(),
                                              password: _passwordController.text
                                                  .trim(),
                                              name: _nameController.text.trim(),
                                            ),
                                          );
                                    }
                                  },
                                  child: Text('register'.tr()),
                                ),
                              ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const LoginScreen(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(-1.0, 0.0);
                                  const end = Offset.zero;
                                  const curve = Curves.ease;
                                  final tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));
                                  final offsetAnimation =
                                      animation.drive(tween);
                                  return SlideTransition(
                                      position: offsetAnimation, child: child);
                                },
                              ),
                            );
                          },
                          child: Text('already_have_account'.tr()),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
