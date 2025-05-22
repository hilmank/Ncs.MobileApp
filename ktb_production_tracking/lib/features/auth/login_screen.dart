import 'package:flutter/material.dart';
import '../../core/utils/dialog_helper.dart';
import '../dashboard/dashboard_screen.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/shared_prefs_helper.dart';
import '../../core/utils/error_handler.dart';
import '../../shared_widgets/loading.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  int _shiftId = 1;
  bool _isLoading = false;
  bool _obscureText = true;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final username = _userIdController.text.trim();
    final password = _passwordController.text.trim();
    final shift = _shiftId;

    final authService = AuthService();

    try {
      final result = await authService.login(username, password, shift);

      if (result != null && result.token != null && result.token!.isNotEmpty) {
        await SharedPrefsHelper.saveToken(result.token!);
        await SharedPrefsHelper.saveUserId(result.id);
        await SharedPrefsHelper.saveRole(result.role ?? '');

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Welcome ${result.fullName ?? result.username} [${result.role}]',
            ),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardScreen(
              userName: result.fullName ?? result.username,
              role: result.role ?? '',
              shiftNo: shift,
            ),
          ),
        );
      } else {
        if (!mounted) return;
        await DialogHelper.showError(context, "Username atau password salah.");
      }
    } catch (e, stack) {
      if (!mounted) return;
      ErrorHandler.handle(context: context, error: e, stackTrace: stack);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1B),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Text(
                    'Production Tracking System',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _userIdController,
                            decoration: const InputDecoration(
                              labelText: 'User ID',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Enter User ID'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Enter Password'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<int>(
                            value: _shiftId,
                            decoration: const InputDecoration(
                              labelText: 'Shift ID',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(value: 1, child: Text('1')),
                              DropdownMenuItem(value: 2, child: Text('2')),
                              DropdownMenuItem(value: 3, child: Text('3')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _shiftId = value ?? 1;
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFBD0000),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Log In',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          LoadingOverlay(isLoading: _isLoading),
        ],
      ),
    );
  }
}
