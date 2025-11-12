import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'constants.dart';

// Helpers pour le formatage
class FormatHelper {
  // Formater une date
  static String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
    return DateFormat(format).format(date);
  }
  
  // Formater une date avec heure
  static String formatDateTime(DateTime date, {String format = 'dd/MM/yyyy HH:mm'}) {
    return DateFormat(format).format(date);
  }
  
  // Formater un montant d'argent
  static String formatAmount(double amount, {String currency = 'FCFA'}) {
    final formatter = NumberFormat('#,##0', 'fr_FR');
    return '${formatter.format(amount)} $currency';
  }
  
  // Formater un nombre de votes
  static String formatVotes(int votes) {
    if (votes >= 1000000) {
      return '${(votes / 1000000).toStringAsFixed(1)}M';
    } else if (votes >= 1000) {
      return '${(votes / 1000).toStringAsFixed(1)}K';
    }
    return votes.toString();
  }
  
  // Formater un numéro de téléphone
  static String formatPhoneNumber(String phone) {
    if (phone.startsWith('+228')) {
      return phone.replaceAllMapped(
        RegExp(r'(\+228)(\d{2})(\d{2})(\d{2})(\d{2})'),
        (Match m) => '${m[1]} ${m[2]} ${m[3]} ${m[4]} ${m[5]}',
      );
    }
    return phone;
  }
  
  // Formater une durée
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}j';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}min';
    }
    return '${duration.inSeconds}s';
  }
}

// Helpers pour la validation
class ValidationHelper {
  // Valider un email
  static bool isValidEmail(String email) {
    final regex = RegExp(ValidationConstants.emailRegex);
    return regex.hasMatch(email);
  }
  
  // Valider un numéro de téléphone
  static bool isValidPhone(String phone) {
    final regex = RegExp(ValidationConstants.phoneRegex);
    return regex.hasMatch(phone);
  }
  
  // Valider un mot de passe
  static bool isValidPassword(String password) {
    return password.length >= ValidationConstants.minPasswordLength;
  }
  
  // Valider un nom
  static bool isValidName(String name) {
    return name.length >= ValidationConstants.minNameLength && 
           name.length <= ValidationConstants.maxNameLength;
  }
  
  // Valider le nombre de votes
  static bool isValidVoteCount(int count) {
    return count >= ValidationConstants.minVotes && 
           count <= ValidationConstants.maxVotes;
  }
  
  // Obtenir le message d'erreur pour un champ
  static String? getFieldError(String field, String value) {
    switch (field) {
      case 'email':
        if (value.isEmpty) return ValidationConstants.requiredField;
        if (!isValidEmail(value)) return ValidationConstants.emailError;
        break;
      case 'password':
        if (value.isEmpty) return ValidationConstants.requiredField;
        if (!isValidPassword(value)) return ValidationConstants.passwordError;
        break;
      case 'name':
        if (value.isEmpty) return ValidationConstants.requiredField;
        if (!isValidName(value)) return ValidationConstants.nameError;
        break;
      case 'phone':
        if (value.isEmpty) return ValidationConstants.requiredField;
        if (!isValidPhone(value)) return ValidationConstants.phoneError;
        break;
    }
    return null;
  }
}

// Helpers pour les couleurs
class ColorHelper {
  // Obtenir la couleur d'un statut
  static Color getStatusColor(String status) {
    return StatusConstants.statusColors[status] ?? Colors.grey;
  }
  
  // Obtenir le texte d'un statut
  static String getStatusText(String status, {String type = 'concours'}) {
    if (type == 'concours') {
      return StatusConstants.concoursStatus[status] ?? status;
    } else {
      return StatusConstants.transactionStatus[status] ?? status;
    }
  }
  
  // Obtenir la couleur en fonction du pourcentage
  static Color getPercentageColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.blue;
    if (percentage >= 40) return Colors.orange;
    if (percentage >= 20) return Colors.amber;
    return Colors.red;
  }
  
  // Obtenir la couleur pour le classement
  static Color getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Or
      case 2:
        return const Color(0xFFC0C0C0); // Argent
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.blue.shade100;
    }
  }
  
  // Assombrir une couleur
  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    
    return hslDark.toColor();
  }
  
  // Éclaircir une couleur
  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    
    return hslLight.toColor();
  }
}

// Helpers pour les calculs
class CalculationHelper {
  // Calculer le pourcentage
  static double calculatePercentage(int part, int total) {
    if (total == 0) return 0.0;
    return (part / total) * 100;
  }
  
  // Calculer le montant total pour des votes
  static int calculateTotalAmount(int voteCount, int pricePerVote) {
    return voteCount * pricePerVote;
  }
  
  // Calculer le temps restant
  static Duration calculateTimeRemaining(DateTime endDate) {
    final now = DateTime.now();
    return endDate.difference(now);
  }
  
  // Vérifier si une date est passée
  static bool isDatePassed(DateTime date) {
    return date.isBefore(DateTime.now());
  }
  
  // Calculer l'âge à partir de la date de naissance
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}

// Helpers pour les strings
class StringHelper {
  // Tronquer un texte
  static String truncate(String text, {int maxLength = 50, String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - suffix.length)}$suffix';
  }
  
  // Capitaliser la première lettre
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}';
  }
  
  // Capitaliser chaque mot
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }
  
  // Extraire les initiales
  static String getInitials(String name) {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (name.isNotEmpty) {
      return name.substring(0, 1).toUpperCase();
    }
    return '?';
  }
  
  // Nettoyer un numéro de téléphone
  static String cleanPhoneNumber(String phone) {
    return phone.replaceAll(RegExp(r'[^\d+]'), '');
  }
}

// Helpers pour les images
class ImageHelper {
  // Vérifier si une URL d'image est valide
  static bool isValidImageUrl(String url) {
    return url.isNotEmpty && 
           (url.startsWith('http://') || url.startsWith('https://')) &&
           (url.endsWith('.jpg') || url.endsWith('.jpeg') || 
            url.endsWith('.png') || url.endsWith('.gif'));
  }
  
  // Obtenir l'URL de l'image de placeholder
  static String getPlaceholderImage() {
    return AssetConstants.placeholder;
  }
  
  // Obtenir l'URL de l'image par défaut pour un candidat
  static String getCandidatePlaceholder() {
    return AssetConstants.noImage;
  }
}

// Helpers pour la navigation
class NavigationHelper {
  // Vérifier si on peut revenir en arrière
  static bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }
  
  // Revenir à l'écran précédent
  static void goBack(BuildContext context, [dynamic result]) {
    if (canPop(context)) {
      Navigator.of(context).pop(result);
    }
  }
  
  // Revenir à l'écran d'accueil
  static void goHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

// Helpers pour les dialogues
class DialogHelper {
  // Afficher un dialogue de confirmation
  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Confirmer',
    String cancelText = 'Annuler',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }
  
  // Afficher un dialogue d'information
  static void showInfoDialog({
    required BuildContext context,
    required String title,
    required String content,
    String buttonText = 'OK',
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
  
  // Afficher un dialogue de chargement
  static void showLoadingDialog(BuildContext context, {String message = 'Chargement...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }
}

// Helpers pour les snacks
class SnackbarHelper {
  // Afficher un message de succès
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  // Afficher un message d'erreur
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  // Afficher un message d'information
  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  // Afficher un message d'avertissement
  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}