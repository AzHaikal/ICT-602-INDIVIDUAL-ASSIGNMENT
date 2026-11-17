import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'baggage_calculator.dart';

// --- STUDENT & PROJECT DETAILS ---
const String authorName = 'AZFAR HAIKAL BIN MOHD ARIZAL';
const String matricNumber = '2024252138';
const String courseName = 'ICT602';
const String githubUrl = 'https://github.com/AzHaikal/ICT-602-INDIVIDUAL-ASSIGNMENT';

void main() => runApp(const BaggageApp());

// -----------------------------------------------------------------------------
// 1. APPLICATION & THEME (Rubric 3: Customization - 6 Marks)
// -----------------------------------------------------------------------------
class BaggageApp extends StatelessWidget {
  const BaggageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkyBaggage Calculator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF008F83),
          primary: const Color(0xFF103B66),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7FB),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF103B66), foregroundColor: Colors.white, centerTitle: false, elevation: 2),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      home: const MainNavigationShell(),
    );
  }
}

// -----------------------------------------------------------------------------
// 2. NAVIGATION MENU (Dropdown: Home & About)
// -----------------------------------------------------------------------------
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [CalculatorPage(), AboutPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.flight_takeoff_rounded),
        title: const Text('SkyBaggage', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          // Dropdown Navigation Menu
          PopupMenuButton<int>(
            tooltip: 'Navigation Menu',
            initialValue: _currentIndex,
            onSelected: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context) => [
              _buildMenuItem(0, Icons.calculate, 'Home'),
              _buildMenuItem(1, Icons.info, 'About'),
            ],
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Icon(_currentIndex == 0 ? Icons.calculate : Icons.info, size: 18, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(_currentIndex == 0 ? 'Home' : 'About', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _pages[_currentIndex],
    );
  }

  PopupMenuItem<int> _buildMenuItem(int val, IconData icon, String text) {
    final active = _currentIndex == val;
    return PopupMenuItem(
      value: val,
      child: Row(
        children: [
          Icon(icon, color: active ? const Color(0xFF008F83) : const Color(0xFF103B66)),
          const SizedBox(width: 10),
          Text(text, style: TextStyle(fontWeight: active ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. HOME / CALCULATOR PAGE (Rubric 1, 2, 5: Inputs, Outputs, Good Design)
// -----------------------------------------------------------------------------
class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _rateController = TextEditingController();

  TicketClass _ticketClass = TicketClass.economy;
  BaggageResult? _result;

  @override
  void dispose() {
    _weightController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  // Good Design Practice: Input validation with error messages
  String? _validateInput(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return 'Please enter $fieldName.';
    final num = double.tryParse(value.trim());
    if (num == null) return 'Enter a valid number.';
    if (num < 0) return '$fieldName cannot be negative.';
    return null;
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _result = calculateBaggage(
        baggageWeightKg: double.parse(_weightController.text.trim()),
        ticketClass: _ticketClass,
        excessRatePerKgRm: double.parse(_rateController.text.trim()),
      );
    });
  }

  void _reset() {
    _formKey.currentState?.reset();
    _weightController.clear();
    _rateController.clear();
    FocusScope.of(context).unfocus();
    setState(() {
      _ticketClass = TicketClass.economy;
      _result = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 550),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Notice / Instructions (Rubric 5: Helpful Notice)
              Card(
                color: const Color(0xFFE3F2FD),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Color(0xFF103B66)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Allowance: Economy = 20kg, Business = 40kg.\nFixed service tax is 8%.',
                          style: TextStyle(fontSize: 12.5, color: Color(0xFF103B66), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Form Inputs (Rubric 1: 3 inputs with at least one other widget)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Input 1: Baggage Weight
                        const Text('1. Checked Baggage Weight (kg)', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(hintText: 'e.g. 25', prefixIcon: Icon(Icons.scale), suffixText: 'kg'),
                          validator: (val) => _validateInput(val, 'baggage weight'),
                        ),
                        const SizedBox(height: 14),

                        // Input 2: Ticket Class (SegmentedButton)
                        const Text('2. Ticket Class', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<TicketClass>(
                            segments: const [
                              ButtonSegment(value: TicketClass.economy, label: Text('Economy (20 kg)'), icon: Icon(Icons.airline_seat_recline_normal)),
                              ButtonSegment(value: TicketClass.business, label: Text('Business (40 kg)'), icon: Icon(Icons.airline_seat_recline_extra)),
                            ],
                            selected: {_ticketClass},
                            onSelectionChanged: (set) => setState(() => _ticketClass = set.first),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Input 3: Rate per kg
                        const Text('3. Excess Baggage Rate per kg (RM)', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _rateController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(hintText: 'e.g. 15', prefixIcon: Icon(Icons.payments_outlined), prefixText: 'RM '),
                          validator: (val) => _validateInput(val, 'excess baggage rate'),
                        ),
                        const SizedBox(height: 18),

                        // Calculate and Reset Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _calculate,
                                icon: const Icon(Icons.calculate),
                                label: const Text('Calculate'),
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF103B66), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton.icon(
                              onPressed: _reset,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Reset'),
                              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Output Card (Rubric 2: 3 outputs appropriately formatted)
              if (_result != null)
                Card(
                  elevation: 2,
                  color: const Color(0xFFF1F8F6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Calculation Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF103B66))),
                        const Divider(height: 20),
                        _buildOutputRow('1. Excess Baggage Weight:', '${_result!.excessWeightKg.toStringAsFixed(2)} kg'),
                        _buildOutputRow('2. Excess Baggage Charge:', 'RM ${_result!.excessChargeRm.toStringAsFixed(2)}'),
                        _buildOutputRow('Service Tax (8%):', 'RM ${_result!.serviceTaxRm.toStringAsFixed(2)}'),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('3. Total Amount Payable:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text('RM ${_result!.totalPayableRm.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF008F83))),
                          ],
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

  Widget _buildOutputRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black87)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 4. ABOUT PAGE (Rubric 4: Icon, Author Info, Clickable URL, Copyright - 6 Marks)
// -----------------------------------------------------------------------------
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchGitHub(BuildContext context) async {
    final uri = Uri.parse(githubUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open GitHub URL')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            children: [
              // 1. Application Icon
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/app_icon.png', width: 85, height: 85, fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
              const Text('SkyBaggage', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF103B66))),
              const Text('Excess Baggage Fee Estimator', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 18),

              // 2. Author Details Card
              Card(
                elevation: 1.5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    children: [
                      ListTile(dense: true, leading: Icon(Icons.person, color: Color(0xFF008F83)), title: Text('Name'), subtitle: Text(authorName, style: TextStyle(fontWeight: FontWeight.w600))),
                      Divider(height: 1),
                      ListTile(dense: true, leading: Icon(Icons.badge, color: Color(0xFF008F83)), title: Text('Matric Number'), subtitle: Text(matricNumber, style: TextStyle(fontWeight: FontWeight.w600))),
                      Divider(height: 1),
                      ListTile(dense: true, leading: Icon(Icons.school, color: Color(0xFF008F83)), title: Text('Course'), subtitle: Text(courseName, style: TextStyle(fontWeight: FontWeight.w600))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // 3. Clickable GitHub URL
              Card(
                elevation: 1.5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _launchGitHub(context),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.link, color: Colors.blue, size: 18),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            githubUrl,
                            style: TextStyle(color: Colors.blue, fontSize: 12.5, decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // 4. Copyright Notice
              const Text(
                'Copyright © 2026 AZFAR HAIKAL BIN MOHD ARIZAL\nAll rights reserved • ICT602 Mobile Technology',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black45, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
