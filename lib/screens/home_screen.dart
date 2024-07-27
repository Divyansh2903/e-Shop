import 'package:flutter/material.dart';
import 'package:pingolearn_assignment/constants/colors.dart';
import 'package:pingolearn_assignment/provider/remote_config_provider.dart';
import 'package:pingolearn_assignment/provider/product_provider.dart';
import 'package:pingolearn_assignment/services/firebase_services.dart';
import 'package:pingolearn_assignment/widgets/loading_container.dart';
import 'package:pingolearn_assignment/widgets/single_product_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<ProductProvider>().fetchProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text("e-Shop"),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseService().signOut();
            },
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.exit_to_app),
          )
        ],
        backgroundColor: AppColors.primaryColor,
        toolbarHeight: h * 0.08,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Consumer2<RemoteConfigProvider, ProductProvider>(
        builder: (context, remoteConfigProvider, productProvider, _) {
          if (productProvider.products.isEmpty && productProvider.isLoading) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.48,
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return LoadingContainer();
              },
            );
          } else if (productProvider.products.isEmpty) {
            return const Center(child: Text('No products available'));
          } else {
            return GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.48,
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
              ),
              itemCount: productProvider.products.length +
                  (productProvider.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < productProvider.products.length) {
                  final product = productProvider.products[index];
                  return SingleProductWidget(
                    isSale: remoteConfigProvider.isSale,
                    product: product,
                  );
                } else {
                  return LoadingContainer();
                }
              },
            );
          }
        },
      ),
    );
  }
}
