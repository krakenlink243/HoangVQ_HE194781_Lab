// Lab 7 – Building a Signup Form with Validation & Good UX
// Single-file demo (can be pasted into DartPad → New Flutter).
//
// Covers:
//   7.1 Form + TextFormField + GlobalKey<FormState> + Submit
//   7.2 Validation rules (required, email, password strength, confirm match)
//   7.3 Focus & keyboard management (FocusNode, TextInputAction, unfocus)
//   7.4 Async email availability check (Future.delayed, loading button)
// Bonus: show/hide password, strength indicator, Terms & Conditions checkbox.

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 7 – Signup',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const SignupScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// Validators (Lab 7.2) – pure functions: return null if valid, else an error.
// ---------------------------------------------------------------------------

String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) return 'Name is required';
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) return 'Email is required';
  final email = value.trim();
  // Minimum rule from the lab: must contain '@' and '.', with text around them.
  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!email.contains('@') || !email.contains('.') || !emailRegex.hasMatch(email)) {
    return 'Enter a valid email';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Password is required';
  if (value.length < 8) return 'Password must be at least 8 characters';
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'Password must contain at least 1 digit';
  }
  return null;
}

String? validateConfirmPassword(String? value, String password) {
  if (value == null || value.isEmpty) return 'Please confirm your password';
  if (value != password) return 'Passwords do not match';
  return null;
}

// ---------------------------------------------------------------------------
// Password strength indicator (Bonus)
// ---------------------------------------------------------------------------

enum PasswordStrength { none, weak, medium, strong }

PasswordStrength passwordStrength(String password) {
  if (password.isEmpty) return PasswordStrength.none;
  var score = 0;
  if (password.length >= 8) score++;
  if (password.length >= 12) score++;
  if (RegExp(r'[0-9]').hasMatch(password)) score++;
  if (RegExp(r'[A-Z]').hasMatch(password) && RegExp(r'[a-z]').hasMatch(password)) score++;
  if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;
  if (score <= 2) return PasswordStrength.weak;
  if (score <= 3) return PasswordStrength.medium;
  return PasswordStrength.strong;
}

// ---------------------------------------------------------------------------
// Fake API (Lab 7.4) – emails starting with "taken" are already registered.
// ---------------------------------------------------------------------------

Future<bool> isEmailTaken(String email) async {
  await Future.delayed(const Duration(seconds: 2)); // simulate network latency
  return email.trim().toLowerCase().startsWith('taken');
}

// ---------------------------------------------------------------------------
// Signup screen
// ---------------------------------------------------------------------------

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Key used to validate() / save() the whole form (Lab 7.1).
  final _formKey = GlobalKey<FormState>();

  // Password controller: lets the Confirm validator read the current password
  // while validating (onSaved would run too late).
  final _passwordController = TextEditingController();

  // One FocusNode per field (Lab 7.3).
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  // Values filled in by onSaved after a successful validate().
  String _name = '';
  String _email = '';

  bool _isCheckingEmail = false; // Lab 7.4: true while the fake API runs
  bool _obscurePassword = true;  // Bonus: show/hide password
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  /// Submit flow: local validation → save → async email check → success.
  Future<void> _submit() async {
    FocusScope.of(context).unfocus(); // hide keyboard

    // 1. Synchronous validation – block submission if anything is invalid.
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    // 2. Async email check – disable the button while waiting.
    setState(() => _isCheckingEmail = true);
    final taken = await isEmailTaken(_email);
    if (!mounted) return; // widget may be gone after the await
    setState(() => _isCheckingEmail = false);

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    if (taken) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('This email is already taken'),
          backgroundColor: Colors.red,
        ),
      );
      _emailFocus.requestFocus(); // let the user fix the email right away
      return;
    }

    // 3. Success.
    messenger.showSnackBar(
      SnackBar(
        content: Text('Account created for $_name ($_email)'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tapping anywhere outside a field dismisses the keyboard (Lab 7.3).
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Signup')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            // Re-validate as the user types after the first interaction (7.2).
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // ListView keeps the form scrollable when the keyboard is open.
            child: ListView(
              children: [
                Text('Create your account',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),

                // ---- Full name ----
                TextFormField(
                  focusNode: _nameFocus,
                  decoration: const InputDecoration(
                    labelText: 'Full name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                  validator: validateName,
                  onSaved: (v) => _name = v!.trim(),
                ),
                const SizedBox(height: 12),

                // ---- Email ----
                TextFormField(
                  focusNode: _emailFocus,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'you@example.com',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                  validator: validateEmail,
                  onSaved: (v) => _email = v!.trim(),
                ),
                const SizedBox(height: 12),

                // ---- Password ----
                TextFormField(
                  focusNode: _passwordFocus,
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    helperText: 'At least 8 characters and 1 digit',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                      icon: Icon(_obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _confirmFocus.requestFocus(),
                  onChanged: (_) => setState(() {}), // refresh strength bar
                  validator: validatePassword,
                ),
                const SizedBox(height: 8),
                _StrengthIndicator(
                    strength: passwordStrength(_passwordController.text)),
                const SizedBox(height: 12),

                // ---- Confirm password ----
                TextFormField(
                  focusNode: _confirmFocus,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    labelText: 'Confirm password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      tooltip: _obscureConfirm ? 'Show password' : 'Hide password',
                      icon: Icon(_obscureConfirm
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  textInputAction: TextInputAction.done, // last field
                  onFieldSubmitted: (_) => _submit(),
                  validator: (v) =>
                      validateConfirmPassword(v, _passwordController.text),
                ),
                const SizedBox(height: 8),

                // ---- Terms & Conditions (Bonus) – a FormField so its error
                // shows inline like the other fields.
                FormField<bool>(
                  initialValue: false,
                  validator: (v) =>
                      v == true ? null : 'You must accept the Terms & Conditions',
                  builder: (field) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('I accept the Terms & Conditions'),
                        value: field.value,
                        onChanged: field.didChange,
                      ),
                      if (field.hasError)
                        Text(
                          field.errorText!,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ---- Submit button: disabled + spinner while checking ----
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isCheckingEmail ? null : _submit,
                    child: _isCheckingEmail
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Sign up'),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Tip: emails starting with "taken" are treated as already registered.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small bar + label showing Weak / Medium / Strong (Bonus).
class _StrengthIndicator extends StatelessWidget {
  final PasswordStrength strength;
  const _StrengthIndicator({required this.strength});

  @override
  Widget build(BuildContext context) {
    if (strength == PasswordStrength.none) return const SizedBox.shrink();
    final (label, value, color) = switch (strength) {
      PasswordStrength.weak => ('Weak', 1 / 3, Colors.red),
      PasswordStrength.medium => ('Medium', 2 / 3, Colors.orange),
      _ => ('Strong', 1.0, Colors.green),
    };
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: value,
            color: color,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
