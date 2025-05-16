import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/theme/theme_bloc.dart';
import '../../bloc/theme/theme_event.dart';
import '../../services/firebase_service.dart';
import '../../components/theme_toggle.dart';
import '../../components/language_selector.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Требуется вход'));
    }
    final firestoreService = FirestoreService();
    final emailController = TextEditingController(text: user.email ?? '');
    final passwordController = TextEditingController();
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: firestoreService.getProfile(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data?.data() ?? {};
        final nameController = TextEditingController(text: data['name'] ?? '');
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                color: const Color(0xFF4B0036),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 4,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: const Color(0xFFB71C5A),
                        child: Text(
                          (data['name'] ?? user.email ?? 'U')
                              .toString()
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        data['name'] ?? '',
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.email ?? '',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ListTile(
                leading:
                    const Icon(Icons.manage_accounts, color: Color(0xFFB71C5A)),
                title: Text(
                    '${'change_email'.tr()} / ${'change_password'.tr()}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ChangeEmailPasswordScreen(),
                  ));
                },
              ),
              const SizedBox(height: 24),
              ThemeToggle(
                isDarkMode: Theme.of(context).brightness == Brightness.dark,
                onChanged: (value) {
                  context.read<ThemeBloc>().add(ToggleTheme());
                },
              ),
              const SizedBox(height: 16),
              LanguageSelector(
                currentLocale: Localizations.localeOf(context),
                onChanged: (locale) {
                  if (locale != null) {
                    // ignore: use_build_context_synchronously
                    context.setLocale(locale);
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB71C5A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                ),
                onPressed: () async {
                  await FirebaseService().signOut();
                  if (context.mounted) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (route) => false);
                  }
                },
                child: Text('logout'.tr()),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ChangeNameScreen extends StatefulWidget {
  const ChangeNameScreen({super.key});

  @override
  State<ChangeNameScreen> createState() => _ChangeNameScreenState();
}

class _ChangeNameScreenState extends State<ChangeNameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('change_name'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'name'.tr()),
                validator: (value) =>
                    value == null || value.isEmpty ? 'required'.tr() : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await FirestoreService().setProfile(
                          user.uid, {'name': _nameController.text.trim()});
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('profile_saved'.tr())),
                        );
                        Navigator.pop(context);
                      }
                    }
                  }
                },
                child: Text('save_name'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('change_email'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'email'.tr()),
                validator: (value) => value == null || !value.contains('@')
                    ? 'required'.tr()
                    : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await user.updateEmail(_emailController.text.trim());
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('profile_saved'.tr())),
                        );
                        Navigator.pop(context);
                      }
                    }
                  }
                },
                child: Text('save_name'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('change_password'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'password'.tr()),
                obscureText: true,
                validator: (value) =>
                    value == null || value.length < 6 ? 'required'.tr() : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await user
                          .updatePassword(_passwordController.text.trim());
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('profile_saved'.tr())),
                        );
                        Navigator.pop(context);
                      }
                    }
                  }
                },
                child: Text('save_name'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeEmailPasswordScreen extends StatefulWidget {
  @override
  State<ChangeEmailPasswordScreen> createState() =>
      _ChangeEmailPasswordScreenState();
}

class _ChangeEmailPasswordScreenState extends State<ChangeEmailPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('change_email'.tr() + ' / ' + 'change_password'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'email'.tr()),
                validator: (value) =>
                    value != null && value.isNotEmpty && !value.contains('@')
                        ? 'required'.tr()
                        : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'password'.tr()),
                obscureText: true,
                validator: (value) =>
                    value != null && value.isNotEmpty && value.length < 6
                        ? 'required'.tr()
                        : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      if (_emailController.text.isNotEmpty) {
                        await user.updateEmail(_emailController.text.trim());
                      }
                      if (_passwordController.text.isNotEmpty) {
                        await user
                            .updatePassword(_passwordController.text.trim());
                      }
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('profile_saved'.tr())),
                        );
                        Navigator.pop(context);
                      }
                    }
                  }
                },
                child: Text('save_name'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
