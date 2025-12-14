class AppConstants {
  // App Info
  static const String appName = 'MJ Print';
  static const String appVersion = '1.0.0';
  
  // Supabase Configuration
  static const String supabaseUrl = 'https://becvitccwaonthftnwyf.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJlY3ZpdGNjd2FvbnRoZnRud3lmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU0NDIwNDYsImV4cCI6MjA4MTAxODA0Nn0.tcLHJ3L0dRsVWYj79HxuMZuLPmhJNAWgsEchRA28ekQ';
  
  // Storage bucket names (sesuai SQL)
  static const String productImagesBucket = 'product-images';
  static const String orderProofsBucket = 'order-proofs';
  static const String userAvatarsBucket = 'user-avatars';
  
  // Table names
  static const String profilesTable = 'profiles';
  static const String productsTable = 'products';
  static const String ordersTable = 'orders';
  static const String orderItemsTable = 'order_items';
  
  // Auth messages
  static const String loginSuccess = 'Login berhasil';
  static const String registerSuccess = 'Registrasi berhasil';
  static const String logoutSuccess = 'Logout berhasil';
  
  // Order Status
  static const String orderPending = 'pending';
  static const String orderProcessing = 'processing';
  static const String orderShipped = 'shipped';
  static const String orderDelivered = 'delivered';
  static const String orderCancelled = 'cancelled';
  static const String orderConfirmed = 'confirmed';
  static const String orderReady = 'ready';
  
  // Payment Status
  static const String paymentUnpaid = 'unpaid';
  static const String paymentPaid = 'paid';
  static const String paymentPartial = 'partial';
  static const String paymentRefunded = 'refunded';
  
  // Payment Methods
  static const String paymentCash = 'cash';
  static const String paymentTransfer = 'transfer';
  static const String paymentCreditCard = 'credit_card';
  
  // User Roles
  static const String roleCustomer = 'customer';
  static const String roleAdmin = 'admin';
  static const String roleStaff = 'staff';
  
  // Error messages
  static const String connectionError = 'Koneksi gagal. Periksa internet Anda';
  static const String serverError = 'Terjadi kesalahan pada server';
  static const String unauthorizedError = 'Akses ditolak. Silakan login ulang';
  
  // Default Values
  static const double defaultProductPrice = 0.0;
  static const int defaultQuantity = 1;
  static const String defaultCurrency = 'Rp';
  
  // Colors
  static const int primaryColor = 0xFF2196F3;
  static const int secondaryColor = 0xFF03A9F4;
  static const int accentColor = 0xFF00BCD4;
  static const int successColor = 0xFF4CAF50;
  static const int warningColor = 0xFFFF9800;
  static const int errorColor = 0xFFF44336;
}