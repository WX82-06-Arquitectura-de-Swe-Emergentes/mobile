

import 'package:flutter/material.dart';

class ImageSliderWidget extends StatelessWidget {
  ImageSliderWidget({
    super.key,
    required this.images,
  });

  final List<String> images;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {


    return Container(
            height: 300.0,
            child: Stack(
              children: [
                Positioned(
                  top: 0.0,
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      if (details.delta.dx > 0) {
                        _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      } else if (details.delta.dx < 0) {
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      }
                    },
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Scaffold(
                                  appBar: AppBar(
                                    backgroundColor: Colors.black,
                                  ),
                                  body: Center(
                                    child: Image.network(
                                      images[index],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Image.network(
                            images[index],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );

  }
}