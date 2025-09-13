// import 'package:flutter/material.dart';
// import '../api/coudinary.dart';
// class CreateAccountScreen extends StatefulWidget {
//   const CreateAccountScreen({super.key});

//   @override
//   State<CreateAccountScreen> createState() => _CreateAccountScreenState();
// }

// class _CreateAccountScreenState extends State<CreateAccountScreen> {
//   final _formKey = GlobalKey<FormState>();

//   String? selectedDepartment;
//   String? selectedYear;
//   bool agree = false;

//   final List<String> departments = ["MCA"];

//   final List<String> years = [
//     "1st Year",
//     "2nd Year",
//   ];

//   final List<String> interests = ["Sports", "Music", "Gaming"];
//   final TextEditingController interestController = TextEditingController();

//   void addInterest() {
//     if (interestController.text.isNotEmpty &&
//         !interests.contains(interestController.text)) {
//       setState(() {
//         interests.add(interestController.text);
//         interestController.clear();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: const BackButton(color: Colors.black),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           "Create Account",
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // Profile Picture
//              Center(
//   child: Column(
//     children: [
//       GestureDetector(
//         onTap: pickAndUploadImage, // 👈 call the function here
//         child: CircleAvatar(
//           radius: 50,
//           backgroundColor: Colors.grey[200],
//           backgroundImage: uploadedImageUrl.isNotEmpty
//               ? NetworkImage(uploadedImageUrl)
//               : null,
//           child: uploadedImageUrl.isEmpty
//               ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
//               : null,
//         ),
//       ),
//       const SizedBox(height: 8),
//       TextButton.icon(
//         onPressed: pickAndUploadImage, // 👈 or call it here
//         icon: const Icon(Icons.add_circle, color: Colors.blue),
//         label: const Text("Add Profile Picture"),
//       ),
//     ],
//   ),
// ),

//               const SizedBox(height: 20),

//               // Full Name
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: "Full Name",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // College ID
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: "College ID",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Department Dropdown
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   labelText: "Department",
//                   border: OutlineInputBorder(),
//                 ),
//                 value: selectedDepartment,
//                 items: departments
//                     .map((dept) =>
//                         DropdownMenuItem(value: dept, child: Text(dept)))
//                     .toList(),
//                 onChanged: (val) => setState(() => selectedDepartment = val),
//               ),
//               const SizedBox(height: 16),

//               // Year Dropdown
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   labelText: "Year",
//                   border: OutlineInputBorder(),
//                 ),
//                 value: selectedYear,
//                 items: years
//                     .map((yr) => DropdownMenuItem(value: yr, child: Text(yr)))
//                     .toList(),
//                 onChanged: (val) => setState(() => selectedYear = val),
//               ),
//               const SizedBox(height: 16),

//               // Interests
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Wrap(
//                   spacing: 8,
//                   children: interests
//                       .map((e) => Chip(
//                             label: Text(e),
//                             deleteIcon: const Icon(Icons.close),
//                             onDeleted: () {
//                               setState(() {
//                                 interests.remove(e);
//                               });
//                             },
//                           ))
//                       .toList(),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: interestController,
//                       decoration: const InputDecoration(
//                         hintText: "Add or search interests",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.add_circle, color: Colors.blue),
//                     onPressed: addInterest,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // Email
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: "Email",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Password
//               TextFormField(
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   labelText: "Password",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Terms and Conditions
//               Row(
//                 children: [
//                   Checkbox(
//                     value: agree,
//                     onChanged: (val) {
//                       setState(() => agree = val!);
//                     },
//                   ),
//                   const Expanded(
//                     child: Text.rich(
//                       TextSpan(
//                         text: "I agree to the ",
//                         children: [
//                           TextSpan(
//                             text: "Terms and Conditions",
//                             style: TextStyle(color: Colors.blue),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // Register Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 48,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                   ),
//                   onPressed: () {
//                     if (_formKey.currentState!.validate() && agree) {
//                       // Handle registration logic
//                     }
//                   },
//                   child: const Text("Register"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
