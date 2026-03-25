
import 'package:flutter/material.dart';

class PersonalInformationSection extends StatefulWidget {
  final String title;
  final IconData icon;
  const PersonalInformationSection({
    super.key,
    this.title = 'Personal Information',
    this.icon = Icons.person,
  });

  @override
  State<PersonalInformationSection> createState() =>
      _PersonalInformationSectionState();
}

class _PersonalInformationSectionState
    extends State<PersonalInformationSection> {
  String _gender = 'Male';
  String _maritalStatus = 'Single';
  DateTime? _dob;
  final TextEditingController _dobController = TextEditingController();

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(236, 203, 221, 224),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.local_activity,
                            color: const Color.fromARGB(255, 8, 63, 73),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'FULL LIFE ASSEMBLY OF GOD (FLAG)',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '10/15, II Floor, East Patel Nagar, Delhi - 110008',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ph.: +91 9811273880 E. Mail: fulllifeassemblyofgod.flag@gmail.com',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
              const SizedBox(width: 16),
             Column(
                children: [
                  Container(
                    width: 120,
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'AFFIX\nPASSPORT SIZE\nPHOTO',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color : Colors.black54,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            spacing: 12,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromARGB(236, 203, 221, 224),
                ),
                child: Icon(widget.icon),
              ),
              Text(
                widget.title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'NAME',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'e.g. Alexander Pierce',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DATE OF BIRTH',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _dobController,
                          readOnly: true,
                          onTap: () async {
                            final now = DateTime.now();
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _dob ?? DateTime(now.year - 25),
                              firstDate: DateTime(1950),
                              lastDate: now,
                            );
                            if (picked == null) return;
                            setState(() {
                              _dob = picked;
                              _dobController.text =
                                  '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                            });
                          },
                          decoration: InputDecoration(
                            hintText: _dob == null ? 'DD/MM/YYYY' : null,
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: const Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'GENDER',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  InkWell(
                    onTap: () => setState(() => _gender = 'Male'),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _gender == 'Male'
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          const Text('Male'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => setState(() => _gender = 'Female'),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _gender == 'Female'
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          const Text('Female'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'NATIONALITY',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'e.g. Indian',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MOTHER TONGUE',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'e.g. Hindi',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'BLOOD GROUP',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'e.g. O+',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'AADHAAR NO.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'XXXX XXXX XXXX',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PAN NO.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'ABCDE1234F',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MARITAL STATUS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            InkWell(
                              onTap: () =>
                                  setState(() => _maritalStatus = 'Single'),
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F3F3),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _maritalStatus == 'Single'
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    const Text('Single'),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            InkWell(
                              onTap: () =>
                                  setState(() => _maritalStatus = 'Married'),
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F3F3),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _maritalStatus == 'Married'
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    const Text('Married'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SPOUSE\'S NAME',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'e.g. Priya Sharma',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'EDUCATIONAL QUALIFICATION',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'e.g. B.Tech',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ANY PHYSICAL DISABILITY OR ALLERGIC TO ANY FOOD OR DRUG',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'e.g. None',
                      filled: true,
                      fillColor: const Color(0xFFF3F3F3),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContactInformationSection extends StatelessWidget {
  final String title;
  final IconData icon;
  const ContactInformationSection({
    super.key,
    this.title = 'Contact Information',
    this.icon = Icons.contact_phone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            spacing: 12,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromARGB(236, 203, 221, 224),
                ),
                child: Icon(icon),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CORRESPONDENCE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Enter correspondence address',
                  filled: true,
                  fillColor: const Color(0xFFF3F3F3),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'PERMANENT ADDRESS (IF DIFFERENT)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Enter permanent address',
                  filled: true,
                  fillColor: const Color(0xFFF3F3F3),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PHONE',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'e.g. +91 98765 43210',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'EMAIL',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'name@company.com',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SPOUSE NAME',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'e.g. Priya Sharma',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CONTACT NUMBER',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'e.g. +91 98765 43210',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'FATHER\'S NAME',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'e.g. Ramesh Sharma',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CONTACT NUMBER',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'e.g. +91 98765 43210',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MOTHER\'S NAME',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'e.g. Sunita Sharma',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CONTACT NUMBER',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'e.g. +91 98765 43210',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PreviousEmploymentSection extends StatelessWidget {
  final String title;
  final IconData icon;
  const PreviousEmploymentSection({
    super.key,
    this.title = 'Previous Employment',
    this.icon = Icons.work_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            spacing: 12,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromARGB(236, 203, 221, 224),
                ),
                child: Icon(icon),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'POSITION HELD',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'e.g. Senior Analyst',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SALARY DRAWN',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'e.g. 45,000',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'EMPLOYER NAME',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'e.g. Red Systems',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'EMPLOYER ADDRESS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'e.g. 12, MG Road, Pune',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'P F NUMBER',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'e.g. PF1234567',
                  filled: true,
                  fillColor: const Color(0xFFF3F3F3),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EmergencyContactSection extends StatelessWidget {
  final String title;
  final IconData icon;
  const EmergencyContactSection({
    super.key,
    this.title = 'Emergency Contact Details',
    this.icon = Icons.health_and_safety_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            spacing: 12,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromARGB(236, 203, 221, 224),
                ),
                child: Icon(icon),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'NAME AND ADDRESS OF NEXT KIN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'e.g. Ramesh Sharma, 22 Park Street, Delhi',
                  filled: true,
                  fillColor: const Color(0xFFF3F3F3),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'RELATIONSHIP',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'e.g. Father',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CONTACT NUMBER',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'e.g. +91 98765 43210',
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BankDetailsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  const BankDetailsSection({
    super.key,
    this.title = 'Bank Details',
    this.icon = Icons.account_balance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            spacing: 12,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromARGB(236, 203, 221, 224),
                ),
                child: Icon(icon),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'NAME OF THE BANK',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'e.g. State Bank of India',
                  filled: true,
                  fillColor: const Color(0xFFF3F3F3),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'NAME OF THE BRANCH',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'e.g. MG Road',
                  filled: true,
                  fillColor: const Color(0xFFF3F3F3),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'BANK ACCOUNT NUMBER',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'e.g. 1234567890',
                  filled: true,
                  fillColor: const Color(0xFFF3F3F3),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'IFSC CODE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'e.g. SBIN0001234',
                  filled: true,
                  fillColor: const Color(0xFFF3F3F3),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DeclarationSection extends StatelessWidget {
  final String title;
  final IconData icon;
  const DeclarationSection({
    super.key,
    this.title = 'Declaration',
    this.icon = Icons.verified_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            spacing: 12,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromARGB(236, 203, 221, 224),
                ),
                child: Icon(icon),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'I undersigned hereby confirm that all the information given above is true and correct.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'SIGNATURE',
                    filled: true,
                    fillColor: const Color(0xFFF3F3F3),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'NB: Kindly attach a copy of your Aadhar Card, PAN Card, Experience certificate, Salary Proof, Bank Passbook Front Page, Medical certificate, Recommendation Letter and Education Certificates together with this form.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black54,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class OfficeUseOnlySection extends StatefulWidget {
  final String title;
  final IconData icon;

  const OfficeUseOnlySection({
    super.key,
    this.title = 'For Office Use Only',
    this.icon = Icons.assignment_turned_in_outlined,
  });

  @override
  State<OfficeUseOnlySection> createState() => _OfficeUseOnlySectionState();
}

class _OfficeUseOnlySectionState extends State<OfficeUseOnlySection> {
  bool _approved = true;
  DateTime? _dob;
  final TextEditingController _dobController = TextEditingController();
  final Map<String, bool> _checklist = {
    'PAN CARD': false,
    'AADHAR CARD': false,
    'EXPERIENCE CERTIFICATE': false,
    'SALARY PROOF': false,
    'EDUCATIONAL CERTIFICATES': false,
    'BANK PASSBOOK': false,
    'RECOMMENDATION LETTER': false,
    'MEDICAL CERTIFICATE': false,
  };
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            spacing: 12,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromARGB(236, 203, 221, 224),
                ),
                child: Icon(widget.icon),
              ),
              Text(
                widget.title.toUpperCase(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _officeField(label: 'RECEIVED DATE', hint: 'DD/MM/YYYY'),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _officeField(
                  label: 'CHECKED BY DATE',
                  hint: 'DD/MM/YYYY',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _officeField(label: 'DATE OF JOINING', hint: 'DD/MM/YYYY'),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'CHECKLIST',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _checkRow('PAN CARD')),
              const SizedBox(width: 20),
              Expanded(child: _checkRow('AADHAR CARD')),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _checkRow('EXPERIENCE CERTIFICATE')),
              const SizedBox(width: 20),
              Expanded(child: _checkRow('SALARY PROOF')),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _checkRow('EDUCATIONAL CERTIFICATES')),
              const SizedBox(width: 20),
              Expanded(child: _checkRow('BANK PASSBOOK')),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _checkRow('RECOMMENDATION LETTER')),
              const SizedBox(width: 20),
              Expanded(child: _checkRow('MEDICAL CERTIFICATE')),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'HR SIGN',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _radioRow(
                  'APPROVED',
                  _approved == true,
                  () => setState(() => _approved = true),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _radioRow(
                  'NOT APPROVED',
                  _approved == false,
                  () => setState(() => _approved = false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EMPLOYEE ID NUMBER ALLOTTED',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'e.g. EMP-1024',
                        filled: true,
                        fillColor: const Color(0xFFF3F3F3),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "PRESIDENT'S SIGNATURE",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'SIGNATURE',
                        filled: true,
                        fillColor: const Color(0xFFF3F3F3),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 25,
            children: [
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0C5D6B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  label: const Text(
                    "Cancel",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0C5D6B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  label: const Text(
                    "Create Employee Profile",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _officeField({required String label, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _dobController,
          readOnly: true,
          onTap: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: _dob ?? DateTime(now.year - 25),
              firstDate: DateTime(1950),
              lastDate: now,
            );
            if (picked == null) return;
            setState(() {
              _dob = picked;
              _dobController.text =
                  '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
            });
          },
          decoration: InputDecoration(
            hintText: _dob == null ? 'DD/MM/YYYY' : null,
            filled: true,
            fillColor: const Color(0xFFF3F3F3),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _checkRow(String label) {
    final checked = _checklist[label] ?? false;
    return InkWell(
      onTap: () {
        setState(() => _checklist[label] = !checked);
      },
      borderRadius: BorderRadius.circular(10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.black54,
              ),
            ),
          ),
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black26),
            ),
            child: checked
                ? const Icon(Icons.check, size: 14, color: Colors.black54)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _radioRow(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.black54,
              ),
            ),
          ),
          Icon(
            selected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            size: 18,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }
}
