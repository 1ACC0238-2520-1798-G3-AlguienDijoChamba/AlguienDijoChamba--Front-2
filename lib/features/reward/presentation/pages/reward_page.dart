import 'package:flutter/material.dart';
import '../widgets/reward_card.dart';
import '../widgets/reward_activity_item.dart';

class RewardPage extends StatelessWidget {
  const RewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Rewards',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF9CA6F5), Color(0xFF4B6FEA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    '🏆 Silver Member',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '750 Reward Points',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Progress to Gold: 250 points to go',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: 0.75,
                      backgroundColor: Colors.white24,
                      color: Colors.yellowAccent,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Your Silver Benefits',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Benefits
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BenefitItem(text: '10% cashback'),
                _BenefitItem(text: 'Free cancellation'),
                _BenefitItem(text: 'Priority booking'),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              'Available Rewards',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            const RewardCard(
              title: '\$10 Service Credit',
              description: 'Use on any service booking',
              points: 200,
            ),
            const RewardCard(
              title: 'Free Service Call',
              description: 'Waive the \$25 service call fee',
              points: 150,
            ),
            const RewardCard(
              title: '\$25 Service Credit',
              description: 'Use on any booking over \$100',
              points: 500,
            ),

            const SizedBox(height: 24),
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            const RewardActivityItem(
              title: 'Plumbing service completed',
              date: '2024-01-15',
              points: 15,
            ),
            const RewardActivityItem(
              title: 'Redeemed \$10 credit',
              date: '2024-01-12',
              points: -200,
            ),
            const RewardActivityItem(
              title: 'Electrical service completed',
              date: '2024-01-08',
              points: 12,
            ),
            const RewardActivityItem(
              title: 'Review bonus',
              date: '2024-01-05',
              points: 25,
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final String text;
  const _BenefitItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.blue, size: 20),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
