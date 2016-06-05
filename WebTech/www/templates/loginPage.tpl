<div class="centered loginFormContainer">
<form class="loginForm" role="login" method="post" action="login.php">
<h2 style="text-align: center;">Log In</h2>
<div align="center">
<table id="loginFormTable">
<tr>
<td>
<div class="loginCaption">Login</div>
</td>
<td align="right" style="padding-right: 5px;">
<script>
function updateRestorepassLink(val)
{
	$('#restorepassLink').attr('href', 'restorepass.php?username=' + val);
}
</script>
<input class="loginInput" type="text" id="usernameInput" name="loginUsernameInput" onchange="updateRestorepassLink(this.value)"/>
</td>
</tr>
<tr>
<td>
<div class="loginCaption">Password</div>
</td>
<td align="right" style="padding-right: 5px;">
<input class="loginInput" type="password" id="passwordInput" name="loginPasswordInput"/>
</td>
</tr>
<tr>
<td colspan="2" align="center" style="padding: 10px;">
<input class="button" type="submit" value="Log In" id="submitInput"/>
</td>
</tr>
<tr>
<td colspan="2" align="center">
<div class="loginErrorBox" style="display: $ERROR_DISPLAY$">
Invalid username and password combination!
</div>
</td>
</tr>
<tr>
<td colspan="2" align="center" style="padding: 10px;">
<hr style="margin-bottom: 15px;" />
<a href="http://www.nexonlab.hol.es/register.php">
<span class="button" style="margin-right: 3px">Register</span>
</a>
<a href="http://www.nexonlab.hol.es/restorepass.php?username=$$" id="restorepassLink">
<span class="button" style="margin-left: 3px">Restore password</span>
</a>
</td>
</tr>
</table>
</div>
</form>
</div>