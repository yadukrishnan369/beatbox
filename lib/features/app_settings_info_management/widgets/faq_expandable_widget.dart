import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FAQExpandableWidget extends StatelessWidget {
  const FAQExpandableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    return Container(
      padding: EdgeInsets.all(isWeb ? 20.w : 16.w),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FAQ header
          Row(
            children: [
              Icon(
                Icons.chat,
                size: isWeb ? 9.sp : 22.sp,
                color: AppColors.textPrimary,
              ),
              SizedBox(width: isWeb ? 6.w : 8.w),
              Text(
                'FAQs',
                style: TextStyle(
                  fontSize: isWeb ? 9.sp : 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: isWeb ? 20.h : 16.h),

          // FAQ items
          ..._faqData.map(
            (item) => _buildFAQItem(
              context,
              question: item['question']!,
              answer: item['answer']!,
              isWeb: isWeb,
            ),
          ),
        ],
      ),
    );
  }

  // expansion tile widget
  Widget _buildFAQItem(
    BuildContext context, {
    required String question,
    required String answer,
    required bool isWeb,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 0),
        childrenPadding: EdgeInsets.only(
          left: isWeb ? 8.w : 4.w,
          right: isWeb ? 8.w : 4.w,
          bottom: isWeb ? 12.h : 8.h,
        ),
        title: Text(
          question,
          style: TextStyle(
            fontSize: isWeb ? 5.sp : 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.textPrimary,
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: TextStyle(
                fontSize: isWeb ? 4.sp : 14.sp,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // FAQ data list
  List<Map<String, String>> get _faqData => [
    {
      'question': 'Q: How do I add a category or brand?',
      'answer':
          'Go to the stock screen and tap the add icon. Enter name and image to save.',
    },
    {
      'question': 'Q: Can I update the quantity of a product?',
      'answer':
          'Yes, use the Update Product screen or Limited Stock screen to modify quantity.',
    },
    {
      'question': 'Q: How does Limited Stock work?',
      'answer':
          'Products with quantity below 5 will appear in Limited Stock screen for quick restock.',
    },
    {
      'question': 'Q: What is the Sales & Profit chart?',
      'answer':
          'It shows daily, weekly, or monthly performance. Filter by date for full insight.',
    },
    {
      'question': 'Q: Can I export and import data?',
      'answer':
          'Yes, go to Settings. You can backup data to a file and restore from it anytime.',
    },
    {
      'question': 'Q: How to download the bill as PDF?',
      'answer':
          'After making a sale, tap the generate PDF button on the bill details screen to download it.',
    },
    {
      'question': 'Q: How to share the bill?',
      'answer':
          'After generating PDF, tap the share icon to send via WhatsApp, Gmail, or others.',
    },
    {
      'question': 'Q: Can I delete all app data?',
      'answer':
          'Yes, but use it carefully. Go to Settings and tap "Clear All Data" with confirmation.',
    },
    {
      'question': 'Q: How to change between light and dark mode?',
      'answer':
          'In Settings, use the Theme Toggle to switch between Light and Dark themes.',
    },
    {
      'question': 'Q: What happens if a product is out of stock?',
      'answer':
          'It will be marked as Out of Stock and not shown in active product list.',
    },
    {
      'question': 'Q: What does New Arrival mean?',
      'answer':
          'Products added in the last 7 days are tagged as New Arrival automatically.',
    },
  ];
}
