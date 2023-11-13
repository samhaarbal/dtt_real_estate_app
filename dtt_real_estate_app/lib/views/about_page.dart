import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../utils/styles.dart';

/// Static constant for the image asset path of DTT banner.
const String _dttBannerImagePath = 'Images/dtt_banner/dtt_banner.png';

/// Static constant for DTT website URL.
const String _dttWebsiteUrl = 'https://www.d-tt.nl';

/// A stateless widget that displays an information page about the app.
///
/// It includes sections about the app, its design, and development, with links to the developer's website.
class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.lightgray,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6.h),
            _buildSectionTitle("ABOUT"),
            _buildTextParagraph(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et "
                    "dolore magna aliqua. Nibh nisl condimentum id venenatis a. Sit amet nisl purus in mollis nunc sed. "
                    "Arcu cursus euismod quis viverra nibh cras. Auctor augue mauris augue neque gravida in fermentum et. "
                    "Nec ullamcorper sit amet risus nullam eget. Quam vulputate dignissim suspendisse in est. Ullamcorper a"
                    " lacus vestibulum sed arcu non odio euismod. Feugiat nibh sed pulvinar proin gravida hendrerit lectus. "
                    "Ut eu sem integer vitae justo eget. Praesent elementum facilisis leo vel fringilla est ullamcorper. "
                    "Ultrices in iaculis nunc sed augue lacus viverra vitae congue. Gravida neque convallis a cras. "
                    "Diam ut venenatis tellus in metus vulputate eu. Id velit ut tortor pretium viverra. In ante metus "
                    "dictum at tempor commodo."
            ),
            _buildSectionTitle("Design and Development"),
            _buildDesignAndDevelopmentSection(),
          ],
        ),
      ),
    );
  }

  /// Builds the section title with the given [titleText].
  Widget _buildSectionTitle(String titleText) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Text(titleText, style: CustomTextStyles.title03),
    );
  }

  /// Builds a text paragraph with the given [paragraphText].
  Widget _buildTextParagraph(String paragraphText) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Text(paragraphText, style: CustomTextStyles.body),
    );
  }

  /// Builds the design and development section with an image and a link to the developer's website.
  Widget _buildDesignAndDevelopmentSection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(_dttBannerImagePath, width: 30.w),
          SizedBox(width: 5.w),
          _buildDeveloperInfoColumn(),
        ],
      ),
    );
  }

  /// Builds the column containing developer information and website link.
  Widget _buildDeveloperInfoColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('By DTT', style: CustomTextStyles.bodystrong),
        InkWell(
          onTap: () => _launchURL(_dttWebsiteUrl),
          child: Text(
            'd-tt.nl',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 8.sp,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
      ],
    );
  }

  /// Launches the given [url] in the mobile browser.
  void _launchURL(String url) async {
    try {
      await launchUrlString(url);
    } catch (e) {
      // Log the error
      print('Could not launch $url: $e');
    }
  }
}
