import 'package:beatbox/features/product_management/widgets/limited_stock_body_content_widget.dart';
import 'package:beatbox/utils/limited_stock_utils.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/widgets/custom_search_bar.dart';
import 'package:beatbox/core/notifiers/limited_stock_notifier.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';

class LimitedStockScreen extends StatefulWidget {
  const LimitedStockScreen({super.key});

  @override
  State<LimitedStockScreen> createState() => _LimitedStockScreenState();
}

class _LimitedStockScreenState extends State<LimitedStockScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    LimitedStockUtils.filterLimitedStockProducts();
  }

  void _onSearch(String query) {
    final isQueryEmpty = query.trim().isEmpty;
    setState(() {
      _isSearching = !isQueryEmpty;
    });

    if (_isSearching) {
      LimitedStockUtils.searchLimitedProducts(query);
    } else {
      LimitedStockUtils.filterLimitedStockProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (_) {
          FocusScope.of(context).unfocus();
          return false;
        },
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            title: Text(
              "Limited stock",
              style: TextStyle(
                fontSize: isWeb ? 20 : 22.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: ValueListenableBuilder<bool>(
            valueListenable: limitedStockShimmerNotifier,
            builder: (_, isShimmer, __) {
              return Column(
                children: [
                  ValueListenableBuilder<List<ProductModel>>(
                    valueListenable: limitedStockNotifier,
                    builder: (_, productList, __) {
                      return productList.isNotEmpty || _isSearching
                          ? Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isWeb ? 24 : 16.w,
                              vertical: isWeb ? 12 : 8.h,
                            ),
                            child: CustomSearchBar(
                              controller: _searchController,
                              onChanged: _onSearch,
                              focusNode: _searchFocusNode,
                              showFilterIcon: false,
                            ),
                          )
                          : const SizedBox();
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        width: isWeb ? 700 : double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: isWeb ? 24 : 0,
                          vertical: isWeb ? 10 : 0,
                        ),
                        child: LimtedStockBodyContent(
                          isSearching: _isSearching,
                          isWeb: isWeb,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
