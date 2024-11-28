import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import '../models/product.dart';
import '../providers/cart.dart';
import '../utils/utils.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool _isHovered = false;
  bool _isClicked = false;
  late final Cart cart;

  @override
  void initState() {
    super.initState();
    cart = Provider.of<Cart>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.product.stok! > 0
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AbsorbPointer(
        absorbing: widget.product.stok! > 0 ? false : true,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isClicked = true),
          onTapUp: (_) => setState(() => _isClicked = false),
          onTapCancel: () => setState(() => _isClicked = false),
          onTap: () {
            cart.addCart(
              widget.product.id!,
              widget.product.name!,
              widget.product.price!.toDouble(),
              widget.product.stok!,
              widget.product.photo!,
            );
          },
          child: Stack(
            children: [
              AnimatedContainer(
                margin: const EdgeInsets.all(16),
                duration: const Duration(milliseconds: 200),
                foregroundDecoration: BoxDecoration(
                  color: widget.product.stok! > 0
                      ? _isClicked
                          ? secondaryColor
                          : (_isHovered ? hoverColor : Colors.transparent)
                      : const Color.fromARGB(146, 189, 189, 189),
                  borderRadius: BorderRadius.circular(8),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      spreadRadius: 7,
                      blurRadius: 11,
                      offset: const Offset(
                        -7,
                        7,
                      ),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 6,
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              "$apiImageProducts/${widget.product.photo}",
                            ),
                          ),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 7,
                                    child: Text(
                                      "${widget.product.name}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: titleSmall.copyWith(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: Text(
                                      "${widget.product.category}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: labelLargeMed.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: const Color.fromRGBO(
                                            102, 112, 133, 1.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Text(
                                "Rp. ${Utils.priceFormatter(widget.product.price)}",
                                style: labelLargeMed.copyWith(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              if (widget.product.stok! < 1)
                Center(
                  child: Text(
                    "Stok Habis.",
                    style: labelLargeMed.copyWith(
                      color: errorColor,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
