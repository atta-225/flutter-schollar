import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool hasSwitch;
  final bool showDivider;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.hasSwitch = false,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 36,
          child: Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF9E9E9E),
                size: 23,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
              if (hasSwitch)
                Switch(
                  value: true,
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFF67C54E),
                  onChanged: (_) {},
                ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE2E2E2),
          ),
      ],
    );
  }
}