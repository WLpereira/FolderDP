import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class ProductFolder extends StatefulWidget {
  const ProductFolder({super.key});

  @override
  State<ProductFolder> createState() => _ProductFolderState();
}

class _ProductFolderState extends State<ProductFolder>
    with SingleTickerProviderStateMixin {
  late AnimationController _carouselController;
  late Animation<double> _carouselAnimation;
  bool _isAutoPlaying = true;
  double _currentOffset = 0;
  double _dragDelta = 0;

  @override
  void initState() {
    super.initState();
    _carouselController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );

    _carouselAnimation = Tween<double>(begin: 0.0, end: -1.0).animate(
      CurvedAnimation(parent: _carouselController, curve: Curves.linear),
    );

    _carouselController.repeat();
  }

  void _toggleAutoPlay() {
    setState(() {
      _isAutoPlaying = !_isAutoPlaying;
      if (_isAutoPlaying) {
        _carouselController.repeat();
      } else {
        _carouselController.stop();
      }
    });
  }

  void _updateOffset(double delta) {
    setState(() {
      _currentOffset += delta;
      if (_currentOffset > 0) _currentOffset = 0;
      final maxOffset =
          -(MediaQuery.of(context).size.height * (products.length - 1) / 2);
      if (_currentOffset < maxOffset) _currentOffset = maxOffset;
    });
  }

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> products = const [
    {
      'name': 'Dataplace ERP',
      'url': 'https://www.dataplace.com.br/dataplace-erp/',
      'image': 'assets/images/dataplace_erp.png',
    },
    {
      'name': 'Dataplace SFA',
      'url': 'https://www.dataplace.com.br/sales-force-automation/',
      'image': 'assets/images/dataplace_sfa.png',
    },
    {
      'name': 'Dataplace Delivery Control',
      'url': 'https://www.dataplace.com.br/delivery-control/',
      'image': 'assets/images/dataplace_delivery_control.png',
    },
    {
      'name': 'Dataplace RH',
      'url': 'https://www.dataplace.com.br/dataplace-rh-gestao-completa/',
      'image': 'assets/images/dataplace_rh.png',
    },
    {
      'name': 'Dataplace BI',
      'url': 'https://www.dataplace.com.br/gestao-assertiva-e-integrada/',
      'image': 'assets/images/dataplace_bi.png',
    },
    {
      'name': 'Dataplace B2B',
      'url':
          'https://dataplace.help/webhelp/erp/dataplace-sfa/dataplace-b2b-portal/?hilite=b2b',
      'image': 'assets/images/dataplace_b2b.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[900]!.withOpacity(0.9),
              const Color.fromARGB(255, 61, 172, 251)!.withOpacity(0.7),
              const Color.fromARGB(255, 10, 1, 53).withOpacity(0.8),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(seconds: 10),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.cyan[400]!.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    radius: 0.7,
                    center: const Alignment(-0.4, -0.4),
                  ),
                ),
              ),
            ),
            Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Listener(
                    onPointerSignal: (pointerSignal) {
                      if (pointerSignal is PointerScrollEvent) {
                        _updateOffset(
                          pointerSignal.scrollDelta.dy / constraints.maxHeight,
                        );
                      }
                    },
                    child: GestureDetector(
                      onPanStart: (details) {
                        _carouselController.stop();
                        _dragDelta = 0;
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          _dragDelta = details.delta.dy / constraints.maxHeight;
                          _updateOffset(_dragDelta);
                        });
                      },
                      onPanEnd: (details) {
                        if (_isAutoPlaying) {
                          _carouselController.repeat();
                        }
                      },
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        child: SizedBox(
                          height: constraints.maxHeight * products.length / 2,
                          child: AnimatedBuilder(
                            animation:
                                _isAutoPlaying
                                    ? _carouselAnimation
                                    : _carouselController,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                  0,
                                  _isAutoPlaying
                                      ? _carouselAnimation.value *
                                          constraints.maxHeight
                                      : _currentOffset * constraints.maxHeight,
                                ),
                                child: Column(
                                  children:
                                      products
                                          .asMap()
                                          .entries
                                          .map(
                                            (entry) => SizedBox(
                                              height:
                                                  constraints.maxHeight * 0.4,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12.0,
                                                      horizontal: 16.0,
                                                    ),
                                                child: ProductCard(
                                                  name: entry.value['name']!,
                                                  url: entry.value['url']!,
                                                  image: entry.value['image']!,
                                                  index: entry.key,
                                                  isMobile: isMobile,
                                                  isTablet: !isMobile,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final String name;
  final String url;
  final String image;
  final int index;
  final bool isMobile;
  final bool isTablet;

  const ProductCard({
    super.key,
    required this.name,
    required this.url,
    required this.image,
    required this.index,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _glowAnimation = Tween<double>(begin: 0.2, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Não foi possível abrir $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = widget.isMobile ? 70.0 : (widget.isTablet ? 90.0 : 110.0);
    final fontSize = widget.isMobile ? 20.0 : (widget.isTablet ? 22.0 : 26.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(
          vertical: widget.isMobile ? 10.0 : 14.0,
          horizontal: widget.isMobile ? 6.0 : 10.0,
        ),
        padding: EdgeInsets.all(widget.isMobile ? 14.0 : 22.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                _isHovered
                    ? [
                      const Color.fromARGB(255, 10, 165, 254)!.withOpacity(0.9),
                      Colors.blue[900]!.withOpacity(0.9),
                    ]
                    : [
                      Colors.blue[800]!.withOpacity(0.85),
                      Colors.blue[900]!.withOpacity(0.85),
                    ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.cyan[300]!.withOpacity(_isHovered ? 0.8 : 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.cyan[400]!.withOpacity(_glowAnimation.value),
              blurRadius: 15,
              spreadRadius: _isHovered ? 3 : 1,
            ),
          ],
        ),
        child: InkWell(
          onTap: () => _launchURL(widget.url),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.image,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('Erro ao carregar imagem ${widget.image}: $error');
                    return Container(
                      width: imageSize,
                      height: imageSize,
                      color: const Color.fromARGB(255, 0, 9, 88),
                      child: const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 32,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: widget.isMobile ? 14.0 : 22.0),
              Expanded(
                child: Text(
                  widget.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        color: Colors.cyan[200]!.withOpacity(0.5),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.cyan[200]!.withOpacity(_isHovered ? 1.0 : 0.7),
                size: widget.isMobile ? 18.0 : 26.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
