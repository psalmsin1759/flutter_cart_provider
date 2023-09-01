import 'package:flutter/material.dart';
import 'package:flutter_cart_provider/provider/cart_provider.dart';
import 'package:provider/provider.dart';

import 'api/httpservice.dart';
import 'cart_details.dart';
import 'listitem/product_grid_item.dart';
import 'model/product.dart';
import 'package:badges/badges.dart' as badges;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: const Text(
          "Flutter Cart Provider",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          Row(
            children: [
              Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  return badges.Badge(
                    badgeColor: Colors.red,
                    position: badges.BadgePosition.bottomEnd(bottom: 1, end: 1),
                    badgeContent: Text(
                      cartProvider.cartCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.local_mall),
                      iconSize: 25,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext ctx) =>
                                    const CartDetails()));
                      },
                    ),
                  );
                },
              ),
              const SizedBox(
                width: 5,
              )
            ],
          )
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Store Products",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: FutureBuilder<List<Product>>(
                  future: httpService.getProductList(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.connectionState ==
                        ConnectionState.none) {
                      return const Center(
                        child: Text('An error occurred!'),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasData) {
                        if (snapshot.error != null) {
                          // ...
                          // Do error handling stuff
                          return const Center(
                            child: Text('An error occurred!'),
                          );
                        } else {
                          List<Product> data = snapshot.data!;

                          return GridView.builder(
                            padding: const EdgeInsets.all(4.0),
                            itemCount: data.length,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 3 / 4.8,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            itemBuilder: (context, index) {
                              var product = data[index];
                              print(product.title);
                              return GestureDetector(
                                  onTap: () {},
                                  child: ProductGridItem(product: product));
                            },
                          );
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }

                    return const Text("");
                  },
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
