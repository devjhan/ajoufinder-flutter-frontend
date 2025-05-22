import 'package:ajoufinder/domain/entities/user.dart';
import 'package:ajoufinder/ui/viewmodels/auth_view_model.dart';
import 'package:ajoufinder/ui/views/account/my_boards_screen.dart';
import 'package:ajoufinder/ui/views/account/my_bookmarked_boards_screen.dart';
import 'package:ajoufinder/ui/views/account/my_comments_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final currentUser = authViewModel.currentUser!;
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          '나의 정보',
          style: theme.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.colorScheme.surfaceContainer, 
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildMyInfoSection(currentUser, context),
          const SizedBox(height: 20),
          _buildAccountSection(currentUser, context),
          const SizedBox(height: 20),
          _buildCommunitySection(currentUser, context),
        ],
      ),
    );
  }

 Widget _buildMyInfoSection(User currentUser, BuildContext context) {
    String formattedJoinDate = DateFormat('yyyy-MM-dd').format(currentUser.joinDate);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3)
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                '내 정보',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<AuthViewModel>(context, listen: false).logout();
                },
                style: theme.elevatedButtonTheme.style!.copyWith(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color.fromARGB(255, 193, 1, 1);
                      } else if (states.contains(WidgetState.disabled)) {
                        return Colors.grey;
                      } else {
                      return const Color.fromARGB(255, 255, 1, 1);
                    }
                  },
                ),
                ),
                child: Text('로그아웃', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant,
                  shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3)
          )
        ],
                  image: currentUser.profileImage != null && currentUser.profileImage!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(currentUser.profileImage!), // 실제 프로필 이미지 설정
                          fit: BoxFit.cover,
                        )
                      : null, // 이미지가 없으면 DecorationImage를 설정하지 않음
                ),
                // 이미지가 없을 때 기본 아이콘 표시
                child: (currentUser.profileImage == null || currentUser.profileImage!.isEmpty)
                    ? Icon(Icons.person, color: theme.colorScheme.onSurfaceVariant, size: 30)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentUser.nickname,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: 4),
                    Text(
                      // 이메일을 기본으로 표시하고, 전화번호가 있으면 같이 표시
                      currentUser.phoneNumber != null && currentUser.phoneNumber!.isNotEmpty
                          ? '${currentUser.email}\n${currentUser.phoneNumber}'
                          : currentUser.email, // 이메일 / 전화번호
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '가입일 : $formattedJoinDate', // 가입일
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // "계정" 섹션 위젯
  Widget _buildAccountSection(User currentUser, BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3)
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
            child: Text(
              '계정',
              style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
            ),
          ),
          _buildClickableListItem(
            title: '아이디',
            trailingText: currentUser.email, 
            context: context
          ),
          _buildClickableListItem(
            title: '비밀번호 변경',
            onTap: () {
              // TODO: 비밀번호 변경 기능 구현
            },
            context: context
          ),
          _buildClickableListItem(
            title: '관심 물품 설정',
            onTap: () {
              
            },
            context: context
          ),
        ],
      ),
    );
  }

  // "커뮤니티" 섹션 위젯
  Widget _buildCommunitySection(User currentUser, BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3)
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
            child: Text(
              '커뮤니티',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildClickableListItem(
            title: '닉네임 설정',
            onTap: () {
              // TODO: 닉네임 설정 기능 구현
            },
            context: context
          ),
          _buildClickableListItem(
            title: '내 게시글 보기',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: MyBoardsScreen()
                  ),
                )),
              );
            },
            context: context
          ),
          _buildClickableListItem(
            title: '내 댓글 보기',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: MyCommentsScreen()
                  ),
                )),
              );
            },
            context: context
          ),
          _buildClickableListItem(
            title: '내 북마크 보기',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: MyBookmarkedBoardsScreen()
                  ),
                )),
              );
            },
            context: context
          ),
        ],
      ),
    );
  }

  // 재사용 가능한 리스트 아이템 위젯
  Widget _buildClickableListItem({
    required String title,
    String? trailingText,
    VoidCallback? onTap,
    bool showDivider = true,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.normal,
                  ),
                  ),
                  if (trailingText != null)
                    Text(
                      trailingText,
                      style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                    ),
                ],
              ),
              if (showDivider) const SizedBox(height: 8),
              if (showDivider) Divider(color: theme.dividerColor, height: 1),
            ],
          ),
        ),
      ),
    );
  }
}
