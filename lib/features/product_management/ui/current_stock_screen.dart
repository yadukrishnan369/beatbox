import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/features/product_management/widgets/current_stock_body_content_widget.dart';
import 'package:beatbox/utils/current_stock_utils.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:beatbox/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/current_stock_notifier.dart';

class CurrentStockScreen extends StatefulWidget {
  const CurrentStockScreen({super.key});

  @override
  State<CurrentStockScreen> createState() => _CurrentStockScreenState();
}

class _CurrentStockScreenState extends State<CurrentStockScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    CurrentStockUtils.filterCurrentStockProducts();
  }

  void _onSearch(String query) {
    final isQueryEmpty = query.trim().isEmpty;
    setState(() {
      _isSearching = !isQueryEmpty;
    });

    if (_isSearching) {
      CurrentStockUtils.searchCurrentStockProducts(query);
    } else {
      CurrentStockUtils.filterCurrentStockProducts();
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
              "Current Stock",
              style: TextStyle(
                fontSize: isWeb ? 7.sp : 22.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final bool isWeb =
                  Responsive.isDesktop(context) || constraints.maxWidth > 600;

              return ValueListenableBuilder<bool>(
                valueListenable: currentStockShimmerNotifier,
                builder: (_, isShimmer, __) {
                  return Column(
                    children: [
                      ValueListenableBuilder<List<ProductModel>>(
                        valueListenable: currentStockNotifier,
                        builder: (_, productList, __) {
                          return productList.isNotEmpty || _isSearching
                              ? Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isWeb ? 120 : 16.w,
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
                      CurrentStockBodyContent(
                        isShimmer: isShimmer,
                        isWeb: isWeb,
                        isSearching: _isSearching,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
