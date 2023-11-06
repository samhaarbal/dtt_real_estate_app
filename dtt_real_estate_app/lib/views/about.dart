import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../utils/styles.dart';


class InfoPage extends StatelessWidget { // stateless because it holds no mutable states. Easy page.
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.lightgray,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,  // Set cross-axis alignment to start (left)
          children: [
            SizedBox(height: 6.h),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Text(
                  "ABOUT",
                  style: CustomTextStyles.title03
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et "
                      "dolore magna aliqua. Nibh nisl condimentum id venenatis a. Sit amet nisl purus in mollis nunc sed. "
                      "Arcu cursus euismod quis viverra nibh cras. Auctor augue mauris augue neque gravida in fermentum et. "
                      "Nec ullamcorper sit amet risus nullam eget. Quam vulputate dignissim suspendisse in est. Ullamcorper a"
                      " lacus vestibulum sed arcu non odio euismod. Feugiat nibh sed pulvinar proin gravida hendrerit lectus. "
                      "Ut eu sem integer vitae justo eget. Praesent elementum facilisis leo vel fringilla est ullamcorper. "
                      "Ultrices in iaculis nunc sed augue lacus viverra vitae congue. Gravida neque convallis a cras. "
                      "Diam ut venenatis tellus in metus vulputate eu. Id velit ut tortor pretium viverra. In ante metus "
                      "dictum at tempor commodo.",
                  style: CustomTextStyles.body
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Text(
                  "Design and Development",
                  style: CustomTextStyles.title02
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('Images/dtt_banner/dtt_banner.png', width: 30.w),

                  SizedBox(width: 5.w), // For spacing between the image and column

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Aligns the children of the column to the start
                    children: [
                      Text('By DTT', style: CustomTextStyles.bodystrong,),

                      InkWell(
                        onTap: () {
                          launchUrlString('https://www.d-tt.nl');
                        },
                        child: Text(
                          'd-tt.nl',
                          style: TextStyle(
                            color: Colors.blue, // Makes the text blue like a typical hyperlink
                            fontSize: 8.sp,
                              fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Your second child, third child, etc., here
                ],
              ),
            )


          ],
        ),
      ),
    );
  }
}
