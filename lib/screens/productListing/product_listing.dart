import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../constants/app_colors.dart';
import '../../widgets/app_text.dart';

class ProductListing extends StatefulWidget {
  const ProductListing({super.key});

  @override
  State<ProductListing> createState() => _ProductListingState();
}

class _ProductListingState extends State<ProductListing> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameContoller = TextEditingController();

    final products = [
      {
        'name': 'GUCCI bag',
        'brand': 'GUCCI',
        'price': '₹ 45,599',
        'rating': '4.8',
        'image':
            'https://plus.unsplash.com/premium_photo-1664392147011-2a720f214e01?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZHVjdHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=600',
        'fav': false,
      },
      {
        'name': 'Boat wear',
        'brand': 'Boat',
        'price': '₹ 8,999',
        'rating': '4.6',
        'image':
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZHVjdHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=600',
        'fav': true,
      },
      {
        'name': 'Nike air',
        'brand': 'Nike',
        'price': '₹ 12,500',
        'rating': '4.5',
        'image':
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8cHJvZHVjdHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=600',
        'fav': false,
      },
      {
        'name': 'Sony Camera',
        'brand': 'Sony',
        'price': '₹ 6,999',
        'rating': '4.6',
        'image':
            'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8cHJvZHVjdHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=600',
        'fav': false,
      },
      {
        'name': 'Mitzie organic',
        'brand': 'Mitzie',
        'price': '₹ 6,999',
        'rating': '4.6',
        'image':
            "https://images.unsplash.com/photo-1549049950-48d5887197a0?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHByb2R1Y3R8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&q=60&w=600",
        'fav': false,
      },
      {
        'name': 'BioGlow',
        'brand': 'Faberlic',
        'price': '₹ 999',
        'rating': '4.6',
        'image':
            "https://images.unsplash.com/photo-1615397349754-cfa2066a298e?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fHByb2R1Y3R8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&q=60&w=600",
        'fav': false,
      },
      {
        'name': 'Women shoe',
        'brand': 'wildon',
        'price': '₹ 3,999',
        'rating': '4.6',
        'image':
            "https://images.unsplash.com/photo-1543163521-1bf539c55dd2?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fHByb2R1Y3R8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&q=60&w=600",
        'fav': false,
      },
      {
        'name': 'Air shoe',
        'brand': 'Nike',
        'price': '₹ 12,999',
        'rating': '4.6',
        'image':
            "https://images.unsplash.com/photo-1491553895911-0055eca6402d?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fHByb2R1Y3R8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&q=60&w=600",
        'fav': false,
      },
      {
        'name': 'Glassess',
        'brand': 'Rayban',
        'price': '₹ 9,999',
        'rating': '4.6',
        'image':
            "https://images.unsplash.com/photo-1572635196237-14b3f281503f?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8cHJvZHVjdHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=600",
        'fav': false,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () {
            // BACK ARROW BUTTON FUNCTION
          },
          child: Icon(Icons.arrow_back, size: 40.sp, color: AppColors.white),
        ),
        title: Container(
          height: 35.h,
          margin: EdgeInsets.only(right: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              SizedBox(width: 10.w),
              Icon(Icons.search, color: Colors.grey, size: 22.sp),
              SizedBox(width: 10.w),
              Expanded(
                child: TextField(
                  controller: nameContoller,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: AppColors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              //    FAVORITE BUTTON FUNCTION
            },
            child: Icon(
              Icons.favorite_border,
              color: AppColors.white,
              size: 35.sp,
            ),
          ),
          SizedBox(width: 10.w),
        ],
      ),

      body: Column(
        children: [
          Container(
            color: AppColors.lightGrey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.black,
                    ),
                    onPressed: () {
                      //  SORT BUTTON FUNCTION
                    },
                    icon: Icon(LucideIcons.arrowUpDown, size: 18.sp),
                    label: appText("sort", fontSize: 18.sp),
                  ),
                ),

                Container(
                  width: 1.w,
                  height: 40.h,
                  color: AppColors.shadowColor,
                ),
                Expanded(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.black,
                    ),
                    onPressed: () {
                      //    FILTER BUTTON FUNCTION
                    },
                    icon: Icon(LucideIcons.filter, size: 18.sp),
                    label: appText("filter ", fontSize: 18.sp),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(12.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.60.r,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return productCard(product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget productCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(color: Colors.grey, spreadRadius: 2.r, blurRadius: 6.r),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
                child: Image.network(
                  product['image'],
                  height: 115.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Icon(
                  product['fav'] ? Icons.favorite : Icons.favorite_border,
                  color: product['fav'] ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 2.h),
            child: appText(
              product["name"],
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.h),
            child: appText(
              product["brand"],
              fontSize: 13.sp,

              color: AppColors.grey,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 6.w),
            child: appText(
              product["price"],
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.h),
            child: Row(
              children: [
                Icon(Icons.star, color: AppColors.mediumAmber, size: 16.sp),
                SizedBox(width: 4.w),

                appText(product["rating"], fontSize: 13.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
