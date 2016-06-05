<div class="centered">
<form class="editUserForm" role="edituser" method="post" action="edit.php?entity=user&id=$USER_ID$&referer=index.php">
<table style="width: 95%; margin: 10px;">
<tr>
<td style="padding: 4px 0px">
<strong>Name</strong>
</td>
<td>
<input style="width: 100%" type="text" placeholder="Post title" value="$NAME$" name="nameEdit"/>
</td>
</tr>
<tr>
<td style="padding: 4px 0px">
<strong>Surname</strong>
</td>
<td>
<input style="width: 100%" type="text" placeholder="Post title" value="$SURNAME$" name="surnameEdit"/>
</td>
</tr>
<tr>
<td style="padding: 4px 0px">
<strong>Old Password</strong>
</td>
<td>
<input style="width: 100%" type="password" name="passwordEdit"/>
</td>
</tr>
<tr>
<td style="padding: 4px 0px">
<strong>New password</strong>
</td>
<td>
<input style="width: 100%" type="password" name="newPasswordEdit"/>
</td>
</tr>
<tr>
<td style="padding: 4px 0px">
<strong>Password repeat</strong>
</td>
<td>
<input style="width: 100%" type="password" name="newPasswordRepeatEdit"/>
</td>
</tr>
<tr>
<td style="padding: 4px 0px">
<strong>VK</strong>
</td>
<td>
<input style="width: 100%" type="text" placeholder="VK Link" value="$VK$" name="vkEdit"/>
</td>
</tr>
<tr>
<td style="padding: 4px 0px">
<strong>Twitter</strong>
</td>
<td>
<input style="width: 100%" type="text" placeholder="Twitter link" value="$TWITTER$" name="twitterEdit"/>
</td>
</tr>
<tr>
<td style="padding: 4px 0px">
<strong>LinkedIn</strong>
</td>
<td>
<input style="width: 100%" type="text" placeholder="LinkedIn Profile Link" value="$LINKEDIN$" name="linkedinEdit"/>
</td>
</tr>
<tr>
<td colspan="2" style="padding: 4px 0px" align="center">
<input class="button" type="submit" style="font-size: 14px;" value="Apply changes"/>
</td>
</tr>
</table>
</form>
</div>