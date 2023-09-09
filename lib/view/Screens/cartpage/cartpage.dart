import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rabe3/main.dart';
import 'package:url_launcher/url_launcher.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  Widget build(BuildContext context) {
    setState(() {
      cartList;
    });
Timer(Duration(milliseconds: 500), () {setState(() {
  
}); });
    return Scaffold(
      backgroundColor: Color(0xff0e1712),
      appBar: AppBar(
        backgroundColor: Color(0xff0e1712),
        title: Text('سلة المشتريات'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartList.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartList[index];
                    return Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          child: Image.network(
                            cartItem.image,
                            fit: BoxFit.fill,
                          ),
                        ),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "${cartItem.title}",
                                    style: TextStyle(
                                      fontSize: 19,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${cartItem.price}",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (cartItem.quantity > 1) {
                                          setState(() {
                                            cartItem.quantity--;
                                          });
                                        }
                                      },
                                      icon: Icon(Icons.remove),
                                    ),
                                    Text('${cartItem.quantity}'),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          cartItem.quantity++;
                                        });
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                ),
                                Container(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        cartList.removeAt(index);
                                      });
                                    },
                                    child: Icon(Icons.close),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Divider(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Quantity:",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    "${cartList.fold(0, (sum, item) => sum + item.quantity)}",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price:",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    "${cartList.fold(0, (sum, item) => sum + (item.price * item.quantity).toInt())}",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xfff7e4a1)
                      ),
                      onPressed: () {
                        _launchWhatsApp();// Perform checkout operation
                      },
                      child: Text("تاكيد اودر فرع ميدان المنسي",style: TextStyle(
                        color:
                          Color(0xff0e1712),
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                    SizedBox(height: 15,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xfff7e4a1)
                      ),
                      onPressed: () {
                        _launchWhatsApp2();// Perform checkout operation
                      },
                      child: Text("تاكيد اودر فرع كوبري البحر بجوار مستشفي جلال",style: TextStyle(
                          color:
                          Color(0xff0e1712),
                          fontWeight: FontWeight.bold
                      ),),),

                  ],
                ),
              )
            ],
          ),
        ),
      ),

    );
  }


  _launchWhatsApp()  {
    // رقم هاتف WhatsApp
    String phoneNumber = '201140114357';

// String textMessage = cartList.map((cartItem) {
//   return "${cartItem.title} - السعر: ${cartItem.price} جنيه - الكمية: ${cartItem.quantity}";
// }).join('\n');

    String textMessage = '';
    double totalPrice = 0;

    for (int index = 0; index < cartList.length; index++) {
      CartListModel cartItem = cartList[index];
      double itemTotal = cartItem.price * cartItem.quantity;

      String itemInfo =
          "${cartItem.title} - السعر: ${cartItem.price} جنيه - الكمية: ${cartItem.quantity} - الإجمالي: $itemTotal جنيه";

      totalPrice += itemTotal;

      textMessage += itemInfo;
      if (index < cartList.length - 1) {
        textMessage += '\n'; // Add a new line separator for all but the last item
      }
    }

    textMessage += "\nإجمالي السعر : $totalPrice جنيه";


    String encodedMessage = Uri.encodeComponent(textMessage);
// print(encodedMessage);
    var url = Uri.parse('https://wa.me/$phoneNumber?text=$encodedMessage');
    // فحص ما إذا كان بإمكان تشغيل التطبيق

    launchUrl(url,mode: LaunchMode.externalApplication);
  }
  _launchWhatsApp2()  {
    // رقم هاتف WhatsApp
    String phoneNumber = '201140544820';

// String textMessage = cartList.map((cartItem) {
//   return "${cartItem.title} - السعر: ${cartItem.price} جنيه - الكمية: ${cartItem.quantity}";
// }).join('\n');

    String textMessage = '';
    double totalPrice = 0;

    for (int index = 0; index < cartList.length; index++) {
      CartListModel cartItem = cartList[index];
      double itemTotal = cartItem.price * cartItem.quantity;

      String itemInfo =
          "${cartItem.title} - السعر: ${cartItem.price} جنيه - الكمية: ${cartItem.quantity} - الإجمالي: $itemTotal جنيه";

      totalPrice += itemTotal;

      textMessage += itemInfo;
      if (index < cartList.length - 1) {
        textMessage += '\n'; // Add a new line separator for all but the last item
      }
    }

    textMessage += "\nإجمالي السعر : $totalPrice جنيه";


    String encodedMessage = Uri.encodeComponent(textMessage);
// print(encodedMessage);
    var url = Uri.parse('https://wa.me/$phoneNumber?text=$encodedMessage');
    // فحص ما إذا كان بإمكان تشغيل التطبيق

    launchUrl(url,mode: LaunchMode.externalApplication);
  }

}

