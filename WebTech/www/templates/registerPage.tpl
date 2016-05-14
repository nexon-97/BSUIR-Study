<div class="centered loginFormContainer">
	<form class="registerForm" id="registerForm" role="register" method="post" action="register.php">
		<h2 style="text-align: center;">Register</h2>
		<div align="center">
			<table id="loginFormTable">
				<tr>
					<td>
						<div class="loginCaption">Login <span class="requiredField">*</span></div>
					</td>
					<td align="right" style="padding-right: 5px;">
						<input class="loginInput" type="text" name="loginInput"/>
					</td>
					<td style="padding-right: 5px">
						<div class="loginErrorBox" style="display: $LOGIN_ERROR_DISPLAY$">
							$LOGIN_ERROR_TEXT$
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div class="loginCaption">Password <span class="requiredField">*</span></div>
					</td>
					<td align="right" style="padding-right: 5px;">
						<input class="loginInput" type="password" name="passwordInput"/>
					</td>
					<td style="padding-right: 5px">
						<div class="loginErrorBox" style="display: $PASSWORD_ERROR_DISPLAY$">
							$PASSWORD_ERROR_TEXT$
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div class="loginCaption">Repeat password <span class="requiredField">*</span></div>
					</td>
					<td align="right" style="padding-right: 5px;">
						<input class="loginInput" type="password" name="passwordRepeatInput"/>
					</td>
					<td style="padding-right: 5px">
						<div class="loginErrorBox" style="display: $PASSWORD_REPEAT_ERROR_DISPLAY$">
							$PASSWORD_REPEAT_ERROR_TEXT$
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<hr/>
					</td>
				</tr>
				<tr>
					<td>
						<div class="loginCaption">E-Mail <span class="requiredField">*</span></div>
					</td>
					<td align="right" style="padding-right: 5px;">
						<input class="loginInput" type="text" name="emailInput"/>
					</td>
					<td style="padding-right: 5px">
						<div class="loginErrorBox" style="display: $EMAIL_ERROR_DISPLAY$">
							$EMAIL_ERROR_TEXT$
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div class="loginCaption">Name</div>
					</td>
					<td align="right" style="padding-right: 5px;">
						<input class="loginInput" type="text" name="nameInput"/>
					</td>
				</tr>
				<tr>
					<td>
						<div class="loginCaption">Surname</div>
					</td>
					<td align="right" style="padding-right: 5px;">
						<input class="loginInput" type="text" name="surnameInput"/>
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<hr/>
					</td>
				</tr>
				<tr>
					<td>
						<div class="loginCaption">Phone Number</div>
					</td>
					<td align="right" style="padding-right: 5px;">
						<input class="loginInput" type="text" name="phoneNumberInput"/>
					</td>
				</tr>
				<tr>
					<td>
						<div class="loginCaption">VK</div>
					</td>
					<td align="right" style="padding-right: 5px;">
						<input class="loginInput" type="text" name="vkPageInput"/>
					</td>
				</tr>
				<tr>
					<td>
						<div class="loginCaption">Twitter</div>
					</td>
					<td align="right" style="padding-right: 5px;">
						<input class="loginInput" type="text" name="twitterPageInput"/>
					</td>
				</tr>
				<tr>
					<td>
						<div class="loginCaption">LinkedIn</div>
					</td>
					<td align="right" style="padding-right: 5px;">
						<input class="loginInput" type="text" name="linkedinPageInput"/>
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<hr/>
					</td>
				</tr>
				<tr>
					<td colspan="3" align="center" style="padding: 10px;">
						<h4 style="margin: 0px">[CAPTCHA]</h4>
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<hr/>
					</td>
				</tr>
				<tr>
					<td colspan="3" align="center" style="padding: 10px;">
						<input class="button" type="submit" value="Register"/>
					</td>
				</tr>
		</table>
		</div>
	</form>
</div>