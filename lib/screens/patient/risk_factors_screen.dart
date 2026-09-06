import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../localization/translator.dart';
import '../../data/hospitals.dart';
import '../../services/app_data.dart';
import 'screening_request_screen.dart';

class RiskFactorsScreen extends StatefulWidget {
  const RiskFactorsScreen({super.key});

  @override
  State<RiskFactorsScreen> createState() => _RiskFactorsScreenState();
}

class _RiskFactorsScreenState extends State<RiskFactorsScreen> {
  // true = facteur présent, false = facteur absent, null = pas encore répondu
  late List<bool?> _answers;

  @override
  void initState() {
    super.initState();
    _answers = List<bool?>.filled(riskFactorsList.length, null);
  }

  double? get _ratio {
    if (_answers.any((a) => a == null)) return null;
    final positives = _answers.where((a) => a == true).length;
    return positives / riskFactorsList.length;
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<AppData>().localeCode;
    final ratio = _ratio;

    return Scaffold(
      appBar: AppBar(title: Text(context.t('module_risk_factors'))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(context.t('risk_factors_instruction'), style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: riskFactorsList.length,
              itemBuilder: (context, index) {
                final label = riskFactorsList[index][locale] ?? riskFactorsList[index]['fr']!;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(label),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ChoiceChip(
                              label: const Text('Oui'),
                              selected: _answers[index] == true,
                              onSelected: (_) => setState(() => _answers[index] = true),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('Non'),
                              selected: _answers[index] == false,
                              onSelected: (_) => setState(() => _answers[index] = false),
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
          if (ratio != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${context.t('risk_ratio_result')} : ${(ratio * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ratio >= 0.3 ? context.t('risk_ratio_advice_high') : context.t('risk_ratio_advice_low'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ScreeningRequestScreen()),
                    ),
                    child: Text(context.t('request_screening_now')),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
