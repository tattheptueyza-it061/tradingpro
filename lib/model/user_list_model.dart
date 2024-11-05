class User {
  final String id;
  final String user;
  final String password;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String bankName;
  final String bankAccountNumber;
  final String status;
  final String accountBalance;
  final String outstandingBalance;

  User({
    required this.id,
    required this.user,
    required this.password,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.bankName,
    required this.bankAccountNumber,
    required this.status,
    required this.accountBalance,
    required this.outstandingBalance,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      user: json['user'],
      password: json['password'],
      phoneNumber: json['phone_number'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      bankName: json['bank_name'],
      bankAccountNumber: json['bank_account_number'],
      status: json['status'],
      accountBalance: json['account_balance'],
      outstandingBalance: json['outstanding_balance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'password': password,
      'phone_number': phoneNumber,
      'first_name': firstName,
      'last_name': lastName,
      'bank_name': bankName,
      'bank_account_number': bankAccountNumber,
      'status': status,
      'account_balance': accountBalance,
      'outstanding_balance': outstandingBalance,
    };
  }
}
