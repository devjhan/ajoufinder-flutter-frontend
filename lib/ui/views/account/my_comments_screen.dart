import 'package:ajoufinder/ui/shared/widgets/comment_list_widget.dart';
import 'package:ajoufinder/ui/viewmodels/auth_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/comment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCommentsScreen extends StatefulWidget{
  const MyCommentsScreen({super.key});

  @override
  State<MyCommentsScreen> createState() => _MyCommentsScreenState();
}

class _MyCommentsScreenState extends State<MyCommentsScreen> {

  @override 
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final commentViewModel = Provider.of<CommentViewModel>(context, listen: false);
      
      if (authViewModel.userUid != null) {
        commentViewModel.fetchCommentsByUserId(uuid: authViewModel.userUid!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final authViewModel = Provider.of<AuthViewModel>(context, listen: true);
    final commentViewModel = Provider.of<CommentViewModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          '댓글 보기',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),          
        ),
      ),
      body: _buildBodyContent(commentViewModel: commentViewModel, authViewModel: authViewModel),
    );
  }

  Widget _buildBodyContent({required CommentViewModel commentViewModel, required AuthViewModel authViewModel}) {
    return commentViewModel.isLoading
    ? Center(child: CircularProgressIndicator())
    : (
      commentViewModel.error != null
      ? Center(child: Text(commentViewModel.error!))
      : (
        commentViewModel.comments.isEmpty
        ? Center(child: Text('작성한 댓글이 없습니다.'))
        : CommentListWidget(comments: commentViewModel.comments, currentUser: authViewModel.currentUser!)
      )
    );
  }
}