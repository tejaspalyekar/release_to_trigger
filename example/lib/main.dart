import 'package:flutter/material.dart';
import 'package:release_to_trigger/release_to_trigger.dart';

void main() {
  runApp(const SecretVaultApp());
}

class SecretVaultApp extends StatelessWidget {
  const SecretVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SecretVaultScreen(),
    );
  }
}

class SecretVaultScreen extends StatefulWidget {
  const SecretVaultScreen({super.key});

  @override
  State<SecretVaultScreen> createState() => _SecretVaultScreenState();
}

class _SecretVaultScreenState extends State<SecretVaultScreen>
    with SingleTickerProviderStateMixin {
  bool _isVaultOpen = false;
  late AnimationController _vaultAnimationController;
  late Animation<double> _vaultScaleAnimation;
  late Animation<double> _vaultRotationAnimation;

  @override
  void initState() {
    super.initState();
    _vaultAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _vaultScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _vaultAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _vaultRotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _vaultAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _vaultAnimationController.dispose();
    super.dispose();
  }

  Widget _buildVaultContent() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade400,
                  Colors.deepPurple.shade800,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getVaultItemIcon(index),
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  _getVaultItemName(index),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getVaultItemIcon(int index) {
    switch (index) {
      case 0:
        return Icons.photo_library;
      case 1:
        return Icons.note_alt;
      case 2:
        return Icons.video_library;
      case 3:
        return Icons.attach_file;
      case 4:
        return Icons.folder_special;
      default:
        return Icons.security;
    }
  }

  String _getVaultItemName(int index) {
    switch (index) {
      case 0:
        return 'Private Photos';
      case 1:
        return 'Secret Notes';
      case 2:
        return 'Hidden Videos';
      case 3:
        return 'Secure Files';
      case 4:
        return 'Private Folders';
      default:
        return 'Security Settings';
    }
  }

  Widget _buildLockedState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _vaultAnimationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _vaultScaleAnimation.value,
                child: Transform.rotate(
                  angle: _vaultRotationAnimation.value,
                  child: Icon(
                    Icons.lock,
                    size: 120,
                    color: Colors.deepPurple.shade300,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Secret Vault',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple.shade200,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pull down to unlock',
            style: TextStyle(
              fontSize: 16,
              color: Colors.deepPurple.shade300,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secret Vault'),
        backgroundColor: _isVaultOpen ? Colors.deepPurple.shade900 : null,
        actions: [
          if (_isVaultOpen)
            IconButton(
              icon: const Icon(Icons.lock),
              onPressed: () {
                setState(() {
                  _isVaultOpen = false;
                });
              },
            ),
        ],
      ),
      body: ReleaseToTrigger(
        // Visual Customization

        backgroundColor: Colors.deepPurple.withAlpha(20),
        progressColor: Colors.deepPurple,
        initialText: 'Pull down to unlock vault',
        triggeredText: 'Release to access secret content',
        initialTextStyle: const TextStyle(
          fontSize: 16,
          color: Colors.white70,
          fontWeight: FontWeight.w500,
        ),
        triggerTextStyle: const TextStyle(
          fontSize: 16,
          color: Colors.deepPurple,
          fontWeight: FontWeight.bold,
        ),

        // Progress Indicator Customization
        progressIndicatorType: ProgressIndicatorType.rotatingIcon,
        progressIcon: Icons.lock_open,
        progressIconSize: 40.0,
        rotateProgress: true,
        maxRotationAngle: 2 * 3.14159, // Full rotation

        // Behavior Configuration
        triggerHeight: 200.0,
        pullSensitivityHeight: 250.0,
        top: true,
        showProgressIndicator: true,
        animationDuration: const Duration(milliseconds: 400),
        animationCurve: Curves.easeInOut,
        dragThreshold: 15.0,
        hapticFeedback: true,
        preventScrollingWhileDragging: true,
        enableHorizontalSwipe: true,
        swipeDirection: Axis.vertical,

        // Trigger Action
        onTrigger: () {
          setState(() {
            _isVaultOpen = !_isVaultOpen;
            if (_isVaultOpen) {
              _vaultAnimationController.forward();
            } else {
              _vaultAnimationController.reverse();
            }
          });
        },

        // Child Content
        child: _isVaultOpen ? _buildVaultContent() : _buildLockedState(),
      ),
    );
  }
}
