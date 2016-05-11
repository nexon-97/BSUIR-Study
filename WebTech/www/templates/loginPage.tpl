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
<input class="loginInput" type="text" id="usernameInput" name="loginUsernameInput"/>
</td>
<td style="padding-left: 5px;">
<div style="background: #FF3232; border-radius: 5px; padding: 5px 10px; display: none;">
$LOGIN_ERROR_TEXT$
</div>
</td>
</tr>
<tr>
<td>
<div class="loginCaption">Password</div>
</td>
<td align="right" style="padding-right: 5px;">
<input class="loginInput" type="password" id="passwordInput" name="loginPasswordInput"/>
</td>
<td style="padding-left: 5px;">
<div style="background: #FF3232; border-radius: 5px; padding: 5px 10px; display: none;">
$PASSWORD_ERROR_TEXT$
</div>
</td>
</tr>
<tr>
<td colspan="3" align="center" style="padding: 10px;">
<input class="button" type="submit" value="Log In" id="submitInput"/>
</td>
</tr>
<tr>
<td colspan="3" align="center" style="padding: 10px;">
<a href="http://www.nexonlab.by/register.php">Register</a> | <a href="http://www.nexonlab.by/restorepass.php">Restore password</a>
</td>
</tr>
</table>
</div>
</form>
</div>