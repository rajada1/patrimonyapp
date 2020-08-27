import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Email {
  String _username;
  var smtpServer;

  Email(String username, String password) {
    _username = username;
    smtpServer = gmail(_username, password);
  }

  //Envia um email para o destinário, contendo a mensgaem
  Future<bool> sendMessage(
      String mensagem, String destinario, String assunto) async {
    //Configurar a mensagem
    final message = Message()
      ..from = Address(_username, 'Nome')
      ..recipients.add(destinario)
      ..subject = assunto
      ..text = mensagem;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message enviada: ' + sendReport.toString());
      return true;
    } on MailerException catch (e) {
      print('Mensagem não enviada.');
      for (var p in e.problems) {
        print('Problema: ${p.code}: ${p.msg}');
      }
      return false;
    }
  }
}
