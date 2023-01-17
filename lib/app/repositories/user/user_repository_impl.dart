// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list_provider/app/exceptions/auth_exception.dart';

import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> register(String email, String password) async {
    try {
      final userCredencial = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      return userCredencial.user;
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == "email-already-in-use") {
        final loginTypes =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);
        if (loginTypes.contains("password")) {
          throw AuthException(
              message: "E-mail já utilizado, por favor escolha outro e-mail");
        } else {
          throw AuthException(
              message:
                  "Você se cadastrou no TodoList pelo google, por favor efetue o login com Google");
        }
      } else {
        throw AuthException(message: e.message ?? "Erro ao registrar usuário");
      }
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthException(message: e.message ?? "Erro ao realizar Login");
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == "user-not-found") {
        throw AuthException(
            message: "Não existe usuários com essas credenciais");
      } else {
        throw AuthException(message: "Login ou senha inválidos: ${e.message}");
      }
    }
  }

  @override
  Future<void> forgtPassword(String email) async {
    try {
      final loginMethods =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);

      if (loginMethods.contains("password")) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else if (loginMethods.contains("google")) {
        throw AuthException(
            message:
                "Cadastro realizado com o google, clique no botão entrar com o google");
      } else {
        throw AuthException(message: "Email não cadastrado");
      }
    } on PlatformException catch (e, s) {
      print(s);
      print(e);
      throw AuthException(message: "Erro ao resetar senha ");
    }
  }

  @override
  Future<User?> googleLogin() async {
    List<String>? loginMethods;
    try {
      final googleSingIn = GoogleSignIn();
      final googleUser = await googleSingIn.signIn();
      if (googleUser != null) {
        loginMethods =
            await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);

        if (loginMethods.contains("password")) {
          throw AuthException(
              message:
                  "Você utilizou e-mail e senha para se cadastrar, não é possível entrar com o google, caso tenha esquecido sua senha clique no link: (Esqueci minha senha)");
        } else {
          final googleAuth = await googleUser.authentication;
          final firebseCredential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
          var userCredential =
              await _firebaseAuth.signInWithCredential(firebseCredential);
          return userCredential.user;
        }
      }
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == "account-exists-with-different-credential") {
        throw AuthException(message: """
            Login inválido você se registrou com os seguintes provedores:
            ${loginMethods?.join(",")} 
          """);
      } else {
        throw AuthException(message: "Erro ao realizar login");
      }
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    _firebaseAuth.signOut();
  }

  @override
  Future<void> updateDisplayName(String name) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      user.reload();
    }
  }
}
