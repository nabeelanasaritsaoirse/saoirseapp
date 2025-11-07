import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        elevation: 0,
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () {
            // BACK ARROW BUTTON FUNCTION
          },
          child: Icon(Icons.arrow_back, size: 40, color: Colors.white),
        ),
        title: Container(
          height: 42,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              const Icon(Icons.search, color: Colors.grey, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(controller: nameContoller,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: Colors.grey),
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
            child: const Icon(
              Icons.favorite_border,
              color: Color.fromARGB(255, 255, 255, 255),
              size: 40,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 245, 245, 246),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    onPressed: () {
                      //  SORT BUTTON FUNCTION
                    },
                    icon: const Icon(LucideIcons.arrowUpDown, size: 18),
                    label: const Text('Sort'),
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: const Color.fromARGB(60, 17, 17, 17),
                ),
                Expanded(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    onPressed: () {
                      //    FILTER BUTTON FUNCTION
                    },
                    icon: const Icon(LucideIcons.filter, size: 18),
                    label: const Text('Filter'),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
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
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.grey, spreadRadius: 2, blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                child: Image.network(
                  product['image'],
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  product['fav'] ? Icons.favorite : Icons.favorite_border,
                  color: product['fav'] ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 2),
            child: Text(
              product['name'],
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              product['brand'],
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Text(
              product['price'],
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(product['rating'], style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
