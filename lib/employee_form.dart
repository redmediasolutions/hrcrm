import 'package:flutter/material.dart';
import 'package:red_hrcrm/component/employeeinfo.dart';

class EmployeeForm extends StatefulWidget {
  const EmployeeForm({super.key});

  @override
  State<EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: AppBar(
         elevation: 0,
        leadingWidth: 500,
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(15),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              
              children: [
             
          
                const SizedBox(height: 16),
                const PersonalInformationSection(),
                const SizedBox(height: 25),
                const ContactInformationSection(),
                const SizedBox(height: 25),
                const PreviousEmploymentSection(),
                const SizedBox(height: 25),
                const EmergencyContactSection(),
                const SizedBox(height: 25),
                const BankDetailsSection(),
                const SizedBox(height: 25),
                const DeclarationSection(),
                const SizedBox(height: 25),
                const OfficeUseOnlySection(),
                const SizedBox(height: 16),
               
              ],
            ),
          ),
              
        )

      ),
        );
     
  }
}
