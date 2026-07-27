import '../../../common/constant/app_imports.dart';
import '../controllers/profile_controller.dart';

class ReferAndEarnScreen extends StatelessWidget {
  const ReferAndEarnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CustomAppBar(
        title: AppStrings.referAndEarn,
        actions: [
          IconButton(
            icon: Icon(Icons.card_giftcard, color: AppColors.textPrimary),
            onPressed: () => controller.showRewardsBottomSheet(context),
            tooltip: 'Rewards & Earnings',
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeroSection(controller: controller),
                const SizedBox(height: 24),
                Obx(() => Row(
                      children: [
                        Expanded(
                          child: ReferralCodeCard(
                            title: 'Your Referral Code',
                            value: controller.referralCode.value,
                            onTap: controller.copyReferralCode,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ReferralCodeCard(
                            title: 'Your Referral Link',
                            value: controller.referralLink.value,
                            onTap: controller.copyReferralLink,
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: 16),

                const EarningHighlightSection(),
                const SizedBox(height: 24),

                Text('More Ways to Earn 🎉', style: AppTextStyles.h1),
                const SizedBox(height: 12),
                Obx(() => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: controller.bonusMilestones.map((milestone) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: BonusCard(
                              tag: milestone['tag'] ?? '',
                              title: milestone['title'] ?? '',
                              subtitle: milestone['subtitle'] ?? '',
                              bgColor: milestone['bgColor'] ?? AppColors.tagBg,
                              current: milestone['current'] ?? 0,
                              target: milestone['target'] ?? 5,
                            ),
                          );
                        }).toList(),
                      ),
                    )),
                const SizedBox(height: 24),

                // How it works
                Text('How it works', style: AppTextStyles.h1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const HowItWorksStep(
                      step: 1,
                      title: 'Invite Friends',
                      desc: 'Share your code or link',
                    ),
                    Icon(Icons.arrow_right_alt, color: AppColors.lightDisabled),
                    const HowItWorksStep(
                      step: 2,
                      title: 'Friend Places Order',
                      desc: 'They get 20% OFF',
                    ),
                    Icon(Icons.arrow_right_alt, color: AppColors.lightDisabled),
                    const HowItWorksStep(
                      step: 3,
                      title: 'You Earn £10',
                      desc: 'After order completed',
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Share Icons
                Text('Share your link', style: AppTextStyles.h1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SocialShareIcon(
                      icon: Icons.chat,
                      color: AppColors.success,
                      label: 'WhatsApp',
                      onTap: controller.shareToWhatsApp,
                    ),
                    SocialShareIcon(
                      icon: Icons.send,
                      color: Colors.blue,
                      label: 'Telegram',
                      onTap: controller.shareToTelegram,
                    ),
                    SocialShareIcon(
                      icon: Icons.camera_alt,
                      color: Colors.pink,
                      label: 'Instagram',
                      onTap: controller.shareToInstagram,
                    ),
                    SocialShareIcon(
                      icon: Icons.message,
                      color: Colors.blueAccent,
                      label: 'Messenger',
                      onTap: controller.shareToMessenger,
                    ),
                    SocialShareIcon(
                      icon: Icons.more_horiz,
                      color: AppColors.lightDivider,
                      label: 'More',
                      isIconDark: true,
                      onTap: controller.shareNative,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Bottom Banner
                BottomBannerSection(onInvite: controller.shareNative),
                const SizedBox(height: 80),
              ],
            ),
          ),
          const GlobalChatWidget(bottomMargin: 16.0, rightMargin: 16.0),
        ],
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  final ProfileController controller;
  const HeroSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Refer Friends,\nEarn £10', style: AppTextStyles.h2),
              const SizedBox(height: 8),
              Text(
                'Your friend gets 20% OFF on their first order and you earn £10 after their order is completed.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: controller.shareNative,
                icon: const Icon(Icons.share, color: AppColors.white),
                label: Text(
                  'Invite Friends',
                  style: AppTextStyles.button,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimary,
                  textStyle: AppTextStyles.button,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF673AB7), Color(0xFF512DA8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  right: -10,
                  top: -10,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white10,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.card_giftcard,
                      size: 48,
                      color: Colors.amberAccent,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'GET £10',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ReferralCodeCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const ReferralCodeCard({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightDivider),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.bgLight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.caption),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryPurple,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.copy, size: 16, color: AppColors.primaryPurple),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EarningHighlightSection extends StatelessWidget {
  const EarningHighlightSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tagBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primaryPurple,
            child: const Icon(Icons.account_balance_wallet, color: AppColors.white),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You Earn', style: AppTextStyles.bodySmall),
              Text(
                '£10',
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.primaryPurple,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Text(
              'For every friend who places their first order',
              style: AppTextStyles.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class BonusCard extends StatelessWidget {
  final String tag;
  final String title;
  final String subtitle;
  final Color bgColor;
  final int current;
  final int target;

  const BonusCard({
    super.key,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.current,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (target > 0) ? (current / target).clamp(0.0, 1.0) : 0.0;

    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(tag, style: AppTextStyles.stepBadge),
          const SizedBox(height: 8),
          Icon(Icons.emoji_events, size: 32, color: AppColors.warning),
          const SizedBox(height: 8),
          Text(title, style: AppTextStyles.bodySmall),
          Text(
            subtitle,
            style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.bgLight,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryPurple,
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class HowItWorksStep extends StatelessWidget {
  final int step;
  final String title;
  final String desc;

  const HowItWorksStep({
    super.key,
    required this.step,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.primaryPurple,
            child: Text(
              step.toString(),
              style: AppTextStyles.caption.copyWith(color: AppColors.white),
            ),
          ),
          const SizedBox(height: 8),
          Icon(Icons.people, color: AppColors.primaryPurple),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: AppTextStyles.overline,
          ),
        ],
      ),
    );
  }
}

class SocialShareIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final bool isIconDark;
  final VoidCallback onTap;

  const SocialShareIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
    this.isIconDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color,
            child: Icon(
              icon,
              color: isIconDark ? AppColors.textPrimary : AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.overline),
        ],
      ),
    );
  }
}

class BottomBannerSection extends StatelessWidget {
  final VoidCallback onInvite;
  const BottomBannerSection({super.key, required this.onInvite});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.card_giftcard, color: AppColors.white, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Invite more. Earn more.',
                  style: AppTextStyles.subtitle.copyWith(
                    color: AppColors.white,
                  ),
                ),
                Text(
                  "There's no limit to how much you can earn!",
                  style: AppTextStyles.overline.copyWith(
                    color: AppColors.white70,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onInvite,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.white),
            child: Text(
              'Invite Now',
              style: AppTextStyles.button.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
