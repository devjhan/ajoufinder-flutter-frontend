import 'package:ajoufinder/domain/entities/board.dart';
import 'package:ajoufinder/ui/shared/widgets/board_view_widget.dart';
import 'package:ajoufinder/ui/viewmodels/auth_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/comment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardListWidget extends StatelessWidget {
  final List<Board> boards;
  const BoardListWidget({super.key, required this.boards});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (boards.isEmpty) {
      return Center(child: Text('게시글이 없습니다'),);
    }else {
      return ListView.builder(
        itemCount: boards.length,
        itemBuilder: (context, index) {
          final board = boards[index];
          return _BoardCard(board: board, theme: theme);
        }
      );
    }
  }
}

class _BoardCard extends StatelessWidget {
  final Board board;
  final ThemeData theme;

  const _BoardCard({
    super.key,
    required this.board, 
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardBg = theme.colorScheme.surface; // 밝은 회색 계열
    final Color borderColor = theme.dividerColor.withValues(alpha: 0.7);

    final authViewModel = Provider.of<AuthViewModel>(context);
    final commentViewModel = Provider.of<CommentViewModel>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: BoardViewWidget(
                      board: board,
                      currentUser: authViewModel.currentUser!,
                      comments: commentViewModel.comments,
                      onCommentSubmitted: (commentText) {
                        commentViewModel.postComments(comment: commentText);
                      },
                      ),
                  ),
                )),
              );
        },
        child: Card(
          elevation: 1, 
          shadowColor: theme.colorScheme.shadow,
          surfaceTintColor: Colors.transparent,
          color: cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: borderColor, width: 1),
          ),
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageArea(cardBg, borderColor, context),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(),
                    SizedBox(height: 8),
                    _buildLocationRow(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageArea(Color cardBg, Color borderColor, BuildContext context) {
    return Stack(
      children: [
        _buildImage(cardBg, borderColor),
        Positioned(
          top: 10,
          right: 10,
          child: _buildBookmarkButton(context),
        ),
      ],
    );
  }

  Widget _buildImage(Color cardBg, Color borderColor) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg, // 카드와 같은 배경색
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: board.image != null
          ? ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              child: Image.network(
                board.image!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 120,
              ),
            )
          : Center(
              child: Icon(
                Icons.image_outlined,
                color: theme.iconTheme.color?.withValues(alpha: 0.25) ?? Colors.grey[400],
                size: 38,
              ),
            ),
    );
  }

  Widget _buildBookmarkButton(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        // TODO: 북마크 클릭 시 동작
        print('북마크 클릭됨: ${board.title}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.bookmark_border_rounded,
          color: theme.iconTheme.color ?? Colors.grey[700],
          size: 28,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      board.title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 16.5,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildLocationRow() {
    return Row(
      children: [
        Icon(
          Icons.place_outlined,
          color: theme.iconTheme.color?.withValues(alpha: 0.6) ?? Colors.grey[500],
          size: 18,
        ),
        SizedBox(width: 4),
        Text(
          board.detailedLocation ?? '',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.85) ?? Colors.grey[700],
            fontSize: 13.5,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}


