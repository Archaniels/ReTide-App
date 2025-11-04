import 'package:flutter/material.dart';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  String? selectedDonationType;
  String? selectedAmount;
  String? selectedFrequency = 'Monthly';

  final customAmountController = TextEditingController();
  final FocusNode customAmountFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    customAmountFocus.addListener(() {
      if (customAmountFocus.hasFocus) {
        setState(() {
          selectedAmount = null;
        });
      }
    });
  }

  @override
  void dispose() {
    customAmountFocus.dispose();
    customAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: const Text('Donation', style: TextStyle(color: Colors.white)),
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Text(
                'ReTide',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('assets/images/donationbg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.6)),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  const Text(
                    'We Can Save\nThe Future.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Choose a donation type',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 10),

                        DropdownButtonFormField<String>(
                          value: selectedDonationType,
                          dropdownColor: const Color(
                            0xFF1A1A1A,
                          ), // warna background dropdown list
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white70,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Select donation type',
                            labelStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor:
                                Colors.black54, // sama seperti custom amount
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),

                            // Border normal
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.white30,
                                width: 1,
                              ),
                            ),

                            // Border saat fokus (tidak biru)
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.white70,
                                width: 1.2,
                              ),
                            ),

                            // Border default
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.white24,
                                width: 1,
                              ),
                            ),
                          ),

                          items:
                              [
                                'Cost of education',
                                'Environmental protection',
                                'Ocean cleanup',
                              ].map((String label) {
                                return DropdownMenuItem<String>(
                                  value: label,
                                  child: Text(
                                    label,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              }).toList(),

                          onChanged: (String? value) {
                            setState(() {
                              selectedDonationType = value;
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Choose a donation amount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Wrap(
                          spacing: 12,
                          runSpacing: 10,
                          children: ['Rp25.000', 'Rp50.000', 'Rp100.000'].map((
                            String amount,
                          ) {
                            return ChoiceChip(
                              label: Text(
                                amount,
                                style: TextStyle(
                                  color: selectedAmount == amount
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              selected: selectedAmount == amount,
                              onSelected: (bool selected) {
                                setState(() {
                                  selectedAmount = selected ? amount : null;
                                  customAmountController.clear();
                                  customAmountFocus.unfocus();
                                });
                              },
                              backgroundColor: Colors.black45,
                              selectedColor: Colors.tealAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: const BorderSide(color: Colors.white24),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 16),

                        TextField(
                          controller: customAmountController,
                          focusNode: customAmountFocus,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Enter a custom amount',
                            labelStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.black38,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.white30,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.tealAccent,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 26),

                        const Text(
                          'Choose a donation frequency',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 14),

                        Row(
                          children: [
                            _buildRadioOption('Monthly'),
                            const SizedBox(width: 14),
                            _buildRadioOption('One time'),
                          ],
                        ),

                        const SizedBox(height: 30),

                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  side: const BorderSide(color: Colors.white70),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.tealAccent,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'Checkout',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String label) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedFrequency = label;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selectedFrequency == label
                  ? Colors.tealAccent
                  : Colors.white30,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selectedFrequency == label
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: selectedFrequency == label
                    ? Colors.tealAccent
                    : Colors.white60,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
