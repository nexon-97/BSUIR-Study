<!DOCTYPE html>
<html lang="en-US">
<head>
	<meta charset="UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=10" />
	<title>Denis Ponyakov</title>
	<link rel="stylesheet" href="styles/mainStyle.css" />	
	<script type="text/javascript" href="scripts/jquery-1.12.1.min.js"></script>
</head>
<body>

	<div class="centered headerWrapper">
	<table class="header">
		<tr>
			<td id="nameBlock">
				<p>Denis Ponyakov</p>
				<p>Game &amp; Tools Programmer </p>
			</td>
			<td />
			<td id="searchPanel">
				<form class="searchform" role="search" method="get">
					<input type="text" placeholder="Search" id="searchBox" value="" name="search"/>
				</form>
			</td>
		</tr>
	</table>
	</div>
	
	<div class="horizontalMenuBody">
		<div class="centered horizontalMenuListWrapper">
			<ul class="horizontalMenuList">
				<a href="#"><li>Blog</li></a>
				<a href="#"><li>Projects</li></a>
				<a href="#"><li>Tutorials</li></a>
				<a href="#"><li>Guides</li></a>
				<a href="#"><li>Games</li></a>
				<a href="#"><li>Contact Me</li></a>
			</ul>
		</div>
	</div>
	
	<div id="pinnedPostWrapper" class="centered">
		<table>
			<tr>
				<td id="pinnedPostText">
					<h2 id="pinnedPostTitle">Pinned post title</h2>
					<hr id="pinnedPostSeparator">
					<p>
						Pinned post full description, which can be even multilined
					</p>
				</td>
				<td id="pinnedPostImage">
					<img src="img/pinned_post_img.jpg" style="width: 100%" />
				</td>
			</tr>
		</table>
	</div>
	
	<div class="centered" id="latestPostsSection">
		<h3 style="margin-left: 20px;">Latest posts</h3>
		<div id="latestPostsListing">
			<div class="latestPost">
				<a href="#"><img src="img/post1.jpg" style="width: 100%" /></a>
			</div>
			<div class="latestPost">
				<a href="#"><img src="img/post2.jpg" style="width: 100%" /></a>
			</div>
			<div class="latestPost">
				<a href="#"><img src="img/post3.jpg" style="width: 100%" /></a>
			</div>
			<div class="latestPost">
				<a href="#"><img src="img/post4.jpg" style="width: 100%" /></a>
			</div>
		</div>
	</div>
	
	<div id="footer">
		<div class="centered" style="text-align: center; color: white;">
			Copyright NexonLab 2016 &copy;
		</div>
	</div>

</body>
</html>