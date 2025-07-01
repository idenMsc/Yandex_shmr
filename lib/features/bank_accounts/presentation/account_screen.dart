import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../gen/assets.gen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4FA),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _AccountListTile(
            emoji: '💰',
            title: 'Баланс',
            value: '-670 000 ₽',
            icon: Assets.icons.account,
          ),
          _AccountListTile(
            emoji: '',
            title: 'Валюта',
            value: '₽',
            icon: '',
          ),
        ],
      ),
    );
  }
}

class _AccountListTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String value;
  final String icon;

  const _AccountListTile({
    required this.emoji,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFFB8F5C5),
      child: ListTile(
        leading: icon.isNotEmpty
            ? SvgPicture.asset(icon, width: 32, height: 32)
            : (emoji.isNotEmpty
                ? Text(emoji, style: const TextStyle(fontSize: 28))
                : null),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}
