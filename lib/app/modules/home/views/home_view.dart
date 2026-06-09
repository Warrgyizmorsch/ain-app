
import '../../../common/constant/app_imports.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      drawer: _AppDrawer(),
      appBar: CustomAppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu),
          ),
        ),
        title:
          'Home',
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Bar ──────────────────────────────────────────────────


              // ── Greeting ─────────────────────────────────────────────────
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hey!',
                      style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
                    ),
                    Text(
                      'Priyanka',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Banner ───────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    ImageConstant.homeBanner,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // ── Dot Indicator ─────────────────────────────────────────
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Dot(active: true),
                  const SizedBox(width: 4),
                  _Dot(active: false),
                ],
              ),

              const SizedBox(height: 24),

              // ── Orders ───────────────────────────────────────────────────
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Orders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _OrderCard(count: '0', label: 'Total'),
                    const SizedBox(width: 12),
                    _OrderCard(count: '0', label: 'In Progress'),
                    const SizedBox(width: 12),
                    _OrderCard(count: '0', label: 'Completed'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Current Orders ────────────────────────────────────────────
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Current Orders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Icon(
                      Icons.assignment_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No orders yet.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Hire a writer to get started!',
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Get.toNamed(Routes.ADD_ORDER),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 14),
                      ),
                      child: const Text(
                        'Order Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Drawer ────────────────────────────────────────────────────────────────────
class _AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Stack(
          children: [
            // ── Bottom decorative background (behind everything) ─────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                ImageConstant.drawerBackground,
                fit: BoxFit.fitWidth,
              ),
            ),

            // ── Foreground content ───────────────────────────────────────
            SizedBox(
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Profile Row ─────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Row(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: AppColors.primary,
                          child: const Text(
                            'P',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Name & email
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Priyanka Joshi',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Priyanka9999@gmail.com',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF888888),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Cart icon right
                        const Icon(
                          Icons.shopping_bag_outlined,
                          color: Color(0xFF888888),
                          size: 22,
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 12),

                  // ── Main Actions Label ───────────────────────────────────────
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Main Actions',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── Menu Items ───────────────────────────────────────────────
                  _DrawerItem(
                    icon:ImageConstant.addIcon,
                    iconBgColor: const Color(0xFFE8F4FF),
                    iconColor: const Color(0xFF3BBFCF),
                    label: 'New Assignment',
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.ADD_ORDER);
                    },
                  ),
                  _DrawerItem(
                    icon: ImageConstant.walletIcon,
                    iconBgColor: const Color(0xFFFFF3E0),
                    iconColor: const Color(0xFFFF9800),
                    label: 'Wallet',
                    onTap: () => Get.toNamed(Routes.WALLET),
                  ),
                  _DrawerItem(
                    icon: ImageConstant.ordersIcon,
                    iconBgColor: const Color(0xFFE8F5E9),
                    iconColor: const Color(0xFF4CAF50),
                    label: 'My Orders',
                    onTap: () => Get.back(),
                  ),
                  _DrawerItem(
                    icon:ImageConstant.settingIcon,
                    iconBgColor: const Color(0xFFF3E5F5),
                    iconColor: const Color(0xFF9C27B0),
                    label: 'Settings',
                    onTap: () => Get.back(),
                  ),
                  _DrawerItem(
                    icon: ImageConstant.policyIcon,
                    iconBgColor: const Color(0xFFE8EAF6),
                    iconColor: const Color(0xFF3F51B5),
                    label: 'Policies',
                    onTap: () => Get.back(),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String icon;
  final Color iconBgColor;
  final Color iconColor;
  final String label;
  final Color? labelColor;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.label,
    required this.onTap,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: Row(
          children: [
            // Colored circular icon badge
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                // color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(icon, color: AppColors.secondary, height: 20,width: 20,),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: labelColor ?? const Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Order Card ────────────────────────────────────────────────────────────────
class _OrderCard extends StatelessWidget {
  final String count;
  final String label;

  const _OrderCard({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              count,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0E8FCE),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dot Indicator ─────────────────────────────────────────────────────────────
class _Dot extends StatelessWidget {
  final bool active;
  const _Dot({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: active ? 16 : 8,
      height: 6,
      decoration: BoxDecoration(
        color: active ? AppColors.primary : const Color(0xFFCCCCCC),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}