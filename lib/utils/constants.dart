// Constantes de l'application
import 'package:flutter/material.dart';

class AppConstants {
  // URLs de base
  static const String baseUrl = 'https://votre-domaine.com/api';
  static const String fedapayWebhookUrl = '$baseUrl/v1/fedapay/webhook';
  
  // Clés de stockage
  static const String authTokenKey = 'auth_token';
  static const String userTokenKey = 'user_token';
  static const String adminTokenKey = 'admin_token';
  static const String userDataKey = 'user_data';
  static const String appLanguageKey = 'app_language';
  
  // Durées
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration splashDelay = Duration(seconds: 2);
  static const Duration connectionTimeout = Duration(seconds: 10);
  
  // Configuration FedaPay
  static const String fedapayPublicKey = 'pk_sandbox_xxxxxxxxxxxx';
  static const String fedapaySecretKey = 'sk_sandbox_xxxxxxxxxxxx';
  static const String fedapayWebhookSecret = 'whk_xxxxxxxxxxxx';
  
  // Textes de l'application
  static const String appName = 'Vote App';
  static const String appVersion = '1.0.0';
  static const String companyName = 'Vote App Company';
  
  // Messages d'erreur
  static const String networkError = 'Erreur de connexion réseau';
  static const String serverError = 'Erreur du serveur';
  static const String unknownError = 'Erreur inconnue';
  static const String timeoutError = 'Timeout de la requête';
  static const String unauthorizedError = 'Accès non autorisé';
  
  // Messages de succès
  static const String voteSuccess = 'Vote enregistré avec succès';
  static const String paymentSuccess = 'Paiement effectué avec succès';
  static const String updateSuccess = 'Mise à jour réussie';
  static const String deleteSuccess = 'Suppression réussie';
}

// Constantes de design
class DesignConstants {
  // Dimensions
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;
  static const double inputBorderRadius = 8.0;
  
  // Tailles d'icônes
  static const double smallIconSize = 16.0;
  static const double mediumIconSize = 24.0;
  static const double largeIconSize = 32.0;
  static const double xlargeIconSize = 48.0;
  
  // Hauteurs
  static const double buttonHeight = 50.0;
  static const double appBarHeight = 56.0;
  static const double bottomBarHeight = 70.0;
  
  // Animations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);
}

// Constantes des couleurs
class ColorConstants {
  // Couleurs principales
  static const int primaryColorValue = 0xFF2196F3;
  static const int secondaryColorValue = 0xFFFF9800;
  static const int accentColorValue = 0xFF4CAF50;
  
  // Couleurs de statut
  static const int successColorValue = 0xFF4CAF50;
  static const int warningColorValue = 0xFFFF9800;
  static const int errorColorValue = 0xFFF44336;
  static const int infoColorValue = 0xFF2196F3;
  
  // Couleurs de texte
  static const int textPrimaryValue = 0xFF333333;
  static const int textSecondaryValue = 0xFF666666;
  static const int textHintValue = 0xFF999999;
  
  // Couleurs d'arrière-plan
  static const int backgroundValue = 0xFFF5F5F5;
  static const int surfaceValue = 0xFFFFFFFF;
  static const int cardValue = 0xFFFFFFFF;
}

// Constantes des routes
class RouteConstants {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminLogin = '/admin/login';
  static const String concoursList = '/concours';
  static const String concoursDetails = '/concours/details';
  static const String candidateDetails = '/candidate/details';
  static const String votePage = '/vote';
  static const String paymentPage = '/payment';
  static const String transactionDetails = '/transactions/details';
  static const String adminConcoursList = '/admin/concours';
  static const String adminCandidateDetails = '/admin/candidate/details';
}

// Constantes des assets
class AssetConstants {
  // Images
  static const String logo = 'assets/images/logo.png';
  static const String placeholder = 'assets/images/placeholder.jpg';
  static const String noImage = 'assets/images/no_image.png';
  
  // Icônes
  static const String homeIcon = 'assets/icons/home.svg';
  static const String voteIcon = 'assets/icons/vote.svg';
  static const String historyIcon = 'assets/icons/history.svg';
  static const String profileIcon = 'assets/icons/profile.svg';
  static const String adminIcon = 'assets/icons/admin.svg';
  
  // Animations Lottie
  static const String loadingAnimation = 'assets/animations/loading.json';
  static const String successAnimation = 'assets/animations/success.json';
  static const String errorAnimation = 'assets/animations/error.json';
  static const String emptyAnimation = 'assets/animations/empty.json';
}

// Constantes des préférences
class PreferenceConstants {
  static const String isFirstLaunch = 'is_first_launch';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
  static const String userPhone = 'user_phone';
  static const String darkMode = 'dark_mode';
  static const String language = 'language';
  static const String notifications = 'notifications';
}

// Constantes de validation
class ValidationConstants {
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minVotes = 1;
  static const int maxVotes = 100;
  
  static const String emailRegex = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
  static const String phoneRegex = r'^\+?[0-9]{8,15}$';
  
  static const String emailError = 'Veuillez entrer un email valide';
  static const String passwordError = 'Le mot de passe doit contenir au moins 6 caractères';
  static const String nameError = 'Le nom doit contenir entre 2 et 50 caractères';
  static const String phoneError = 'Veuillez entrer un numéro de téléphone valide';
  static const String requiredField = 'Ce champ est obligatoire';
}

// Constantes des paiements
class PaymentConstants {
  static const List<String> paymentMethods = ['tmoney', 'flooz'];
  static const Map<String, String> paymentMethodNames = {
    'tmoney': 'T-Money',
    'flooz': 'Flooz',
  };
  
  static const Map<String, String> paymentMethodIcons = {
    'tmoney': 'assets/icons/tmoney.png',
    'flooz': 'assets/icons/flooz.png',
  };
  
  static const int minVoteAmount = 100;
  static const int maxVoteAmount = 100000;
}

// Constantes des statuts
class StatusConstants {
  static const Map<String, String> concoursStatus = {
    'encours': 'En cours',
    'terminer': 'Terminé',
  };
  
  static const Map<String, String> transactionStatus = {
    'pending': 'En attente',
    'completed': 'Complétée',
    'failed': 'Échouée',
  };
  
  static const Map<String, Color> statusColors = {
    'encours': Colors.green,
    'terminer': Colors.grey,
    'pending': Colors.orange,
    'completed': Colors.green,
    'failed': Colors.red,
  };
}