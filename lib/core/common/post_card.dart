import 'package:any_link_preview/any_link_preview.dart';
import 'package:ecommerse_website/model/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/myThemes.dart';

class PostCard extends ConsumerWidget {
  final PostModel post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(.66),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Community Info
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(post.communityProfilePic),
                  radius: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    post.communityName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.dividerColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Post Title
            Text(
              post.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColorLight,
              ),
            ),
            const SizedBox(height: 12),

            // Centered Description
            if (post.description != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.dividerColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    post.description!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 15,
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            const SizedBox(height: 12),

            // Post Image
            if (post.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  post.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 12),
            // Link Preview
            if (post.link != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AnyLinkPreview(
                  link: post.link!,
                ),
              ),
            const SizedBox(height: 12),

            // Post Actions (Votes, Comments)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.thumb_up_alt_rounded, color: theme.primaryColor, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      post.upVotes.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.thumb_down_alt_rounded, color: theme.dividerColor.withOpacity(0.7), size: 20),
                    const SizedBox(width: 6),
                    Text(
                      post.downVotes.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.chat_bubble_outline, color: theme.iconTheme.color, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      post.commentCount.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
