import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../constants.dart';
import '../../../../models/product_model.dart';
import '../../../../models/category_model.dart' as category_model;
import '../../../../route/screen_export.dart';
import 'package:shop/components/product/product_card.dart';

class WomensScreenRoute extends StatefulWidget {
  const WomensScreenRoute({super.key});

  @override
  State<WomensScreenRoute> createState() => _WomensScreenRouteState();
}

class _WomensScreenRouteState extends State<WomensScreenRoute> {
  String selectedCategory = "All Clothing";
  List<ProductModel> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    filteredProducts = demoFlashSaleProducts
        .where((product) => product.category == "Woman's")
        .toList();
  }

  void filterProducts(String category) {
    setState(() {
      selectedCategory = category;
      if (category == "All Clothing") {
        filteredProducts = demoFlashSaleProducts
            .where((product) => product.category == "Woman's")
            .toList();
      } else {
        filteredProducts = demoFlashSaleProducts
            .where((product) =>
                product.category == "Woman's" &&
                product.title.toLowerCase().contains(category.toLowerCase()))
            .toList();
      }
    });
  }

  void handleCategoryPress(String category) {
    switch (category) {
      case "On sale":
        Navigator.pushNamed(context, onSaleScreenRoute);
        break;
      case "Man's & Woman's":
        Navigator.pushNamed(context, MensScreenRoute);
        break;
      case "Kids":
        Navigator.pushNamed(context, kidsScreenRoute);
        break;

      default:
        filterProducts(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Women\'s'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Categories Section
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: Row(
              children: [
                ...List.generate(
                  category_model.demoCategories.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 0 : defaultPadding / 2,
                      right: index == category_model.demoCategories.length - 1
                          ? 0
                          : defaultPadding / 2,
                    ),
                    child: CategoryBtn(
                      category: category_model.demoCategories[index].title,
                      svgSrc: category_model.demoCategories[index].svgSrc,
                      isActive: selectedCategory ==
                          category_model.demoCategories[index].title,
                      press: () {
                        handleCategoryPress(
                            category_model.demoCategories[index].title);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Products Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(defaultPadding),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: defaultPadding,
                mainAxisSpacing: defaultPadding,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductCard(
                  image: product.image,
                  brandName: product.brandName,
                  title: product.title,
                  price: product.price,
                  press: () {
                    Navigator.pushNamed(context, productDetailsScreenRoute,
                        arguments: index.isEven);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryBtn extends StatelessWidget {
  const CategoryBtn({
    super.key,
    required this.category,
    this.svgSrc,
    required this.isActive,
    required this.press,
  });

  final String category;
  final String? svgSrc;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.transparent,
          border: Border.all(
              color: isActive
                  ? Colors.transparent
                  : Theme.of(context).dividerColor),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          children: [
            if (svgSrc != null)
              SvgPicture.asset(
                svgSrc!,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isActive ? Colors.white : Theme.of(context).iconTheme.color!,
                  BlendMode.srcIn,
                ),
              ),
            if (svgSrc != null) const SizedBox(width: defaultPadding / 2),
            Text(
              category,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
