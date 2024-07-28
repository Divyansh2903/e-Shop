import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pingolearn_assignment/constants/colors.dart';
import 'package:pingolearn_assignment/models/product_model.dart';
import 'package:pingolearn_assignment/screens/detailed_product_screen.dart';
import 'package:pingolearn_assignment/utils/app_spacing.dart';

class SingleProductWidget extends StatelessWidget {
  final bool isSale;
  final ProductElement product;

  const SingleProductWidget({
    super.key,
    required this.isSale,
    required this.product,
  });

  double getDiscountedPrice(originalPrice, discountPercentage) {
    return originalPrice - (originalPrice * discountPercentage / 100);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    const hPadding = EdgeInsets.symmetric(horizontal: 10);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailedProductScreen(
              product: product,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        height: h * 0.45,
        width: w * 0.46,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: product.id,
              child: Container(
                  height: h * 0.2,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    key: Key(product.thumbnail),
                    imageUrl: product.thumbnail,
                  )),
            ),
            AppSpacing.height(5),
            Padding(
              padding: hPadding,
              child: Text(
                product.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AppSpacing.height(10),
            Padding(
              padding: hPadding,
              child: Text(
                product.description,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
                maxLines: 3,
              ),
            ),
            const Spacer(
              flex: 2,
            ),
            Padding(
              padding: hPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      decoration: isSale
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  if (isSale)
                    Text(
                      "\$${getDiscountedPrice(product.price, product.discountPercentage).toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  if (isSale)
                    Text(
                      "${product.discountPercentage.toStringAsFixed(0)}% off",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 0, 248, 8),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
            const Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
