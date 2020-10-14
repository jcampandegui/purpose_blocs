import 'package:flutter/material.dart';
import 'package:purpose_blocs/widgets/purpose_elements/fusable_block_controller.dart';
import 'package:vibration/vibration.dart';

class FusableBlock extends StatefulWidget {
  final double width;
  final double height;
  final EdgeInsets margins;
  final Color color;
  final FusableBlockController controller;
  final VoidCallback onComplete;

  FusableBlock({
    Key key,
    this.width,
    this.height,
    this.margins,
    this.color,
    this.controller,
    this.onComplete
  }) : super(key: key);

  @override
  _FusableBlockState createState() => _FusableBlockState(controller);
}

class _FusableBlockState extends State<FusableBlock> with TickerProviderStateMixin {
  _FusableBlockState(FusableBlockController _controller) {
    _controller.animationTrigger = triggerAnimation;
  }

  AnimationController _opacityController;
  Animation _opacityAnimation;
  //bool opacityAnimationCompleted = false;

  AnimationController _transformController;
  Animation _transformAnimation;
  bool fused = false;
  bool fuseAnimationCompleted = false;

  AnimationController _glowController;
  Tween _glowTween;
  Animation _glowAnimation;
  bool glowAnimationCompleted = false;
  String glowAnimationState = 'expand';

  @override
  void initState() {
    _opacityController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _opacityAnimation =  Tween(begin: 0.0,end: 1.0).animate(
        new CurvedAnimation(
            parent: _opacityController, curve: Curves.easeInSine));
    _opacityAnimation.addListener(_opacityListener);

    _transformController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _transformAnimation =  Tween(begin: 20.0,end: 0.0).animate(
        new CurvedAnimation(
            parent: _transformController, curve: Curves.elasticIn));
    _transformAnimation.addListener(_transformListener);

    _glowController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _glowTween = Tween(begin: 0.0,end: 20.0);
    _glowAnimation =  _glowTween.animate(
        new CurvedAnimation(
            parent: _glowController, curve: Curves.easeOutExpo));
    _glowAnimation.addListener(_glowListener);

    super.initState();
  }

  void _opacityListener() {
    setState(() {
      if(_opacityAnimation.isCompleted) {
        _transformController.forward();
      }
    });
  }

  void _transformListener() {
    setState(() {
      fuseAnimationCompleted = _transformAnimation.isCompleted;
      if(fuseAnimationCompleted) {
        Vibration.vibrate(duration: 200);
        _glowController.forward();
      }
    });
  }

  void _glowListener() {
    setState(() {
      glowAnimationCompleted = _glowAnimation.isCompleted;
      if(glowAnimationCompleted && glowAnimationState == 'expand') {
        _swapGlowTween(glowAnimationState);
        _glowController.forward();
      } else if(glowAnimationCompleted && glowAnimationState == 'retract') {
        _resetAll();
        widget.onComplete();
      }
    });
  }

  void _swapGlowTween(state) {
    double aux = _glowTween.end;
    _glowTween.end = _glowTween.begin;
    _glowTween.begin = aux;
    _glowController.reset();
    state == 'expand' ? glowAnimationState = 'retract' : glowAnimationState = 'expand';
  }

  void _resetAll() {
    _opacityController.reset();

    _transformController.reset();
    fused = false;
    fuseAnimationCompleted = false;

    _glowTween.begin = 0.0;
    _glowTween.end = 20.0;
    _glowController.reset();

    glowAnimationCompleted = false;
    glowAnimationState = 'expand';
  }

  void triggerAnimation() {
    _opacityController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return fuseAnimationCompleted ? Center(
        child: Container(
        width: widget.width,
        height: widget.height,
        margin: widget.margins,
        decoration: BoxDecoration(
            color: widget.color,
            boxShadow: [
              BoxShadow(
                  blurRadius: _glowAnimation.value < 10 ? _glowAnimation.value : 10,
                  spreadRadius: _glowAnimation.value < 10 ? _glowAnimation.value : 10,
                  color: Colors.white
              )
            ]
        ),
    ),
  ) : Container(
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
                  _transformAnimation.value > 0 ? _transformAnimation.value * -1 : 0,
                  _transformAnimation.value > 0 ? _transformAnimation.value * -1 : 0,
                ),
                child: Container(
                  width: widget.width/2,
                  height: widget.height/2,
                  decoration: BoxDecoration(
                      color: widget.color,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 2,
                            color: Colors.white
                        )
                      ]
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.translate(
                offset: Offset(
                  _transformAnimation.value,
                  _transformAnimation.value > 0 ? _transformAnimation.value * -1 : 0,
                ),
                child: Container(
                  width: widget.width/2,
                  height: widget.height/2,
                  decoration: BoxDecoration(
                      color: widget.color,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 2,
                            color: Colors.white
                        )
                      ]
                  ),
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
                  _transformAnimation.value > 0 ? _transformAnimation.value * -1 : 0,
                  _transformAnimation.value,
                ),
                child: Container(
                  width: widget.width/2,
                  height: widget.height/2,
                  decoration: BoxDecoration(
                      color: widget.color,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 2,
                            color: Colors.white
                        )
                      ]
                  ),
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
                  width: widget.width/2,
                  height: widget.height/2,
                  decoration: BoxDecoration(
                      color: widget.color,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 2,
                            color: Colors.white
                        )
                      ]
                  ),
                ),
              ),
            )
          ],
        )
      ],
    ),
  );
  }

  @override
  void dispose() {
    _transformController.dispose();
    _glowController.dispose();
    super.dispose();
  }
}