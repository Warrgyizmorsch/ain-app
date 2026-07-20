import '../../../common/constant/app_imports.dart';

class ReferAndEarnScreen extends StatelessWidget {
    ReferAndEarnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: 'Refer and Earn',
        actions: [
          IconButton(
            icon:   Icon(Icons.card_giftcard, color: AppColors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding:   EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              HeroSection(),
              SizedBox(height: 24),
              Row(
              children: [
                Expanded(
                  child: ReferralCodeCard(
                    title: 'Your Referral Code',
                    value: 'AIN25',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ReferralCodeCard(
                    title: 'Your Referral Link',
                    value: 'ain.co.uk/ref/...',
                  ),
                ),
              ],
            ),
              SizedBox(height: 16),

              EarningHighlightSection(),
              SizedBox(height: 24),

            Text('More Ways to Earn 🎉', style: AppTextStyles.h1),
              SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                    BonusCard(
                    tag: 'EXTRA BONUS',
                    title: 'Invite 5 Friends',
                    subtitle: 'Earn £20 Bonus',
                    bgColor: AppColors.tagBg,
                    current: 3,
                    target: 5,
                  ),
                    SizedBox(width: 12),
                    BonusCard(
                    tag: 'MEGA BONUS',
                    title: 'Invite 10 Friends',
                    subtitle: 'Earn £50 Bonus',
                    bgColor: AppColors.priceBg,
                    current: 3,
                    target: 10,
                  ),
                ],
              ),
            ),
              SizedBox(height: 24),

            // How it works
            Text('How it works', style: AppTextStyles.h1),
              SizedBox(height: 16),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HowItWorksStep(
                  step: 1,
                  title: 'Invite Friends',
                  desc: 'Share your code or link',
                ),
                Icon(Icons.arrow_right_alt, color: AppColors.lightDisabled),
                HowItWorksStep(
                  step: 2,
                  title: 'Friend Places Order',
                  desc: 'They get 20% OFF',
                ),
                Icon(Icons.arrow_right_alt, color: AppColors.lightDisabled),
                HowItWorksStep(
                  step: 3,
                  title: 'You Earn £10',
                  desc: 'After order completed',
                ),
              ],
            ),
              SizedBox(height: 24),

            // Share Icons
            Text('Share your link', style: AppTextStyles.h1),
              SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                  SocialShareIcon(
                  icon: Icons.chat,
                  color: AppColors.success,
                  label: 'WhatsApp',
                ),
                  SocialShareIcon(
                  icon: Icons.send,
                  color: Colors.blue,
                  label: 'Telegram',
                ),
                  SocialShareIcon(
                  icon: Icons.camera_alt,
                  color: Colors.pink,
                  label: 'Instagram',
                ),
                  SocialShareIcon(
                  icon: Icons.message,
                  color: Colors.blueAccent,
                  label: 'Messenger',
                ),
                  SocialShareIcon(
                  icon: Icons.more_horiz,
                  color: AppColors.lightDivider,
                  label: 'More',
                  isIconDark: true,
                ),
              ],
            ),
              SizedBox(height: 24),

            // Bottom Banner
              BottomBannerSection(),
              SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
    HeroSection({super.key});

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
                SizedBox(height: 8),
              Text(
                'Your friend gets 20% OFF on their first order and you earn £10 after their order is completed.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
                SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {},
                icon:   Icon(Icons.share, color: AppColors.white),
                label:   Text(
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
        Expanded(
          flex: 2,
          child: Container(
            height: 150,
            color: AppColors.appBackground,
            alignment: Alignment.center,
            child: Text('3D Image', style: AppTextStyles.bodyMedium),
          ),
        ),
      ],
    );
  }
}

class ReferralCodeCard extends StatelessWidget {
  final String title;
  final String value;

    ReferralCodeCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:   EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightDivider),
        borderRadius: BorderRadius.circular(8),
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.caption),
            SizedBox(height: 8),
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
    );
  }
}

class EarningHighlightSection extends StatelessWidget {
    EarningHighlightSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:   EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tagBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
            CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primaryPurple,
            child: Icon(Icons.account_balance_wallet, color: AppColors.white),
          ),
            SizedBox(width: 16),
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
            SizedBox(width: 24),
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

    BonusCard({
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
    return Container(
      width: 160,
      padding:   EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(tag, style: AppTextStyles.stepBadge),
            SizedBox(height: 8),
            Icon(Icons.emoji_events, size: 32, color: AppColors.warning),
            SizedBox(height: 8),
          Text(title, style: AppTextStyles.bodySmall),
          Text(
            subtitle,
            style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold),
          ),
            SizedBox(height: 8),
          LinearProgressIndicator(
            value: current / target,
            backgroundColor: AppColors.white,
            valueColor:   AlwaysStoppedAnimation<Color>(
              AppColors.primaryPurple,
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

    HowItWorksStep({
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
            SizedBox(height: 8),
            Icon(Icons.people, color: AppColors.primaryPurple),
            SizedBox(height: 8),
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

    SocialShareIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    this.isIconDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color,
          child: Icon(
            icon,
            color: isIconDark ? AppColors.textPrimary : AppColors.white,
          ),
        ),
          SizedBox(height: 8),
        Text(label, style: AppTextStyles.overline),
      ],
    );
  }
}

class BottomBannerSection extends StatelessWidget {
    BottomBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:   EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
            Icon(Icons.card_giftcard, color: AppColors.white, size: 40),
            SizedBox(width: 16),
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
            onPressed: () {},
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
