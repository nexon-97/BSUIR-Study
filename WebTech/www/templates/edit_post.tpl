<div class="centered">
<form class="addPostForm" role="addpost" method="post" action="$ACTION$?entity=post&$ENTITY_ID$referer=blog.php">
<table style="width: 95%; margin: 10px;">
<tr>
<td style="padding: 4px 0px">
<strong>Category</strong>
</td>
<td>
<select name="categorySelect" style="padding: 3px">
$CATEGORY_OPTIONS$
</select>
</td>
</tr>
<tr>
<td style="padding: 4px 0px">
<strong>Title</strong>
</td>
<td>
<input style="width: 100%" type="text" placeholder="Post title" value="$TITLE$" name="postTitle"/>
</td>
</tr>
<tr>
<td colspan="2" style="padding: 4px 0px">
<textarea placeholder="Short description" name="shortDesc" style="width: 100%; height: 140px; resize: none;">$SHORT_DESC$</textarea>
</td>
</tr>
<tr>
<td colspan="2" style="padding: 4px 0px">
<textarea placeholder="Text" name="postText" style="width: 100%; height: 400px; resize: none;">$DESC$</textarea>
</td>
</tr>
<tr>
<td colspan="2" style="padding: 4px 0px" align="center">
<input class="button" type="submit" style="font-size: 14px;" value="Send"/>
</td>
</tr>
</table>
</form>
</div>