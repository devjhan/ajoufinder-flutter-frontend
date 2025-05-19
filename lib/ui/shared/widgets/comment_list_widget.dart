import 'package:ajoufinder/domain/entities/comment.dart';
import 'package:ajoufinder/domain/entities/user.dart';
import 'package:ajoufinder/domain/repository/user_repository.dart';
import 'package:ajoufinder/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentListWidget extends StatelessWidget{
  final List<Comment> comments;
  final User currentUser;

  CommentListWidget({Key? key, required this.comments, required this.currentUser}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (comments.isEmpty) {
      return Center(child: Text('댓글이 없습니다'),);
    }else {
      return ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          final comment = comments[index];
          return _CommentCard(comment: comment, theme: theme, currentUser: currentUser,);
        }
      );
    }
  }
}

class _CommentCard extends StatefulWidget {
  final Comment comment;
  final User currentUser;
  final ThemeData theme;

  const _CommentCard({
    Key? key, 
    required this.comment, 
    required this.currentUser,
    required this.theme
  }) : super(key: key);

  @override
  State<_CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<_CommentCard> {
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileAvatar(theme: widget.theme),    
          SizedBox(width: 12,), 
          Expanded(child: _buildCommentContent(theme: widget.theme)),            
        ],
      )
    );
  }
  
  Future<void> _fetchUser() async {
    final userRepository = getIt<UserRepository>();
    final user = await userRepository.findById(widget.comment.userId);

    setState(() {
      _user = user;
      _isLoading = false;
    }); 
  }
  
  Widget _buildProfileAvatar({required ThemeData theme}) {
    if (_isLoading) {
      return CircleAvatar(
        radius: 14,
        backgroundColor: theme.hintColor,
        child: SizedBox(
          width: 14, height: 14,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    return CircleAvatar(
      radius: 14,
      backgroundColor: theme.hintColor,
      backgroundImage: _user?.profileImage != null
          ? NetworkImage(_user!.profileImage!)
          : null,
      child: _user?.profileImage == null
          ? Icon(Icons.person, color: theme.hintColor, size: 18)
          : null,
    );
  }
  
  Widget _buildCommentContent({required ThemeData theme}) {
    String formattedCreatedDate = DateFormat('MM.dd HH:mm').format(widget.comment.createdAt);
    String formattedUpdatedDate = DateFormat('MM.dd HH:mm').format(widget.comment.updatedAt);   

    final String displayContent;

    if (widget.currentUser.id == widget.comment.userId) {
      displayContent = widget.comment.content;
    } else {
      if (widget.comment.status == 'DELETED') {
        displayContent = '삭제된 댓글입니다.';
      } else {
        if (widget.comment.isSecret == true) {
          displayContent = '비밀 댓글입니다.';
        } else {
          displayContent = widget.comment.content;
        }
      }
    }

        return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              _isLoading ? '...' : (_user?.nickname ?? '익명${widget.comment.userId}'),
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Text(
              formattedCreatedDate,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          displayContent,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}