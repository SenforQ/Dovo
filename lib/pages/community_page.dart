import 'package:flutter/material.dart';
import 'ai_gift_result_page.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final Set<String> _selectedOccasions = <String>{};
  String? _selectedRelationship;
  double _budgetValue = 200.0;
  final TextEditingController _detailsController = TextEditingController(
    text: '',
  );

  @override
  void initState() {
    super.initState();
    _selectedRelationship = 'Companion';
    _selectedOccasions.add('Birthday');
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _toggleOccasion(String occasion) {
    setState(() {
      if (_selectedOccasions.contains(occasion)) {
        _selectedOccasions.remove(occasion);
      } else {
        if (_selectedOccasions.length < 2) {
          _selectedOccasions.add(occasion);
        }
      }
    });
  }

  void _onSubmit() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AiGiftResultPage(
          occasions: _selectedOccasions,
          relationship: _selectedRelationship,
          budget: _budgetValue,
          details: _detailsController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topSafe = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/base_bg.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: topSafe),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top background image at y=0
                    Image.asset(
                      'assets/community_top_bg.webp',
                      width: size.width,
                      height: 272,
                      fit: BoxFit.cover,
                    ),
                    // Occasion section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          Image.asset(
                            'assets/community_occasion.webp',
                            width: 114,
                            height: 35,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _OccasionButton(
                                label: 'Birthday',
                                isSelected: _selectedOccasions.contains('Birthday'),
                                onTap: () => _toggleOccasion('Birthday'),
                                enabled: _selectedOccasions.contains('Birthday') || _selectedOccasions.length < 2,
                              ),
                              _OccasionButton(
                                label: 'Anniversary',
                                isSelected: _selectedOccasions.contains('Anniversary'),
                                onTap: () => _toggleOccasion('Anniversary'),
                                enabled: _selectedOccasions.contains('Anniversary') || _selectedOccasions.length < 2,
                              ),
                              _OccasionButton(
                                label: 'Holiday',
                                isSelected: _selectedOccasions.contains('Holiday'),
                                onTap: () => _toggleOccasion('Holiday'),
                                enabled: _selectedOccasions.contains('Holiday') || _selectedOccasions.length < 2,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Relationship section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),
                          Image.asset(
                            'assets/community_relationship.webp',
                            width: 160,
                            height: 31,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _RelationshipButton(
                                label: 'Companion',
                                isSelected: _selectedRelationship == 'Companion',
                                onTap: () => setState(() => _selectedRelationship = 'Companion'),
                              ),
                              _RelationshipButton(
                                label: 'Family',
                                isSelected: _selectedRelationship == 'Family',
                                onTap: () => setState(() => _selectedRelationship = 'Family'),
                              ),
                              _RelationshipButton(
                                label: 'Friend',
                                isSelected: _selectedRelationship == 'Friend',
                                onTap: () => setState(() => _selectedRelationship = 'Friend'),
                              ),
                              _RelationshipButton(
                                label: 'Colleague',
                                isSelected: _selectedRelationship == 'Colleague',
                                onTap: () => setState(() => _selectedRelationship = 'Colleague'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Budget section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),
                          Image.asset(
                            'assets/community_budget.webp',
                            width: 93,
                            height: 31,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: const Color(0xFF8B5CF6),
                                  inactiveTrackColor: const Color(0xFFE8F4FD),
                                  thumbColor: Colors.white,
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                                  trackHeight: 4,
                                ),
                                child: Slider(
                                  value: _budgetValue,
                                  min: 0,
                                  max: 5000,
                                  divisions: 100,
                                  label: '\$${_budgetValue.toInt()}',
                                  onChanged: (value) {
                                    setState(() {
                                      _budgetValue = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${_budgetValue.toInt()}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // More Details section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),
                          Image.asset(
                            'assets/community_details.webp',
                            width: 167,
                            height: 31,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(minHeight: 120),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              controller: _detailsController,
                              maxLines: null,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'She likes to make pastries and recently wants to buy a new oven...',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Submit button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _onSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5CF6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 38),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OccasionButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool enabled;

  const _OccasionButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF8B5CF6) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.black : Colors.grey[400],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _RelationshipButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RelationshipButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF8B5CF6) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.black : Colors.grey[400],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
