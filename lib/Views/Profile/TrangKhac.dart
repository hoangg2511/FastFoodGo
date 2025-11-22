// delivery_address_screen.dart
import 'package:flutter/material.dart';

class DeliveryAddressScreen extends StatelessWidget {
  const DeliveryAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Địa chỉ giao hàng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add new address
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAddressCard(
            title: 'Nhà riêng',
            address: '123 Nguyễn Văn Linh, Quận 7, TP.HCM',
            phone: '+84 123 456 789',
            isDefault: true,
          ),
          const SizedBox(height: 12),
          _buildAddressCard(
            title: 'Văn phòng',
            address: '456 Lê Văn Việt, Quận 9, TP.HCM',
            phone: '+84 987 654 321',
            isDefault: false,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard({
    required String title,
    required String address,
    required String phone,
    required bool isDefault,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isDefault) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Mặc định',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () {},
              ),
            ],
          ),
          Text(
            address,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            phone,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// payment_method_screen.dart
class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phương thức thanh toán'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add new payment method
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPaymentCard(
            icon: Icons.credit_card,
            title: 'Thẻ tín dụng',
            subtitle: '**** **** **** 1234',
            isDefault: true,
          ),
          const SizedBox(height: 12),
          _buildPaymentCard(
            icon: Icons.account_balance_wallet,
            title: 'Ví điện tử MoMo',
            subtitle: '0123 456 789',
            isDefault: false,
          ),
          const SizedBox(height: 12),
          _buildPaymentCard(
            icon: Icons.money,
            title: 'Tiền mặt',
            subtitle: 'Thanh toán khi nhận hàng',
            isDefault: false,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDefault,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange[50],
          ),
          child: Icon(icon, color: Colors.orange),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: isDefault
            ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.orange[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Mặc định',
            style: TextStyle(
              fontSize: 10,
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : const Icon(Icons.settings_rounded, size: 23),
        onTap: () {},
      ),
    );
  }
}

// notifications_screen.dart
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _orderNotification = true;
  bool _promotionNotification = false;
  bool _emailNotification = true;
  bool _smsNotification = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSwitchTile(
                  icon: Icons.shopping_bag,
                  title: 'Thông báo đơn hàng',
                  subtitle: 'Nhận thông báo về trạng thái đơn hàng',
                  value: _orderNotification,
                  onChanged: (value) => setState(() => _orderNotification = value),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.local_offer,
                  title: 'Thông báo khuyến mãi',
                  subtitle: 'Nhận thông báo về ưu đãi và khuyến mãi',
                  value: _promotionNotification,
                  onChanged: (value) => setState(() => _promotionNotification = value),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.email,
                  title: 'Thông báo email',
                  subtitle: 'Nhận thông báo qua email',
                  value: _emailNotification,
                  onChanged: (value) => setState(() => _emailNotification = value),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.sms,
                  title: 'Thông báo SMS',
                  subtitle: 'Nhận thông báo qua tin nhắn',
                  value: _smsNotification,
                  onChanged: (value) => setState(() => _smsNotification = value),
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purple[50],
            ),
            child: Icon(icon, color: Colors.purple, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 72),
      color: Colors.grey[100],
    );
  }
}

// support_screen.dart
class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hỗ trợ'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Contact Section
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildContactTile(
                  icon: Icons.phone,
                  title: 'Hotline',
                  subtitle: '1900 1234',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildContactTile(
                  icon: Icons.email,
                  title: 'Email hỗ trợ',
                  subtitle: 'support@example.com',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildContactTile(
                  icon: Icons.chat,
                  title: 'Chat trực tuyến',
                  subtitle: 'Hỗ trợ 24/7',
                  onTap: () {},
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // FAQ Section
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildFAQTile(
                  question: 'Làm thế nào để đặt hàng?',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildFAQTile(
                  question: 'Chính sách đổi trả như thế nào?',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildFAQTile(
                  question: 'Thời gian giao hàng bao lâu?',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildFAQTile(
                  question: 'Làm thế nào để hủy đơn hàng?',
                  onTap: () {},
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyan[50],
              ),
              child: Icon(icon, color: Colors.cyan, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQTile({
    required String question,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.help_outline, color: Colors.cyan),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                question,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 72),
      color: Colors.grey[100],
    );
  }
}

// settings_screen.dart
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _fingerprintAuth = true;
  String _language = 'Tiếng Việt';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App Settings
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSwitchTile(
                  icon: Icons.dark_mode,
                  title: 'Chế độ tối',
                  value: _darkMode,
                  onChanged: (value) => setState(() => _darkMode = value),
                ),
                _buildDivider(),
                _buildTile(
                  icon: Icons.language,
                  title: 'Ngôn ngữ',
                  subtitle: _language,
                  onTap: _changeLanguage,
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.fingerprint,
                  title: 'Xác thực sinh trắc học',
                  value: _fingerprintAuth,
                  onChanged: (value) => setState(() => _fingerprintAuth = value),
                ),
                _buildDivider(),
                _buildTile(
                  icon: Icons.storage,
                  title: 'Xóa cache',
                  subtitle: '245 MB',
                  onTap: _clearCache,
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // About Section
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildTile(
                  icon: Icons.info,
                  title: 'Về ứng dụng',
                  subtitle: 'Phiên bản 1.0.0',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildTile(
                  icon: Icons.privacy_tip,
                  title: 'Chính sách bảo mật',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildTile(
                  icon: Icons.gavel,
                  title: 'Điều khoản sử dụng',
                  onTap: () {},
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100],
              ),
              child: Icon(icon, color: Colors.grey[600], size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[100],
            ),
            child: Icon(icon, color: Colors.grey[600], size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 72),
      color: Colors.grey[100],
    );
  }

  void _changeLanguage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn ngôn ngữ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Tiếng Việt'),
              value: 'Tiếng Việt',
              groupValue: _language,
              onChanged: (value) {
                setState(() => _language = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _language,
              onChanged: (value) {
                setState(() => _language = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa cache'),
        content: const Text('Bạn có chắc chắn muốn xóa cache không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã xóa cache thành công'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}