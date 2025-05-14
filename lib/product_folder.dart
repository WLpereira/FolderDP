import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductFolder extends StatefulWidget {
  const ProductFolder({super.key});

  @override
  State<ProductFolder> createState() => _ProductFolderState();
}

class _ProductFolderState extends State<ProductFolder>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  bool _isAutoPlaying = true;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    // Autoplay
    if (_isAutoPlaying) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_isAutoPlaying && mounted) {
        if (_currentPage < products.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        _startAutoPlay();
      }
    });
  }

  void _toggleAutoPlay() {
    setState(() {
      _isAutoPlaying = !_isAutoPlaying;
      if (_isAutoPlaying) {
        _startAutoPlay();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
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
              Colors.cyan[800]!.withOpacity(0.7),
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Efeito de partículas futuristas
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
              child: PageView.builder(
                controller: _pageController,
                itemCount: products.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    child: ProductCard(
                      name: products[index]['name']!,
                      url: products[index]['url']!,
                      image: products[index]['image']!,
                      index: index,
                      isMobile: isMobile,
                      isTablet: !isMobile,
                    ),
                  );
                },
              ),
            ),
            // Indicador de página
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  products.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: _currentPage == index ? 12.0 : 8.0,
                    height: _currentPage == index ? 12.0 : 8.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _currentPage == index
                              ? Colors.cyan[300]
                              : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
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
          color: Colors.white.withOpacity(0.1),
          gradient: LinearGradient(
            colors:
                _isHovered
                    ? [
                      Colors.cyan[600]!.withOpacity(0.9),
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
            // Sombra para efeito de página
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(5, 5),
              blurRadius: 10,
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
                      color: Colors.grey[800],
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
