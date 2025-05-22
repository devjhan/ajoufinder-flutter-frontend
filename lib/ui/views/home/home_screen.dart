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
    
    return Stack( // 메뉴 오버레이를 위해 Stack 사용
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
      );
  }
}

