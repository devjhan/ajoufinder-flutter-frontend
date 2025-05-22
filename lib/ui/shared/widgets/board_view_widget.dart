import 'package:ajoufinder/domain/entities/board.dart';
import 'package:ajoufinder/domain/entities/comment.dart';
import 'package:ajoufinder/domain/entities/user.dart';
import 'package:ajoufinder/domain/repository/user_repository.dart';
import 'package:ajoufinder/injection_container.dart';
import 'package:ajoufinder/ui/shared/widgets/comment_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BoardViewWidget extends StatelessWidget{
  final Board board;
  final User currentUser;
  final List<Comment> comments;
  final void Function(String) onCommentSubmitted;

  const BoardViewWidget({
    super.key,
    required this.board,
    required this.currentUser,
    required this.comments,
    required this.onCommentSubmitted,
  });

@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final textTheme = theme.textTheme;
  
  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text('게시글 보기', style: textTheme.titleLarge),
      actions: [
        IconButton(
          icon: Icon(Icons.share, color: theme.colorScheme.onSurface),
          onPressed: () => _handleShare(),
        ),
        IconButton(
          icon: Icon(Icons.bookmark_border, color: theme.colorScheme.onSurface),
          onPressed: () => _handleBookmark(),
        ),
      ],
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(theme),
          const SizedBox(height: 24),
          _buildTitleSection(textTheme),
          const SizedBox(height: 16),
          _buildAuthorInfo(theme),
          const SizedBox(height: 24),
          _buildDescriptionSection(textTheme),
          const SizedBox(height: 24),
          _buildLocationSection(theme),
          const SizedBox(height: 32),
          _buildCommentsHeader(textTheme),
          CommentListWidget(comments: comments, currentUser: currentUser),
        ],
      ),
    ),
    bottomNavigationBar: _buildCommentInputBar(theme),
  );
}


  Widget _buildImageSection(ThemeData theme) {
    return GestureDetector(
      onTap: () => _handleImageTap(), // TODO: 이미지 확대 기능
      child: Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: board.image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(board.image!, fit: BoxFit.cover),
              )
            : Center(
                child: Icon(
                  Icons.photo_camera_back,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 48,
                ),
              ),
      ),
    );
  }

  Widget _buildTitleSection(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: Text(
            board.title,
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          board.category,
          style: textTheme.headlineSmall?.copyWith(
            color: Colors.orange[700],
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthorInfo(ThemeData theme) {
    return FutureBuilder<User?>(
      future: getIt<UserRepository>().findById(board.userId),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final timeDifference = DateTime.now().difference(board.createdAt).inHours;

        return Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: user?.profileImage != null 
                  ? NetworkImage(user!.profileImage!) 
                  : null,
              child: user?.profileImage == null 
                  ? Icon(Icons.person, color: theme.colorScheme.onSurface)
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.nickname ?? '익명${board.userId}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  timeDifference < 24 
                      ? '$timeDifference시간 전' 
                      : DateFormat('MM/dd').format(board.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildDescriptionSection(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('상품 설명', style: textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          board.description,
          style: textTheme.bodyLarge?.copyWith(height: 1.4),
        ),
      ],
    );
  }

   Widget _buildLocationSection(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.place_outlined,
          color: theme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          board.detailedLocation ?? '위치 정보 없음',
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }
  
  Widget _buildCommentsHeader(TextTheme textTheme) {
    return Row(
      children: [
        Text('댓글 ', style: textTheme.titleLarge),
        Text('${comments.length}', style: textTheme.titleLarge?.copyWith(
          color: Colors.grey[600],
        )),
      ],
    );
  }

  Widget _buildCommentInputBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: '댓글을 입력하세요...',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: onCommentSubmitted,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: theme.colorScheme.primary),
            onPressed: () => _handleCommentSubmit(), // TODO: 텍스트 필드 값 처리
          ),
        ],
      ),
    );
  }

  void _handleShare() {
    // TODO: 공유 기능 구현
  }

    void _handleBookmark() {
    // TODO: 북마크 상태 토글
  }

  void _handleImageTap() {
    // TODO: 이미지 확대/축소 구현
  }

  void _handleCommentSubmit() {
    // TODO: 댓글 제출 로직
  }
}