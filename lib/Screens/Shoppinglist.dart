import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';






class Product {
  final String name;
  final int id;
  final double cost;
  final int availability;
  final String details;
  final String category;
  final String imagePath; // Add this field for the image asset path
  int quantity;

  Product({
    required this.name,
    required this.id,
    required this.cost,
    required this.availability,
    required this.details,
    required this.category,
    required this.imagePath, // Include this field in the constructor
    this.quantity = 0,
  });
}



class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    String data = await rootBundle.loadString('assets/products.json');
    List<dynamic> productsJson = json.decode(data);
    setState(() {
      products = productsJson.map((json) {
        String imagePath = ''; // Manually specify image paths based on your assets
        if (json['p_id'] == 1) {
          imagePath = 'assets/images/apple.png';
        } else if (json['p_id'] == 2) {
          imagePath = 'assets/images/mango.png';
        } else if (json['p_id'] == 3) {
          imagePath = 'assets/images/bananas.png';
        } else if (json['p_id'] == 4) {
          imagePath = 'assets/images/orange.png';
        }

        return Product(
          name: json['p_name'],
          id: json['p_id'],
          cost: json['p_cost'].toDouble(),
          availability: json['p_availability'],
          details: json['p_details'] ?? '',
          category: json['p_category'] ?? 'Uncategorized',
          quantity: json['p_quantity'] ?? 0,
          imagePath: imagePath,
        );
      }).toList();
    });
  }

  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return
Padding(padding:EdgeInsets.all(15),
    child:  Column(
crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          height: 50,
          width: 400,
          padding: EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
           // color: Colors.indigo.shade400
              /*
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.indigo.shade700,
                    Colors.deepPurple.shade900,
                    Colors.deepPurple.shade800,
                    Colors.indigo.shade700
                  ]
              ),*/
            border: Border.all(color: Colors.amber)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.search,color: Colors.amber,),
              Text('Search here',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),)
            ],
          ),
        ),


        SizedBox(height: 23,),
        Text('Category',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
        SizedBox(height: 12,),
        Container(
          height: 50,
          child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (String category in ['All', ...products.map((product) => product.category).toSet().toList()])
              Padding(padding: EdgeInsets.all(3),
              child:ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = category;
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: selectedCategory == category ? Colors.amber :Colors.indigo.shade700,
                ),
                child: Text(category,style: TextStyle(color: Colors.white),),
              )
              )
              ,
          ],
        ), ),

Expanded(child: GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, // You can adjust the number of columns as needed
    crossAxisSpacing: 8.0,
    mainAxisSpacing: 8.0,
    childAspectRatio: 0.8
  ),
  itemCount: products.length,
  itemBuilder: (context, index) {
    Product product = products[index];
    if (selectedCategory == null || selectedCategory == 'All' || product.category == selectedCategory) {
      return InkWell(
        onTap: () {
          _showProductDetails(product);
        },
        child: Container(
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.deepPurple.shade900,
                  Colors.deepPurple.shade800,
                  Colors.indigo.shade700
                ]
            ),
            borderRadius: BorderRadius.circular(15),

          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(Icons.apple,color: Colors.amber,),
              Image.asset( product.imagePath,height: 110,),
              Text(product.name,style: TextStyle(
                  color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold
              ),),
              Text('${product.cost} \$',style: TextStyle(
                  color: Colors.amber,fontSize: 17,fontWeight: FontWeight.bold
              ),),

              SizedBox(height: 15,),

              Row(
                //mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  InkWell(
                    onTap:(){
                      setState(() {
                        setState(() {
                          if (product.quantity > 0) product.quantity--;
                        });
                      });
                    },
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                              colors: [
                                Colors.amber.shade900,
                                Colors.amberAccent
                              ]
                          )

                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Icon(Icons.remove,color: Colors.white,size: 20,)
                        ],
                      ),
                    )  ,
                  ),
                  Text('${product.quantity}',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),

                  InkWell(
                    onTap:(){
                      setState(() {
                        product.quantity++;
                      });
                    },
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                              colors: [
                                Colors.amber.shade900,
                                Colors.amberAccent
                              ]
                          )

                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Icon(Icons.add,color: Colors.white,size: 20,)
                        ],
                      ),
                    )  ,
                  )

                  ,

                ],
              ),
            ],
          ),
        ) ,
      );






    } else {
      return Container(); // Return an empty container for products not in the selected category
    }
  },
),
),


        InkWell(
          onTap: (){
            _showCheckoutBottomSheet();
          },
          child:Container(
            height: 60,
            width: 400,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.shade900,
                    Colors.amberAccent
                  ]
                )

            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text('Chekout',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)
              ],
            ),
          ) ,
        )
        ,

      ],
    ));
  }

  void _showProductDetails(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(product.name),
          content: Text(
            'ID: ${product.id}\n'
                'Cost: ${product.cost}\n'
                'Availability: ${product.availability}\n'
                'Details: ${product.details}\n'
                'Category: ${product.category}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showCheckoutBottomSheet() {
    List<Product> selectedProducts = products.where((product) => product.quantity > 0).toList();

    showModalBottomSheet(
      context: context,
      
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(left: 16,right: 16,top: 6,bottom: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.deepPurple.shade900,

                  Colors.deepPurple.shade700,
                  Colors.deepPurple.shade900,
                ]
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(alignment: Alignment.center,
              child:Container(

                height: 5,
                width: 68,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        colors: [
                          Colors.amber.shade900,
                          Colors.amberAccent,

                        ]
                    )

                ),

              ) ,
              ),
SizedBox(height: 20,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Checkout', style: TextStyle(fontSize:20, fontWeight: FontWeight.bold,color: Colors.white)),
                TextButton(onPressed: (){
                  setState(() {
                    Navigator.pop(context);
                  });
                }, child:  Text('Cancel', style: TextStyle(fontSize:17, fontWeight: FontWeight.bold,color: Colors.red)))
              ],
              )
             ,
             // Divider(),
              SizedBox(height: 15,),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedProducts.length,
                  itemBuilder: (context, index) {
                    Product product = selectedProducts[index];
                    return ListTile(
                      title: Text(product.name,style: TextStyle(color: Colors.white),),
                      leading:CircleAvatar(
                        backgroundColor: Colors.amber.shade700,
                        backgroundImage: AssetImage( product.imagePath,),
                      ),
                      trailing: Text('${product.quantity} x ${product.cost} \$',style: TextStyle(color: Colors.amber),),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),

              InkWell(
                onTap: (){
                  setState(() {
                    Navigator.of(context).pop();
                    _showCheckoutSummary(selectedProducts);
                  });
                },
                child:Container(
                  height: 50,
                  width: 390,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          colors: [
                            Colors.amber.shade900,
                            Colors.amberAccent,

                          ]
                      )

                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text('Proceed to Chekout',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)
                    ],
                  ),
                ) ,
              )


            ],
          ),
        );
      },
    );
  }


  void _showCheckoutSummary(List<Product> selectedProducts) {
    double totalCost = 0;
    for (var product in selectedProducts) {
      totalCost += product.quantity * product.cost;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                 Colors.deepPurple.shade900,
                  Colors.deepPurpleAccent
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.amberAccent,
                    backgroundImage: AssetImage('assets/images/party.png'),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    'Order Sucessful!',
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),
                  ),
                  Text('Total Cost: $totalCost \$',style: TextStyle(color: Colors.amber,fontWeight: FontWeight.bold,fontSize: 16)),
                  SizedBox(height: 16),
                  Text('Thank you for shopping\n              with us!',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16)),
                 InkWell(
                   onTap: (){
                   setState(() {
                     Navigator.pop(context);
                   });

                 },
                 child:Container(
                   height: 30,
                   width: 65,
                   margin: EdgeInsets.only(left: 170,top: 15),
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(6),
                       gradient: LinearGradient(
                           colors: [
                             Colors.amber.shade900,
                             Colors.amberAccent,

                           ]
                       )

                   ),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [

                       Text('cancel',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),)
                     ],
                   ),
                 ) ,
                 ),

                ],
              )


            ),
          ),

        );
      },
    );
  }
}
