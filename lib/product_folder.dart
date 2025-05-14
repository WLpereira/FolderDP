import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductFolder extends StatelessWidget {
  const ProductFolder({super.key});

  // Lista de produtos com seus nomes, URLs e imagens
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
    // Obtém o tamanho da tela
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;
    final isTablet = screenSize.width >= 600 && screenSize.width < 1200;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[900]!, Colors.cyan[300]!],
            stops: const [0.0, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Partículas de fundo mais dinâmicas
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(
                  seconds: 60,
                ), // Aumentado para 60 segundos
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.blue[800]!.withOpacity(0.7),
                      Colors.transparent,
                    ],
                    radius: 0.6,
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(
                  seconds: 75,
                ), // Aumentado para 75 segundos
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.cyan[700]!.withOpacity(0.5),
                      Colors.transparent,
                    ],
                    radius: 0.8,
                    center: const Alignment(0.5, -0.5),
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),
            Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Calcula o número de colunas baseado na largura da tela
                  int crossAxisCount = 1;
                  if (constraints.maxWidth > 1200) {
                    crossAxisCount = 3;
                  } else if (constraints.maxWidth > 800) {
                    crossAxisCount = 2;
                  }

                  return GridView.builder(
                    padding: EdgeInsets.all(isMobile ? 10.0 : 20.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: isMobile ? 1.5 : 2.0,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        name: products[index]['name']!,
                        url: products[index]['url']!,
                        image: products[index]['image']!,
                        index: index,
                        isMobile: isMobile,
                        isTablet: isTablet,
                      );
                    },
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
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(
        milliseconds: 5000 + widget.index * 1500,
      ), // Aumentado para 5000ms
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutSine),
      ),
    );

    _controller.forward();
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
    final imageSize = widget.isMobile ? 60.0 : (widget.isTablet ? 80.0 : 100.0);
    final fontSize = widget.isMobile ? 18.0 : (widget.isTablet ? 20.0 : 24.0);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: MouseRegion(
          onEnter: (_) {
            setState(() => _isHovered = true);
            _controller.stop();
          },
          onExit: (_) {
            setState(() => _isHovered = false);
            _controller.repeat(reverse: true);
          },
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 2000,
            ), // Aumentado para 2000ms
            margin: EdgeInsets.symmetric(
              vertical: widget.isMobile ? 8.0 : 12.0,
              horizontal: widget.isMobile ? 4.0 : 8.0,
            ),
            padding: EdgeInsets.all(widget.isMobile ? 12.0 : 20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    _isHovered
                        ? [Colors.blue[700]!, Colors.blue[900]!]
                        : [
                          Colors.blue[800]!.withOpacity(0.8),
                          Colors.blue[900]!.withOpacity(0.8),
                        ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue[900]!.withOpacity(_glowAnimation.value),
                  blurRadius: 20,
                  spreadRadius: _isHovered ? 5 : 0,
                ),
              ],
            ),
            child: InkWell(
              onTap: () => _launchURL(widget.url),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      widget.image,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print(
                          'Erro ao carregar imagem ${widget.image}: $error',
                        );
                        print('Stack trace: $stackTrace');
                        return Container(
                          width: imageSize,
                          height: imageSize,
                          color: Colors.grey[300],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Erro ao carregar\n${widget.image}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: widget.isMobile ? 12.0 : 20.0),
                  Expanded(
                    child: Text(
                      widget.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(_isHovered ? 1.0 : 0.7),
                    size: widget.isMobile ? 16.0 : 24.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
