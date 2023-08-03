import 'package:flutter/material.dart';

class MobileHeader extends StatelessWidget {
  const MobileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const Image(
          //   image: AssetImage(
          //     "assets/messenger.png",
          //   ),
          //   width: 32,
          //   height: 32,
          // ),
          const Expanded(child: SizedBox()),
          IconButton(
            onPressed: () {},
            splashRadius: 20,
            icon: const Icon(
              Icons.search,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
