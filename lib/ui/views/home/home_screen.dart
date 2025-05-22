import 'package:ajoufinder/ui/shared/widgets/filter_menu_overlay.dart';
import 'package:ajoufinder/ui/shared/widgets/board_list_widget.dart';
import 'package:ajoufinder/ui/shared/widgets/search_bar_widget.dart';
import 'package:ajoufinder/ui/viewmodels/board_view_model.dart';
import 'package:ajoufinder/ui/views/notifications/notifications_tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final String lostCategory;
  const HomeScreen({super.key, required this.lostCategory});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearchBarWidgetActivated = false;
  final _searchControllerInHome = TextEditingController();
  final _searchFocusNodeInHome = FocusNode();

  @override
  void dispose() {
    _searchControllerInHome.dispose();
    _searchFocusNodeInHome.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final boardViewModel = Provider.of<BoardViewModel>(context, listen: false);
    boardViewModel.fetchBoards(category: widget.lostCategory);
  }

  void _toggleSearchBarWidgetActivated() {
    setState(() {
      _isSearchBarWidgetActivated = !_isSearchBarWidgetActivated;
      
      if (_isSearchBarWidgetActivated) {
        Future.delayed(const Duration(microseconds: 75), () {
          FocusScope.of(context).requestFocus(_searchFocusNodeInHome);
          });
      }else {
        _searchFocusNodeInHome.unfocus();
        _searchControllerInHome.clear();
      }
    });
  }

  void _performHomeSearch(String query) {
    print('HomeScreen 검색 실행: $query');
    // TODO: HomeScreen에 맞는 검색 로직 구현 (예: PostListWidget에 query 전달하여 필터링)
    // 검색 후 검색 바를 닫을 수도 있음:
    // _toggleSearchInHome();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final boardViewModel = Provider.of<BoardViewModel>(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: SearchBarWidget(
          controller: _searchControllerInHome, 
          hintText: '게시글 검색...', 
          onSubmitted: _performHomeSearch,
          focusNode: _searchFocusNodeInHome,
          onClear: () {
            // 검색어 클리어 시의 추가 동작 구현할 것.
          },), 
        actions: _isSearchBarWidgetActivated
        ? ([
          IconButton(
            icon: Icon(Icons.close, color: theme.colorScheme.primary),
            onPressed: _toggleSearchBarWidgetActivated,
            ),
          ])
        : [
          IconButton(
            icon: Icon(Icons.filter_list, color: theme.colorScheme.primary,),
            onPressed: () async {
              showDialog(
                context: context, 
                barrierDismissible: true,
                barrierColor: Colors.black.withValues(alpha: 0.5),
                builder: (context) => FilterMenuOverlay(
                  onApply: (a, b, c) {},
                  onCancel: () {},
                ),
              );
            },
            tooltip: '필터',
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: theme.colorScheme.primary),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 400),
                      child: NotificationsTabScreen()
                    ),
                  ),),
              );
            },
            tooltip: '알림',
          ),
        ],
        automaticallyImplyLeading: !_isSearchBarWidgetActivated,
      ),
      body: Stack( // 메뉴 오버레이를 위해 Stack 사용
        children: [
          GestureDetector( // 화면 다른 곳 탭 시 검색창 포커스 해제 (선택적)
          onTap: () {
            if (_isSearchBarWidgetActivated) {
              _searchFocusNodeInHome.unfocus();
              }
            },
            child: boardViewModel.isLoading 
            ? Center(child: CircularProgressIndicator())
            : (
              boardViewModel.error != null
              ? Center(child: Text(boardViewModel.error!))
              : (
                boardViewModel.boards.isEmpty 
                ? Center(child: Text('게시글이 없습니다'))
                : BoardListWidget(boards: boardViewModel.boards)
              )
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){},
        icon: Icon(Icons.post_add_outlined, size: 24),
        label: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(widget.lostCategory == 'lost' ? '잃어버렸어요' : '주웠어요',),
        ),
        tooltip: '글쓰기',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}

