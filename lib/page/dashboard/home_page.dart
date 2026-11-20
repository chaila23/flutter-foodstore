
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foodstore/bloc/category/category_cubit.dart';
import 'package:flutter_foodstore/bloc/product/product_cubit.dart';
import 'package:flutter_foodstore/bloc/product_populer/product_populer_cubit.dart';
import 'package:flutter_foodstore/bloc/slider/slider_cubit.dart';
import 'package:flutter_foodstore/core/components/category_card.dart';
import 'package:flutter_foodstore/core/components/product_card.dart';
import 'package:flutter_foodstore/resource/model/slider_model.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<SliderCubit>().fetchSlider();
      context.read<CategoryCubit>().fetchCategory();
      context.read<ProductCubit>().fetchProduct(isRefresh: true);
      context.read<ProductPopulerCubit>().fetchProductPopuler();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // SLIDER
              _buildSliderSection(),

              const SizedBox(height: 24),

              // KATEGORI
              _buildCategorySection(),

              const SizedBox(height: 24),

              // PRODUK POPULER
              _buildProductSection(
                title: 'Produk Populer',
                icon: Icons.local_fire_department_outlined,
                onSeeAll: () {
                  context.push('/products');
                },
                child: BlocBuilder<ProductPopulerCubit,
                    ProductPopulerState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading: () => _buildLoadingIndicator(),

                      loadedProductPopuler: (products) {
                        if (products.isEmpty) {
                          return _buildEmptyMessage();
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: ProductCard(
                                product: products[index],
                                isPopular: true,
                              ),
                            );
                          },
                        );
                      },

                      error: (message) {
                        return _buildErrorMessage(message);
                      },

                      orElse: () => _buildLoadingIndicator(),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // PRODUK TERBARU
              _buildProductSection(
                title: 'Produk Terbaru',
                icon: Icons.shopping_bag_outlined,
                onSeeAll: () {
                  context.push('/products');
                },
                child: BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading: () => _buildLoadingIndicator(),

                      loadedProduct: (products, hasMore) {
                        if (products.isEmpty) {
                          return _buildEmptyMessage();
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: ProductCard(
                                product: products[index],
                                isPopular: false,
                              ),
                            );
                          },
                        );
                      },

                      error: (message) {
                        return _buildErrorMessage(message);
                      },

                      orElse: () => _buildLoadingIndicator(),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // SLIDER SECTION
  Widget _buildSliderSection() {
    return BlocBuilder<SliderCubit, SliderState>(
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => _buildLoadingIndicator(),

          loaded: (sliders) {
            if (sliders.isEmpty) {
              return const SizedBox.shrink();
            }

            return _buildImageSlider(sliders);
          },

          error: (message) {
            return _buildErrorMessage(message);
          },

          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  // IMAGE SLIDER
  Widget _buildImageSlider(List<SliderModel> sliders) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: sliders.length,
            itemBuilder: (context, index) {
              final slider = sliders[index];
              final imageUrl = slider.image ?? '';

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade100,
                ),
                clipBehavior: Clip.antiAlias,
                child: imageUrl.isEmpty
                    ? const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 45,
                          color: Colors.grey,
                        ),
                      )
                    : Image.network(
                        imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              size: 45,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
              );
            },
          ),
        ),

        if (sliders.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              sliders.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // CATEGORY SECTION
  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Kategori',
          Icons.category_outlined,
          () => context.push('/categories'),
        ),

        const SizedBox(height: 12),

        BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => _buildLoadingIndicator(),

              loaded: (categories) {
                if (categories.isEmpty) {
                  return _buildEmptyMessage();
                }

                return SizedBox(
                  height: 115,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: CategoryCard(
                          category: categories[index],
                        ),
                      );
                    },
                  ),
                );
              },

              error: (message) {
                return _buildErrorMessage(message);
              },

              orElse: () => _buildLoadingIndicator(),
            );
          },
        ),
      ],
    );
  }

  // PRODUCT SECTION
  Widget _buildProductSection({
    required String title,
    required IconData icon,
    required Widget child,
    required VoidCallback onSeeAll,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title, icon, onSeeAll),
        const SizedBox(height: 12),
        SizedBox(
          height: 250,
          child: child,
        ),
      ],
    );
  }

  // SECTION HEADER
  Widget _buildSectionHeader(
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.orange,
            size: 22,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: const Text(
              'Lihat Lainnya',
              style: TextStyle(
                color: Colors.deepOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // LOADING
  Widget _buildLoadingIndicator() {
    return const SizedBox(
      height: 150,
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
        ),
      ),
    );
  }

  // EMPTY
  Widget _buildEmptyMessage() {
    return const SizedBox(
      height: 150,
      child: Center(
        child: Text('Belum ada produk tersedia'),
      ),
    );
  }

  // ERROR
  Widget _buildErrorMessage(String message) {
    return SizedBox(
      height: 150,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
