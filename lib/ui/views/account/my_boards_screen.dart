import 'package:ajoufinder/ui/shared/widgets/board_list_widget.dart';
import 'package:ajoufinder/ui/viewmodels/auth_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/board_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBoardsScreen extends StatefulWidget{
  const MyBoardsScreen({Key? key}) : super(key : key);

  @override
  State<MyBoardsScreen> createState() => _MyBoardsScreenState();
}

class _MyBoardsScreenState extends State<MyBoardsScreen> {

  @override
  void initState() {
    super.initState();

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final boardViewModel = Provider.of<BoardViewModel>(context, listen: false);
    
    if (authViewModel.userUid != null) {
      boardViewModel.fetchBoards(uuid: authViewModel.userUid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final boardViewModel = Provider.of<BoardViewModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          '게시글 보기',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),          
        ),
      ),
      body: boardViewModel.isLoading 
      ? Center(child: CircularProgressIndicator())
      : (
        boardViewModel.error != null
        ? Center(child: Text(boardViewModel.error!))
        : (
          boardViewModel.boards.isEmpty 
          ? Center(child: Text('작성한 게시글이 없습니다.'))
          : BoardListWidget(boards: boardViewModel.boards)
        )
      ),
    );
  }
}