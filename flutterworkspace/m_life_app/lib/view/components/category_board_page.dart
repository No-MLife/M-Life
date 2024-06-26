import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/controller/post_controller.dart';
import 'package:m_life_app/util/post_category.dart';
import 'package:m_life_app/view/components/post_item.dart';
import 'package:m_life_app/view/pages/post/category_page.dart';
import '../../controller/dto/Res/PostResDto.dart';
import '../pages/post/detail_page.dart';
import 'ad_banner.dart';
import 'buildBottomNavigationBar.dart';
import 'buildFloatingActionButton.dart';
import 'category_emogi.dart';
import 'custom_header_navi.dart';

class CategoryBoardPage extends StatefulWidget {
  final Category category;

  CategoryBoardPage({required this.category});

  @override
  _CategoryBoardPageState createState() => _CategoryBoardPageState();
}

class _CategoryBoardPageState extends State<CategoryBoardPage> {
  final PostController _postController = Get.put(PostController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _postController.getPostsByCategory(widget.category.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final emoji = getCategoryEmoji(widget.category);

    return Scaffold(
      appBar: CustomAppBar(
        isHome: false,
        title: 'M-life',
        onBackPressed: () => Get.off(() => CategoryPage()),
      ),
      body: Obx(
        () {
          return RefreshIndicator(
            onRefresh: () async {
              await _postController.getPostsByCategory(widget.category.id);
            },
            child: _postController.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: (_postController
                                .categoryPosts[widget.category.id]?.length ??
                            0) +
                        3,
                    itemBuilder: (context, index) =>
                        _buildListItem(index, emoji),
                  ),
          );
        },
      ),
      floatingActionButton: buildFloatingActionButton(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget _buildListItem(int index, String emoji) {
    final posts = _postController.categoryPosts[widget.category.id] ?? [];

    if (index == 0) {
      return _buildAdBanner();
    } else if (index == 1) {
      return _buildCategoryTitle(emoji);
    } else if (index == 2) {
      return _buildDivider();
    }

    final reversedIndex = posts.length - 1 - (index - 3);
    if (reversedIndex < 0 || reversedIndex >= posts.length) {
      return Container(); // 유효하지 않은 인덱스일 경우 빈 컨테이너 반환
    }

    final post = posts[reversedIndex];

    return Column(
      children: [
        PostItem(
          post: post,
          onTap: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                    strokeWidth: 5.0,
                  ),
                );
              },
            );

            final result = await _postController.findByid(post.id!);
            Navigator.pop(context); // 로딩 Dialog 닫기

            if (result != null) {
              Get.to(() => DetailPage(category: widget.category, id: post.id));
            }
          },
          showCategory: false,
        ),
        if (index < posts.length + 2) _buildDivider(),
      ],
    );
  }

  Widget _buildAdBanner() {
    return Container(
      height: 0, // 광고로 바꿔야함
      margin: EdgeInsets.all(8.0), // 마진 조정
      decoration: BoxDecoration(
        color: Colors.amber[200],
        borderRadius: BorderRadius.circular(12.0), // Border radius 조정
      ),
      child: AdBanner(
        imagePaths: [
          'assets/ad1.png',
          'assets/ad2.png',
          'assets/ad3.png',
          'assets/ad4.png',
        ],
      ),
    );
  }

  Widget _buildCategoryTitle(String emoji) {
    return Container(
      padding: EdgeInsets.all(8.0), // 패딩 조정
      color: Colors.white,
      child: Text(
        '$emoji ${widget.category.name}',
        style: TextStyle(
          fontSize: 20, // 폰트 크기 조정
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Divider(
        color: Colors.grey[400],
        thickness: 1.0,
      ),
    );
  }
}
