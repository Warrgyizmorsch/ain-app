import 'package:ain/app/common/constant/app_imports.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlWebView extends StatefulWidget {
  final String htmlContent;

  const HtmlWebView({
    super.key,
    required this.htmlContent,
  });

  @override
  State<HtmlWebView> createState() => _HtmlWebViewState();
}

class _HtmlWebViewState extends State<HtmlWebView> {
  late final WebViewController _controller;

  final RxBool _isLoading = true.obs;
  // Start with a small default height while loading
  final RxDouble webViewHeight = 150.0.obs;

  @override
  void initState() {
    super.initState();
    _isLoading.value = true;
    webViewHeight.value = 150.0;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            // 1. Wait a moment for images and fonts to render
            await Future.delayed(const Duration(milliseconds: 300));

            try {
              // 2. Ask the WebView for its exact total height
              final result = await _controller.runJavaScriptReturningResult(
                  "document.documentElement.scrollHeight.toString();");

              // Clean the result (Android sometimes adds quotes)
              final cleanResult = result.toString().replaceAll('"', '');
              final double? height = double.tryParse(cleanResult);

              if (height != null && height > 0) {
                // 3. Update the GetX variable to stretch the container
                webViewHeight.value = height + 40; // Add 40px padding for safety
                debugPrint('Dynamic Height Set To: ${webViewHeight.value}');
              }
            } catch (e) {
              debugPrint("JS Error: $e");
            } finally {
              _isLoading.value = false;
            }
          },
          onWebResourceError: (error) {
            _isLoading.value = false;
          },
        ),
      )
    // Adding localhost baseUrl to bypass Android local HTML restrictions
      ..loadHtmlString(_html(widget.htmlContent), baseUrl: 'https://localhost');
  }

  String _html(String body) {
    return '''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
<style>
html,body{
  margin:0;
  padding:8px;
  overflow:hidden; /* CRITICAL: Must be hidden so the webview expands instead of scrolling */
  background:transparent;
  font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Arial,sans-serif;
  font-size:14px;
  line-height:1.6;
  color:#1A1A2E;
  box-sizing:border-box;
}
*{
  box-sizing:border-box;
  max-width:100%;
}
img{
  max-width:100%;
  height:auto;
  display:block;
}
table{
  width:100%;
  border-collapse:collapse;
}
iframe{
  max-width:100%;
}
video{
  max-width:100%;
  height:auto;
}
a{
  color:#FF8A65;
  text-decoration:none;
}
p{
  margin:0 0 12px;
}
h1,h2,h3,h4,h5,h6{
  color:#5E35B1;
  margin-top:16px;
  margin-bottom:8px;
}
</style>
</head>
<body>
$body
</body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        height: webViewHeight.value,
        clipBehavior: Clip.hardEdge,
        decoration: _cardDecoration(),
        child: Stack(
          children: [
            // No gesture recognizers needed here anymore because
            // the whole widget expands and scrolls natively with the outer page!
            WebViewWidget(controller: _controller),

            if (_isLoading.value)
              const Center(
                child: CircularProgressIndicator(color: Color(0xFF5E35B1)),
              ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha:0.04), // Fixed withOpacity for wider compatibility
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}