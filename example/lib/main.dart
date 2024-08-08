import 'package:fake_store_client/fake_store_client.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = FakeStoreController();

  bool _isLoading = false;
  Exception? _error;

  List<Category>? _categories;
  Category? _categorySelected;

  List<Product>? _products;
  Product? _product;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MaterialApp(
      title: 'Example',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fake Store Client'),
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // * Error info
              if (_error != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Center(
                      child: Text(
                        _error.toString(),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

              // * Button Start getting categories and products
              SliverToBoxAdapter(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_isLoading) return;

                    setState(() {
                      _product = null;
                      _products = null;
                      _categories = null;
                      _categorySelected = null;
                      _isLoading = true;
                    });

                    // ? Get Categories
                    final result = await _controller.getAllCategories();

                    if (result.isFailure) {
                      setState(() {
                        _error = result.getException();
                        _isLoading = false;
                      });
                      return;
                    }

                    setState(() {
                      _error = null;
                      _categories = result.getSuccessValue();
                      _isLoading = false;
                    });
                  },
                  child: const Text('Get All Categories'),
                ),
              ),

              // * List of [Category]
              if (_categories != null)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: size.height * 0.1,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories!.length,
                      itemBuilder: (context, index) {
                        final category = _categories![index];

                        return ChoiceChip(
                          selected: _categorySelected == category,
                          label: Text(
                            category.name,
                            key: ValueKey(category.name),
                          ),
                          onSelected: (_) async {
                            if (_categorySelected == category) return;
                            if (_isLoading) return;

                            // ? Get products by category
                            setState(() {
                              _categorySelected = category;
                              _products = null;
                              _product = null;
                              _isLoading = true;
                            });

                            final result = await _controller
                                .getProductsByCategory(category.name);

                            if (result.isFailure) {
                              setState(() {
                                _error = result.getException();
                                _isLoading = false;
                              });
                              return;
                            }

                            setState(() {
                              _error = null;
                              _products = result.getSuccessValue();
                              _isLoading = false;
                            });
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                    ),
                  ),
                ),

              // * List of [Product]
              if (_products != null)
                SliverList.separated(
                  itemCount: _products!.length,
                  itemBuilder: (context, index) {
                    final product = _products![index];

                    return ListTile(
                      leading: Text(
                        'ID ${product.id}',
                      ),
                      title: Text(
                        product.title,
                      ),
                      selected: _product == product,
                      key: ValueKey(product.id),
                      onTap: () async {
                        if (_product == product) return;
                        if (_isLoading) return;

                        //? Get info about product
                        if (_isLoading) return;

                        setState(() {
                          _isLoading = true;
                          _product = null;
                        });

                        final result = await _controller.getProductDetail(
                          product.id,
                        );

                        // ? Validate if has error
                        if (result.isFailure) {
                          setState(() {
                            _error = result.getException();
                            _isLoading = false;
                          });
                          return;
                        }

                        setState(() {
                          _error = null;
                          _product = result.getSuccessValue();
                          _isLoading = false;
                        });
                      },
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                ),

              if (_isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),

              // * Info about product
              if (_product != null)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        const Divider(),

                        // * Image
                        if (_product!.image != null)
                          Image.network(
                            _product!.image!,
                          ),

                        // * Description
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 25,
                          ),
                          child: Text(
                            _product!.description ?? 'Sin Description',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
