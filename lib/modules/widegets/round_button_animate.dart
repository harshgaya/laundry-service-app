import 'package:flutter/material.dart';

class RoundButtonAnimate extends StatefulWidget {
  final String buttonName;
  final VoidCallback onClick;
  final Widget image;
  const RoundButtonAnimate(
      {super.key,
      required this.buttonName,
      required this.onClick,
      required this.image});

  @override
  State<RoundButtonAnimate> createState() => _RoundButtonAnimateState();
}

class _RoundButtonAnimateState extends State<RoundButtonAnimate>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 150.0, end: 180.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick,
      child: SizedBox(
        width: 180,
        height: 180,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Center(
              child: Container(
                width: _animation.value,
                height: _animation.value,
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          widget.image,
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.buttonName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
