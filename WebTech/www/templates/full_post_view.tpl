<div class="centered">
<div class="postCategory">
<strong>Category - <a href="$CATEGORY_LINK$">$POST_CATEGORY$</a></strong>
</div>
<h2 class="postTitle">$POST_TITLE$</h2>
<div class="postStats">
Posted on <a href="#"><strong>$CREATION_DATE$</strong></a> by <a href="$AUTHOR_LINK$"><strong>$AUTHOR_NAME$</strong></a>
</div>
<hr class="postHR">
<div class="postTextDefault">
$POST_TEXT$
</div>
<hr class="postHR">
<div>
$POST_COMMENTS$
</div>
<h4 align="left" style="margin-left: 20px; margin-bottom: 5px;">Leave your comment:</h4>
<div style="margin: 10px">
<form class="commentForm" role="comment" method="post" action="leavecomment.php?post_id=$POST_ID$&amp;referer=post.php?id=$POST_ID$">
<textarea placeholder="Comment" name="commentText" style="width: 95%; height: 100px; resize: none;"></textarea>
<input class="button" type="submit" style="margin-top: 5px" value="Comment" name="commentButton"/>
</form>
</div>
</div>