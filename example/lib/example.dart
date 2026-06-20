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
      home: const MainTabContainer(),
    );
  }
}

class MainTabContainer extends StatefulWidget {
  const MainTabContainer({super.key});

  @override
  State<MainTabContainer> createState() => _MainTabContainerState();
}

class _MainTabContainerState extends State<MainTabContainer> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const SecretVaultScreen(),
    const MultiStageScreen(),
    const LongPressLockScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.security),
            label: 'Secret Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.layers),
            label: 'Multi-Stage',
          ),
          NavigationDestination(
            icon: Icon(Icons.touch_app),
            label: 'Long-Press hold',
          ),
        ],
      ),
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
  bool _useHorizontalMode = false;
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
            _useHorizontalMode ? 'Swipe right to unlock' : 'Pull down to unlock',
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
          if (!_isVaultOpen)
            IconButton(
              icon: Icon(_useHorizontalMode ? Icons.swap_vert : Icons.swap_horiz),
              tooltip: _useHorizontalMode
                  ? 'Switch to Vertical Mode'
                  : 'Switch to Horizontal Mode',
              onPressed: () {
                setState(() {
                  _useHorizontalMode = !_useHorizontalMode;
                });
              },
            ),
          if (_isVaultOpen)
            IconButton(
              icon: const Icon(Icons.lock),
              onPressed: () {
                setState(() {
                  _isVaultOpen = false;
                  _vaultAnimationController.reverse();
                });
              },
            ),
        ],
      ),
      body: ReleaseToTrigger(
        backgroundColor: Colors.deepPurple.withAlpha(20),
        progressColor: Colors.deepPurple,
        initialText: _useHorizontalMode
            ? 'Swipe right to unlock vault'
            : 'Pull down to unlock vault',
        triggeredText: _useHorizontalMode
            ? 'Release to access secret content'
            : 'Release to access secret content',
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
        progressIndicatorType: ProgressIndicatorType.rotatingIcon,
        progressIcon: Icons.lock_open,
        progressIconSize: 40.0,
        rotateProgress: true,
        maxRotationAngle: 2 * 3.14159,
        triggerHeight: 200.0,
        pullSensitivityHeight: 250.0,
        top: !_useHorizontalMode,
        left: _useHorizontalMode,
        showProgressIndicator: true,
        animationDuration: const Duration(milliseconds: 400),
        animationCurve: Curves.easeInOut,
        dragThreshold: 15.0,
        hapticFeedback: true,
        preventScrollingWhileDragging: true,
        enableHorizontalSwipe: _useHorizontalMode,
        swipeDirection: _useHorizontalMode ? Axis.horizontal : Axis.vertical,
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
        child: _isVaultOpen ? _buildVaultContent() : _buildLockedState(),
      ),
    );
  }
}

class MultiStageScreen extends StatefulWidget {
  const MultiStageScreen({super.key});

  @override
  State<MultiStageScreen> createState() => _MultiStageScreenState();
}

class _MultiStageScreenState extends State<MultiStageScreen> {
  double _progressTickValue = 0.0;
  bool _easterEggUnlocked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-Stage overpull'),
        actions: [
          if (_easterEggUnlocked)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => setState(() => _easterEggUnlocked = false),
            )
        ],
      ),
      body: ReleaseToTrigger(
        backgroundColor: Colors.blue.withAlpha(20),
        progressColor: Colors.blue,
        initialText: 'Pull down to explore stages',
        triggeredText: 'Release to unlock base level',
        triggerHeight: 180.0,
        progressBackgroundColor: Colors.blue.shade100,
        progressStrokeWidth: 8.0,
        spacing: 16.0,
        onProgressTick: (progress) {
          setState(() {
            _progressTickValue = progress;
          });
        },
        stages: [
          TriggerStage(
            threshold: 0.5,
            label: 'Stage 1: Halfway there...',
            textStyle: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            onStageReached: () {
              debugPrint('Stage 0.5 reached!');
            },
          ),
          TriggerStage(
            threshold: 1.0,
            label: 'Stage 2: Release to Unlock!',
            textStyle: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            onStageReached: () {
              debugPrint('Stage 1.0 reached!');
            },
          ),
          TriggerStage(
            threshold: 1.5,
            label: '💥 Stage 3 (OVERPULL): Easter Egg Stage!',
            textStyle: const TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
            onStageReached: () {
              debugPrint('Stage 1.5 reached! Easter Egg ready.');
            },
          ),
        ],
        onTrigger: () {
          setState(() {
            if (_progressTickValue >= 1.49) {
              _easterEggUnlocked = true;
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _easterEggUnlocked ? Icons.star : Icons.looks_one,
                  size: 100,
                  color: _easterEggUnlocked ? Colors.amber : Colors.blue.shade300,
                ),
                const SizedBox(height: 24),
                Text(
                  _easterEggUnlocked ? 'Easter Egg Activated!' : 'Multi-Stage Area',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  _easterEggUnlocked
                      ? 'Congratulations! You triggered the 1.5x overpull stage.'
                      : 'Pull down past 1.0 to find the secret overpull stage (1.5x).',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),
                LinearProgressIndicator(
                  value: _progressTickValue / 1.5,
                  backgroundColor: Colors.blue.withAlpha(30),
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                Text('Normalized Pull Progress: ${(_progressTickValue * 100).toInt()}%'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LongPressLockScreen extends StatefulWidget {
  const LongPressLockScreen({super.key});

  @override
  State<LongPressLockScreen> createState() => _LongPressLockScreenState();
}

class _LongPressLockScreenState extends State<LongPressLockScreen> {
  bool _unlocked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Long-Press Lock'),
        actions: [
          if (_unlocked)
            IconButton(
              icon: const Icon(Icons.lock),
              onPressed: () => setState(() => _unlocked = false),
            )
        ],
      ),
      body: ReleaseToTrigger(
        backgroundColor: Colors.teal.withAlpha(20),
        progressColor: Colors.teal,
        initialText: 'Hold for 0.8s, then pull',
        triggeredText: 'Release to open screen',
        triggerHeight: 200.0,
        requireLongPressBeforePull: true,
        longPressDuration: const Duration(milliseconds: 800),
        onTrigger: () {
          setState(() {
            _unlocked = true;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _unlocked ? Icons.lock_open : Icons.admin_panel_settings,
                  size: 100,
                  color: _unlocked ? Colors.green : Colors.teal.shade300,
                ),
                const SizedBox(height: 24),
                Text(
                  _unlocked ? 'Admin Panel Unlocked' : 'Protected Area',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  _unlocked
                      ? 'You successfully performed the secure hold-then-swipe gesture.'
                      : 'Requires an initial 0.8s stationary hold before swipe is activated.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
