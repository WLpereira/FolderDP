import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

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
  double _currentPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _pageController.addListener(() {
      setState(() {
        _currentPageValue = _pageController.page ?? 0;
      });
    });

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

    // Paleta de cores Dataplace
    const azulPetroleo = Color(0xFF0097b2);
    const azulEscuro = Color(0xFF005e6e);
    const cianoClaro = Color(0xFF00c6e0);
    const branco = Color(0xFFFFFFFF);
    const laranja = Color(0xFFFF9800);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [azulPetroleo, azulEscuro, cianoClaro.withOpacity(0.7)],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: products.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final pageValue = index - _currentPageValue;
                        final rotation = pageValue * math.pi;
                        final scale =
                            1.0 - (pageValue.abs() * 0.1).clamp(0.0, 0.5);
                        final opacity = (1.0 - pageValue.abs()).clamp(0.0, 1.0);

                        return Transform(
                          transform:
                              Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(rotation)
                                ..scale(scale),
                          alignment: Alignment.center,
                          child: Opacity(
                            opacity: opacity,
                            child: Padding(
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
                                azulPetroleo: azulPetroleo,
                                azulEscuro: azulEscuro,
                                cianoClaro: cianoClaro,
                                branco: branco,
                                laranja: laranja,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Navegação inferior
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildNavigationButton(
                          icon: Icons.arrow_back_ios,
                          onTap: () {
                            if (_currentPage > 0) {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          color: laranja,
                          iconColor: branco,
                        ),
                        const SizedBox(width: 20),
                        _buildNavigationButton(
                          icon: Icons.arrow_forward_ios,
                          onTap: () {
                            if (_currentPage < products.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          color: laranja,
                          iconColor: branco,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Indicador de página
            Positioned(
              bottom: 80,
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
                              ? laranja
                              : branco.withOpacity(0.5),
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

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: 24),
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
  final Color azulPetroleo;
  final Color azulEscuro;
  final Color cianoClaro;
  final Color branco;
  final Color laranja;

  const ProductCard({
    super.key,
    required this.name,
    required this.url,
    required this.image,
    required this.index,
    required this.isMobile,
    required this.isTablet,
    required this.azulPetroleo,
    required this.azulEscuro,
    required this.cianoClaro,
    required this.branco,
    required this.laranja,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(
            vertical: widget.isMobile ? 10.0 : 14.0,
            horizontal: widget.isMobile ? 6.0 : 10.0,
          ),
          padding: EdgeInsets.all(widget.isMobile ? 14.0 : 22.0),
          decoration: BoxDecoration(
            color: widget.branco,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.azulEscuro.withOpacity(_isHovered ? 0.18 : 0.10),
                blurRadius: 15,
                spreadRadius: _isHovered ? 2 : 1,
              ),
            ],
            border: Border.all(
              color: widget.azulPetroleo.withOpacity(_isHovered ? 0.7 : 0.3),
              width: 2,
            ),
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
                        color: widget.cianoClaro.withOpacity(0.2),
                        child: const Icon(
                          Icons.error_outline,
                          color: Colors.grey,
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
                      color: widget.azulEscuro,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: widget.azulPetroleo,
                  size: widget.isMobile ? 18.0 : 24.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
