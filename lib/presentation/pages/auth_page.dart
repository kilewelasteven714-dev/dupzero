import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/auth/auth_bloc.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isSignIn = true;
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (ctx, state) {
          if (state is AuthAuthenticated) context.go('/');
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: cs.error),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              const SizedBox(height: 40),
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(20)),
                child: Icon(Icons.deblur, color: cs.onPrimary, size: 40),
              ),
              const SizedBox(height: 16),
              Text('DupZero', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
              Text('Intelligent Duplicate Cleaner',
                style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
              const SizedBox(height: 48),
              Row(children: [
                Expanded(child: FilledButton.tonal(
                  onPressed: () => setState(() => _isSignIn = true),
                  style: FilledButton.styleFrom(
                    backgroundColor: _isSignIn ? cs.primaryContainer : null,
                  ),
                  child: const Text('Sign In'),
                )),
                const SizedBox(width: 12),
                Expanded(child: FilledButton.tonal(
                  onPressed: () => setState(() => _isSignIn = false),
                  style: FilledButton.styleFrom(
                    backgroundColor: !_isSignIn ? cs.primaryContainer : null,
                  ),
                  child: const Text('Sign Up'),
                )),
              ]),
              const SizedBox(height: 24),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _password,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<AuthBloc, AuthState>(builder: (ctx, state) {
                final loading = state is AuthLoading;
                return SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: loading ? null : () {
                      if (_isSignIn) {
                        ctx.read<AuthBloc>().add(SignInWithEmailEvent(_email.text, _password.text));
                      } else {
                        ctx.read<AuthBloc>().add(SignUpWithEmailEvent(_email.text, _password.text));
                      }
                    },
                    style: FilledButton.styleFrom(padding: const EdgeInsets.all(18)),
                    child: loading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(_isSignIn ? 'Sign In' : 'Create Account'),
                  ),
                );
              }),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: Divider(color: cs.outlineVariant)),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or', style: TextStyle(color: cs.onSurfaceVariant))),
                Expanded(child: Divider(color: cs.outlineVariant)),
              ]),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.read<AuthBloc>().add(SignInWithGoogleEvent()),
                  icon: const Icon(Icons.g_mobiledata, size: 24),
                  label: const Text('Continue with Google'),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/'),
                child: Text('Skip for now', style: TextStyle(color: cs.onSurfaceVariant)),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
