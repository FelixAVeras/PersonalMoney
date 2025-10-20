import 'package:flutter/material.dart';

class DialogHelper {
  static Future<void> successDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'Aceptar',
    VoidCallback? onConfirm,
  }) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Éxito'),
          ],
        ),
        content: Text('$title\n\n$message'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onConfirm != null) onConfirm();
            },
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  static Future<void> infoDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'Entendido',
  }) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: 8),
            Text('Información'),
          ],
        ),
        content: Text('$title\n\n$message'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  static Future<void> deleteDialog({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String cancelText = 'No',
    String confirmText = 'Sí',
  }) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Confirmar eliminación'),
          ],
        ),
        content: Text('$title\n\n$message'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(cancelText, style: const TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: Text(confirmText, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  static Future<void> emptyNameDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String buttonText,
  }) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  static Future<void> reportDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'Aceptar',
    VoidCallback? onConfirm,
  }) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onConfirm != null) onConfirm();
            },
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  static Future<void> errorDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'Aceptar',
  }) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Error'),
          ],
        ),
        content: Text('$title\n\n$message'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}