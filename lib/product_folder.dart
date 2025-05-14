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
              child: Container(
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
              child: Container(
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

class _ProductCardState extends State<ProductCard> {
  bool _isHovered = false;

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

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 2000),
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
          border:
              _isHovered
                  ? Border.all(
                    color: Colors.cyan[300]!.withOpacity(0.8),
                    width: 2,
                  )
                  : null,
          boxShadow: [
            BoxShadow(
              color: Colors.blue[900]!.withOpacity(_isHovered ? 0.8 : 0.3),
              blurRadius: 20,
              spreadRadius: _isHovered ? 5 : 0,
            ),
            if (_isHovered)
              BoxShadow(
                color: Colors.cyan[300]!.withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            if (_isHovered)
              BoxShadow(
                color: Colors.blue[400]!.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 10,
              ),
          ],
        ),
        child: InkWell(
          onTap: () => _launchURL(widget.url),
          child: Stack(
            children: [
              if (_isHovered)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: RadialGradient(
                        colors: [
                          Colors.cyan[300]!.withOpacity(0.2),
                          Colors.transparent,
                        ],
                        radius: 0.8,
                        center: const Alignment(0.5, 0.5),
                      ),
                    ),
                  ),
                ),
              Row(
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
                        color: _isHovered ? Colors.cyan[100] : Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        shadows:
                            _isHovered
                                ? [
                                  Shadow(
                                    color: Colors.cyan[300]!.withOpacity(0.5),
                                    blurRadius: 10,
                                  ),
                                ]
                                : null,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color:
                        _isHovered
                            ? Colors.cyan[300]
                            : Colors.white.withOpacity(0.7),
                    size: widget.isMobile ? 16.0 : 24.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
