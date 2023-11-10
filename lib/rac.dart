       // Container(
          //   height: 60,
          //   child: Expanded(
          //     flex: 1,
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 45.0),
          //       child: Align(
          //         alignment: Alignment.centerLeft,
          //         child: Text(
          //           'Welcome',
          //           style: GoogleFonts.alata(
          //             fontWeight: FontWeight.w900,
          //             fontSize: 40,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),



          // else {
          //                     return Stack(
          //                       alignment: Alignment.bottomRight,
          //                       children: [
          //                         CircleAvatar(
          //                           backgroundImage:
          //                               NetworkImage('${imgs[0]['image']}'),
          //                           radius: 50,
          //                           backgroundColor: Colors.blue,
          //                         ),
          //                       ],
          //                     );
          //                   }













              // if (snapshot.hasError) {
                          //   return Stack(
                          //     alignment: Alignment.bottomRight,
                          //     children: [
                          //       const CircleAvatar(
                          //         backgroundImage:
                          //             AssetImage('assets/images/logo/user.png'),
                          //         radius: 50,
                          //         backgroundColor: Colors.blue,
                          //       ),
                          //       Container(
                          //         height: 40,
                          //         width: 40,
                          //         child: ElevatedButton(
                          //             style: ButtonStyle(
                          //                 backgroundColor:
                          //                     MaterialStateProperty.all(
                          //               Colors.red.shade300,
                          //             )),
                          //             onPressed: getimg,
                          //             child: Container(
                          //               alignment: Alignment.center,
                          //               child: const Icon(
                          //                 Icons.add,
                          //                 color: Colors.white,
                          //                 size: 10,
                          //               ),
                          //             )),
                          //       ),
                          //     ],
                          //   );
                          // } else if (snapshot.hasData) {
                          //   QuerySnapshot<Map<String, dynamic>>? favourite =
                          //       snapshot.data;
                          //   List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          //       imgs = favourite!.docs;
                          //   if (imgs.isEmpty) {
                          //     return Stack(
                          //       alignment: Alignment.bottomRight,
                          //       children: [
                          //         const CircleAvatar(
                          //           backgroundImage: AssetImage(
                          //               'assets/images/logo/user.png'),
                          //           radius: 50,
                          //           backgroundColor: Colors.blue,
                          //         ),
                          //         Container(
                          //           height: 40,
                          //           width: 40,
                          //           child: ElevatedButton(
                          //               style: ButtonStyle(
                          //                   backgroundColor:
                          //                       MaterialStateProperty.all(
                          //                 Colors.red.shade300,
                          //               )),
                          //               onPressed: getimg,
                          //               child: Container(
                          //                 alignment: Alignment.center,
                          //                 child: const Icon(
                          //                   Icons.add,
                          //                   color: Colors.white,
                          //                   size: 10,
                          //                 ),
                          //               )),
                          //         ),
                          //       ],
                          //     );
                          //   }
                          // }

  //                         Future<QuerySnapshot> getthisUserInfo(String name) async {
  //   return await FirebaseFirestore.instance
  //       .collection("customer")
  //       .where("first_name", isEqualTo: name)
  //       .get();
  // }

  // Future UpdateUserData(String age, String id) async {
  //   return await FirebaseFirestore.instance
  //       .collection("customer")
  //       .doc(id)
  //       .update({"Age": age});
  // }

  // Future DeleteUserData(String id) async {
  //   return await FirebaseFirestore.instance
  //       .collection("customer")
  //       .doc(id)
  //       .delete();
  // }

      // await CustomerFsMethods()
      //       .addCustomerWithAddress(uploadData, uploadData);