import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class FigureVideoPage extends StatefulWidget {
  final Map<String, dynamic> figureData;
  const FigureVideoPage({super.key, required this.figureData});

  @override
  State<FigureVideoPage> createState() => _FigureVideoPageState();
}

class _FigureVideoPageState extends State<FigureVideoPage> {
  late AudioPlayer _audioPlayer;
  int _remainingSeconds = 30;
  bool _isPlaying = false;

  String get _figureAvatar => widget.figureData['DovoUserIcon'] as String? ?? 'assets/app_default_headerIcon.webp';

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _startCall();
  }

  Future<void> _startCall() async {
    try {
      await _audioPlayer.play(AssetSource('dovo_call_video.mp3'));
      setState(() {
        _isPlaying = true;
      });
      _startCountdown();
    } catch (e) {
      debugPrint('Error playing audio: $e');
      // If audio fails, still start countdown
      _startCountdown();
    }
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _remainingSeconds--;
      });
      if (_remainingSeconds > 0) {
        _startCountdown();
      } else {
        _endCall();
      }
    });
  }

  Future<void> _endCall() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topSafe = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.all(8),
          child: IconButton(
            icon: Image.asset(
              'assets/base_back.webp',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
            onPressed: _endCall,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_figureAvatar),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              // Timer display
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  '${_remainingSeconds}s',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // End call button
              GestureDetector(
                onTap: _endCall,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
              SizedBox(height: topSafe + 40),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

