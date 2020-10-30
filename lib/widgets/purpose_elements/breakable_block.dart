import 'package:flutter/material.dart';
import 'package:purpose_blocs/widgets/purpose_elements/fusable_block_controller.dart';
import 'package:vibration/vibration.dart';

class BreakableBlock extends StatefulWidget {
  final double width;
  final double height;
  final EdgeInsets margins;
  final Color color;
  final FusableBlockController controller;
  final VoidCallback onComplete;

  BreakableBlock(
      {Key key,
      this.width,
      this.height,
      this.margins,
      this.color,
      this.controller,
      this.onComplete})
      : super(key: key);

  @override
  _BreakableBlockState createState() => _BreakableBlockState(controller);
}

class _BreakableBlockState extends State<BreakableBlock>
    with TickerProviderStateMixin {
  _BreakableBlockState(FusableBlockController _controller) {
    _controller.animationTrigger = triggerAnimation;
    _controller.resetTrigger = triggerReset;
  }

  AnimationController _opacityController;
  Animation _opacityAnimation;

  AnimationController _transformController;
  Animation _transformAnimation;
  bool fused = false;
  bool breakAnimationCompleted = false;

  bool animationStarted = false;
  bool allAnimationFinished = false;

  @override
  void initState() {
    _opacityController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _opacityAnimation = Tween(begin: 1.0, end: 0.0).animate(new CurvedAnimation(
        parent: _opacityController, curve: Curves.easeInSine));
    _opacityAnimation.addListener(_opacityListener);

    _transformController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _transformAnimation = Tween(begin: 0.0, end: 50.0).animate(
        new CurvedAnimation(
            parent: _opacityController, curve: Curves.easeOutCirc));
    _transformAnimation.addListener(_transformListener);

    super.initState();
  }

  void _opacityListener() {
    setState(() {
      if (_opacityAnimation.isCompleted) {
        allAnimationFinished = true;
        widget.onComplete();
      }
    });
  }

  void _transformListener() {
    setState(() {
      breakAnimationCompleted = _transformAnimation.isCompleted;
      if (breakAnimationCompleted) {
        _opacityController.forward();
      }
    });
  }

  void _resetAll() {
    _opacityController.reset();
    _transformController.reset();
    breakAnimationCompleted = false;
    animationStarted = false;
    allAnimationFinished = false;
  }

  void triggerAnimation() {
    //_transformController.forward();
    animationStarted = true;
    _opacityController.forward();
  }

  void triggerReset() {
    _resetAll();
  }

  @override
  Widget build(BuildContext context) {
    return animationStarted ? Container(
      margin: widget.margins,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.translate(
                  offset: Offset(
                    _transformAnimation.value > 0
                        ? _transformAnimation.value * -1
                        : 0,
                    _transformAnimation.value > 0
                        ? _transformAnimation.value * -1
                        : 0,
                  ),
                  child: Container(
                      width: widget.width / 2,
                      height: widget.height / 2,
                      color: widget.color
                  ),
                ),
              ),
              Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.translate(
                  offset: Offset(
                    _transformAnimation.value,
                    _transformAnimation.value > 0
                        ? _transformAnimation.value * -1
                        : 0,
                  ),
                  child: Container(
                      width: widget.width / 2,
                      height: widget.height / 2,
                      color: widget.color
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.translate(
                  offset: Offset(
                    _transformAnimation.value > 0
                        ? _transformAnimation.value * -1
                        : 0,
                    _transformAnimation.value,
                  ),
                  child: Container(
                      width: widget.width / 2,
                      height: widget.height / 2,
                      color: widget.color
                  ),
                ),
              ),
              Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.translate(
                  offset: Offset(
                    _transformAnimation.value,
                    _transformAnimation.value,
                  ),
                  child: Container(
                    width: widget.width / 2,
                    height: widget.height / 2,
                    color: widget.color,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ) : Container(
      margin: widget.margins,
      color: widget.color,
      width: widget.width,
      height: widget.height,
    );
  }

  @override
  void dispose() {
    if(!allAnimationFinished && animationStarted) widget.onComplete();
    _transformController.dispose();
    _opacityController.dispose();
    super.dispose();
  }
}
