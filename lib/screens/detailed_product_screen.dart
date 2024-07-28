import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pingolearn_assignment/constants/colors.dart';
import 'package:pingolearn_assignment/models/product_model.dart';
import 'package:pingolearn_assignment/utils/app_spacing.dart';

class DetailedProductScreen extends StatelessWidget {
  final ProductElement product;
  const DetailedProductScreen({super.key, required this.product});

  double calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;

    int totalRating = 0;
    for (var review in reviews) {
      totalRating += review.rating;
    }

    return totalRating / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    double averageRating = calculateAverageRating(product.reviews);
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        backgroundColor: AppColors.backgroundColor,
        titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          Widget content = Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: product.id,
                child: Container(
                    height: h * 0.3,
                    width: w,
                    decoration: const BoxDecoration(
                      color: AppColors.backgroundColor,
                    ),
                    child: CachedNetworkImage(
                        imageUrl: product.thumbnail,
                        fit: BoxFit.contain,
                        key: Key(product.thumbnail))),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpacing.height(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                            AppSpacing.height(5),
                            Text(
                              "\$${product.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                            AppSpacing.height(5),
                            Text(
                              categoryValues.reverse[product.category]!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.blueGrey),
                            ),
                            AppSpacing.height(15),
                            Text(
                              product.description,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                            AppSpacing.height(10),
                            Text(
                              returnPolicyValues.reverse[product.returnPolicy]!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.grey),
                            ),
                            AppSpacing.height(20),
                            Text(
                              "🌟 ${averageRating.toStringAsFixed(1)} stars (${product.reviews.length} reviews)",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Colors.yellow),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );

          if (constraints.maxHeight < 600) {
            return SingleChildScrollView(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: content));
          } else {
            return content;
          }
        },
      ),
    );
  }
}
