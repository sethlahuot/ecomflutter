import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../constants.dart';
import '../../../../models/product_model.dart';
import '../../../../models/category_model.dart';
import '../../../../route/screen_export.dart';
import 'package:shop/components/product/product_card.dart';

class KidsScreen extends StatefulWidget {
  const KidsScreen({super.key});

  @override
  State<KidsScreen> createState() => _KidsScreenState();
}

class _KidsScreenState extends State<KidsScreen> {
  String selectedCategory = "All Clothing";
  List<ProductModel> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    filteredProducts = kidsProducts;
  }

  void filterProducts(String category) {
    setState(() {
      selectedCategory = category;
      if (category == "All Clothing") {
        filteredProducts = kidsProducts;
      } else {
        filteredProducts = kidsProducts
            .where((product) =>
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
        title: const Text("Kids"),
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
                  demoCategories.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 0 : defaultPadding / 2,
                      right: index == demoCategories.length - 1
                          ? 0
                          : defaultPadding / 2,
                    ),
                    child: CategoryBtn(
                      category: demoCategories[index].title,
                      svgSrc: demoCategories[index].svgSrc,
                      isActive: selectedCategory == demoCategories[index].title,
                      press: () {
                        handleCategoryPress(demoCategories[index].title);
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
                  priceAfetDiscount: product.priceAfetDiscount,
                  dicountpercent: product.dicountpercent,
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
